import 'dart:async';

import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/assistant_controller.dart';
import '../../application/controllers/models_controller.dart';
import '../../application/controllers/voice_controller.dart';
import '../../application/providers.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/view_models.dart';
import '../../domain/services/speech_service.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// AI 助手页（docs/07 §1）：对话流 + 常驻麦克风 + 常用问题 chip。
class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage>
    with WidgetsBindingObserver {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  GoRouter? _observedRouter;
  bool _foreground = true;
  bool? _visible;
  int? _pointer;
  double _pressY = 0;
  late SpeechService _speech;
  @override
  void initState() {
    super.initState();
    _speech = ref.read(speechServiceProvider);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (!identical(router, _observedRouter)) {
      _observedRouter?.routerDelegate.removeListener(_routeChanged);
      _observedRouter = router;
      router.routerDelegate.addListener(_routeChanged);
    }
    _routeChanged();
  }

  void _routeChanged() {
    final visible =
        _foreground &&
        _observedRouter?.routeInformationProvider.value.uri.path ==
            '/assistant';
    if (visible == _visible) return;
    _visible = visible;
    if (!visible) _pointer = null;
    scheduleMicrotask(() {
      if (mounted) {
        unawaited(
          ref
              .read(voiceControllerProvider.notifier)
              .setVisible(_visible ?? false),
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _routeChanged();
  }

  static List<String> get _quickQuestions => [
    tr.assistant.quickStatus,
    tr.assistant.quickNext,
    tr.assistant.quickUsage,
  ];

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _observedRouter?.routerDelegate.removeListener(_routeChanged);
    unawaited(_speech.cancelListening());
    unawaited(_speech.stopSpeak(owner: SpeechOwner.assistant));
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    if (ref.read(assistantControllerProvider).value?.busy == true) return;
    final original = _inputController.text;
    final ok = await ref.read(assistantControllerProvider.notifier).send(text);
    if (mounted &&
        ok &&
        _inputController.text == original &&
        original == text) {
      _inputController.clear();
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final state = ref.watch(assistantControllerProvider);
    final voice = ref.watch(voiceControllerProvider);
    ref.listen(assistantControllerProvider, (previous, next) {
      if (next.value?.messages.lastOrNull?.id !=
          previous?.value?.messages.lastOrNull?.id) {
        _scrollToBottom();
      }
    });
    ref.listen(voiceControllerProvider, (previous, next) {
      if (next.phase == VoicePhase.idle && next.text.isNotEmpty) {
        _inputController.text = next.text;
      }
    });
    final hasModel = ref.watch(hasChatModelProvider).value;

    return Scaffold(
      appBar: buildPillPalAppBar(
        title: tr.assistant.title,
        actions: [
          IconButton(
            tooltip: tr.agentV2.memories,
            icon: const Icon(Icons.psychology_outlined),
            onPressed: () => context.push('/assistant/memories'),
          ),
          IconButton(
            tooltip: tr.assistant.clearTooltip,
            icon: const Icon(Icons.delete_sweep, size: 28),
            onPressed: () async {
              await ref
                  .read(voiceControllerProvider.notifier)
                  .setVisible(false);
              if (!context.mounted) return;
              final ok = await confirmDangerous(
                context,
                title: tr.assistant.clearTitle,
                message: tr.agentV2.clearHint,
                confirmLabel: tr.assistant.clear,
              );
              if (ok) {
                await ref.read(voiceControllerProvider.notifier).cancel();
                await ref
                    .read(assistantControllerProvider.notifier)
                    .clearHistory();
              }
              if (mounted) {
                await ref
                    .read(voiceControllerProvider.notifier)
                    .setVisible(_visible ?? false);
              }
            },
          ),
        ],
      ),
      body: hasModel == false
          ? _buildNoModel(context)
          : Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr.assistant.welcome,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tr.assistant.available,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.value?.hasEarlier == true)
                        SliverToBoxAdapter(
                          child: TextButton(
                            onPressed: state.value?.busy == true
                                ? null
                                : () => ref
                                      .read(
                                        assistantControllerProvider.notifier,
                                      )
                                      .loadEarlier(),
                            child: Text(tr.agentV2.loadEarlier),
                          ),
                        ),
                      if (state.value?.busy == true)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(tr.agentV2.thinking),
                          ),
                        ),
                      if (state.value?.notice.isNotEmpty == true)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(state.value!.notice),
                          ),
                        ),
                      if (state.value?.retryTurnId != null)
                        SliverToBoxAdapter(
                          child: TextButton(
                            onPressed: state.value?.busy == true
                                ? null
                                : () => ref
                                      .read(
                                        assistantControllerProvider.notifier,
                                      )
                                      .retry(),
                            child: Text(tr.agentV2.retry),
                          ),
                        ),
                      ...state.when<List<Widget>>(
                        loading: () => [
                          const SliverToBoxAdapter(child: LoadingView()),
                        ],
                        error: (e, _) => [
                          SliverToBoxAdapter(child: ErrorView(error: e)),
                        ],
                        data: (data) {
                          final messages = data.messages
                              .where((m) => m.role != ChatRole.tool)
                              .toList();
                          if (messages.isEmpty) {
                            return [
                              SliverToBoxAdapter(child: _buildEmpty(context)),
                            ];
                          }
                          return [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              sliver: SliverList.builder(
                                itemCount: messages.length,
                                itemBuilder: (context, index) =>
                                    _bubble(context, messages[index], data),
                              ),
                            ),
                          ];
                        },
                      ),
                      if (state.value?.lastWrites.isNotEmpty ?? false)
                        SliverToBoxAdapter(
                          child: _UndoStrip(
                            writes: state.value!.lastWrites,
                            onUndo: (event) => ref
                                .read(assistantControllerProvider.notifier)
                                .undoWrite(event),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final question in _quickQuestions)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: BigOutlinedButton(
                                    label: question,
                                    onPressed: () => _send(question),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (state.value?.error != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              friendlyError(state.value!.error!),
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppTheme.badRed,
                              ),
                            ),
                          ),
                        ),
                      if (voice.phase != VoicePhase.idle ||
                          voice.notice.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              '${voice.statusLabel}${voice.text.isEmpty ? '' : '\n${voice.text}'}',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      if ([
                        SpeechIssue.permissionDenied,
                        SpeechIssue.unavailable,
                        SpeechIssue.languageMissing,
                      ].contains(voice.issue))
                        SliverToBoxAdapter(
                          child: TextButton.icon(
                            onPressed: () =>
                                ref.read(speechSettingsProvider)(voice.issue!),
                            icon: const Icon(Icons.settings_voice),
                            label: Text(tr.agentV2.speechSettings),
                          ),
                        ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: DisclaimerFooter(),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildInputBar(context, state.value?.busy ?? false),
              ],
            ),
    );
  }

  Widget _buildNoModel(BuildContext context) {
    return EmptyState(
      icon: Icons.smart_toy_outlined,
      title: tr.assistant.setupTitle,
      hint: tr.assistant.setupHint,
      action: BigPrimaryButton(
        label: tr.assistant.addModel,
        icon: Icons.settings,
        height: 76,
        onPressed: () => context.push('/settings/models'),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BrandMark(size: 88),
            const SizedBox(height: 16),
            Text(tr.assistant.emptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              tr.assistant.emptyHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(
    BuildContext context,
    ChatMessage message,
    AssistantState state,
  ) {
    final theme = Theme.of(context);
    final isUser = message.role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary : AppTheme.warmSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isUser ? AppTheme.primary : AppTheme.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D4776A1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: isUser ? Colors.white : AppTheme.ink,
              ),
            ),
            if (!isUser) ...[
              const SizedBox(height: 6),
              const DisclaimerFooter(),
              // 容错出口（docs/07 §3）：AI 答错了有"不对"按钮，点了直接帮您
              // 把纠偏的话放进输入框。
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  icon: const Icon(Icons.thumb_down_alt_outlined, size: 18),
                  label: Text(tr.assistant.correct),
                  onPressed: () {
                    _inputController.text = tr.assistant.correctionPrefix;
                    _inputController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _inputController.text.length),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, bool busy) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Row(
          children: [
            Semantics(
              label: tr.agentV2.hold,
              value: ref.watch(voiceControllerProvider).statusLabel,
              enabled: !busy,
              button: true,
              child: Listener(
                onPointerDown: (event) {
                  if (busy || _pointer != null) return;
                  _pointer = event.pointer;
                  _pressY = event.position.dy;
                  unawaited(ref.read(voiceControllerProvider.notifier).press());
                },
                onPointerMove: (event) {
                  if (event.pointer == _pointer) {
                    ref
                        .read(voiceControllerProvider.notifier)
                        .drag(_pressY - event.position.dy);
                  }
                },
                onPointerUp: (event) {
                  if (event.pointer != _pointer) return;
                  _pointer = null;
                  unawaited(
                    ref.read(voiceControllerProvider.notifier).release(),
                  );
                },
                onPointerCancel: (event) {
                  if (event.pointer != _pointer) return;
                  _pointer = null;
                  unawaited(
                    ref.read(voiceControllerProvider.notifier).cancel(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 72,
                    height: 64,
                    child: Tooltip(
                      message: tr.agentV2.hold,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              ref.watch(voiceControllerProvider).recording
                              ? AppTheme.badRed
                              : AppTheme.primary,
                        ),
                        onPressed: busy ? null : () {},
                        child: const Icon(Icons.mic, size: 30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _inputController,
                style: theme.textTheme.bodyLarge,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(hintText: tr.assistant.inputHint),
                onSubmitted: _send,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 72,
              height: 64,
              child: FilledButton(
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: busy ? null : () => _send(_inputController.text),
                child: busy
                    ? const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 可撤销确认条（AI 代办打卡后显示，docs/03 §4）。
class _UndoStrip extends StatelessWidget {
  const _UndoStrip({required this.writes, required this.onUndo});

  final List<AgentWriteEvent> writes;
  final void Function(AgentWriteEvent) onUndo;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final event in writes)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(event.summary, style: theme.textTheme.bodyLarge),
                  Wrap(
                    children: [
                      if (event.kind == 'draft')
                        TextButton(
                          onPressed: () =>
                              context.push('/draft/${event.taskId}'),
                          child: Text(tr.agentV2.reviewDraft),
                        ),
                      TextButton(
                        onPressed: () => onUndo(event),
                        child: Text(tr.agentV2.undo),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
