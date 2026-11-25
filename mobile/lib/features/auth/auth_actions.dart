import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/session_controller.dart';
import '../../core/sync/data_topics.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/session.dart';

/// Các thao tác đăng nhập dùng chung cho màn Đăng nhập, Đăng ký, nút Google.
///
/// Sau khi có token, gọi thêm `me()` để lấy ảnh đại diện (LoginResponse
/// không có trường này). Lỗi ở bước `me()` không chặn đăng nhập.
class AuthActions {
  AuthActions(this._ref);
  final Ref _ref;

  AuthRepository get _repo => _ref.read(authRepositoryProvider);

  Future<void> login(String userName, String password) => _finish(_repo.login(userName, password));

  Future<void> register(String userName, String password) => _finish(_repo.register(userName, password));

  Future<void> google(String idToken) => _finish(_repo.google(idToken));

  Future<void> _finish(Future<Session> pending) async {
    final session = await pending;
    final controller = _ref.read(sessionProvider.notifier);
    await controller.signIn(session);
    _ref.read(dataRevisionsProvider.notifier).bumpAll();
    try {
      final me = await _repo.me();
      await controller.updateProfile(displayName: me.displayName, avatarUrl: me.avatarUrl);
    } catch (_) {
      // Ảnh đại diện chỉ là phần phụ; MinIO/R2 tắt thì vẫn vào app được.
    }
  }

  Future<void> signOut() => _ref.read(sessionProvider.notifier).signOut();
}

final authActionsProvider = Provider(AuthActions.new);
