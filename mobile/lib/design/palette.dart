import 'package:flutter/material.dart';

import '../core/settings/app_settings.dart';

/// Token màu của Mầm, chép từ `frontend/src/styles/tokens.css` (SPEC §4).
///
/// Là một `ThemeExtension` để widget đọc `context.palette.primary` thay vì
/// mã màu cứng: đổi theme là mọi widget vẽ lại theo bộ màu mới, giống CSS variables.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.brightness,
    required this.bgApp,
    required this.paper,
    required this.grid,
    required this.surface,
    required this.primary,
    required this.primaryInk,
    required this.primaryText,
    required this.accentSoft,
    required this.accentTint,
    required this.ink,
    required this.muted,
    required this.line,
    required this.sketchInk,
    required this.warn,
    required this.warnInk,
    required this.danger,
    required this.dangerText,
    required this.dangerBg,
    required this.urgentBg,
    required this.urgentFg,
    required this.importantBg,
    required this.importantFg,
    required this.mutedBar,
    required this.chartTotal,
  });

  final Brightness brightness;
  final Color bgApp, paper, grid, surface;
  final Color primary, primaryInk, primaryText, accentSoft, accentTint;
  final Color ink, muted, line, sketchInk;
  final Color warn, warnInk, danger, dangerText, dangerBg;
  final Color urgentBg, urgentFg, importantBg, importantFg;
  final Color mutedBar, chartTotal;

  static const _light = (
    grid: Color(0x14105C40),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF1C2B24),
    muted: Color(0xFF6B7A72),
    line: Color(0xFFE3E9E4),
    warn: Color(0xFFF59E0B),
    warnInk: Color(0xFFB45309),
    danger: Color(0xFFDC2646),
    dangerBg: Color(0xFFFDE8EC),
    urgentBg: Color(0xFFFEE2E2),
    urgentFg: Color(0xFFDC2626),
    importantBg: Color(0xFFFEF3C7),
    importantFg: Color(0xFFB45309),
    mutedBar: Color(0xFFC9CDD1),
    chartTotal: Color(0xFF94A3B8),
  );

  factory Palette._lightWith({
    required Color bgApp,
    required Color paper,
    required Color primary,
    required Color primaryInk,
    required Color accentSoft,
    required Color accentTint,
  }) =>
      Palette(
        brightness: Brightness.light,
        bgApp: bgApp,
        paper: paper,
        grid: _light.grid,
        surface: _light.surface,
        primary: primary,
        primaryInk: primaryInk,
        primaryText: primary,
        accentSoft: accentSoft,
        accentTint: accentTint,
        ink: _light.ink,
        muted: _light.muted,
        line: _light.line,
        sketchInk: _light.ink,
        warn: _light.warn,
        warnInk: _light.warnInk,
        danger: _light.danger,
        dangerText: _light.danger,
        dangerBg: _light.dangerBg,
        urgentBg: _light.urgentBg,
        urgentFg: _light.urgentFg,
        importantBg: _light.importantBg,
        importantFg: _light.importantFg,
        mutedBar: _light.mutedBar,
        chartTotal: _light.chartTotal,
      );

  static final forest = Palette._lightWith(
    bgApp: const Color(0xFFEEF4E8),
    paper: const Color(0xFFF3F7EE),
    primary: const Color(0xFF0B7A55),
    primaryInk: const Color(0xFF0A4D37),
    accentSoft: const Color(0xFFB7F0D8),
    accentTint: const Color(0xFFDDF3E8),
  );

  static final ocean = Palette._lightWith(
    bgApp: const Color(0xFFEEF2FB),
    paper: const Color(0xFFF3F6FC),
    primary: const Color(0xFF1D4ED8),
    primaryInk: const Color(0xFF1E3A8A),
    accentSoft: const Color(0xFFBFDBFE),
    accentTint: const Color(0xFFDBEAFE),
  );

  static final sunset = Palette._lightWith(
    bgApp: const Color(0xFFFBF1EA),
    paper: const Color(0xFFFCF5EF),
    primary: const Color(0xFFC2410C),
    primaryInk: const Color(0xFF7C2D12),
    accentSoft: const Color(0xFFFED7AA),
    accentTint: const Color(0xFFFFEDD5),
  );

  static final lavender = Palette._lightWith(
    bgApp: const Color(0xFFF3F0FB),
    paper: const Color(0xFFF7F5FC),
    primary: const Color(0xFF6D28D9),
    primaryInk: const Color(0xFF4C1D95),
    accentSoft: const Color(0xFFDDD6FE),
    accentTint: const Color(0xFFEDE9FE),
  );

  static const night = Palette(
    brightness: Brightness.dark,
    bgApp: Color(0xFF0F1517),
    paper: Color(0xFF141B1D),
    grid: Color(0x0DB4E6D2),
    surface: Color(0xFF1B2426),
    primary: Color(0xFF0E8159),
    primaryInk: Color(0xFF8CE6C2),
    primaryText: Color(0xFF5FD8AA),
    accentSoft: Color(0xFF1F4A3C),
    accentTint: Color(0xFF1A3329),
    ink: Color(0xFFE6EEEA),
    muted: Color(0xFF9FB0A8),
    line: Color(0xFF2E3B3C),
    sketchInk: Color(0xFF84978F),
    warn: Color(0xFFF59E0B),
    warnInk: Color(0xFFFBBF24),
    danger: Color(0xFFDC2646),
    dangerText: Color(0xFFFF8FA3),
    dangerBg: Color(0xFF47202B),
    urgentBg: Color(0xFF47202B),
    urgentFg: Color(0xFFFFA3B4),
    importantBg: Color(0xFF433413),
    importantFg: Color(0xFFFCD34D),
    mutedBar: Color(0xFF4A5759),
    chartTotal: Color(0xFF7F9094),
  );

  static Palette of(AppThemeId id) => switch (id) {
        AppThemeId.forest => forest,
        AppThemeId.ocean => ocean,
        AppThemeId.sunset => sunset,
        AppThemeId.lavender => lavender,
        AppThemeId.night => night,
      };

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return Palette(
      brightness: t < .5 ? brightness : other.brightness,
      bgApp: l(bgApp, other.bgApp),
      paper: l(paper, other.paper),
      grid: l(grid, other.grid),
      surface: l(surface, other.surface),
      primary: l(primary, other.primary),
      primaryInk: l(primaryInk, other.primaryInk),
      primaryText: l(primaryText, other.primaryText),
      accentSoft: l(accentSoft, other.accentSoft),
      accentTint: l(accentTint, other.accentTint),
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      line: l(line, other.line),
      sketchInk: l(sketchInk, other.sketchInk),
      warn: l(warn, other.warn),
      warnInk: l(warnInk, other.warnInk),
      danger: l(danger, other.danger),
      dangerText: l(dangerText, other.dangerText),
      dangerBg: l(dangerBg, other.dangerBg),
      urgentBg: l(urgentBg, other.urgentBg),
      urgentFg: l(urgentFg, other.urgentFg),
      importantBg: l(importantBg, other.importantBg),
      importantFg: l(importantFg, other.importantFg),
      mutedBar: l(mutedBar, other.mutedBar),
      chartTotal: l(chartTotal, other.chartTotal),
    );
  }
}

extension PaletteContext on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}
