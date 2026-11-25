import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/session/session_controller.dart';
import '../features/auth/login_page.dart';
import '../features/goals/goals_page.dart';
import '../features/habits/habits_page.dart';
import '../features/stats/stats_page.dart';
import '../features/today/today_page.dart';
import '../features/week/week_page.dart';
import '../features/year/year_page.dart';
import 'app_shell.dart';

/// Thứ tự tab đáy, cùng thứ tự sidebar bên web.
const shellPaths = ['/today', '/goals', '/habits', '/week', '/year', '/stats'];

/// Cầu nối Riverpod → `Listenable` để go_router chạy lại `redirect` khi phiên đổi.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen(sessionProvider, (_, _) => notifyListeners());
  }
}

/// Router là một provider: tạo một lần, đọc trạng thái phiên qua `ref`.
///
/// `redirect` là "route guard" (≈ `RequireAuth` bên web, `[Authorize]` bên
/// ASP.NET): chưa đăng nhập thì mọi đường dẫn về `/login`, đã đăng nhập mà
/// vào `/login` thì về `/today`.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _SessionListenable(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/today',
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      if (session.isLoading && !session.hasValue) return null; // splash
      final signedIn = session.value?.signedIn ?? false;
      final atAuth = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!signedIn) return atAuth ? null : '/login';
      if (atAuth) return '/today';
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/today'),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/today', builder: (_, _) => const TodayPage())]),
          StatefulShellBranch(routes: [GoRoute(path: '/goals', builder: (_, _) => const GoalsPage())]),
          StatefulShellBranch(routes: [GoRoute(path: '/habits', builder: (_, _) => const HabitsPage())]),
          StatefulShellBranch(routes: [GoRoute(path: '/week', builder: (_, _) => const WeekPage())]),
          StatefulShellBranch(routes: [GoRoute(path: '/year', builder: (_, _) => const YearPage())]),
          StatefulShellBranch(routes: [GoRoute(path: '/stats', builder: (_, _) => const StatsPage())]),
        ],
      ),
    ],
  );
});
