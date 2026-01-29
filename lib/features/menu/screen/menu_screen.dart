import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
                          fontWeight: FontWeight.w700,
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
                            // Icon Circle
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/hand_maick.png', // megaphone icon
                                  width: 24.w,
                                  height: 24.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            // Text Section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Automate your home',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Let your home play automatically with Aican '
                                    'you can relax in your home, Please contact with us now!',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                      color: Color(0xFF6B7280),
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
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2563EB),
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
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/analiytics.png',
                          title: 'Analytics',
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/weather.png',
                          title: 'Weather',
                        ),
                        _InnerDivider(indent: 50),
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
                        const _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/smar_devices.png',
                          title: 'Smart Devices',
                          onTap: () => context.go('/smart-devices'),
                        ),
                        const _InnerDivider(indent: 50),
                        const _MenuItemRow(
                          imagePath: 'assets/images/automations.png',
                          title: 'Automations',
                        ),
                        const _InnerDivider(indent: 50),
                        const _MenuItemRow(
                          imagePath: 'assets/images/setting.png',
                          title: 'Settings',
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
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/shading.png',
                          iconBg: Color(0xFFE5F2FF),
                          title: 'Shading',
                          iconWrap: true,
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/heating.png',
                          iconBg: Color(0xFFEFF6FF),
                          title: 'Heating/Cooling',
                          iconWrap: true,
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/ventilation.png',
                          iconBg: Color(0xFFE0F2FE),
                          title: 'Ventilation',
                          iconWrap: true,
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/security.png',
                          iconBg: Color(0xFFEFF6FF),
                          title: 'Security',
                          iconWrap: true,
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/irrigation.png',
                          iconBg: Color(0xFFE0F2FE),
                          title: 'Irrigation',
                          iconWrap: true,
                        ),
                        _InnerDivider(indent: 50),
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
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/living_room.png',
                          title: 'Living room',
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/kitchen.png',
                          title: 'Kitchen',
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/bedroom.png',
                          title: 'Bedroom',
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/kids_room.png',
                          title: 'Kids room',
                        ),
                        _InnerDivider(indent: 50),
                        _MenuItemRow(
                          imagePath: 'assets/images/garden.png',
                          title: 'Garden',
                        ),
                        _InnerDivider(indent: 50),
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
                      children: const [
                        _CoreRow(
                          name: 'Rd Suta',
                          isOnline: true,
                          imagePath: 'assets/images/rd_suta.png',
                        ),
                        _InnerDivider(indent: 50),
                        _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                          imagePath: 'assets/images/aicon_demo.png',
                        ),
                        _InnerDivider(indent: 50),
                        _CoreRow(
                          name: 'Rd Suta',
                          isOnline: false,
                          imagePath: 'assets/images/rd_suta.png',
                        ),
                        _InnerDivider(indent: 50),
                        _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                          imagePath:
                              'assets/images/aicon_demo.png', // ⚠️ empty string দিও না
                        ),
                        _InnerDivider(indent: 50),
                        _AllCoresRow(),
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
          fontWeight: FontWeight.w700,
          color: _primary,
          fontFamily: 'Inter',
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            SizedBox(
              width: 28.w,
              height: 28.w,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ✅ Core icon (no bg)
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      imagePath,
                      width: 24.w,
                      height: 24.w,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  // ✅ Online dot (bottom-right)
                ],
              ),
            ),

            SizedBox(width: 12.w),

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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Image.asset(
              'assets/images/all_categories.png',
              height: 24.h,
              width: 24.w,
            ),
            SizedBox(width: 12.w),
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
  const _InnerDivider({this.indent = 56});
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: indent.w, right: 16.w),
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
    Widget leading = Image.asset(
      imagePath!,
      width: 22.w,
      height: 22.w,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (iconWrap) {
      leading;
      // leading = Container(
      //   width: 34.w,
      //   height: 34.w,
      //   alignment: Alignment.center,
      //   decoration: BoxDecoration(
      //     color: iconBg ?? const Color(0xFFF3F4F6),
      //     borderRadius: BorderRadius.circular(10.r),
      //   ),
      //   child: leading,
      // );
    }

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: _primary.withOpacity(0.04),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            leading,
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),

            // Devices blue circle
            if (pillText != null) ...[
              Container(
                width: 30.w,
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
                width: 34.w,
                height: 34.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _pink,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    fontSize: 14.sp,
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
