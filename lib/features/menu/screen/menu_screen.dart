import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/cores/screen/cores_screen.dart';

/// Single source of truth for all menu section card icon dimensions.
/// Ensures every icon has the same container size, alignment, and fit.
const double _kMenuIconContainerSize = 28;
const double _kMenuIconImageSize = 24;
const double _kMenuIconGap = 14;
const double _kMenuRowPaddingH = 16;

/// Shared badge/pill dimensions for Devices & Notifications.
const double _kMenuBadgeWidth = 39;
const double _kMenuBadgeHeight = 30;

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const String routeName = '/menu';

  // colors (match screenshot)
  static const _bg = Color(0xFFF3F4F6);
  static const _card = Colors.white;
  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);
  static const _divider = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF0088FE);
  static const _pink = Color(0xFFFF2D92);
  static const _green = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Header
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
              child: Row(
                children: [
                  GlobalCircleIconBtn(
                    child: Image.asset(
                      'assets/aro.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                    onTap: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: _primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _MenuIcon(
                              'assets/images/hand_maick.png',
                              iconBg: const Color(0xFFF3F4F6),
                              isCircle: true,
                            ),
                            SizedBox(width: _kMenuIconGap.w),

                            // Text Section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Automate your home',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _primary,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Let your home play automatically with Aican '
                                    'you can relax in your home, Please contact with us now!',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                      color: _primary,
                                      fontFamily: 'Inter',
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 110.w,
                                      height: 28.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Get started',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF0088FE),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ✅ Overview
                    const _SectionTitle(title: 'Overview'),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/Mask group copy.png',
                          title: 'Dashboard',
                          iconSize: 17.5,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/bar 5 copy.png',
                          title: 'Analytics',
                          iconSize: 17.5,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/image 65.png',
                          title: 'Weather',
                          iconWidth: 22,
                          iconHeight: 23.5,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Group 43.png',
                          title: 'Notifications',
                          badgeText: '12',
                          iconSize: 22,
                        ),
                      ],
                    ),

                    // ✅ System
                    const _SectionTitle(title: 'System'),
                    _CardBlock(
                      children: [
                        _MenuItemRow(
                          imagePath: 'assets/images/devices.png',
                          title: 'Devices',
                          pillText: '12',
                          onTap: () => context.go('/devices'),
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask group copy 2.png',
                          title: 'Smart Devices',
                          onTap: () => context.push('/smart-devices'),
                          iconWidth: 18,
                          iconHeight: 19,
                        ),
                        const _InnerDivider(),
                        const _MenuItemRow(
                          imagePath: 'assets/images/automations.png',
                          title: 'Automations',
                          iconSize: 22,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/setting.png',
                          title: 'Settings',
                          onTap: () => context.push('/settings'),
                          iconSize: 18,
                        ),
                      ],
                    ),

                    // ✅ Categories
                    const _SectionTitle(title: 'Categories'),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/Mask group.png',
                          title: 'Lighting',
                          iconSize: 22,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask g.png',
                          title: 'Shading',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask gr.png',
                          title: 'Heating/Cooling',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/make.png',
                          title: 'Ventilation',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask group (.png',
                          title: 'Security',
                          iconSize: 23,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask group (5) copy.png',
                          title: 'Irrigation',
                          iconSize: 24,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask group copy 3.png',
                          title: 'All Categories',
                          titleColor: _blue,
                          showChevron: false,
                          iconSize: 20,
                        ),
                      ],
                    ),

                    // ✅ Zones
                    const _SectionTitle(title: 'Zones'),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/room 1.png',
                          title: 'Whole house',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask group (1).png',
                          title: 'Living room',
                          iconSize: 22,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/kitchen(1) 1.png',
                          title: 'Kitchen',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/image 108.png',
                          title: 'Bedroom',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/image 110.png',
                          title: 'Kids room',
                          iconSize: 23,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/image 111.png',
                          title: 'Garden',
                          iconSize: 24,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/Mask group copy 3.png',
                          title: 'All Zones',
                          titleColor: _blue,
                          showChevron: false,
                          iconSize: 20,
                        ),
                      ],
                    ),

                    // ✅ Cores
                    const _SectionTitle(title: 'Cores'),
                    _CardBlock(
                      children: [
                        const _CoreRow(
                          name: 'Rd Suta',
                          isOnline: true,
                          imagePath: 'assets/image 66 copy.png',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        const _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                          imagePath: 'assets/image 66 copy.png',
                          iconSize: 20,
                          showStatusBadge: true,
                        ),
                        const _InnerDivider(),
                        const _CoreRow(
                          name: 'Rd Suta',
                          isOnline: false,
                          imagePath: 'assets/image 66 copy.png',
                          iconSize: 20,
                        ),
                        const _InnerDivider(),
                        const _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                          imagePath: 'assets/image 66 copy.png',
                          iconSize: 20,
                          showStatusBadge: true,
                        ),
                        const _InnerDivider(),
                        _AllCoresRow(
                          onTap: () => context.push(CoresScreen.routeName),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  static const _primary = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: _primary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

/// Reusable menu icon: fixed-size container, centered image, BoxFit.contain.
/// All section card icons use this for consistent size, shape, and alignment.
/// Optional iconWidth/iconHeight override image size (in logical units, uses .w/.h).
class _MenuIcon extends StatelessWidget {
  const _MenuIcon(
    this.imagePath, {
    this.iconBg,
    this.borderRadius,
    this.isCircle = false,
    this.iconWidth,
    this.iconHeight,
  });

  final String imagePath;
  final Color? iconBg;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final double? iconWidth;
  final double? iconHeight;

  @override
  Widget build(BuildContext context) {
    final size = _kMenuIconContainerSize.w;
    final imgW = (iconWidth ?? _kMenuIconImageSize).w;
    final imgH = (iconHeight ?? _kMenuIconImageSize).h;
    final hasBackground = iconBg != null || isCircle;
    final decoration = BoxDecoration(
      color: hasBackground ? (iconBg ?? const Color(0xFFF3F4F6)) : Colors.transparent,
      borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(10.r)),
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
    );
    return Container(
        decoration: decoration,
        alignment: Alignment.center,
        child: Image.asset(
          imagePath,
          width: imgW,
          height: imgH,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => SizedBox(
            width: imgW,
            height: imgH,
          ),
        ),
   
    );
  }
}

class _CoreRow extends StatelessWidget {
  const _CoreRow({
    required this.name,
    required this.isOnline,
    required this.imagePath,
    this.onTap,
    this.iconSize,
    this.iconWidth,
    this.iconHeight,
    this.showStatusBadge = false,
  });

  final String name;
  final bool isOnline;
  final String imagePath;
  final VoidCallback? onTap;
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final bool showStatusBadge;

  static const primary = Color(0xFF111827);
  static const secondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: primary.withOpacity(0.04),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _kMenuRowPaddingH.w, vertical: 14.h),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _MenuIcon(
                  imagePath,
                  iconWidth: iconWidth ?? iconSize,
                  iconHeight: iconHeight ?? iconSize,
                ),
                if (showStatusBadge)
                  Positioned(
                    right: -3.w,
                    bottom: 1.h,
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                     
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 8.w,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: _kMenuIconGap.w),

            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            // ✅ no chevron in cores rows
          ],
        ),
      ),
    );
  }
}

