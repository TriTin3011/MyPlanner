import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/session.dart';
import '../storage/token_storage.dart';

/// Trạng thái đăng nhập. `expired` = vừa bị đăng xuất do token hết hạn
/// (để màn đăng nhập báo một câu, giống bản web).
class AuthState {
  const AuthState({this.session, this.expired = false});

  final Session? session;
  final bool expired;

  bool get signedIn => session != null;
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => SecureTokenStorage());

/// Đồng hồ tiêm vào được, để test kiểm tra token hết hạn mà không phải chờ.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Nguồn sự thật duy nhất về phiên đăng nhập.
///
/// `AsyncNotifier` vì lúc mở app phải đọc Keystore (bất đồng bộ); router chờ
/// trạng thái này xong mới quyết định vào `/login` hay `/today`.
class SessionController extends AsyncNotifier<AuthState> {
  TokenStorage get _storage => ref.read(tokenStorageProvider);

  @override
  Future<AuthState> build() async {
    final saved = await ref.watch(tokenStorageProvider).read();
    if (saved == null) return const AuthState();
    if (saved.isExpiredAt(ref.read(clockProvider)())) {
      await _storage.clear();
      return const AuthState(expired: true);
    }
    return AuthState(session: saved);
  }

  /// Token hiện tại, đọc đồng bộ cho interceptor. Hết hạn thì trả null.
  String? get validToken {
    final session = state.value?.session;
    if (session == null) return null;
    return session.isExpiredAt(ref.read(clockProvider)()) ? null : session.accessToken;
  }

  Future<void> signIn(Session session) async {
    await _storage.write(session);
    state = AsyncData(AuthState(session: session));
  }

  /// Cập nhật tên hiển thị, ảnh đại diện mà không đổi token.
  Future<void> updateProfile({String? displayName, String? avatarUrl, bool clearAvatar = false}) async {
    final current = state.value?.session;
    if (current == null) return;
    final next = current.copyWith(
      displayName: displayName ?? current.displayName,
      avatarUrl: clearAvatar ? null : (avatarUrl ?? current.avatarUrl),
    );
    await _storage.write(next);
    state = AsyncData(AuthState(session: next));
  }

  Future<void> signOut({bool expired = false}) async {
    await _storage.clear();
    state = AsyncData(AuthState(expired: expired));
  }

  /// Gọi khi API trả 401 hoặc token đã quá hạn.
  Future<void> expire() async {
    if (state.value?.signedIn != true) return;
    await signOut(expired: true);
  }

  void clearExpiredNotice() {
    final current = state.value;
    if (current != null && current.expired) state = const AsyncData(AuthState());
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, AuthState>(SessionController.new);
