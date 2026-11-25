import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_failure.dart';
import '../../design/palette.dart';
import '../../l10n/app_localizations.dart';

/// Đổi lỗi bất kỳ thành câu cho người dùng. Ưu tiên `detail` của ProblemDetails
/// vì backend đã dịch theo `Accept-Language`.
String failureMessage(AppLocalizations l10n, Object error) {
  final f = AppFailure.from(error);
  return switch (f) {
    NetworkFailure() => l10n.errorNetwork,
    TooManyRequestsFailure(:final retryAfterSeconds) => l10n.errorTooMany(retryAfterSeconds),
    ValidationFailure(:final message, :final firstError) => firstError ?? message ?? l10n.errorUnknown,
    ApiFailure(:final message) => message ?? l10n.errorUnknown,
    _ => l10n.errorUnknown,
  };
}

void showError(BuildContext context, Object error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failureMessage(AppLocalizations.of(context), error))));
}

void showInfo(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
}

/// Hiển thị `AsyncValue`: đang tải → vòng quay, lỗi → thông báo + nút Thử lại,
/// có dữ liệu → `data`. Khi tải lại mà đã có dữ liệu cũ thì giữ dữ liệu cũ
/// (không nháy trắng màn hình), giống `placeholderData` của TanStack Query.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.data, this.onRetry});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (value.hasValue) return data(value.requireValue);
    if (value.hasError) return ErrorPanel(error: value.error!, onRetry: onRetry);
    return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()));
  }
}

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({super.key, required this.error, this.onRetry});
  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 40, color: context.palette.muted),
            const SizedBox(height: 12),
            Text(failureMessage(l10n, error), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Hộp xác nhận cho thao tác xoá (không hoàn tác được).
Future<bool> confirmDialog(BuildContext context, String message, {String? confirmLabel}) async {
  final l10n = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: context.palette.danger),
          onPressed: () => Navigator.pop(c, true),
          child: Text(confirmLabel ?? l10n.delete),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Hộp nhập một dòng chữ (đặt tên thói quen, việc trong tháng…).
Future<String?> promptText(BuildContext context, {required String title, String initial = '', String? hint}) {
  final l10n = AppLocalizations.of(context);
  final ctrl = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: InputDecoration(hintText: hint),
        style: const TextStyle(fontSize: 16),
        textInputAction: TextInputAction.done,
        onSubmitted: (v) => Navigator.pop(c, v.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(c, ctrl.text.trim()), child: Text(l10n.save)),
      ],
    ),
  ).whenComplete(ctrl.dispose);
}
