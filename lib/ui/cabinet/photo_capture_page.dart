import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/controllers/models_controller.dart';
import '../../application/providers.dart';
import '../../core/app_logger.dart';
import '../../domain/models/medication_draft.dart';
import '../../domain/services/model_selection.dart';
import '../../domain/services/vision_service.dart';
import '../../platform/image_utils.dart';
import '../shell/app_shell.dart';
import '../widgets/common.dart';

/// 加药·拍照（docs/07 §2：取景提示 → 识别 → 草稿确认页）。
class PhotoCapturePage extends ConsumerStatefulWidget {
  const PhotoCapturePage({super.key, this.returnToOnboarding = false});

  final bool returnToOnboarding;

  @override
  ConsumerState<PhotoCapturePage> createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends ConsumerState<PhotoCapturePage> {
  bool _busy = false;
  bool _fallbackConfirmed = false;

  Future<void> _pickAndRecognize(ImageSource source) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      // 页面本身也校验，覆盖深链和入口之后模型配置发生变化的场景。
      final capability = await ref
          .read(modelSelectionProvider)
          .visionCapability();
      if (!mounted) {
        return;
      }
      if (capability == VisionCapability.unavailable) {
        UndoBar.show(context, message: tr.photoCapture.setupFirst);
        return;
      }
      if (capability == VisionCapability.fallback && !_fallbackConfirmed) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(tr.photoCapture.unverifiedTitle),
            content: Text(tr.photoCapture.unverifiedMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(tr.photoCapture.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(tr.photoCapture.continueScan),
              ),
            ],
          ),
        );
        if (confirmed != true || !mounted) {
          return;
        }
        _fallbackConfirmed = true;
      }
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 2400,
        imageQuality: 88,
      );
      if (picked == null) {
        setState(() => _busy = false);
        return;
      }
      // 提示与原图存档分开：压缩后的给模型，原图存草稿。
      final compressed = await compressForVision(picked.path);
      if (compressed == null) {
        if (mounted) {
          UndoBar.show(context, message: tr.photoCapture.invalidPhoto);
        }
        setState(() => _busy = false);
        return;
      }
      final outcome = await ref
          .read(visionServiceProvider)
          .extractFromImage(jpegBytes: compressed, photoPath: picked.path);
      if (!mounted) {
        return;
      }
      switch (outcome) {
        case VisionSuccess(:final draft):
          await _confirmSaveDraft(draft);
        case VisionNotReadable():
          UndoBar.show(context, message: tr.photoCapture.blurryPhoto);
        case VisionFailure(:final error):
          UndoBar.show(context, message: friendlyError(error));
      }
    } catch (e, st) {
      AppLog.e('拍照识别异常', e, st);
      if (mounted) {
        UndoBar.show(context, message: tr.photoCapture.failed);
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  /// docs/03 §6：识别结果先经"是否保存为草稿"确认——草稿确认页是强制步骤。
  Future<void> _confirmSaveDraft(MedicationDraft draft) async {
    final payload = draft.payload;
    final name = payload.name ?? tr.photoCapture.unnamedMedicine;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.photoCapture.recognizedTitle),
        content: Text(
          tr.photoCapture.recognizedMessage(arg1: (name).toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(tr.photoCapture.discard),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(tr.photoCapture.review),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      if (widget.returnToOnboarding) {
        // Keep this route alive to forward the result to the welcome guide.
        final saved = await context.push<bool>(
          '/draft/${draft.id}?returnToOnboarding=1',
        );
        if (mounted && saved == true) {
          popPillPalPage(
            context,
            fallbackLocation: '/onboarding?step=2',
            result: true,
          );
        }
      } else {
        context.pushReplacement('/draft/${draft.id}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final capability = ref.watch(visionCapabilityProvider).value;
    final canPhoto =
        capability == VisionCapability.native ||
        capability == VisionCapability.fallback;
    return Scaffold(
      appBar: buildPillPalAppBar(
        title: tr.photoCapture.title,
        backLocation: widget.returnToOnboarding
            ? '/onboarding?step=2'
            : '/cabinet',
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _busy
              ? LoadingView(label: tr.photoCapture.loading)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_camera, size: 88),
                    const SizedBox(height: 16),
                    Text(
                      tr.photoCapture.photoTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tr.photoCapture.photoHint,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    BigPrimaryButton(
                      label: tr.photoCapture.camera,
                      icon: Icons.camera_alt,
                      onPressed: canPhoto
                          ? () => _pickAndRecognize(ImageSource.camera)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    BigOutlinedButton(
                      label: tr.photoCapture.gallery,
                      icon: Icons.photo_library,
                      onPressed: canPhoto
                          ? () => _pickAndRecognize(ImageSource.gallery)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      !canPhoto
                          ? tr.photoCapture.setupFirst
                          : capability == VisionCapability.fallback
                          ? tr.photoCapture.unverifiedHint
                          : tr.photoCapture.draftHint,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
