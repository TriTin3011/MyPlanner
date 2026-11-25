import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_failure.dart';
import '../../core/settings/app_settings.dart';
import '../../design/brand_mark.dart';
import '../../design/palette.dart';
import '../../design/sketch.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';

/// Khung chung của Đăng nhập và Đăng ký: logo, thẻ vẽ tay, hai ô nhập, nút gửi.
///
/// Hai màn chỉ khác chữ và hàm `onSubmit`, nên gom về một widget có tham số
/// (giống component dùng chung `AuthCard` bên web).
class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({
    super.key,
    required this.title,
    required this.subtitle,
    required this.submitLabel,
    required this.onSubmit,
    required this.footer,
    this.passwordHint,
    this.minPassword = 1,
    this.notice,
    this.extra,
  });

  final String title, subtitle, submitLabel;
  final Future<void> Function(String userName, String password) onSubmit;
  final Widget footer;
  final String? passwordHint, notice;
  final int minPassword;
  final Widget? extra;

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _form = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _busy = false, _obscure = true;
  String? _error;

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSubmit(_user.text, _pass.text);
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      // 401 ở màn đăng nhập là "sai tên hoặc mật khẩu": backend đã gửi câu đã dịch.
      final f = AppFailure.from(e);
      setState(() => _error = f is UnauthorizedFailure ? (f.message ?? l10n.errorUnknown) : failureMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PaperBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SketchBox(
                  seed: 7,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: AutofillGroup(
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => ref
                                  .read(settingsProvider.notifier)
                                  .setLanguage(settings.language == 'vi' ? 'en' : 'vi'),
                              child: Text(settings.language == 'vi' ? 'EN' : 'VI'),
                            ),
                          ),
                          const Center(child: BrandMark(size: 56)),
                          const SizedBox(height: 12),
                          Text(widget.title,
                              textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text(widget.subtitle, textAlign: TextAlign.center, style: TextStyle(color: p.muted)),
                          if (widget.notice != null) ...[
                            const SizedBox(height: 12),
                            _Banner(text: widget.notice!, bg: p.accentSoft, fg: p.primaryInk),
                          ],
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _user,
                            enabled: !_busy,
                            autofillHints: const [AutofillHints.username],
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(labelText: l10n.authUserName, hintText: l10n.authUserNameHint),
                            validator: (v) => (v == null || v.trim().isEmpty) ? l10n.authUserName : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _pass,
                            enabled: !_busy,
                            obscureText: _obscure,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: l10n.authPassword,
                              helperText: widget.passwordHint,
                              suffixIcon: IconButton(
                                tooltip: _obscure ? l10n.authShowPassword : l10n.authHidePassword,
                                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.length < widget.minPassword) ? (widget.passwordHint ?? l10n.authPassword) : null,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            _Banner(text: _error!, bg: p.dangerBg, fg: p.dangerText),
                          ],
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _busy ? null : _submit,
                            child: _busy
                                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : Text(widget.submitLabel),
                          ),
                          if (widget.extra != null) ...[const SizedBox(height: 12), widget.extra!],
                          const SizedBox(height: 8),
                          widget.footer,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, required this.bg, required this.fg});
  final String text;
  final Color bg, fg;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          child: Text(text, style: TextStyle(color: fg)),
        ),
      );
}
