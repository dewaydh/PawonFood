import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/data/settings_repository.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

class PawonApp extends ConsumerWidget {
  const PawonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'PawonFood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final effectiveScaler = TextScaler.linear(settings.fontScale);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        AppColors.isDark = isDark;

        return MediaQuery(
          data: media.copyWith(
            textScaler: effectiveScaler,
            disableAnimations: settings.reducedMotion || media.disableAnimations,
          ),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(statusBarColor: Colors.transparent),
            child: child!,
          ),
        );
      },
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID')],
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
    );
  }
}
