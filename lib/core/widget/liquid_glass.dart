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

  /// Backdrop strength for header circular controls (iOS Liquid Glass).
  static const double circleButtonBlurSigma = 20;

  /// Frosted circular control (header menu / edit / add on dashboard).
  static BoxDecoration circleButtonDecoration({bool pressed = false}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: pressed ? 0.82 : 0.72),
          Colors.white.withValues(alpha: pressed ? 0.58 : 0.42),
        ],
      ),
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.78),
        width: 0.85,
      ),
    );
  }

  /// Frosted circular header button — blur + [circleButtonDecoration].
  static Widget circleButton({
    required double size,
    required Widget child,
    double sigma = circleButtonBlurSigma,
    bool pressed = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: floatingPillShadow(),
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            width: size,
            height: size,
            decoration: circleButtonDecoration(pressed: pressed),
            alignment: Alignment.center,
            child: child,
          ),
        ),
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

  /// Backdrop strength for the floating footer tab bar (iOS Liquid Glass).
  static const double floatingTabBarBlurSigma = 28;

  /// Floating footer tab bar — frosted white gradient + hairline (iOS Liquid Glass).
  static BoxDecoration floatingTabBarDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.78),
          Colors.white.withValues(alpha: 0.52),
        ],
      ),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.72),
        width: 0.85,
      ),
    );
  }

  /// Selected tab capsule inside [LiquidGlassFloatingTabBar].
  static BoxDecoration floatingTabBarSelectionDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.85),
        width: 0.75,
      ),
    );
  }

  /// Frosted floating footer pill: blur + [floatingTabBarDecoration].
  static Widget floatingTabBar({
    required Widget child,
    BorderRadius borderRadius = BorderRadius.zero,
    double sigma = floatingTabBarBlurSigma,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: DecoratedBox(
          decoration:
              floatingTabBarDecoration().copyWith(borderRadius: borderRadius),
          child: child,
        ),
      ),
    );
  }

  /// Soft drop shadow for a floating glass pill (tab bar, FAB host).
  static List<BoxShadow> floatingPillShadow() {
    return [
      BoxShadow(
        color: const Color(0xFF111827).withValues(alpha: 0.08),
        blurRadius: 22,
        offset: const Offset(0, 8),
      ),
    ];
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

  /// Sheets and menus. Opaque white (Figma) — semi-transparent fill tints grey over #F3F4F6.
  static BoxDecoration sheetDecoration({BorderRadius? borderRadius}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: borderRadius,
      border: Border.all(
        color: const Color(0xFFE5E7EB),
        width: 0.6,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF111827).withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  static const double modalSheetBlurSigma = 22;

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

/// White modal bottom sheet panel ([LiquidGlass.sheetDecoration]).
class LiquidGlassModalSheetPanel extends StatelessWidget {
  const LiquidGlassModalSheetPanel({
    super.key,
    required this.borderRadius,
    required this.child,
  });

  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: LiquidGlass.sheetDecoration(borderRadius: borderRadius),
        child: child,
      ),
    );
  }
}

/// Modal bottom sheet with transparent route chrome (no M3 grey surface).
/// Inner-screen top bar: solid [backgroundColor] at rest, frosted glass when scrolled.
class LiquidGlassInnerScreenHeader extends StatelessWidget {
  const LiquidGlassInnerScreenHeader({
    super.key,
    required this.backgroundColor,
    required this.padding,
    required this.child,
    this.scrollOffset = 0,
    this.glassAfterPixels = 8,
  });

  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final double scrollOffset;
  final double glassAfterPixels;

  bool get _scrolled => scrollOffset > glassAfterPixels;

  @override
  Widget build(BuildContext context) {
    if (!_scrolled) {
      return ColoredBox(
        color: backgroundColor,
        child: Padding(padding: padding, child: child),
      );
    }
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: LiquidGlass.barDecoration(),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Listens to vertical scroll and reports offset for [LiquidGlassInnerScreenHeader].
Widget listenInnerScreenScroll({
  required Widget child,
  required ValueChanged<double> onScrollOffset,
}) {
  return NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification n) {
      if (n.metrics.axis != Axis.vertical) return false;
      if (n is ScrollUpdateNotification ||
          n is ScrollEndNotification ||
          n is ScrollMetricsNotification) {
        onScrollOffset(n.metrics.pixels);
      }
      return false;
    },
    child: child,
  );
}

void updateInnerScreenHeaderScrollOffset({
  required double current,
  required double next,
  required VoidCallback apply,
}) {
  if ((next - current).abs() >= 0.5) apply();
}

Future<T?> showLiquidGlassModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool useSafeArea = false,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.25),
    elevation: 0,
    builder: builder,
  );
}
