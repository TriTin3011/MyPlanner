import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/session/session_controller.dart';
import '../core/settings/app_settings.dart';
import '../design/app_theme.dart';
import '../design/brand_mark.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';

/// Gốc ứng dụng: theme theo bộ màu đã chọn, ngôn ngữ theo cài đặt, router.
class MamApp extends ConsumerWidget {
  const MamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    final loading = ref.watch(sessionProvider.select((s) => s.isLoading && !s.hasValue));

    return MaterialApp.router(
      title: 'Mầm',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(settings.theme),
      locale: Locale(settings.language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      // Đang đọc token từ Keystore: hiện logo thay vì nháy màn đăng nhập.
      builder: (context, child) => loading
          ? ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Center(child: BrandMark(size: 72)),
            )
          : child!,
    );
  }
}
