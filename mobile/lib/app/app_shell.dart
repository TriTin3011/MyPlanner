import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/session/session_controller.dart';
import '../core/sync/data_topics.dart';
import '../design/brand_mark.dart';
import '../design/palette.dart';
import '../features/auth/account_sheet.dart';
import '../l10n/app_localizations.dart';

/// Khung chung sau khi đăng nhập: thanh trên (logo + avatar) và thanh điều
/// hướng đáy 6 tab (SPEC §3.4). Tương đương `AppShell.tsx` ở bề rộng điện thoại.
///
/// `StatefulShellRoute.indexedStack` giữ trạng thái từng tab (vị trí cuộn,
/// ô đang gõ) khi chuyển qua lại, như các tab của ứng dụng di động thật.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Quay lại app sau nửa đêm thì "hôm nay" phải đổi; sau một lúc ở nền thì
    // dữ liệu có thể đã đổi ở web, nên tải lại mọi màn.
    _lifecycle = AppLifecycleListener(onResume: () {
      ref.read(todayProvider.notifier).refresh();
      ref.read(dataRevisionsProvider.notifier).bumpAll();
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _go(int index) =>
      widget.shell.goBranch(index, initialLocation: index == widget.shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final session = ref.watch(sessionProvider.select((s) => s.value?.session));
    final destinations = [
      (Icons.wb_sunny_outlined, Icons.wb_sunny, l10n.navToday),
      (Icons.flag_outlined, Icons.flag, l10n.navGoals),
      (Icons.check_circle_outline, Icons.check_circle, l10n.navHabits),
      (Icons.view_week_outlined, Icons.view_week, l10n.navWeek),
      (Icons.calendar_month_outlined, Icons.calendar_month, l10n.navYear),
      (Icons.insights_outlined, Icons.insights, l10n.navStats),
    ];

    return Scaffold(
      backgroundColor: p.bgApp,
      appBar: AppBar(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 12,
        toolbarHeight: 52,
        title: Row(
          children: [
            const BrandMark(size: 30),
            const SizedBox(width: 8),
            Text('Mầm', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        shape: Border(bottom: BorderSide(color: p.line)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: l10n.authAccount,
              onPressed: () => showAccountSheet(context),
              icon: UserAvatar(name: session?.name ?? '?', url: session?.avatarUrl, size: 34),
            ),
          ),
        ],
      ),
      body: widget.shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.shell.currentIndex,
        onDestinationSelected: _go,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final (icon, selected, label) in destinations)
            NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selected), label: label, tooltip: label),
        ],
      ),
    );
  }
}