class _AllCoresRow extends StatelessWidget {
  const _AllCoresRow({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0088FE);

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: blue.withOpacity(0.05),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _kMenuRowPaddingH.w, vertical: 14.h),
        child: Row(
          children: [
            _MenuIcon('assets/Mask group copy 3.png', iconWidth: 20, iconHeight: 20),
            SizedBox(width: _kMenuIconGap.w),
            Text(
              'All Cores',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: blue,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBlock extends StatelessWidget {
  const _CardBlock({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

/// Shared badge/pill for Devices (blue) and Notifications (pink).
/// Same container size and text style.
class _MenuBadge extends StatelessWidget {
  const _MenuBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kMenuBadgeWidth.w,
      height: _kMenuBadgeHeight.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: 'Inter',
          height: 1.0,
        ),
      ),
    );
  }
}

class _InnerDivider extends StatelessWidget {
  const _InnerDivider();

  @override
  Widget build(BuildContext context) {
    final left =
        _kMenuRowPaddingH.w + _kMenuIconContainerSize.w + _kMenuIconGap.w;
    final leftInset =
        (left - 7.w).clamp(0.0, double.infinity).toDouble();
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(
        left: leftInset,
        // right: _kMenuRowPaddingH.w,
      ),
      color: const Color(0xFFE5E7EB),
    );
  }
}

class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({
    required this.title,
    this.imagePath,
    this.onTap,
    this.iconBg,
    this.badgeText,
    this.pillText,
    this.titleColor,
    this.showChevron = true,
    this.iconWrap = false,
    this.iconSize,
    this.iconWidth,
    this.iconHeight,
  }) : assert(imagePath != null);

  final String title;
  final String? imagePath;
  final VoidCallback? onTap;

  final Color? iconBg;
  final String? badgeText; // pink
  final String? pillText; // blue
  final Color? titleColor;
  final bool showChevron;

  /// Categories style: small rounded square background
  final bool iconWrap;

  /// Icon size (square: iconSize x iconSize). Use iconWidth/iconHeight for non-square.
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;

  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);
  static const _blue = Color(0xFF0088FE);
  static const _pink = Color(0xFFFF2D92);

  @override
  Widget build(BuildContext context) {
    final leading = _MenuIcon(
      imagePath!,
      iconBg: iconWrap ? (iconBg ?? const Color(0xFFF3F4F6)) : null,
      borderRadius: iconWrap ? BorderRadius.circular(10.r) : null,
      iconWidth: iconWidth ?? iconSize,
      iconHeight: iconHeight ?? iconSize,
    );

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: _primary.withOpacity(0.04),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _kMenuRowPaddingH.w, vertical: 14.h),
        child: Row(
          children: [
            leading,
            SizedBox(width: _kMenuIconGap.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: titleColor ?? _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),

            // Devices blue circle
            if (pillText != null) ...[
              _MenuBadge(text: pillText!, color: _blue),
              SizedBox(width: 10.w),
            ],

            // Notifications pink circle
            if (badgeText != null) ...[
              _MenuBadge(text: badgeText!, color: _pink),
              SizedBox(width: 10.w),
            ],

            if (showChevron)
              Icon(Icons.chevron_right_rounded, size: 22.sp, color: _secondary),
          ],
        ),
      ),
    );
  }
}