import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../platform/local_notification_gateway.dart';
import '../domain/models/medication_barcode.dart';
import '../ui/assistant/assistant_page.dart';
import '../ui/assistant/memory_page.dart';
import '../ui/cabinet/barcode_lookup_page.dart';
import '../ui/cabinet/cabinet_page.dart';
import '../ui/cabinet/draft_confirm_page.dart';
import '../ui/cabinet/medication_detail_page.dart';
import '../ui/cabinet/medication_form_page.dart';
import '../ui/cabinet/photo_capture_page.dart';
import '../ui/onboarding/onboarding_page.dart';
import '../ui/settings/about_page.dart';
import '../ui/settings/model_edit_page.dart';
import '../ui/settings/model_manage_page.dart';
import '../ui/settings/rom_guide_page.dart';
import '../ui/settings/settings_page.dart';
import '../ui/settings/stats_page.dart';
import '../ui/shell/app_shell.dart';
import '../ui/today/reminder_fullscreen_page.dart';
import '../ui/today/today_page.dart';
import 'providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
GoRouter? _router;

/// 通知点击/冷启动的深链入口（路由创建后可用）。
void appRouterGoToReminder(List<String> taskIds) {
  if (taskIds.isEmpty) {
    _router?.go('/today');
    return;
  }
  final encoded = Uri.encodeQueryComponent(taskIds.join(','));
  // push 而非 go：保留用户当前页面，打卡后可返回。
  _router?.push('/reminder?tasks=$encoded');
}

/// 应用路由（docs/04：go_router，深链"点通知跳全屏提醒页"）。
///
/// 四 Tab 信息架构（docs/07 §1）；全屏提醒页和引导页不带底栏。
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/today',
    redirect: (context, state) {
      final done = ref.read(settingsServiceProvider).onboardingDone;
      final inOnboarding = state.matchedLocation.startsWith('/onboarding');
      if (!done && !inOnboarding) {
        final returningToOnboarding =
            state.uri.queryParameters['returnToOnboarding'] == '1';
        const onboardingChildPaths = {
          '/settings/models/new',
          '/medication/new',
          '/medication/photo',
          '/medication/scan',
        };
        final isOnboardingChild =
            onboardingChildPaths.contains(state.matchedLocation) ||
            (state.matchedLocation.startsWith('/draft/') &&
                returningToOnboarding);
        if (!returningToOnboarding || !isOnboardingChild) {
          return '/onboarding';
        }
      }
      if (done && inOnboarding && state.uri.queryParameters['replay'] != '1') {
        return '/today';
      }
      return null;
    },
    routes: [
      // 带 Tab 的主体。
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cabinet',
                builder: (context, state) => const CabinetPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/assistant',
                builder: (context, state) => const AssistantPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      // 引导。
      GoRoute(
        path: '/assistant/memories',
        builder: (context, state) => const MemoryPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingPage(
          replay: state.uri.queryParameters['replay'] == '1',
          initialStep:
              int.tryParse(state.uri.queryParameters['step'] ?? '') ?? 0,
        ),
      ),
      // 全屏提醒（docs/06 §2）。
      GoRoute(
        path: '/reminder',
        builder: (context, state) => ReminderFullscreenPage(
          taskIds: (state.uri.queryParameters['tasks'] ?? '')
              .split(',')
              .where((e) => e.isNotEmpty)
              .toList(),
        ),
      ),
      // 药品。
      GoRoute(
        path: '/medication/new',
        builder: (context, state) => MedicationFormPage(
          barcodeMedicine: state.extra is BarcodeMedication
              ? state.extra as BarcodeMedication
              : null,
          returnToOnboarding:
              state.uri.queryParameters['returnToOnboarding'] == '1',
        ),
      ),
      GoRoute(
        path: '/medication/photo',
        builder: (context, state) => PhotoCapturePage(
          returnToOnboarding:
              state.uri.queryParameters['returnToOnboarding'] == '1',
        ),
      ),
      GoRoute(
        path: '/medication/scan',
        builder: (context, state) => BarcodeLookupPage(
          returnToOnboarding:
              state.uri.queryParameters['returnToOnboarding'] == '1',
        ),
      ),
      GoRoute(
        path: '/medication/:id',
        builder: (context, state) =>
            MedicationDetailPage(medicationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/medication/:id/edit',
        builder: (context, state) => MedicationFormPage(
          editId: state.pathParameters['id'],
          returnToOnboarding:
              state.uri.queryParameters['returnToOnboarding'] == '1',
        ),
      ),
      // 草稿确认（docs/03 §6 强制步骤）。
      GoRoute(
        path: '/draft/:id',
        builder: (context, state) => DraftConfirmPage(
          draftId: state.pathParameters['id']!,
          returnToOnboarding:
              state.uri.queryParameters['returnToOnboarding'] == '1',
        ),
      ),
      // 设置子页。
      GoRoute(
        path: '/settings/models',
        builder: (context, state) => const ModelManagePage(),
      ),
      GoRoute(
        path: '/settings/models/new',
        builder: (context, state) => ModelEditPage(
          returnToOnboarding:
              state.uri.queryParameters['returnToOnboarding'] == '1',
        ),
      ),
      GoRoute(
        path: '/settings/models/:id',
        builder: (context, state) =>
            ModelEditPage(configId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/settings/stats',
        builder: (context, state) => const StatsPage(),
      ),
      GoRoute(
        path: '/settings/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/settings/rom-guide',
        builder: (context, state) => const RomGuidePage(),
      ),
    ],
  );
  _router = router;
  ref.onDispose(() {
    if (identical(_router, router)) _router = null;
    router.dispose();
  });
  return router;
});

/// 通知点击入口（background → UI 的唯一转发，docs/04 §7）。
void handleReminderPayload(String payload) {
  appRouterGoToReminder(parseReminderPayload(payload));
}
