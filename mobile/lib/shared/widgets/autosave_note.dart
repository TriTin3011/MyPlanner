import 'dart:async';

import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../l10n/app_localizations.dart';
import 'async_view.dart';
import 'section.dart';

/// Ô ghi chú tự lưu sau 800ms ngừng gõ (debounce), dùng cho ghi chú ngày và ghi chú tuần.
///
/// [resetKey] đổi (sang ngày/tuần khác) thì nạp lại nội dung từ [initial].
/// Rời màn khi còn chữ chưa lưu thì lưu nốt trong `dispose`.
class AutosaveNote extends StatefulWidget {
  const AutosaveNote({
    super.key,
    required this.title,
    required this.hint,
    required this.initial,
    required this.resetKey,
    required this.onSave,
  });

  final String title, hint, initial;
  final Object resetKey;
  final Future<void> Function(String text) onSave;

  @override
  State<AutosaveNote> createState() => _AutosaveNoteState();
}

enum _SaveState { idle, saving, saved }

class _AutosaveNoteState extends State<AutosaveNote> {
  late final TextEditingController _ctrl = TextEditingController(text: widget.initial);
  Timer? _debounce;
  _SaveState _state = _SaveState.idle;
  late String _lastSaved = widget.initial;

  @override
  void didUpdateWidget(AutosaveNote old) {
    super.didUpdateWidget(old);
    final pending = _debounce?.isActive == true;
    if (old.resetKey != widget.resetKey || (!pending && widget.initial != _lastSaved)) {
      _ctrl.text = widget.initial;
      _lastSaved = widget.initial;
      _state = _SaveState.idle;
    }
  }

  @override
  void dispose() {
    if (_debounce?.isActive == true) {
      _debounce!.cancel();
      widget.onSave(_ctrl.text).ignore();
    }
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), _save);
  }

  Future<void> _save() async {
    final text = _ctrl.text;
    if (text == _lastSaved) return;
    setState(() => _state = _SaveState.saving);
    try {
      await widget.onSave(text);
      _lastSaved = text;
      if (mounted) setState(() => _state = _SaveState.saved);
    } catch (e) {
      if (mounted) {
        setState(() => _state = _SaveState.idle);
        showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return SectionCard(
      title: widget.title,
      trailing: switch (_state) {
        _SaveState.idle => null,
        _SaveState.saving => Text(l10n.saving, style: TextStyle(color: p.muted, fontSize: 12)),
        _SaveState.saved => Text(l10n.saved, style: TextStyle(color: p.primaryText, fontSize: 12)),
      },
      child: TextField(
        controller: _ctrl,
        minLines: 3,
        maxLines: 8,
        maxLength: 4000,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(hintText: widget.hint, counterText: ''),
        onChanged: _onChanged,
      ),
    );
  }
}
