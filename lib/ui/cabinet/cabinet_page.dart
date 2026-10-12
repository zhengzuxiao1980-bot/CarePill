import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/models_controller.dart';
import '../../application/controllers/today_controller.dart';
import '../../domain/services/model_selection.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 药箱页（docs/07 §1）：在用药卡列表 + 大号"＋加药"。
class CabinetPage extends ConsumerWidget {
  const CabinetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final state = ref.watch(cabinetControllerProvider);
    final capability = ref.watch(visionCapabilityProvider).value;
    return Scaffold(
      appBar: buildPillPalAppBar(title: tr.cabinet.title),
      floatingActionButton: SizedBox(
        width: 84,
        height: 84,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => _showAddSheet(context, capability: capability),
            child: const Icon(Icons.add, size: 44),
          ),
        ),
      ),
      body: state.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(cabinetControllerProvider),
        ),
        data: (cards) {
          if (cards.isEmpty) {
            return EmptyState(
              icon: Icons.medication,
              title: tr.cabinet.emptyTitle,
              hint: tr.cabinet.emptyHint,
              action: BigPrimaryButton(
                label: tr.cabinet.add,
                icon: Icons.add,
                height: 72,
                onPressed: () => _showAddSheet(context, capability: capability),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.cabinet.activeTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tr.cabinet.count(arg1: (cards.length).toString()),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              for (final (index, card) in cards.indexed)
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: [
                          const Color(0xFFE4F5FF),
                          const Color(0xFFE8F8F3),
                          const Color(0xFFFFF1D9),
                        ][index % 3],
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        Icons.medication_rounded,
                        color: [
                          AppTheme.primary,
                          AppTheme.okGreen,
                          AppTheme.warnAmber,
                        ][index % 3],
                        size: 30,
                      ),
                    ),
                    title: Text(
                      card.medication.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        card.nextDoseSummary ?? tr.cabinet.noSchedule,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    trailing: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right, size: 28),
                    ),
                    onTap: () =>
                        context.push('/medication/${card.medication.id}'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context, {VisionCapability? capability}) {
    final visionAvailable =
        capability == VisionCapability.native ||
        capability == VisionCapability.fallback;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr.cabinet.addTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              BigPrimaryButton(
                label: tr.cabinet.manual,
                icon: Icons.edit,
                height: 76,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.push('/medication/new');
                },
              ),
              const SizedBox(height: 12),
              BigOutlinedButton(
                label: tr.barcode.entry,
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.push('/medication/scan');
                },
              ),
              const SizedBox(height: 12),
              BigOutlinedButton(
                label: capability == VisionCapability.fallback
                    ? tr.cabinet.photoUncertain
                    : visionAvailable
                    ? tr.cabinet.photo
                    : tr.cabinet.photoSetup,
                icon: Icons.camera_alt,
                onPressed: visionAvailable
                    ? () {
                        Navigator.of(sheetContext).pop();
                        context.push('/medication/photo');
                      }
                    : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// 供药箱卡片在详情页保存后刷新使用。
void refreshCabinet(WidgetRef ref) {
  ref.invalidate(cabinetControllerProvider);
  ref.invalidate(todayControllerProvider);
}
