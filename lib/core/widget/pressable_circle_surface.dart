import 'package:flutter/material.dart';
import 'package:workpleis/core/utils/ui_tap_haptic.dart';
import 'package:workpleis/core/widget/liquid_glass.dart';

/// Circular header/control surface — optional frosted Liquid Glass chrome.
class PressableCircleSurface extends StatefulWidget {
  const PressableCircleSurface({
    super.key,
    required this.side,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.marked = false,
    this.enableHaptic = true,
    this.idleTransparent = false,
    this.useLiquidGlass = false,
  });

  final double side;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final bool marked;
  final bool enableHaptic;
  final bool idleTransparent;
  final bool useLiquidGlass;

  static const Color pressedFill = Color(0xFFE5E7EB);

  @override
  State<PressableCircleSurface> createState() => _PressableCircleSurfaceState();
}

class _PressableCircleSurfaceState extends State<PressableCircleSurface> {
  bool _pressed = false;
  bool _longPressHandled = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final bool glass = widget.useLiquidGlass && !widget.idleTransparent;
    final bool highlight = widget.marked || _pressed;
    final Widget circle;
    if (glass) {
      circle = LiquidGlass.blurred(
        borderRadius: BorderRadius.circular(widget.side / 2),
        sigma: 16,
        child: Container(
          width: widget.side,
          height: widget.side,
          decoration: LiquidGlass.circleButtonDecoration(pressed: highlight),
          alignment: Alignment.center,
          child: widget.child,
        ),
      );
    } else {
      final Color fill = highlight
          ? PressableCircleSurface.pressedFill
          : widget.idleTransparent
          ? Colors.transparent
          : Colors.white;
      circle = Container(
        width: widget.side,
        height: widget.side,
        decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: widget.child,
      );
    }
    if (widget.onTap == null &&
        widget.onLongPress == null &&
        widget.onLongPressStart == null) {
      return circle;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        _longPressHandled = false;
        _setPressed(true);
      },
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (_longPressHandled) {
                _longPressHandled = false;
                _setPressed(false);
                return;
              }
              if (widget.enableHaptic) uiTapHaptic();
              widget.onTap!();
              _setPressed(false);
            },
      onLongPressStart: widget.onLongPressStart == null
          ? null
          : (_) {
              _longPressHandled = true;
              if (widget.enableHaptic) uiTapHaptic();
              widget.onLongPressStart!();
              _setPressed(false);
            },
      onLongPressEnd: widget.onLongPressEnd == null
          ? null
          : (_) {
              if (widget.enableHaptic) uiTapHaptic();
              widget.onLongPressEnd!();
              _setPressed(false);
            },
      onLongPress: widget.onLongPress == null && widget.onLongPressStart == null
          ? null
          : () {
              if (widget.onLongPressStart == null &&
                  widget.onLongPress != null) {
                _longPressHandled = true;
                if (widget.enableHaptic) uiTapHaptic();
                widget.onLongPress!();
                _setPressed(false);
              }
            },
      child: circle,
    );
  }
}

/// Frosted close control for bottom sheets and popups.
class LiquidGlassCloseButton extends StatelessWidget {
  const LiquidGlassCloseButton({
    super.key,
    required this.onPressed,
    this.size,
    this.iconColor = const Color(0xFF111827),
  });

  final VoidCallback onPressed;
  final double? size;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final double side = size ?? 30;
    return PressableCircleSurface(
      side: side,
      useLiquidGlass: true,
      enableHaptic: false,
      onTap: onPressed,
      child: Icon(Icons.close_rounded, size: side * 0.67, color: iconColor),
    );
  }
}
