import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/session_controller.dart';
import '../../l10n/app_localizations.dart';
import 'auth_actions.dart';
import 'auth_form.dart';
import 'google_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final expired = ref.watch(sessionProvider.select((s) => s.value?.expired ?? false));
    return AuthForm(
      title: l10n.authTitle,
      subtitle: l10n.authSubtitle,
      submitLabel: l10n.authSubmit,
      notice: expired ? l10n.authSessionExpired : null,
      onSubmit: (u, p) => ref.read(authActionsProvider).login(u, p),
      extra: const GoogleButton(),
      footer: _SwitchLink(text: l10n.authNoAccount, action: l10n.authGoToRegister, to: '/register'),
    );
  }
}

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  static const minPassword = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AuthForm(
      title: l10n.authRegisterTitle,
      subtitle: l10n.authRegisterSubtitle,
      submitLabel: l10n.authRegisterSubmit,
      passwordHint: l10n.authPasswordHint(minPassword),
      minPassword: minPassword,
      onSubmit: (u, p) => ref.read(authActionsProvider).register(u, p),
      extra: const GoogleButton(),
      footer: _SwitchLink(text: l10n.authHaveAccount, action: l10n.authGoToLogin, to: '/login'),
    );
  }
}

class _SwitchLink extends StatelessWidget {
  const _SwitchLink({required this.text, required this.action, required this.to});
  final String text, action, to;

  @override
  Widget build(BuildContext context) => Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(text),
          TextButton(onPressed: () => context.go(to), child: Text(action)),
        ],
      );
}
