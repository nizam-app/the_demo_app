import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalCircleIconBtn extends StatelessWidget {
  const GlobalCircleIconBtn({
    this.icon,
    this.child,
    required this.onTap,
    this.color = Colors.white,
  }) : assert(
          icon != null || child != null,
          'Either icon or child must be provided',
        );

  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final double side = 36.w;
    final bool useGlass =
        color == null ||
        color == Colors.white ||
        color == const Color(0xFFF3F4F6);
    final Widget face = Center(
      child: child ?? Icon(icon, size: 23.sp, color: const Color(0xFF111827)),
    );
    if (!useGlass) {
      return Material(
        color: color,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: side, height: side, child: face),
        ),
      );
    }
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.white.withOpacity(0.46),
          shape: CircleBorder(
            side: BorderSide(color: Colors.white.withOpacity(0.75), width: 0.8),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(width: side, height: side, child: face),
          ),
        ),
      ),
    );
  }
}
