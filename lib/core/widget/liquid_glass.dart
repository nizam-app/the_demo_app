import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Frosted iOS surface. The [child] keeps its own size and layout.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.sigma = 18,
    this.padding,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double sigma;
  final EdgeInsetsGeometry? padding;

  /// Chrome wash. [topEdge] is for a bottom bar; otherwise the hairline sits on the bottom.
  static BoxDecoration barDecoration({bool topEdge = false}) {
    final BorderSide hairline = BorderSide(
      color: Colors.white.withOpacity(0.72),
      width: 0.6,
    );
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.62),
          Colors.white.withOpacity(0.28),
        ],
      ),
      border: Border(
        top: topEdge ? hairline : BorderSide.none,
        bottom: topEdge ? BorderSide.none : hairline,
      ),
    );
  }

  /// Frosted circular control (header menu / edit / add on dashboard).
  static BoxDecoration circleButtonDecoration({bool pressed = false}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(pressed ? 0.62 : 0.46),
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white.withOpacity(0.75),
        width: 0.8,
      ),
    );
  }

  /// Horizontal category chips on the dashboard.
  static BoxDecoration frostedPillDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.72),
          Colors.white.withOpacity(0.42),
        ],
      ),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: Colors.white.withOpacity(0.70),
        width: 0.8,
      ),
    );
  }

  /// Backdrop blur wrapper; caller supplies size/decoration on [child].
  static Widget blurred({
    required Widget child,
    BorderRadius borderRadius = BorderRadius.zero,
    double sigma = 12,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: child,
      ),
    );
  }

  /// Sheets and menus. Radius is applied by the caller.
  static BoxDecoration sheetDecoration({BorderRadius? borderRadius}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.72),
          Colors.white.withOpacity(0.42),
        ],
      ),
      borderRadius: borderRadius,
      border: Border.all(
        color: Colors.white.withOpacity(0.70),
        width: 0.8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = padding == null
        ? child
        : Padding(padding: padding!, child: child);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: DecoratedBox(
          decoration: barDecoration().copyWith(borderRadius: borderRadius),
          child: body,
        ),
      ),
    );
  }
}
