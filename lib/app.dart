import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slang_flutter/slang_flutter.dart';

import 'application/app_bootstrap.dart';
import 'application/platform_startup.dart';
import 'application/providers.dart';
import 'application/router.dart';
import 'i18n/strings.g.dart';
import 'ui/theme/app_theme.dart';
import 'ui/widgets/common.dart';

class PillPalApp extends ConsumerStatefulWidget {
  const PillPalApp({super.key});

  @override
  ConsumerState<PillPalApp> createState() => _PillPalAppState();
}

class _PillPalAppState extends ConsumerState<PillPalApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // 首帧与路由就绪后才调用平台插件，失败也不会留在原生开屏。
      final startup = ref.read(appPlatformStartupProvider);
      if (startup != null) unawaited(startup.start());
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontTier = ref.watch(fontTierProvider);
    // 启动补偿：任务展开 + 漏服判定 + 提醒重排（App 级一次）。
    ref.watch(appBootstrapProvider);

    // Slang's locale stream drives Flutter while generated resources remain
    // pure Dart, so notifications and domain services work in a background isolate.
    return StreamBuilder<AppLocale>(
      stream: LocaleSettings.getLocaleStream(),
      initialData: LocaleSettings.currentLocale,
      builder: (context, snapshot) => MaterialApp.router(
        title: 'CarePill',
        theme: AppTheme.theme(fontTier),
        routerConfig: ref.watch(routerProvider),
        builder: (context, child) =>
            PillPalBackdrop(child: child ?? const SizedBox.shrink()),
        locale: snapshot.requireData.flutterLocale,
        supportedLocales: AppLocaleUtils.instance.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: kDebugMode,
      ),
    );
  }
}
