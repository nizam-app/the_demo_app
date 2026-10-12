import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared draggable host for [EditAddSectionSheet] on dashboard-style screens.
class DashboardFloatingEditSectionPanel extends StatefulWidget {
  const DashboardFloatingEditSectionPanel({
    super.key,
    required this.sheetBuilder,
  });

  final Widget Function(
    GestureDragStartCallback onDragStart,
    GestureDragUpdateCallback onDragUpdate,
  ) sheetBuilder;

  @override
  State<DashboardFloatingEditSectionPanel> createState() =>
      _DashboardFloatingEditSectionPanelState();
}

class _DashboardFloatingEditSectionPanelState
    extends State<DashboardFloatingEditSectionPanel> {
  final GlobalKey _sheetMeasureKey = GlobalKey();
  Offset? _position;
  bool _anchoredToBottom = true;

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _anchoredToBottom = false;
      _position ??= _defaultPosition(context);
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position = _clampPosition(
        (_position ?? _defaultPosition(context)) + details.delta,
      );
    });
  }

  Offset _defaultPosition(BuildContext context) {
    final Size screen = MediaQuery.sizeOf(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    final RenderBox? box =
        _sheetMeasureKey.currentContext?.findRenderObject() as RenderBox?;
    final double sheetHeight = box?.size.height ?? screen.height * 0.55;
    return Offset(
      0,
      screen.height - sheetHeight - padding.bottom,
    );
  }

  Offset _clampPosition(Offset position) {
    final Size screen = MediaQuery.sizeOf(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    final RenderBox? box =
        _sheetMeasureKey.currentContext?.findRenderObject() as RenderBox?;
    final double sheetWidth = box?.size.width ?? screen.width;
    final double sheetHeight = box?.size.height ?? screen.height * 0.55;
    final double edgePeek = 52.h;
    final double minTop = padding.top;
    final double maxTop = screen.height - edgePeek;
    return Offset(
      position.dx.clamp(0.0, math.max(0.0, screen.width - sheetWidth)),
      position.dy.clamp(minTop, maxTop),
    );
  }

  void _syncBottomAnchor() {
    if (!_anchoredToBottom || _position != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_anchoredToBottom || _position != null) return;
      final RenderBox? box =
          _sheetMeasureKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;
      setState(() {
        _position = _defaultPosition(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _syncBottomAnchor();
    final Size screen = MediaQuery.sizeOf(context);
    final Widget sheet = widget.sheetBuilder(_onDragStart, _onDragUpdate);

    if (_position == null) {
      return Positioned.fill(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            SafeArea(
              top: false,
              child: KeyedSubtree(
                key: _sheetMeasureKey,
                child: sheet,
              ),
            ),
          ],
        ),
      );
    }

    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: _position!.dx,
            top: _position!.dy,
            width: screen.width,
            child: KeyedSubtree(
              key: _sheetMeasureKey,
              child: sheet,
            ),
          ),
        ],
      ),
    );
  }
}
