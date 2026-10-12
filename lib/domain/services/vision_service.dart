import 'dart:convert';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import '../../ai/client/ai_client.dart';
import '../../ai/client/ai_models.dart';
import '../../ai/prompts/vision_prompts.dart';
import '../../core/app_constants.dart';
import '../../core/app_logger.dart';
import '../../core/exceptions.dart';
import '../../data/repositories/draft_repository.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/medication_draft.dart';
import 'model_selection.dart';

/// 拍照识别服务（docs/03 §6 流程：压缩 → 视觉模型 → JSON 校验 → 草稿）。
///
/// 识别结果永远是草稿，绝不经确认直接写入。
sealed class VisionOutcome {
  const VisionOutcome();
}

/// 成功：草稿已落库（pending），UI 引导进确认页。
class VisionSuccess extends VisionOutcome {
  const VisionSuccess(this.draft);

  final MedicationDraft draft;
}

/// 模型如实报告照片不可读（docs/03 §6 幻觉防护 1）。
class VisionNotReadable extends VisionOutcome {
  const VisionNotReadable();
}

/// 失败（网络/解析/能力缺失），UI 翻译成口语文案。
class VisionFailure extends VisionOutcome {
  const VisionFailure(this.error);

  final AppException error;
}

class VisionService {
  VisionService({
    required AiVisionClient visionClient,
    required ModelSelectionService modelSelection,
    required DraftRepository draftRepository,
  })  : _client = visionClient,
        _selection = modelSelection,
        _drafts = draftRepository;

  static const Uuid _uuid = Uuid();

  final AiVisionClient _client;
  final ModelSelectionService _selection;
  final DraftRepository _drafts;

  Future<VisionOutcome> extractFromImage({
    required Uint8List jpegBytes,
    String? photoPath,
  }) async {
    final resolution = await _selection.resolveVision();
    if (resolution == null) {
      return const VisionFailure(
        AiException(AiErrorCode.notConfigured),
      );
    }
    final dataUrl =
        'data:image/jpeg;base64,${base64Encode(jpegBytes)}';

    // 解析失败重试 1 次，附上错误信息（docs/03 §6）。
    var attempt = 0;
    Object? lastError;
    while (attempt <= kVisionRetryLimit) {
      final messages = <AiProtocolMessage>[
        const AiProtocolMessage(role: AiRole.system, content: VisionPrompts.system),
        AiProtocolMessage(
          role: AiRole.user,
          content: attempt == 0
              ? VisionPrompts.instruction
              : VisionPrompts.retryInstruction(lastError.toString()),
          contentParts: [AiContentPart.imageUrl(dataUrl)],
        ),
      ];
      try {
        final result = await _client.vision(
          AiChatRequest(
            model: resolution.config.modelId,
            messages: messages,
            maxTokens: resolution.config.maxTokens ?? 1200,
          ),
          config: resolution.config,
        );
        final parsed = parseVisionOutput(result.message.text);
        if (parsed is ExtractNotReadable) {
          return const VisionNotReadable();
        }
        final payload = (parsed as ExtractParsed).payload;
        final draft = MedicationDraft(
          id: _uuid.v4(),
          source: DraftSource.photo,
          payload: payload,
          photoPath: photoPath,
          status: DraftStatus.pending,
          createdAt: DateTime.now(),
        );
        await _drafts.save(draft);
        AppLog.i('视觉识别成功 draft=${draft.id} name=${payload.name}');
        return VisionSuccess(draft);
      } on AiException catch (e) {
        lastError = e;
        if (e.code == AiErrorCode.parse && attempt < kVisionRetryLimit) {
          attempt++;
          continue;
        }
        return VisionFailure(e);
      } on NetworkException catch (e) {
        return VisionFailure(e);
      } catch (e, st) {
        AppLog.e('视觉识别未知异常', e, st);
        lastError = AiException(AiErrorCode.parse, cause: e);
        if (attempt < kVisionRetryLimit) {
          attempt++;
          continue;
        }
        return VisionFailure(
          AiException(AiErrorCode.parse, cause: e),
        );
      }
    }
    return VisionFailure(
      AiException(AiErrorCode.parse, cause: lastError),
    );
  }
}
