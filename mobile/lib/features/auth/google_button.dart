import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/env.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import 'auth_actions.dart';

/// Nút "Đăng nhập bằng Google". Ẩn khi build không có `GOOGLE_CLIENT_ID`,
/// giống web ẩn nút khi thiếu `VITE_GOOGLE_CLIENT_ID`.
///
/// Luồng: SDK Google trên máy (Credential Manager của Android) cho người dùng chọn
/// tài khoản rồi trả về **idToken** có `aud` = Client ID "Web application"
/// (`serverClientId`). App gửi idToken đó cho `POST /api/auth/google`, backend kiểm
/// chữ ký bằng `GoogleTokenVerifier` (cùng Client ID với web) và trả JWT của Mầm.
/// App không bao giờ giữ mật khẩu Google, cũng không tự tin idToken: backend quyết.
class GoogleButton extends ConsumerStatefulWidget {
  const GoogleButton({super.key});

  @override
  ConsumerState<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends ConsumerState<GoogleButton> {
  static Future<void>? _init;
  bool _busy = false;

  /// `initialize` chỉ được gọi một lần cho cả app nên giữ Future ở biến static.
  Future<void> _ensureInit() =>
      _init ??= GoogleSignIn.instance.initialize(serverClientId: Env.googleClientId);

  Future<void> _signIn() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await _ensureInit();
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        if (mounted) showInfo(context, l10n.authGoogleUnavailable);
        return;
      }
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        if (mounted) showInfo(context, l10n.authGoogleUnavailable);
        return;
      }
      await ref.read(authActionsProvider).google(idToken);
      // Router tự chuyển sang Hôm nay khi session có token, không cần điều hướng ở đây.
    } on GoogleSignInException catch (e) {
      // Ghi ra logcat để biết lý do thật: khi thiếu OAuth client Android (package + SHA-1)
      // Google vẫn báo `canceled` kèm mô tả "[16] Account reauth failed".
      debugPrint('Google sign-in: ${e.code} ${e.description}');
      // Người dùng tự đóng hộp chọn tài khoản thì im lặng, không coi là lỗi.
      if (e.code == GoogleSignInExceptionCode.interrupted) return;
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // Hủy thật thì không có mô tả; có mô tả nghĩa là Google từ chối, nên báo cho người dùng.
        if (e.description != null && e.description!.contains('[16]') && mounted) {
          showInfo(context, l10n.authGoogleUnavailable);
        }
        return;
      }
      if (mounted) showInfo(context, l10n.authGoogleUnavailable);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Env.googleClientId.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return OutlinedButton.icon(
      icon: _busy
          ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.g_mobiledata_rounded, size: 28),
      label: Text(l10n.authGoogleContinue),
      onPressed: _busy ? null : _signIn,
    );
  }
}
