import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/models_controller.dart';
import '../../domain/models/view_models.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 模型管理列表（docs/07：配置列表+状态；docs/03 §2 多配置并存）。
class ModelManagePage extends ConsumerWidget {
  const ModelManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final state = ref.watch(modelListControllerProvider);
    return Scaffold(
      appBar: buildPillPalAppBar(
        title: tr.modelManage.title,
        backLocation: '/settings',
      ),
      floatingActionButton: SizedBox(
        width: 84,
        height: 84,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => context.push('/settings/models/new'),
            child: const Icon(Icons.add, size: 44),
          ),
        ),
      ),
      body: state.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e),
        data: (views) {
          if (views.isEmpty) {
            return EmptyState(
              icon: Icons.smart_toy_outlined,
              title: tr.modelManage.emptyTitle,
              hint: tr.modelManage.emptyHint,
              action: BigPrimaryButton(
                label: tr.modelManage.add,
                icon: Icons.add,
                height: 76,
                onPressed: () => context.push('/settings/models/new'),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  tr.modelManage.hint,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              for (final view in views)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              view.config.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (view.config.isChatDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.okGreen.withValues(
                                    alpha: 0.14,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  tr.modelManage.defaultChat,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: AppTheme.okGreen),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tr.modelManage.summary(
                            arg1: (view.config.modelId).toString(),
                            arg2: (view.config.usage.label).toString(),
                            arg3:
                                (view.hasKey
                                        ? tr.modelManage.keySet
                                        : tr.modelManage.keyMissing)
                                    .toString(),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton.tonal(
                              onPressed: () => _test(context, ref, view),
                              child: Text(tr.modelManage.test),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () => context.push(
                                '/settings/models/${view.config.id}',
                              ),
                              child: Text(tr.modelManage.edit),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => _remove(context, ref, view),
                              child: Text(tr.modelManage.delete),
                            ),
                            if (!view.config.isChatDefault)
                              TextButton(
                                onPressed: () => ref
                                    .read(modelListControllerProvider.notifier)
                                    .setDefault(view.config.id),
                                child: Text(tr.modelManage.setDefault),
                              ),
                          ],
                        ),
                        if (view.lastTestMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              view.lastTestMessage!,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: view.lastTestOk == true
                                        ? AppTheme.okGreen
                                        : AppTheme.badRed,
                                  ),
                            ),
                          ),
                        if (view.lastTestMessage == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(tr.modelSetup.notTested),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _test(
    BuildContext context,
    WidgetRef ref,
    ModelConfigView view,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final (ok, message) = await ref
        .read(modelListControllerProvider.notifier)
        .testConfig(view.config.id);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok ? tr.modelManage.connected(arg1: (message).toString()) : message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    ModelConfigView view,
  ) async {
    final ok = await confirmDangerous(
      context,
      title: tr.modelManage.deleteTitle(arg1: (view.config.name).toString()),
      message: tr.modelManage.deleteMessage,
      confirmLabel: tr.modelManage.delete,
    );
    if (ok) {
      await ref
          .read(modelListControllerProvider.notifier)
          .deleteConfig(view.config.id);
    }
  }
}
