import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/settings/app_settings.dart';
import 'palette.dart';

/// Dựng `ThemeData` từ `Palette`. Font: Baloo 2 cho tiêu đề, Be Vietnam Pro cho chữ
/// thường (giống web). Ô nhập dùng cỡ chữ 16 để bàn phím iOS/Android không tự phóng to.
ThemeData buildTheme(AppThemeId id) {
  final p = Palette.of(id);
  final scheme = ColorScheme.fromSeed(
    seedColor: p.primary,
    brightness: p.brightness,
  ).copyWith(
    primary: p.primary,
    onPrimary: Colors.white,
    surface: p.surface,
    onSurface: p.ink,
    error: p.danger,
    outline: p.line,
  );

  final base = ThemeData(useMaterial3: true, colorScheme: scheme, brightness: p.brightness);
  // Lấy fontFamily từ google_fonts rồi `apply` lên TextTheme gốc: tránh hàm `xxxTextTheme`
  // của google_fonts (kiểu TextTheme của gói lệch với SDK Flutter mới).
  final body = base.textTheme.apply(
    fontFamily: GoogleFonts.beVietnamPro().fontFamily,
    bodyColor: p.ink,
    displayColor: p.ink,
  );
  TextStyle? heading(TextStyle? s) => GoogleFonts.baloo2(textStyle: s, fontWeight: FontWeight.w700, color: p.ink);

  final text = body.copyWith(
    headlineLarge: heading(body.headlineLarge),
    headlineMedium: heading(body.headlineMedium),
    headlineSmall: heading(body.headlineSmall),
    titleLarge: heading(body.titleLarge),
    titleMedium: heading(body.titleMedium)?.copyWith(fontSize: 18),
  );

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: p.sketchInk, width: 1.5),
  );

  return base.copyWith(
    scaffoldBackgroundColor: p.bgApp,
    extensions: [p],
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: p.bgApp,
      foregroundColor: p.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: text.titleLarge,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: p.primary, width: 2)),
      hintStyle: TextStyle(color: p.muted, fontSize: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(44, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: p.sketchInk, width: 2),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.ink,
        minimumSize: const Size(44, 44),
        side: BorderSide(color: p.sketchInk, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: p.primaryText, minimumSize: const Size(44, 44)),
    ),
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: p.sketchInk, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.primary : null),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.surface,
      indicatorColor: p.accentSoft,
      height: 64,
      labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11, color: p.ink, fontWeight: FontWeight.w600)),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(color: s.contains(WidgetState.selected) ? p.primaryInk : p.muted),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    ),
    dialogTheme: DialogThemeData(backgroundColor: p.surface),
    dividerTheme: DividerThemeData(color: p.line, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.ink,
      contentTextStyle: TextStyle(color: p.surface),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.surface,
      selectedColor: p.accentSoft,
      side: BorderSide(color: p.sketchInk, width: 1.2),
      labelStyle: TextStyle(color: p.ink, fontSize: 13),
    ),
  );
}
