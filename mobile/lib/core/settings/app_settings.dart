import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Năm bộ màu, cùng tên với `data-theme` bên web.
enum AppThemeId { forest, ocean, sunset, lavender, night }

/// Kiểu biểu đồ người dùng chọn cho từng khối (giống toggle bên web).
enum ChartKind { line, bar, table }

/// Cài đặt giao diện, chỉ lưu trên máy (SPEC: dữ liệu ở backend, cài đặt UI ở client).
class AppSettings {
  const AppSettings({
    this.theme = AppThemeId.forest,
    this.language = 'vi',
    this.charts = const {},
  });

  final AppThemeId theme;
  final String language;
  final Map<String, ChartKind> charts;

  ChartKind chart(String key, [ChartKind fallback = ChartKind.line]) => charts[key] ?? fallback;

  AppSettings copyWith({AppThemeId? theme, String? language, Map<String, ChartKind>? charts}) =>
      AppSettings(
        theme: theme ?? this.theme,
        language: language ?? this.language,
        charts: charts ?? this.charts,
      );
}

/// Được ghi đè trong `main()` sau khi `SharedPreferences.getInstance()` xong,
/// để các provider khác đọc đồng bộ.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Ghi đè sharedPreferencesProvider trong main()'),
);

class SettingsController extends Notifier<AppSettings> {
  static const _themeKey = 'settings.theme';
  static const _languageKey = 'settings.language';
  static const _chartPrefix = 'settings.chart.';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeName = prefs.getString(_themeKey);
    final theme = AppThemeId.values.where((t) => t.name == themeName).firstOrNull ?? AppThemeId.forest;
    final language = prefs.getString(_languageKey) ?? _deviceLanguage();
    final charts = <String, ChartKind>{};
    for (final key in prefs.getKeys().where((k) => k.startsWith(_chartPrefix))) {
      final kind = ChartKind.values.where((c) => c.name == prefs.getString(key)).firstOrNull;
      if (kind != null) charts[key.substring(_chartPrefix.length)] = kind;
    }
    return AppSettings(theme: theme, language: language, charts: charts);
  }

  static String _deviceLanguage() {
    final code = PlatformDispatcher.instance.locale.languageCode;
    return code == 'en' ? 'en' : 'vi';
  }

  Future<void> setTheme(AppThemeId theme) async {
    state = state.copyWith(theme: theme);
    await _prefs.setString(_themeKey, theme.name);
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _prefs.setString(_languageKey, language);
  }

  Future<void> setChart(String key, ChartKind kind) async {
    state = state.copyWith(charts: {...state.charts, key: kind});
    await _prefs.setString('$_chartPrefix$key', kind.name);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

