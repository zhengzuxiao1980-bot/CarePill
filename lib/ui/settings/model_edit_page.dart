import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/controllers/model_setup_controller.dart';
import '../../core/deepseek_defaults.dart';
import '../../domain/models/ai_model_config.dart';
import '../../domain/models/ai_provider_preset.dart';
import '../../domain/models/enums.dart';
import '../../i18n/strings.g.dart';
import '../shell/app_shell.dart';
import '../widgets/common.dart';

/// Shared four-step flow for adding and editing an AI configuration.
class ModelEditPage extends ConsumerStatefulWidget {
  const ModelEditPage({
    super.key,
    this.configId,
    this.returnToOnboarding = false,
  });
  final String? configId;
  final bool returnToOnboarding;

  @override
  ConsumerState<ModelEditPage> createState() => _ModelEditPageState();
}

class _ModelEditPageState extends ConsumerState<ModelEditPage> {
  final _fields = <String, TextEditingController>{};
  bool _showKey = false;
  bool _customModel = false;
  String? _error;

  ModelSetupController get _controller =>
      ref.read(modelSetupProvider(widget.configId).notifier);
  String get _fallback =>
      widget.returnToOnboarding ? '/onboarding?step=1' : '/settings/models';

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _back() {
    final state = ref.read(modelSetupProvider(widget.configId));
    if (state.saving) return;
    setState(() => _error = null);
    if (state.step > 0) {
      FocusScope.of(context).unfocus();
      _controller.back();
    } else {
      popPillPalPage(context, fallbackLocation: _fallback);
    }
  }

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    final state = ref.watch(modelSetupProvider(widget.configId));
    final titles = [
      tr.modelSetup.provider,
      tr.modelSetup.connect,
      tr.modelSetup.model,
      tr.modelSetup.finish,
    ];
    return PopScope(
      canPop: state.step == 0 && !state.saving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: buildPillPalAppBar(
          title: widget.configId == null
              ? tr.modelEdit.addTitle
              : tr.modelEdit.editTitle,
          leading: BackButton(onPressed: state.saving ? null : _back),
        ),
        bottomNavigationBar: state.loading || state.loadError != null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BigPrimaryButton(
                        label: state.saving
                            ? tr.modelSetup.saving
                            : state.testing
                            ? tr.modelSetup.testing
                            : state.step < 3
                            ? tr.modelSetup.next
                            : state.testResult?.$1 == true
                            ? tr.modelSetup.save
                            : tr.modelSetup.test,
                        onPressed: state.busy
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                if (state.step < 3) {
                                  setState(() => _error = _controller.next());
                                  if (_error != null) {
                                    UndoBar.show(context, message: _error!);
                                  }
                                } else if (state.testResult?.$1 == true) {
                                  await _save();
                                } else {
                                  setState(
                                    () => _error = _controller.validate(3),
                                  );
                                  if (_error == null) {
                                    await _controller.testConnection();
                                  } else {
                                    UndoBar.show(context, message: _error!);
                                  }
                                }
                              },
                      ),
                      if (state.step == 3) ...[
                        const SizedBox(height: 8),
                        BigOutlinedButton(
                          label: tr.modelSetup.saveLater,
                          onPressed: state.busy ? null : _save,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
        body: state.loading
            ? const LoadingView()
            : state.loadError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.loadError!),
                ),
              )
            : AbsorbPointer(
                absorbing: state.busy,
                child: ListView(
                  key: ValueKey('setup-step-${state.step}'),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    Text(
                      tr.modelSetup.progress(step: state.step + 1),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (state.step + 1) / 4,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      titles[state.step],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ...switch (state.step) {
                      0 => _providerStep(state),
                      1 => _connectionStep(state),
                      2 => _modelStep(state),
                      _ => _reviewStep(state),
                    },
                  ],
                ),
              ),
      ),
    );
  }

  String _providerName(AiProviderId id) => switch (id) {
    AiProviderId.deepseek => 'DeepSeek',
    AiProviderId.qwen => tr.modelEdit.qwenName,
    AiProviderId.kimi => tr.modelEdit.kimiName,
    AiProviderId.glm => tr.modelEdit.glmName,
    AiProviderId.openrouter => tr.modelEdit.openrouterName,
    AiProviderId.ollama => tr.modelEdit.ollamaName,
    AiProviderId.custom => tr.modelSetup.custom,
  };

  Widget _providerChoice(ModelSetupState state, AiProviderPreset provider) =>
      PillPalChoice(
        key: ValueKey('provider-${provider.id.name}'),
        label: _providerName(provider.id),
        selected: state.provider?.id == provider.id,
        onSelected: (_) {
          _controller.selectProvider(provider);
          setState(() {
            _customModel = false;
            _showKey = false;
            _error = null;
          });
        },
      );

  List<Widget> _providerStep(ModelSetupState state) => [
    Text(tr.modelSetup.intro),
    const SizedBox(height: 18),
    for (final provider in AiProviderPreset.all.where((p) => !p.isAdvanced))
      _providerChoice(state, provider),
    ExpansionTile(
      key: const ValueKey('other-providers'),
      initiallyExpanded: state.provider?.isAdvanced == true,
      tilePadding: EdgeInsets.zero,
      title: Text(tr.modelSetup.other),
      children: [
        for (final provider in AiProviderPreset.all.where((p) => p.isAdvanced))
          _providerChoice(state, provider),
      ],
    ),
  ];

  List<Widget> _connectionStep(ModelSetupState state) {
    final provider = state.provider!;
    return [
      Text(
        _providerName(provider.id),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 12),
      if (provider.isLocal)
        Text(tr.modelSetup.localHint)
      else if (provider.keysUrl != null) ...[
        Text(tr.modelSetup.keySteps),
        const SizedBox(height: 16),
        BigOutlinedButton(
          label: tr.modelSetup.openWebsite,
          icon: Icons.open_in_new,
          onPressed: () => _openWebsite(provider.keysUrl!),
        ),
        TextButton(
          onPressed: () => _copyAddress(provider.keysUrl!),
          child: Text(tr.modelSetup.copyUrl),
        ),
        Text(tr.modelSetup.cost),
      ] else
        Text(tr.modelSetup.customHint),
      const SizedBox(height: 20),
      if (provider.isAdvanced)
        _field(
          'url',
          tr.modelEdit.urlLabel,
          state.config.baseUrl,
          (value) => _controller.update(baseUrl: value),
          keyboard: TextInputType.url,
          hint: provider.isLocal
              ? 'http://192.168.1.10:11434/v1'
              : 'https://example.com/v1',
        ),
      if (!provider.isLocal) ...[
        _field(
          'key',
          state.hasStoredKey ? tr.modelSetup.storedKey : tr.modelEdit.keyLabel,
          state.key,
          (value) => _controller.update(key: value),
          secret: true,
          hint: 'sk-…',
        ),
        BigOutlinedButton(
          label: tr.modelSetup.paste,
          icon: Icons.content_paste,
          onPressed: () async {
            final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
            if (!mounted) return;
            if (clipboard?.text?.trim().isNotEmpty == true) {
              _controller.update(key: clipboard!.text!.trim());
            } else {
              UndoBar.show(context, message: tr.modelSetup.emptyClipboard);
            }
          },
        ),
        const SizedBox(height: 12),
        Text(tr.modelEdit.keyPrivacy),
        if (widget.configId != null && !state.hasStoredKey)
          Text(tr.modelSetup.keyChanged),
      ],
    ];
  }

  List<Widget> _modelStep(ModelSetupState state) {
    final config = state.config;
    final models = state.provider!.models;
    final custom =
        _customModel || !models.any((model) => model.id == config.modelId);
    return [
      if (DeepSeekDefaults.isOfficialEndpoint(config.baseUrl) &&
          DeepSeekDefaults.isRetiredModel(config.modelId))
        SectionCard(
          title: tr.modelEdit.deepseekUpdateTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                tr.modelEdit.deepseekUpdateHint(
                  model: DeepSeekDefaults.flashModel,
                ),
              ),
              const SizedBox(height: 12),
              BigOutlinedButton(
                label: tr.modelEdit.deepseekUpdate,
                onPressed: () {
                  _controller.selectModel(
                    AiProviderPreset.all.first.models.first,
                  );
                  setState(() => _customModel = false);
                },
              ),
            ],
          ),
        ),
      Text(tr.modelSetup.modelHint),
      const SizedBox(height: 12),
      for (final (index, model) in models.indexed) ...[
        PillPalChoice(
          key: ValueKey('model-${model.id}'),
          label:
              '${model.name}${index == 0 ? ' · ${tr.modelSetup.recommended}' : ''}',
          selected: !custom && model.id == config.modelId,
          onSelected: (_) {
            _controller.selectModel(model);
            setState(() => _customModel = false);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 16),
          child: Text(
            model.vision
                ? '${tr.modelSetup.chat} · ${tr.modelSetup.vision}'
                : tr.modelSetup.chatOnly,
          ),
        ),
      ],
      PillPalChoice(
        label: tr.modelSetup.customModel,
        selected: custom,
        onSelected: (_) => setState(() => _customModel = true),
      ),
      if (custom) ...[
        Text(tr.modelSetup.unknown),
        const SizedBox(height: 12),
        _field(
          'model',
          tr.modelEdit.modelLabel,
          config.modelId,
          (value) => _controller.update(modelId: value),
        ),
      ],
      ExpansionTile(
        key: const ValueKey('model-advanced'),
        tilePadding: EdgeInsets.zero,
        title: Text(tr.modelSetup.advanced),
        children: [
          _field(
            'name',
            tr.modelEdit.nameLabel,
            config.name,
            (v) => _controller.update(name: v),
          ),
          _field(
            'url',
            tr.modelEdit.urlLabel,
            config.baseUrl,
            (v) => _controller.update(baseUrl: v),
            keyboard: TextInputType.url,
          ),
          if (!state.hasStoredKey &&
              !state.provider!.isLocal &&
              state.key.isEmpty)
            Text(tr.modelSetup.keyChanged),
          Text(
            tr.modelEdit.usage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final usage in ModelUsage.values)
            PillPalChoice(
              label: usage.label,
              selected: config.usage == usage,
              onSelected: (_) => _controller.update(usage: usage),
            ),
          PillPalSwitchField(
            label: tr.modelEdit.vision,
            description: tr.modelEdit.visionHint,
            value: config.supportsVision,
            onChanged: (v) => _controller.update(vision: v),
          ),
          const SizedBox(height: 20),
          PillPalSwitchField(
            label: tr.modelEdit.tools,
            description: tr.modelEdit.toolsHint,
            value: config.supportsFunctionCalling,
            onChanged: (v) => _controller.update(tools: v),
          ),
          const SizedBox(height: 20),
          if (config.supportsChat)
            PillPalSwitchField(
              label: tr.modelEdit.defaultChat,
              value: config.isChatDefault,
              onChanged: (v) => _controller.update(isDefault: v),
            ),
          const SizedBox(height: 16),
          _field(
            'output',
            tr.modelEdit.maxTokens,
            state.maxTokens,
            (v) => _controller.update(maxTokens: v),
            keyboard: TextInputType.number,
          ),
          _field(
            'context',
            tr.agentV2.contextWindow,
            state.contextWindow,
            (v) => _controller.update(contextWindow: v),
            keyboard: TextInputType.number,
          ),
        ],
      ),
    ];
  }

  List<Widget> _reviewStep(ModelSetupState state) => [
    Text(tr.modelSetup.review),
    const SizedBox(height: 16),
    SectionCard(
      title: _providerName(state.provider!.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.config.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(state.config.modelId),
          const SizedBox(height: 12),
          if (state.config.canChat) Text('✓ ${tr.modelSetup.chat}'),
          if (state.config.canVision) Text('✓ ${tr.modelSetup.vision}'),
          const SizedBox(height: 12),
          Text(tr.modelSetup.visionUntested),
        ],
      ),
    ),
    const SizedBox(height: 16),
    Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.testing
                ? tr.modelSetup.testing
                : state.testResult == null
                ? tr.modelSetup.notTested
                : state.testResult!.$1
                ? tr.modelSetup.connected
                : tr.modelSetup.testFailed,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (state.testResult?.$1 == false) ...[
            const SizedBox(height: 8),
            Text(state.testResult!.$2),
          ],
        ],
      ),
    ),
  ];

  Widget _field(
    String id,
    String label,
    String value,
    ValueChanged<String> onChanged, {
    bool secret = false,
    TextInputType? keyboard,
    String? hint,
  }) {
    final controller = _fields.putIfAbsent(id, TextEditingController.new);
    if (controller.text != value) {
      controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: PillPalField(
        label: label,
        child: TextField(
          key: ValueKey('setup-$id'),
          controller: controller,
          obscureText: secret && !_showKey,
          keyboardType: keyboard,
          autocorrect: false,
          enableSuggestions: !secret,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: secret
                ? IconButton(
                    tooltip: _showKey
                        ? tr.modelSetup.hideKey
                        : tr.modelSetup.showKey,
                    icon: Icon(
                      _showKey ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _showKey = !_showKey),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (mounted) UndoBar.show(context, message: tr.modelSetup.copied);
  }

  Future<void> _openWebsite(String address) async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(address),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      /* The visible copy-address button is the fallback. */
    }
    if (mounted && !opened) {
      UndoBar.show(context, message: tr.modelSetup.openFailed);
    }
  }

  Future<void> _save() async {
    final error = _controller.validate(3);
    setState(() => _error = error);
    if (error != null) {
      UndoBar.show(context, message: error);
      return;
    }
    final connected =
        ref.read(modelSetupProvider(widget.configId)).testResult?.$1 == true;
    try {
      if (!await _controller.save() || !mounted) return;
      UndoBar.show(
        context,
        message: connected
            ? tr.modelSetup.savedConnected
            : tr.modelSetup.savedUntested,
      );
      popPillPalPage(
        context,
        fallbackLocation: widget.returnToOnboarding
            ? '/onboarding?step=2'
            : '/settings/models',
        result: true,
      );
    } catch (e) {
      if (mounted) UndoBar.show(context, message: friendlyError(e));
    }
  }
}
