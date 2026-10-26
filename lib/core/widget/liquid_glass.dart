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
    /// Soft linear fade at the bottom (no hairline) — dashboard top chrome.
    this.linearFade = false,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double sigma;
  final EdgeInsetsGeometry? padding;
  final bool linearFade;

  /// Chrome wash. [topEdge] is for a bottom bar; otherwise the hairline sits on the bottom.
  static BoxDecoration barDecoration({
    bool topEdge = false,
    bool linearFade = false,
  }) {
    if (linearFade && !topEdge) {
      // iOS Liquid Glass: opaque → clear, no hard edge / hairline.
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.78),
            Colors.white.withValues(alpha: 0.48),
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.42, 0.78, 1.0],
        ),
      );
    }
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
      color: pressed ? const Color(0xFFF3F4F6) : Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: const Color(0xFFE5E7EB),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF111827).withValues(alpha: 0.06),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
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
  static const double floatingTabBarBlurSigma = 36;

  /// Floating footer tab bar — clearer Liquid Glass wash (more transparent).
  static BoxDecoration floatingTabBarDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.11),
          Colors.white.withValues(alpha: 0.03),
        ],
      ),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.18),
        width: 0.55,
      ),
    );
  }

  /// Selected tab capsule — ultra soft grey (visible on frosted white bar).
  static BoxDecoration floatingTabBarSelectionDecoration() {
    return BoxDecoration(
      color: const Color(0xFF111827).withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: const Color(0xFF111827).withValues(alpha: 0.04),
        width: 0.5,
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

  /// Modal sheet wash — frosted white gradient (blur shows through; inner bubbles stay visible).
  static BoxDecoration sheetDecoration({BorderRadius? borderRadius}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.62),
          Colors.white.withValues(alpha: 0.28),
        ],
      ),
      borderRadius: borderRadius,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.72),
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

  /// Grouped rows inside a sheet (Rename, toggles, etc.) — matches legacy `white @ 60%` bubbles.
  static Color get sheetGroupBubbleColor => Colors.white.withValues(alpha: 0.6);

  static BoxDecoration sheetGroupBubbleDecoration({BorderRadius? borderRadius}) {
    return BoxDecoration(
      color: sheetGroupBubbleColor,
      borderRadius: borderRadius ?? BorderRadius.circular(20),
    );
  }

  /// Backdrop blur for dashboard-style section sheets (Add/Edit Section).
  static const double dashboardModalSheetBlurSigma = 12;

  static const double modalSheetBlurSigma = 22;

  @override
  Widget build(BuildContext context) {
    final Widget content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    Widget chrome = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: DecoratedBox(
          decoration: barDecoration(linearFade: linearFade)
              .copyWith(borderRadius: borderRadius),
          child: const SizedBox.expand(),
        ),
      ),
    );
    if (linearFade) {
      // Fade only the frosted chrome — title and header buttons stay fully opaque.
      chrome = ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0x00FFFFFF),
            ],
            stops: [0.0, 0.72, 1.0],
          ).createShader(bounds);
        },
        child: chrome,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(child: chrome),
          content,
        ],
      ),
    );
  }
}

/// Modal panel — frosted by default; set [opaqueWhite] for solid full-white sheets.
class LiquidGlassModalSheetPanel extends StatelessWidget {
  const LiquidGlassModalSheetPanel({
    super.key,
    required this.borderRadius,
    required this.child,
    this.opaqueWhite = false,
  });

  final BorderRadius borderRadius;
  final Widget child;

  /// Solid `#FFFFFF` panel (no blur / no transparent wash).
  final bool opaqueWhite;

  @override
  Widget build(BuildContext context) {
    if (opaqueWhite) {
      return Material(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: LiquidGlass.dashboardModalSheetBlurSigma,
          sigmaY: LiquidGlass.dashboardModalSheetBlurSigma,
        ),
        child: Material(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration:
                LiquidGlass.sheetDecoration(borderRadius: borderRadius),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Inner-screen top bar — same linear Liquid Glass fade as the dashboard header.
class LiquidGlassInnerScreenHeader extends StatelessWidget {
  const LiquidGlassInnerScreenHeader({
    super.key,
    required this.backgroundColor,
    required this.padding,
    required this.child,
    this.scrollOffset = 0,
    this.glassAfterPixels = 8,
  });

  /// Kept for call sites; chrome is always frosted (not a solid wash).
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final double scrollOffset;
  final double glassAfterPixels;

  /// 0 at rest → 1 when scrolled (slightly stronger blur).
  double get _glassStrength {
    if (scrollOffset <= glassAfterPixels) return 0;
    return ((scrollOffset - glassAfterPixels) / 28).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final double sigma = 18 + 8 * _glassStrength;
    return LiquidGlass(
      linearFade: false,
      sigma: sigma,
      child: Padding(padding: padding, child: child),
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
    useSafeArea: false,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.25),
    elevation: 0,
    builder: builder,
  );
}
