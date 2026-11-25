import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/settings/app_settings.dart';

/// Điểm vào: chuẩn bị những thứ cần đọc đồng bộ (SharedPreferences, dữ liệu
/// định dạng ngày của `intl`) rồi mới dựng cây widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // google_fonts tải font lần đầu rồi lưu cache trên máy. Bản phát hành nên
  // đóng gói file .ttf vào assets/google_fonts và đặt cờ này = false.
  GoogleFonts.config.allowRuntimeFetching = true;
  final prefs = await SharedPreferences.getInstance();
  await Future.wait([initializeDateFormatting('vi'), initializeDateFormatting('en')]);

  runApp(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const MamApp(),
  ));
}
