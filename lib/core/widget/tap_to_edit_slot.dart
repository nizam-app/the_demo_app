import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows the current value, and turns that value into a text field on tap.
/// The surrounding row is built by [builder] so layout and colors stay put.
class TapToEditSlot extends StatefulWidget {
  const TapToEditSlot({
    super.key,
    required this.initialText,
    required this.style,
    required this.builder,
    this.maxWidth,
    this.showPencil = true,
    this.pencilAsset = 'assets/Group 63.png',
    this.pencilWidth,
    this.pencilHeight,
    this.pencilGap,
    this.pencilColor,
    this.textAlign = TextAlign.right,
    this.keyboardType,
    this.obscureText = false,
  });

  final String initialText;
  final TextStyle style;
  final double? maxWidth;
  final bool showPencil;
  final String pencilAsset;
  final double? pencilWidth;
  final double? pencilHeight;
  final double? pencilGap;
  final Color? pencilColor;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final bool obscureText;

  /// [startEditing] is null while the field is already open, so the row
  /// does not steal selection gestures from the text field.
  final Widget Function(
    BuildContext context,
    VoidCallback? startEditing,
    Widget value,
  ) builder;

  @override
  State<TapToEditSlot> createState() => _TapToEditSlotState();
}

class _TapToEditSlotState extends State<TapToEditSlot> {
  late final TextEditingController _controller;
  late final FocusNode _focus;
  late String _committed;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _committed = widget.initialText;
    _controller = TextEditingController(text: widget.initialText);
    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focus.hasFocus && _editing) {
      _commit();
    }
  }

  void _start() {
    setState(() => _editing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_editing) return;
      _focus.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  void _commit() {
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      _controller.text = _committed;
    } else {
      _committed = text;
      _controller.text = text;
    }
    if (!mounted) return;
    setState(() => _editing = false);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.maxWidth ?? 155.w;
    final Widget value = _editing
        ? SizedBox(
            width: width,
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              textAlign: widget.textAlign,
              maxLines: 1,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              showCursor: true,
              enableInteractiveSelection: true,
              selectionHeightStyle: BoxHeightStyle.strut,
              selectionWidthStyle: BoxWidthStyle.max,
              cursorColor: const Color(0xFF0088FE),
              cursorWidth: 2,
              style: widget.style,
              decoration: const InputDecoration(
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _commit(),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Text(
                  _controller.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: widget.textAlign,
                  style: widget.style,
                ),
              ),
              if (widget.showPencil) ...[
                SizedBox(width: widget.pencilGap ?? 6.w),
                Image.asset(
                  widget.pencilAsset,
                  width: widget.pencilWidth ?? 14.w,
                  height: widget.pencilHeight ?? 13.h,
                  fit: BoxFit.contain,
                  color: widget.pencilColor,
                ),
              ],
            ],
          );

    return widget.builder(context, _editing ? null : _start, value);
  }
}
