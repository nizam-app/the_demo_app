import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalCircleIconBtn extends StatelessWidget {
  const GlobalCircleIconBtn({
    this.icon,
    this.child,
    required this.onTap,
    this.color = Colors.white,
    this.useLiquidGlass = true,
  }) : assert(
          icon != null || child != null,
          'Either icon or child must be provided',
        );

  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  final Color? color;
  final bool useLiquidGlass;

  @override
  Widget build(BuildContext context) {
    final double side = 36.w;
    final bool useGlass = useLiquidGlass &&
        (color == null ||
            color == Colors.white ||
            color == const Color(0xFFF3F4F6));
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
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Material(
            color: Colors.white.withOpacity(0.55),
            shape: CircleBorder(
              side: BorderSide(color: Colors.white.withOpacity(0.82), width: 0.8),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(width: side, height: side, child: face),
            ),
          ),
        ),
      ),
    );
  }
}
