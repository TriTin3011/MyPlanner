import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/session_controller.dart';
import '../../core/settings/app_settings.dart';
import '../../core/sync/data_topics.dart';
import '../../data/repositories/auth_repository.dart';
import '../../design/palette.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import 'auth_actions.dart';
import 'avatar_picker.dart';

/// Ảnh đại diện tròn; chưa có ảnh thì hiện chữ cái đầu (giống `UserAvatar.tsx`).
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.url, this.size = 36});
  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase();
    final fallback = Center(
      child: Text(initial, style: TextStyle(color: p.primaryInk, fontWeight: FontWeight.w800, fontSize: size * .42)),
    );
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: p.accentSoft,
        border: Border.all(color: p.sketchInk, width: 1.5),
      ),
      child: url == null
          ? fallback
          : Image.network(url!, fit: BoxFit.cover, errorBuilder: (_, _, _) => fallback),
    );
  }
}

/// Menu tài khoản (≈ menu ⋯ của web trên điện thoại): hồ sơ, theme, ngôn ngữ, đăng xuất.
Future<void> showAccountSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AccountSheet(),
    );

class _AccountSheet extends ConsumerStatefulWidget {
  const _AccountSheet();

  @override
  ConsumerState<_AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends ConsumerState<_AccountSheet> {
  late final TextEditingController _name;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: ref.read(sessionProvider).value?.session?.displayName ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    setState(() => _saving = true);
    try {
      final profile = await ref.read(authRepositoryProvider).updateDisplayName(_name.text);
      await ref.read(sessionProvider.notifier).updateProfile(displayName: profile.displayName ?? '');
      ref.bumpTopicsFromWidget([DataTopic.profile]);
      if (mounted) showInfo(context, AppLocalizations.of(context).saved);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final session = ref.watch(sessionProvider.select((s) => s.value?.session));
    final settings = ref.watch(settingsProvider);
    if (session == null) return const SizedBox.shrink();

    final themes = {
      AppThemeId.forest: l10n.themeForest,
      AppThemeId.ocean: l10n.themeOcean,
      AppThemeId.sunset: l10n.themeSunset,
      AppThemeId.lavender: l10n.themeLavender,
      AppThemeId.night: l10n.themeNight,
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AvatarPicker(session: session),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.name, style: Theme.of(context).textTheme.titleMedium),
                      Text(l10n.authLoginName(session.userName), style: TextStyle(color: p.muted, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.authDisplayName, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _name,
                    maxLength: 50,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(hintText: l10n.authDisplayNameHint, counterText: ''),
                    onSubmitted: (_) => _saveName(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _saving ? null : _saveName, child: Text(l10n.save)),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.themeLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in themes.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: settings.theme == entry.key,
                    onSelected: (_) => ref.read(settingsProvider.notifier).setTheme(entry.key),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.languageLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'vi', label: Text('Tiếng Việt')),
                ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {settings.language},
              onSelectionChanged: (s) {
                ref.read(settingsProvider.notifier).setLanguage(s.first);
                // Backend dịch câu nhận xét, tên tháng… theo Accept-Language.
                ref.read(dataRevisionsProvider.notifier).bumpAll();
              },
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: p.dangerText),
              icon: const Icon(Icons.logout),
              label: Text(l10n.authLogout),
              onPressed: () {
                Navigator.pop(context);
                ref.read(authActionsProvider).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension on WidgetRef {
  void bumpTopicsFromWidget(List<DataTopic> topics) => read(dataRevisionsProvider.notifier).bump(topics);
}
