import 'package:flutter/material.dart';
import 'package:workpleis/core/widget/liquid_glass.dart';

/// Frosted top chrome so scrolling content shows through (shared app look).
class GlassNavigationBar extends StatelessWidget {
  const GlassNavigationBar({
    super.key,
    required this.child,
    this.topInset,
    this.blurSigma = 12,
  });

  final Widget child;

  /// Defaults to [MediaQuery.viewPaddingOf] top (status bar / notch).
  final double? topInset;

  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final top = topInset ?? MediaQuery.viewPaddingOf(context).top;
    return LiquidGlass(
      sigma: blurSigma,
      child: Padding(
        padding: EdgeInsets.only(top: top),
        child: child,
      ),
    );
  }
}
