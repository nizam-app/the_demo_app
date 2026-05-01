import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

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
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFE5E7EB).withOpacity(0.18),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: top),
            child: child,
          ),
        ),
      ),
    );
  }
}
