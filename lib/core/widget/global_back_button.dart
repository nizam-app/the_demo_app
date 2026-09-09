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
          child: Center(
            child: child ??
                Icon(icon, size: 23.sp, color: const Color(0xFF111827)),
          ),
        ),
      ),
    );
  }
}
