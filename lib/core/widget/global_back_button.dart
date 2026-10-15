import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workpleis/core/widget/pressable_circle_surface.dart';

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
    final Widget face =
        child ?? Icon(icon, size: 23.sp, color: const Color(0xFF111827));
    final bool useGlass = useLiquidGlass &&
        (color == null ||
            color == Colors.white ||
            color == const Color(0xFFF3F4F6));
    if (!useGlass) {
      return Material(
        color: color,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: side,
            height: side,
            child: Center(child: face),
          ),
        ),
      );
    }
    return PressableCircleSurface(
      side: side,
      useLiquidGlass: true,
      enableHaptic: false,
      onTap: onTap,
      child: face,
    );
  }
}
