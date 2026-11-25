import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/session.dart';

/// Nơi lưu phiên đăng nhập giữa các lần mở app.
///
/// Là interface để test thay bằng bản lưu trong bộ nhớ.
abstract interface class TokenStorage {
  Future<Session?> read();
  Future<void> write(Session session);
  Future<void> clear();
}

/// Lưu vào Keystore (Android) / Keychain (iOS) qua `flutter_secure_storage`.
/// Không dùng `shared_preferences` cho token vì file đó là văn bản thường.
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'myplanner.session';
  final FlutterSecureStorage _storage;

  @override
  Future<Session?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Session(
        accessToken: map['accessToken'] as String,
        expiresAt: DateTime.parse(map['expiresAt'] as String),
        userName: map['userName'] as String,
        displayName: map['displayName'] as String?,
      );
    } catch (_) {
      // Dữ liệu hỏng hoặc khoá Keystore đổi (cài lại app): coi như chưa đăng nhập.
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(Session session) => _storage.write(
        key: _key,
        value: jsonEncode({
          'accessToken': session.accessToken,
          'expiresAt': session.expiresAt.toUtc().toIso8601String(),
          'userName': session.userName,
          'displayName': session.displayName,
        }),
      );

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// Bản trong bộ nhớ cho test.
class MemoryTokenStorage implements TokenStorage {
  MemoryTokenStorage([this._session]);
  Session? _session;

  @override
  Future<Session?> read() async => _session;

  @override
  Future<void> write(Session session) async => _session = session;

  @override
  Future<void> clear() async => _session = null;
}
