import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/cores/screen/cores_screen.dart';

/// Single source of truth for all menu section card icon dimensions.
/// Ensures every icon has the same container size, alignment, and fit.
const double _kMenuIconContainerSize = 28;
const double _kMenuIconImageSize = 24;
const double _kMenuIconGap = 14;
const double _kMenuRowPaddingH = 16;

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
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 24.sp,
                        color: _primary,
                      ),
                    ),
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
                          borderRadius: BorderRadius.circular(16.r),
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
                          imagePath: 'assets/images/dashboard.png',
                          title: 'Dashboard',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/analiytics.png',
                          title: 'Analytics',
                        ),
                        const _InnerDivider(),

                        //size
                        _MenuItemRow(
                          imagePath: 'assets/images/weather.png',
                          title: 'Weather',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/notification.png',
                          title: 'Notifications',
                          badgeText: '12',
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
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/smar_devices.png',
                          title: 'Smart Devices',
                          onTap: () => context.push('/smart-devices'),
                        ),
                        const _InnerDivider(),
                        const _MenuItemRow(
                          imagePath: 'assets/images/automations.png',
                          title: 'Automations',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/setting.png',
                          title: 'Settings',
                          onTap: () => context.push('/settings'),
                        ),
                      ],
                    ),

                    // ✅ Categories
                    const _SectionTitle(title: 'Categories'),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/images/lighting.png',
                          iconBg: Color(0xFFFFF7E6),
                          title: 'Lighting',
                          iconWrap: true,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/shading.png',
                          iconBg: Color(0xFFE5F2FF),
                          title: 'Shading',
                          iconWrap: true,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/heating.png',
                          iconBg: Color(0xFFEFF6FF),
                          title: 'Heating/Cooling',
                          iconWrap: true,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/ventilation.png',
                          iconBg: Color(0xFFE0F2FE),
                          title: 'Ventilation',
                          iconWrap: true,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/security.png',
                          iconBg: Color(0xFFEFF6FF),
                          title: 'Security',
                          iconWrap: true,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/irrigation.png',
                          iconBg: Color(0xFFE0F2FE),
                          title: 'Irrigation',
                          iconWrap: true,
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/all_categories.png',
                          title: 'All Categories',
                          titleColor: _blue,
                          showChevron: false,
                        ),
                      ],
                    ),

                    // ✅ Zones
                    const _SectionTitle(title: 'Zones'),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/images/whole_house.png',
                          title: 'Whole house',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/living_room.png',
                          title: 'Living room',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/kitchen.png',
                          title: 'Kitchen',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/bedroom.png',
                          title: 'Bedroom',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/kids_room.png',
                          title: 'Kids room',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/garden.png',
                          title: 'Garden',
                        ),
                        const _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/all_categories.png',
                          title: 'All Zones',
                          titleColor: _blue,
                          showChevron: false,
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
                          imagePath: 'assets/images/rd_suta.png',
                        ),
                        const _InnerDivider(),
                        const _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                          imagePath: 'assets/images/aicon_demo.png',
                        ),
                        const _InnerDivider(),
                        const _CoreRow(
                          name: 'Rd Suta',
                          isOnline: false,
                          imagePath: 'assets/images/rd_suta.png',
                        ),
                        const _InnerDivider(),
                        const _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                          imagePath: 'assets/images/aicon_demo.png',
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
class _MenuIcon extends StatelessWidget {
  const _MenuIcon(
    this.imagePath, {
    this.iconBg,
    this.borderRadius,
    this.isCircle = false,
  });

  final String imagePath;
  final Color? iconBg;
  final BorderRadius? borderRadius;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    final size = _kMenuIconContainerSize.w;
    final hasBackground = iconBg != null || isCircle;
    final decoration = BoxDecoration(
      color: hasBackground ? (iconBg ?? const Color(0xFFF3F4F6)) : Colors.transparent,
      borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(10.r)),
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
    );
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: decoration,
        alignment: Alignment.center,
        child: Image.asset(
          imagePath,
          width: _kMenuIconImageSize.w,
          height: _kMenuIconImageSize.w,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => SizedBox(
            width: _kMenuIconImageSize.w,
            height: _kMenuIconImageSize.w,
          ),
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
  });

  final String name;
  final bool isOnline;
  final String imagePath;
  final VoidCallback? onTap;

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
            _MenuIcon(imagePath),
            SizedBox(width: _kMenuIconGap.w),

            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
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
            _MenuIcon('assets/images/all_categories.png'),
            SizedBox(width: _kMenuIconGap.w),
            Text(
              'All Cores',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
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

class _InnerDivider extends StatelessWidget {
  const _InnerDivider();

  @override
  Widget build(BuildContext context) {
    final left =
        _kMenuRowPaddingH.w + _kMenuIconContainerSize.w + _kMenuIconGap.w;
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: left, right: _kMenuRowPaddingH.w),
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
              Container(
                width: 36.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  pillText!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Inter',
                    height: 1.0,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],

            // Notifications pink circle
            if (badgeText != null) ...[
              Container(
                width: 38.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _pink,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Inter',
                    height: 1.0,
                  ),
                ),
              ),
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
