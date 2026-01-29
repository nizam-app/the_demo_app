import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const String routeName = '/menu';

  Color get _bgGrey => const Color(0xFFF3F4F6);
  Color get _textPrimary => const Color(0xFF111827);
  Color get _textSecondary => const Color(0xFF6B7280);
  Color get _blue => const Color(0xFF0088FE);
  Color get _pink => const Color(0xFFFF2D92);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: 22.sp,
                        color: _textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 32.w),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
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
                                    height: 28.h ,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(30)
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

                      SizedBox(width: 10.w),

                      // CTA

                    ],
                  ),
                ),
              ),

                SizedBox(height: 22.h),
                    _SectionTitle(
                      title: 'Overview',
                      textColor: _textPrimary,
                    ),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/images/dashboard.png',
                          title: 'Dashboard',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/analiytics.png',
                          title: 'Analytics',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/weather.png',
                          title: 'Weather',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/notification.png',
                          title: 'Notifications',
                          badgeText: '12',
                        ),
                      ],
                    ),
                    _SectionTitle(
                      title: 'System',
                      textColor: _textPrimary,
                    ),
                    _CardBlock(
                      children: [
                        _MenuItemRow(
                          imagePath: 'assets/images/devices.png',
                          title: 'Devices',
                          pillText: '12',
                          onTap: () {
                            context.go('/devices');
                          },
                        ),
                        const _InnerDivider(),
                        const _MenuItemRow(
                          imagePath: 'assets/images/smar_devices.png',
                          title: 'Smart Devices',
                        ),
                        const _InnerDivider(),
                        const _MenuItemRow(
                          imagePath: 'assets/images/automations.png',
                          title: 'Automations',
                        ),
                        const _InnerDivider(),
                        const _MenuItemRow(
                          imagePath: 'assets/images/setting.png',
                          title: 'Settings',
                        ),
                      ],
                    ),
                    _SectionTitle(
                      title: 'Categories',
                      textColor: _textPrimary,
                    ),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/images/lighting.png',
                          iconBg: Color(0xFFFFF7E6),
                          title: 'Lighting',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/shading.png',
                          iconBg: Color(0xFFE5F2FF),
                          iconColor: Color(0xFF0088FE),
                          title: 'Shading',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/heating.png',
                          iconBg: Color(0xFFEFF6FF),
                          iconColor: Color(0xFF6366F1),
                          title: 'Heating/Cooling',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/ventilation.png',
                          iconBg: Color(0xFFE0F2FE),
                          iconColor: Color(0xFF0EA5E9),
                          title: 'Ventilation',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/security.png',
                          iconBg: Color(0xFFEFF6FF),
                          iconColor: Color(0xFF4F46E5),
                          title: 'Security',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/irrigation.png',
                          iconBg: Color(0xFFE0F2FE),
                          iconColor: Color(0xFF0EA5E9),
                          title: 'Irrigation',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/all_categories.png',
                          iconBg: Colors.transparent,
                          title: 'All Categories',
                          titleColor: Color(0xFF0088FE),
                          showChevron: false,
                        ),
                      ],
                    ),
                    _SectionTitle(
                      title: 'Zones',
                      textColor: _textPrimary,
                    ),
                    _CardBlock(
                      children: const [
                        _MenuItemRow(
                          imagePath: 'assets/images/whole_house.png',
                          title: 'Whole house',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/living_room.png',
                          title: 'Living room',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/kitchen.png',
                          title: 'Kitchen',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/bedroom.png',
                          title: 'Bedroom',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/kids_room.png',
                          title: 'Kids room',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/garden.png',
                          title: 'Garden',
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          imagePath: 'assets/images/all_categories.png',
                          iconBg: Colors.transparent,
                          title: 'All Zones',
                          titleColor: Color(0xFF0088FE),
                          showChevron: false,
                          leadingIsCheckboxStyle: true,
                        ),
                      ],
                    ),
                    _SectionTitle(
                      title: 'Cores',
                      textColor: _textPrimary,
                    ),
                    _CardBlock(
                      children: const [
                        _CoreRow(
                          name: 'Rd Suta',
                          isOnline: true,
                          imagePath: 'assets/images/rd_suta.png',
                        ),
                        _InnerDivider(),
                        _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                        ),
                        _InnerDivider(),
                        _CoreRow(
                          name: 'Rd Suta',
                          isOnline: false,
                        ),
                        _InnerDivider(),
                        _CoreRow(
                          name: 'Aican Demo Account',
                          isOnline: true,
                        ),
                        _InnerDivider(),
                        _MenuItemRow(
                          icon: Icons.check_box_outlined,
                          iconBg: Colors.transparent,
                          title: 'All Cores',
                          titleColor: Color(0xFF0088FE),
                          showChevron: false,
                          leadingIsCheckboxStyle: true,
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
  const _SectionTitle({required this.title, required this.textColor});

  final String title;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontFamily: 'Inter',
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
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(children: children),
    );
  }
}

class _InnerDivider extends StatelessWidget {
  const _InnerDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.only(left: 56.w),
      color: const Color(0xFFE5E7EB),
    );
  }
}

class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({
    this.icon,
    this.imagePath,
    required this.title,
    this.iconBg,
    this.iconColor,
    this.badgeText,
    this.pillText,
    this.titleColor,
    this.showChevron = true,
    this.leadingIsCheckboxStyle = false,
    this.onTap,
  }) : assert(
          icon != null || imagePath != null,
          'Either icon or imagePath must be provided',
        );

  final IconData? icon;
  final String? imagePath;
  final String title;
  final Color? iconBg;
  final Color? iconColor;
  final String? badgeText;
  final String? pillText;
  final Color? titleColor;
  final bool showChevron;
  final bool leadingIsCheckboxStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF111827);
    const secondary = Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          children: [
            imagePath != null
                ? Image.asset(
                  imagePath!,
                  width: 18.w,
                  height: 18.w,
                  fit: BoxFit.cover,
                )
                : Icon(
                    icon!,
                    size: leadingIsCheckboxStyle ? 20.sp : 18.sp,
                    color: iconColor ?? primary,
                  ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            if (pillText != null) ...[
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088FE),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  pillText!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            if (badgeText != null) ...[
              Container(
                width: 28.w,
                height: 22.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFF2D92),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: secondary,
              ),
          ],
        ),
      ),
    );
  }
}

class _CoreRow extends StatelessWidget {
  const _CoreRow({
    required this.name,
    required this.isOnline,
    this.imagePath,
  });

  final String name;
  final bool isOnline;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF111827);
    const secondary = Color(0xFF6B7280);
    const blue = Color(0xFF0088FE);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      imagePath!,
                      width: 32.w,
                      height: 32.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.hub_outlined,
                    size: 18.sp,
                    color: blue,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: primary,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline
                            ? const Color(0xFF10B981)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: secondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_box_outlined,
            size: 20.sp,
            color: blue,
          ),
        ],
      ),
    );
  }
}

