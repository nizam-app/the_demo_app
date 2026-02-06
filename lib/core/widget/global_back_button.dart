import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalCircleIconBtn extends StatelessWidget {
  const GlobalCircleIconBtn({this.icon, this.child, required this.onTap, this.color = Colors.white})
      : assert(
  icon != null || child != null,
  'Either icon or child must be provided',
  );

  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
 final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration:  BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child ?? Icon(icon, size: 16.sp, color: const Color(0xFF111827)),
      ),
    );
  }
}