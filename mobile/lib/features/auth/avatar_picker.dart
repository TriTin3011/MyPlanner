import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/session/session_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/session.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import 'account_sheet.dart';

/// Chọn ảnh từ thư viện hoặc máy ảnh rồi `PUT /api/profile/avatar`.
///
/// Ảnh được thu nhỏ ngay trên máy (`maxWidth`, `imageQuality`) để file gửi lên
/// nhỏ hơn giới hạn 5 MB của backend và đỡ tốn dữ liệu di động.
class AvatarPicker extends ConsumerStatefulWidget {
  const AvatarPicker({super.key, required this.session});
  final Session session;

  @override
  ConsumerState<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends ConsumerState<AvatarPicker> {
  static const _maxBytes = 5 * 1024 * 1024;
  bool _busy = false;

  Future<void> _pick(ImageSource source) async {
    final l10n = AppLocalizations.of(context);
    final file = await ImagePicker().pickImage(source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85);
    if (file == null || !mounted) return;
    if (await File(file.path).length() > _maxBytes) {
      if (mounted) showInfo(context, l10n.authPhotoTooLarge);
      return;
    }
    await _run(() async {
      final url = await ref.read(authRepositoryProvider).uploadAvatar(file.path);
      await ref.read(sessionProvider.notifier).updateProfile(avatarUrl: url);
    });
  }

  Future<void> _remove() => _run(() async {
        await ref.read(authRepositoryProvider).deleteAvatar();
        await ref.read(sessionProvider.notifier).updateProfile(clearAvatar: true);
      });

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _menu() {
    final l10n = AppLocalizations.of(context);
    final hasPhoto = widget.session.avatarUrl != null;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.authPhotoHint, textAlign: TextAlign.center),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(hasPhoto ? l10n.authChangePhoto : l10n.authAddPhoto),
              onTap: () {
                Navigator.pop(c);
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.authTakePhoto),
              onTap: () {
                Navigator.pop(c);
                _pick(ImageSource.camera);
              },
            ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.authRemovePhoto),
                onTap: () {
                  Navigator.pop(c);
                  _remove();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          tooltip: AppLocalizations.of(context).authChangePhoto,
          padding: EdgeInsets.zero,
          onPressed: _busy ? null : _menu,
          icon: UserAvatar(name: widget.session.name, url: widget.session.avatarUrl, size: 56),
        ),
        if (_busy) const SizedBox.square(dimension: 56, child: CircularProgressIndicator(strokeWidth: 3)),
      ],
    );
  }
}
