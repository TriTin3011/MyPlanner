import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

/// Phiên đăng nhập: JWT cùng thông tin hiển thị. Không có refresh token,
/// hết hạn thì người dùng đăng nhập lại (giống bản web).
@freezed
abstract class Session with _$Session {
  const Session._();

  const factory Session({
    required String accessToken,
    required DateTime expiresAt,
    required String userName,
    String? displayName,
    String? avatarUrl,
  }) = _Session;

  /// Tên dùng để chào: tên hiển thị nếu có, không thì tên đăng nhập.
  String get name {
    final d = displayName?.trim();
    return d == null || d.isEmpty ? userName : d;
  }

  bool isExpiredAt(DateTime now) => !now.isBefore(expiresAt);
}
