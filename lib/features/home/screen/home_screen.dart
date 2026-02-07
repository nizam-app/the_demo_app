import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/Zones/screen/zones_screen.dart';

import '../../devices/screen/devices_screen.dart';
import '../../menu/screen/menu_screen.dart';
import '../../nav_bar/screen/custom_bottom_nav_bar.dart';
import '../../profile/screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildHomeBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),

                  // ✅ Header
                  Builder(
                    builder: (context) => _Header(
                      onMenuTap: () {
                        CustomBottomNavBar.of(context)?.openDrawer();
                      },
                      onEditTap: () {},
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ✅ Category pills (Light selected)
                  SizedBox(
                    height: 63.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      // padding: EdgeInsets.symmetric(horizontal: 12.w),
                      children: [
                        _CategoryPill(
                          label: 'Light',
                          isSelected: true,
                          icon: Icons.lightbulb_outline,
                          imagePath: 'assets/Mask group (3).png',
                          onTap: () {},
                        ),
                        SizedBox(width: 12.w),
                        _CategoryPill(
                          label: 'Shading',
                          isSelected: false,
                          icon: Icons.blinds_outlined,
                          imagePath: 'assets/Mask group (2).png',
                          onTap: () {},
                        ),
                        SizedBox(width: 12.w),
                        _CategoryPill(
                          label: 'HVAC',
                          isSelected: false,
                          icon: Icons.ac_unit_outlined,
                          imagePath: 'assets/Mask group (4).png',
                          onTap: () {},
                        ),
                        SizedBox(width: 12.w),
                        _CategoryPill(
                          label: 'Security',
                          isSelected: false,
                          icon: Icons.ac_unit_outlined,
                          imagePath: 'assets/securety.png',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  const _SectionTitle('Light'),
                  SizedBox(height: 12.h),

                  // ✅ Light section grid 2x2
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 195 / 185, // ✅ FIX: image-1 ratio
                    ),
                    children: const [
                      _LightDimmerCard(
                        title: 'Bedroom spot light\nsmall patio blue light',
                        percent: 0.72,
                        mode: 'A',
                        modeFilled: false,
                        imagePath: 'assets/Mask group (5).png',
                      ),
                      _ThermostatCard(
                        title: 'Bathroom heating and boiler thermostat',
                        value: 24.6,
                        mode: 'M',
                        modeFilled: true,
                        imagePath: 'assets/Mask group (6).png',
                      ),
                      _BlindCard(
                        title: 'Blind Living Room\nnorth window',
                        downPercent: 0,
                        upPercent: 72,
                        mode: 'M',
                        modeFilled: true,
                        imagePath: 'assets/Rectangle 823.png',
                      ),
                      _ToggleCard(
                        title: 'Irrigation entry and front home two valve',
                        isOn: true,
                        mode: 'A',
                        modeFilled: false,
                        imagePath: 'assets/Mask group (7).png',
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  const _SectionTitle('Lighting'),
                  SizedBox(height: 12.h),

                  _buildLightingSectionCards(),

                  SizedBox(height: 18.h),

                  _buildFavoritesSection(),
                  SizedBox(height: 18.h),

                  _buildShadingSection(),

                  SizedBox(height: 18.h),

                  const _SectionTitle('Chart Section'),
                  SizedBox(height: 12.h),

                  // ✅ Chart card
                  _ChartCard(),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      initialIndex: 2, // Voice/Home is index 2
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.menu, color: Color(0xFF111827)),
                title: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(MenuScreen.routeName);
                },
              ),
             
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF111827),
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(ProfileScreen.routeName);
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.align_horizontal_center,
              //     color: Color(0xFF111827),
              //   ),
              //   title: Text(
              //     'Zones',
              //     style: TextStyle(
              //       fontSize: 16.sp,
              //       fontWeight: FontWeight.w500,
              //       color: const Color(0xFF111827),
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //
              //   },
              // ),
            ],
          ),
        ),
      ),
      children: [
        // Index 0: Devices
        RepaintBoundary(child: DevicesScreen()),
        // Index 1: Analytics
        RepaintBoundary(child: _AnalyticsBody()),
        // Index 2: Home/Voice
        RepaintBoundary(child: _buildHomeBody()),
        // Index 3: Notifications
        RepaintBoundary(child: _NotificationsBody()),
        // Index 4: Automations
        RepaintBoundary(child: _AutomationsBody()),
      ],
    );
  }

  Widget _buildShadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Shading'),
        SizedBox(height: 12.h),
        _buildShadingControl(
          deviceName: 'Blind Living Room south window upside right',
          mode: 'M',
          modeFilled: true,
          downPercent: 100,
          upPercent: 50,
        ),
        SizedBox(height: 12.h),
        _buildShadingControl(
          deviceName: 'Blind Living Room south window upside right',
          mode: 'A',
          modeFilled: false,
          downPercent: 100,
          upPercent: 50,
        ),
        SizedBox(height: 12.h),
        _buildShadingControl(
          deviceName: 'Blind Living Room south window upside right',
          mode: 'M',
          modeFilled: true,
          downPercent: 100,
          upPercent: 50,
        ),
        SizedBox(height: 18.h),
        // _buildTemperatureSetPointCard(),
      ],
    );
  }

  Widget _buildShadingControl({
    required String deviceName,
    required String mode,
    required bool modeFilled,
    required int downPercent,
    required int upPercent,
  }) {
    return Container(
      height: 90.h, // ✅ slimmer like image
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26.r),
      ),
      padding: EdgeInsets.only(left: 8.w, top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Left icon (smaller & centered)
          Image.asset(
            'assets/Rectangle 823.png',
            width: 70.w,
            height: 75.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14.w),

          // ✅ Middle (2 lines title + indicators)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 16.sp, // ✅ bigger like image
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                    height: 1.08,
                  ),
                  maxLines: 2, // ✅ 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // ✅ Indicators row (M + down% + up%)
                Row(
                  children: [
                    _ModeBadge(mode: mode, filled: modeFilled),
                    SizedBox(width: 10.w),

                    Image.asset(
                      'assets/Group 32.jpg', // down icon
                      width: 12.w,
                      height: 19.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$downPercent%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    SizedBox(width: 14.w),

                    Image.asset(
                      'assets/Vector 4.jpg', // up icon
                      width: 10.w,
                      height: 19.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$upPercent%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          // ✅ Right controls (same row, 2 circles)
          Align(
            alignment:
                Alignment.bottomCenter, // ✅ moves circles to bottom like image
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 6.h,
                right: 10.w,
              ), // ✅ fine-tune bottom position
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CircleBtn(
                    size: 35,
                    child: Image.asset(
                      'assets/Mask group (17).png',
                      width: 13.w,
                      height: 13.h,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(width: 17.w),
                  _CircleBtn(
                    size: 35,
                    child: Transform.rotate(
                      angle: math.pi,
                      child: Image.asset(
                        'assets/Mask group (17).png',
                        width: 13.w,
                        height: 13.h,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureSetPointCard() {
    return Container(
      height: 210.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1E1E1)),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bathroom Temperature set point',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088FE),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      '24.6°c',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26.r),
                bottomRight: Radius.circular(26.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Favorites'),
        SizedBox(height: 12.h),

        // Row 1
        Row(
          children: [
            Expanded(child: _buildCameraCard()), // ✅ equal
            SizedBox(width: 12.w),
            Expanded(child: _buildThermostatCard(mode: 'M', filled: true)),
          ],
        ),

        SizedBox(height: 12.h),

        // Row 2
        Row(
          children: [
            Expanded(child: _buildCameraCard()),
            SizedBox(width: 12.w),
            Expanded(child: _buildThermostatCard(mode: 'A', filled: false)),
          ],
        ),
      ],
    );
  }

  Widget _buildCameraCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: SizedBox(
        height: 144.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/328a2c5e933681916f5ce64c1952942a7ea4e97e.png',
              fit: BoxFit.cover,
            ),

            // Blue overlay with 40% opacity
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0175F0).withOpacity(0.4),
                borderRadius: BorderRadius.circular(26.r),
              ),
            ),

            Positioned(
              left: 16.w,
              top: 18.h,
              child: Text(
                'Front Door\nCamera',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.05,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
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

  Widget _buildThermostatCard({required String mode, required bool filled}) {
    return Stack(
      children: [
        Container(
          height: 144.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(26.r),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h), // ✅ tighter
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/IMG_0274 1.png',
                width: 34.w, // ✅ smaller
                height: 34.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8.h), // ✅ smaller

              Text(
                'Bedroom Thermostat\nparents room',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF111827),
                  height: 1.12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              Row(
                children: [
                  _CircleBtn(child: Icon(Icons.remove, size: 20.sp), size: 35),
                  Expanded(
                    child: Center(
                      child: Text(
                        '24.6°c',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                  _CircleBtn(child: Icon(Icons.add, size: 20.sp), size: 35),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(mode: mode, filled: filled),
        ),
      ],
    );
  }

  Widget _buildLightingSectionCards() {
    return Column(
      children: [
        // First row of cards
        Row(
          children: [
            Expanded(
              child: _buildLightingCard(
                deviceName: 'Light Scene child room',
                status: 'All On',
                iconImage:
                    'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildLightingCard(
                deviceName: 'RGBW light patio entry',
                status: '100%',
                iconImage:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildLightingCard(
                          deviceName: 'LED Dimmer living room',
                          status: '100%',
                          iconImage:
                              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                          progressCircle: true,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 7.w, // ✅ outside, but doesn't shrink the card
                    top: 7.h,
                    child: _ModeBadge(mode: 'A', filled: false),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Second row of cards
        Row(
          children: [
            Expanded(
              child: _buildLightingCard(
                deviceName: 'Light Scene child room',
                status: 'All On',
                iconImage:
                    'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildLightingCard(
                deviceName: 'RGBW light\npatio entry',
                status: '100%',
                iconImage:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildLightingCard(
                          deviceName: 'LED Dimmer living room',
                          status: '100%',
                          iconImage:
                              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                          progressCircle: true,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 7.w,
                    top: 7.h,
                    child: _ModeBadge(mode: 'M', filled: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLightingCard({
    required String deviceName,
    required String status,
    required String iconImage,
    bool progressCircle = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top icon area
          progressCircle
              ? _lightingProgress100()
              : Image.asset(
                  iconImage,
                  width: 52.w,
                  height: 52.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 52.w,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
          SizedBox(height: 8.h),
          // Device name
          Flexible(
            child: Text(
              deviceName,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF111827),
                height: 1.15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8.h),
          // Status
          Text(
            status,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
              fontFamily: "Inter",
            ),
          ),
        ],
      ),
    );
  }

  Widget _lightingProgress100() {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          center: Alignment.center,
          startAngle: -math.pi / 2,
          colors: [
            Color(0xFF15DFFE), // Vibrant cyan-blue at top (12 o'clock)
            Color(0xFF87CEEB), // Light aqua cyan at bottom (6 o'clock)
            Color(0xFF00BFFF), // Bright blue transitioning back
            Color(0xFF15DFFE), // Vibrant cyan-blue completing the circle
          ],
          stops: [0.0, 0.5, 0.75, 1.0],
        ),
      ),
      padding: EdgeInsets.all(3.w),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          '100%',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

// ---------------------------
// Header
// ---------------------------
class _Header extends StatelessWidget {
  const _Header({required this.onMenuTap, required this.onEditTap});

  final VoidCallback onMenuTap;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onMenuTap,
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            width: 44.w,
            height: 44.w,
            child: Center(
              child: Image.asset(
                'assets/Group 35 (1).png',
                width: 26.w,
                height: 17.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onEditTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/image 89.png',
                width: 22.w,
                height: 22.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------
// Category pill
// ---------------------------
class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    this.imagePath,
  });

  final String label;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);

    // ✅ auto width based on content (text)
    Widget pillBody(Widget child) {
      return IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0, // ✅ no extra forced width
            maxWidth: 220.w, // ✅ prevent too wide pills
          ),
          child: child,
        ),
      );
    }

    Widget innerRow({required bool selected}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w), // ✅ compact padding
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ icon circle
            Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 22.w,
                      height: 22.w,
                      fit: BoxFit.contain,
                    )
                  : Icon(icon, size: 20.sp, color: const Color(0xFF111827)),
            ),
            SizedBox(width: 10.w),

            // ✅ full text (no ellipsis)
            Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: isSelected
          ? pillBody(
              Container(
                height: 63.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFFFD700), // yellow
                      Color(0xFF00FF99), // green-ish
                      Color(0xFF15DFFE), // cyan
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                  borderRadius: radius,
                ),
                padding: EdgeInsets.all(1.6.r), // ✅ border thickness
                child: Container(
                  height: 63.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: radius,
                  ),
                  child: innerRow(selected: true),
                ),
              ),
            )
          : pillBody(
              Container(
                height: 63.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFE1E1E1),
                    width: 1.5,
                  ),
                  borderRadius: radius,
                ),
                child: innerRow(selected: false),
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF111827),
        fontFamily: 'Inter',
      ),
    );
  }
}

// ---------------------------
// Common Card Wrapper
// ---------------------------
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26.r), // ✅ FIX
      ),
      padding: EdgeInsets.all(16.w), // ✅ FIX
      child: child,
    );
  }
}

class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.mode, required this.filled});

  final String mode;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: filled ? const Color(0xFF6B7280) : const Color(0xFFE1E1E1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        mode,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: filled ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.child, this.size});

  final Widget child;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 32;
    return Container(
      width: s.w,
      height: s.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ---------------------------
// Light Cards
// ---------------------------
class _LightDimmerCard extends StatelessWidget {
  const _LightDimmerCard({
    required this.title,
    required this.percent,
    required this.mode,
    required this.modeFilled,
    this.imagePath,
  });

  final String title;
  final double percent;
  final String mode;
  final bool modeFilled;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ icon size like image-1
              imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 52.w,
                      height: 52.w,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.lightbulb_outline,
                      size: 52.sp,
                      color: const Color(0xFF15DFFE),
                    ),

              SizedBox(height: 10.h),

              // ✅ title like image-1 (NOT huge)
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF111827),
                  height: 1.18,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // ✅ bottom row: 72% + pill slider (sun inside)
              Row(
                children: [
                  Text(
                    '${(percent * 100).round()}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(child: _DimmerPill(percent: percent)),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(mode: mode, filled: modeFilled),
        ),
      ],
    );
  }
}

class _DimmerPill extends StatelessWidget {
  const _DimmerPill({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);

    return Container(
      height: 36.h, // ✅ image-1 height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Stack(
        children: [
          // ✅ right grey segment (remaining)
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: (1 - p),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(999),
                    left: Radius.circular((1 - p) >= 0.98 ? 999 : 0),
                  ),
                ),
              ),
            ),
          ),

          // ✅ sun icon (left)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: Icon(
                Icons.wb_sunny_outlined,
                size: 20.sp,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThermostatCard extends StatelessWidget {
  const _ThermostatCard({
    required this.title,
    required this.value,
    required this.mode,
    required this.modeFilled,
    this.imagePath,
  });

  final String title;
  final double value;
  final String mode;
  final bool modeFilled;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 52.w,
                      height: 52.w,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.thermostat_outlined,
                      size: 44.sp,
                      color: const Color(0xFF0088FE),
                    ),
              SizedBox(height: 10.h),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title.split('\n').isNotEmpty
                            ? title.split('\n')[0]
                            : title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF111827),
                          height: 1.15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (title.contains('\n')) ...[
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          title.split('\n').length > 1
                              ? title.split('\n')[1]
                              : '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF111827),
                            height: 1.15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleBtn(child: Icon(Icons.remove, size: 18.sp)),
                  Text(
                    '${value.toStringAsFixed(1)}° c',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  _CircleBtn(child: Icon(Icons.add, size: 18.sp)),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(mode: mode, filled: modeFilled),
        ),
      ],
    );
  }
}

class _BlindCard extends StatelessWidget {
  const _BlindCard({
    required this.title,
    required this.downPercent,
    required this.upPercent,
    required this.mode,
    required this.modeFilled,
    this.imagePath,
  });

  final String title;
  final int downPercent;
  final int upPercent;
  final String mode;
  final bool modeFilled;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePath != null)
                Image.asset(
                  imagePath!,
                  width: 65.w,
                  height: 65.w,
                  fit: BoxFit.contain,
                ),
              SizedBox(height: 10.h),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                    height: 1.18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8.h),
              // Bottom controls row
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CircleBtn(
                        child: Image.asset(
                          'assets/Mask group (17).png',
                          width: 13.sp,
                          height: 13.sp,
                          fit: BoxFit.contain,
                        ),
                        size: 35,
                      ),
                      SizedBox(width: 7.w),
                      Image.asset(
                        'assets/Group 32.jpg',
                        width: 10.w,
                        height: 17.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '$downPercent%',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Image.asset(
                        'assets/Vector 4.jpg',
                        width: 8.w,
                        height: 17.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '$upPercent%',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      _CircleBtn(
                        child: Image.asset(
                          'assets/Mask group (16).png',
                          width: 13.sp,
                          height: 13.sp,
                          fit: BoxFit.contain,
                        ),
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(mode: mode, filled: modeFilled),
        ),
      ],
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.isOn,
    required this.mode,
    required this.modeFilled,
    this.imagePath,
  });

  final String title;
  final bool isOn;
  final String mode;
  final bool modeFilled;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 52.w,
                      height: 52.w,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.water_drop_outlined,
                      size: 42.sp,
                      color: const Color(0xFF00C2FF),
                    ),
              SizedBox(height: 17.h),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF111827),
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isOn ? 'On' : 'Off',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  _ToggleColorswitch(isOn: isOn),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(mode: mode, filled: modeFilled),
        ),
      ],
    );
  }
}

// ---------------------------
// Lighting mini cards
// ---------------------------
class _MiniLightingCard extends StatelessWidget {
  const _MiniLightingCard({
    required this.title,
    required this.status,
    required this.icon,
    required this.showProgress,
    required this.mode,
  });

  final String title;
  final String status;
  final IconData icon;
  final bool showProgress;
  final String? mode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132.w,
      child: Stack(
        children: [
          _CardShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 38.sp, color: const Color(0xFF111827)),
                SizedBox(height: 4.h),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF111827),
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),

          if (showProgress)
            Positioned(
              right: 10.w,
              top: 10.w,
              child: SizedBox(
                width: 46.w,
                height: 46.w,
                child: CustomPaint(
                  painter: _CircularProgressPainter(
                    progress: 1,
                    strokeWidth: 3,
                  ),
                  child: Center(
                    child: Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (mode != null)
            Positioned(
              right: 10.w,
              top: 10.w,
              child: _ModeBadge(mode: mode!, filled: false),
            ),
        ],
      ),
    );
  }
}

// ---------------------------
// Favorites
// ---------------------------
class _FavoritesRow extends StatelessWidget {
  const _FavoritesRow({required this.mode, required this.modeFilled});

  final String mode;
  final bool modeFilled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Container(
                  height: 132.h,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.videocam_outlined)),
                ),
              ),
              Positioned(
                left: 12.w,
                bottom: 12.w,
                child: Text(
                  'Front Door\nCamera',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10.w,
                top: 10.w,
                child: _ModeBadge(mode: mode, filled: modeFilled),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 132.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bedroom Thermostat\nparents room',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF111827),
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleBtn(
                          child: Icon(Icons.remove, size: 20.sp),
                          size: 35,
                        ),
                        Text(
                          '24.6°c',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _CircleBtn(child: Icon(Icons.add, size: 20.sp)),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10.w,
                top: 10.w,
                child: _ModeBadge(mode: mode, filled: modeFilled),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------
// Chart card
// ---------------------------
class _ChartCard extends StatefulWidget {
  const _ChartCard();

  @override
  State<_ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<_ChartCard> {
  static const int _points = 20;

  late final math.Random _rng;
  late Timer _timer;
  late List<double> _main;
  late List<double> _secondary;
  double _marker = 0.55;

  @override
  void initState() {
    super.initState();
    _rng = math.Random();

    _main = <double>[
      0.18,
      0.24,
      0.40,
      0.34,
      0.55,
      0.78,
      0.46,
      0.30,
      0.64,
      0.52,
      0.45,
      0.36,
      0.42,
      0.54,
      0.60,
      0.58,
      0.62,
      0.70,
      0.74,
      0.68,
    ];
    _secondary = <double>[
      0.22,
      0.48,
      0.62,
      0.44,
      0.40,
      0.72,
      0.58,
      0.50,
      0.82,
      0.66,
      0.54,
      0.40,
      0.52,
      0.70,
      0.80,
      0.62,
      0.72,
      0.58,
      0.66,
      0.60,
    ];

    // Safety: if someone changes the lists above, keep lengths consistent.
    _main = _main.take(_points).toList(growable: true);
    _secondary = _secondary.take(_points).toList(growable: true);
    while (_main.length < _points) {
      _main.add(0.5);
    }
    while (_secondary.length < _points) {
      _secondary.add(0.55);
    }

    _timer = Timer.periodic(const Duration(milliseconds: 650), (_) {
      // Move the marker slowly like a realtime cursor.
      _marker += 0.02;
      if (_marker > 1.0) _marker = 0.0;

      _main = _shiftAdd(_main, _nextValue(_main.last, maxDelta: 0.12));
      _secondary = _shiftAdd(
        _secondary,
        _nextValue(_secondary.last, maxDelta: 0.10),
      );

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<double> _shiftAdd(List<double> series, double next) {
    final out = List<double>.from(series);
    if (out.isNotEmpty) out.removeAt(0);
    out.add(next);
    return out;
  }

  double _nextValue(double current, {required double maxDelta}) {
    // Smoothed random walk, clamped to keep it in a nice visual band.
    final delta = (_rng.nextDouble() * 2 - 1) * maxDelta;
    return (current + delta).clamp(0.12, 0.88);
  }

  double _sampleAtPercent(List<double> series, double percent) {
    if (series.isEmpty) return 0.5;
    if (series.length == 1) return series.first;
    final p = percent.clamp(0.0, 1.0);
    final x = p * (series.length - 1);
    final i = x.floor();
    final t = x - i;
    final a = series[i];
    final b = series[(i + 1).clamp(0, series.length - 1)];
    return a + (b - a) * t;
  }

  @override
  Widget build(BuildContext context) {
    final v = _sampleAtPercent(_main, _marker);
    final tempC = 18 + v * 12; // 18..30°C range for demo
    final label = '${tempC.toStringAsFixed(1)}°C';

    return Container(
      height: 210.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: CustomPaint(
          painter: _WaveChartPainter(
            markerXPercent: _marker,
            label: label,
            mainSeries: _main,
            secondarySeries: _secondary,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _WaveChartPainter extends CustomPainter {
  _WaveChartPainter({
    required this.markerXPercent,
    required this.label,
    required this.mainSeries,
    required this.secondarySeries,
  });

  final double markerXPercent; // 0..1
  final String label;
  final List<double> mainSeries;
  final List<double> secondarySeries;

  @override
  void paint(Canvas canvas, Size size) {
    final blue = const Color(0xFF0088FE);
    final lightBlue = const Color(0xFF9DBDFF);

    final chartTop = 0.0;
    final chartBottom = size.height - 0.5;
    final chartHeight = chartBottom - chartTop;

    List<Offset> toPoints(List<double> series) {
      final n = series.length;
      return List.generate(n, (i) {
        final t = i / (n - 1);
        final x = t * size.width;
        final y = chartTop + (1 - series[i]) * chartHeight;
        return Offset(x, y);
      });
    }

    final mainPts = toPoints(mainSeries);
    final secPts = toPoints(secondarySeries);

    Path smoothPath(List<Offset> pts) {
      if (pts.length < 2) return Path();
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (int i = 0; i < pts.length - 1; i++) {
        final p0 = i == 0 ? pts[i] : pts[i - 1];
        final p1 = pts[i];
        final p2 = pts[i + 1];
        final p3 = i + 2 < pts.length ? pts[i + 2] : p2;

        // Catmull-Rom to Bezier conversion.
        final cp1 = Offset(
          p1.dx + (p2.dx - p0.dx) / 6,
          p1.dy + (p2.dy - p0.dy) / 6,
        );
        final cp2 = Offset(
          p2.dx - (p3.dx - p1.dx) / 6,
          p2.dy - (p3.dy - p1.dy) / 6,
        );
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
      }
      return path;
    }

    final secondaryPath = smoothPath(secPts);
    final mainPath = smoothPath(mainPts);

    // Area fill under secondary curve.
    final fillPath = Path.from(secondaryPath)
      ..lineTo(size.width, chartBottom)
      ..lineTo(0, chartBottom)
      ..close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = blue.withOpacity(0.10);

    final secondaryPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = lightBlue.withOpacity(0.85);

    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = blue;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(secondaryPath, secondaryPaint);
    canvas.drawPath(mainPath, mainPaint);

    // Marker.
    final mx = (size.width * markerXPercent).clamp(0.0, size.width);
    double sampleYAtX(List<Offset> pts, double x) {
      for (int i = 0; i < pts.length - 1; i++) {
        final a = pts[i];
        final b = pts[i + 1];
        if (x >= a.dx && x <= b.dx) {
          final t = (x - a.dx) / (b.dx - a.dx);
          return a.dy + (b.dy - a.dy) * t;
        }
      }
      return pts.last.dy;
    }

    final my = sampleYAtX(mainPts, mx);

    final markerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = blue;

    // Solid line from point to bottom (like the screenshot).
    canvas.drawLine(Offset(mx, my), Offset(mx, chartBottom), markerPaint);

    // Dot on the curve.
    canvas.drawCircle(Offset(mx, my), 4, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(mx, my),
      4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = blue,
    );

    // Label pill (painted, so it matches exactly).
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const pillPadX = 10.0;
    const pillPadY = 6.0;
    final pillW = tp.width + pillPadX * 2;
    final pillH = tp.height + pillPadY * 2;
    final pillTop = 0.0;
    final pillLeft = (mx - pillW / 2).clamp(0.0, size.width - pillW);

    final pillRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(pillLeft, pillTop, pillW, pillH),
      const Radius.circular(10),
    );
    canvas.drawRRect(pillRRect, Paint()..color = blue);

    tp.paint(canvas, Offset(pillLeft + pillPadX, pillTop + pillPadY));

    // Dashed guide from pill to the curve (subtle).
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = blue.withOpacity(0.9);

    final y1 = pillTop + pillH + 6;
    final y2 = (my - 6).clamp(y1, chartBottom);
    const dash = 5.0;
    const gap = 4.0;
    double y = y1;
    while (y < y2) {
      final yEnd = (y + dash).clamp(y1, y2);
      canvas.drawLine(Offset(mx, y), Offset(mx, yEnd), dashPaint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _WaveChartPainter oldDelegate) {
    return oldDelegate.markerXPercent != markerXPercent ||
        oldDelegate.label != label ||
        !listEquals(oldDelegate.mainSeries, mainSeries) ||
        !listEquals(oldDelegate.secondarySeries, secondarySeries);
  }
}

// ---------------------------
// Circular progress painter
// ---------------------------
class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({required this.progress, required this.strokeWidth});

  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = const Color(0xFFE1E1E1);

    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF0088FE);

    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Screen body widgets for CustomBottomNavBar
// class _DevicesBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: 18.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // -------- Header (top bar) ----------
//               Padding(
//                 padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 10.h),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           'Devices',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF111827),
//                           ),
//                         ),
//                       ),
//                     ),
//                     _CircleIconButton(
//                       icon: Icons.more_horiz,
//                       onTap: () {},
//                     ),
//                     SizedBox(width: 10.w),
//                     _CircleIconButton(
//                       icon: Icons.add,
//                       bg: const Color(0xFF0088FE),
//                       iconColor: Colors.white,
//                       onTap: () {},
//                     ),
//                   ],
//                 ),
//               ),

//               // -------- Search ----------
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 14.w),
//                 child: _SearchBar(),
//               ),

//               SizedBox(height: 10.h),

//               // -------- Filter chips ----------
//               SizedBox(
//                 height: 34.h,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   padding: EdgeInsets.symmetric(horizontal: 14.w),
//                   children: const [
//                     _FilterChipPill(label: 'All', selected: true),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Favorites'),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Smart'),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Groups'),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Category'),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 12.h),

//               // -------- Section Title ----------
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 14.w),
//                 child: Text(
//                   'Devices',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF111827),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 8.h),

//               // -------- List (rows) ----------
//               _DeviceListCard(
//                 children: [
//                   // RGBW
//                   _DeviceRow(
//                     topRight: const _TimeTag(text: '18:32', blueIcon: true),
//                     leading: const _GradientCircleIcon(size: 34),
//                     title: 'RGBW',
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: const [
//                             _ModeDot(text: 'A', filled: false),
//                             SizedBox(width: 6),
//                             _SmallText('Off'),
//                           ],
//                         ),
//                         const SizedBox(height: 2),
//                         const _TinyGreyText('LCD0C12'),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: const [
//                             _TagChip(text: 'Lighting', bg: Color(0xFF0088FE)),
//                             SizedBox(width: 6),
//                             _TagChip(text: 'Bathroom', bg: Color(0xFFFE019A)),
//                           ],
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const _CircleMiniBtn(icon: Icons.remove),
//                         SizedBox(width: 10.w),
//                         const _CircleMiniBtn(icon: Icons.add),
//                         SizedBox(width: 10.w),
//                         const _ToggleSwitch(isOn: true),
//                       ],
//                     ),
//                   ),

//                   const _RowDivider(),

//                   // Alarm
//                   _DeviceRow(
//                     leading: const _LockIcon(),
//                     title: 'Alarm',
//                     subtitle: const _SmallText('Disarmed'),
//                     trailing: const _CircleActionBlue(icon: Icons.power_settings_new),
//                   ),

//                   const _RowDivider(),

//                   // Bathroom
//                   _DeviceRow(
//                     leading: const _PowerRingIcon(),
//                     title: 'Bathroom',
//                     subtitle: Row(
//                       children: const [
//                         _ModeDot(text: 'M', filled: true),
//                         SizedBox(width: 8),
//                         Text(
//                           '24.6°categories',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF111827),
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const _CircleMiniBtn(icon: Icons.remove),
//                         SizedBox(width: 10.w),
//                         const _CircleMiniBtn(icon: Icons.add),
//                       ],
//                     ),
//                   ),

//                   const _RowDivider(),

//                   // Blind Living Room (selected highlight row)
//                   _DeviceRow(
//                     selected: true,
//                     topRight: const _StarTimeTag(time: '20:36'),
//                     leading: const _BlindGreenIcon(),
//                     title: 'Blind Living Room',
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         SizedBox(height: 2),
//                         _BlindStatsRow(),
//                         SizedBox(height: 3),
//                         _TinyGreyText('D012U12'),
//                       ],
//                     ),
//                     trailing: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         _CircleMiniBtn(icon: Icons.keyboard_arrow_up),
//                         SizedBox(height: 10),
//                         _CircleMiniBtn(icon: Icons.keyboard_arrow_down),
//                       ],
//                     ),
//                   ),

//                   const _RowDivider(),

//                   // Block Irrigation Schedule (blue play row)
//                   _DeviceRow(
//                     leading: const _PlayCircleIcon(),
//                     title: 'Block Irrigation Schedule',
//                     subtitle: const _SmallText('Blocked'),
//                     trailing: const _CircleActionBlue(icon: Icons.play_arrow),
//                   ),

//                   const _RowDivider(),

//                   // Brightness (with pill slider)
//                   _DeviceRow(
//                     topRight: const _StarOnly(),
//                     leading: const _SunIcon(),
//                     title: 'Brightness',
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         _BoldSmall('54%'),
//                         SizedBox(height: 2),
//                         _TinyGreyText('W5BT'),
//                       ],
//                     ),
//                     trailing: const _BrightnessPill(),
//                   ),

//                   const _RowDivider(),

//                   // Card Reader(s)
//                   _DeviceRow(
//                     leading: const _BulbIcon(),
//                     title: 'Card Reader(s)',
//                     subtitle: const _SmallText('Blocked'),
//                     trailing: const _ToggleSwitch(isOn: false),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 18.h),

//               // -------- Control units ----------
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 14.w),
//                 child: Text(
//                   'Control units',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF111827),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 8.h),

//               _DeviceListCard(
//                 children: const [
//                   _ControlUnitRow(
//                     icon: Icons.memory,
//                     iconColor: Color(0xFF0088FE),
//                     title: 'CORE20',
//                     sub: 'CORE20-4B37-3419-363A',
//                   ),
//                   _RowDivider(),
//                   _ControlUnitRow(
//                     icon: Icons.warning_amber_rounded,
//                     iconColor: Color(0xFFFE019A),
//                     title: 'D012',
//                     sub: '11 Devices',
//                     sub2: 'CORE20-4B37-3419-363A',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _AnalyticsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Analytics',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Analytics Screen',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Notifications Screen',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class _AutomationsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Automations',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Automations Screen',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

// Devices Screen Helper Widgets
class _DeviceListCard extends StatelessWidget {
  const _DeviceListCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(children: children),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.topRight,
    this.selected = false,
  });

  final Widget leading;
  final String title;
  final Widget subtitle;
  final Widget trailing;
  final Widget? topRight;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? const Color(0xFFEAF1FF) : Colors.white,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 6.w),
              SizedBox(
                width: 34.w,
                height: 34.w,
                child: Center(child: leading),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    subtitle,
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              trailing,
              SizedBox(width: 4.w),
            ],
          ),
          if (topRight != null) Positioned(right: 0, top: 0, child: topRight!),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.only(left: 56.w),
      color: const Color(0xFFF1F1F1),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18.sp, color: const Color(0xFF6B7280)),
          SizedBox(width: 8.w),
          Text(
            'Search',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipPill extends StatelessWidget {
  const _FilterChipPill({required this.label, this.selected = false});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final border = selected ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB);
    final text = selected ? const Color(0xFF0088FE) : const Color(0xFF111827);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: text,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.bg = const Color(0xFFF3F4F6),
    this.iconColor = const Color(0xFF111827),
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: 18.sp, color: iconColor),
      ),
    );
  }
}

class _CircleMiniBtn extends StatelessWidget {
  const _CircleMiniBtn({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18.sp, color: const Color(0xFF111827)),
    );
  }
}

class _CircleActionBlue extends StatelessWidget {
  const _CircleActionBlue({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFF0088FE),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18.sp, color: Colors.white),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.isOn});
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.w,
      height: 30.h,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isOn ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 30.86.w,
          height: 30.86.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _SmallText extends StatelessWidget {
  const _SmallText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      ),
    );
  }
}

class _BoldSmall extends StatelessWidget {
  const _BoldSmall(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827),
      ),
    );
  }
}

class _TinyGreyText extends StatelessWidget {
  const _TinyGreyText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }
}

class _ModeDot extends StatelessWidget {
  const _ModeDot({required this.text, required this.filled});
  final String text;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        color: filled ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : const Color(0xFF111827),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text, required this.bg});
  final String text;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TimeTag extends StatelessWidget {
  const _TimeTag({required this.text, this.blueIcon = false});
  final String text;
  final bool blueIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wifi,
          size: 12.sp,
          color: blueIcon ? const Color(0xFF0088FE) : const Color(0xFF9CA3AF),
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StarTimeTag extends StatelessWidget {
  const _StarTimeTag({required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24)),
        SizedBox(width: 4.w),
        Text(
          time,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StarOnly extends StatelessWidget {
  const _StarOnly();

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24));
  }
}

class _GradientCircleIcon extends StatelessWidget {
  const _GradientCircleIcon({this.size = 34});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Color(0xFF15DFFE),
            Color(0xFF0088FE),
            Color(0xFFFE019A),
            Color(0xFFFFD700),
            Color(0xFF15DFFE),
          ],
        ),
      ),
    );
  }
}

class _LockIcon extends StatelessWidget {
  const _LockIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFFFE4F1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_outline,
        size: 18.sp,
        color: const Color(0xFFFE019A),
      ),
    );
  }
}

class _PowerRingIcon extends StatelessWidget {
  const _PowerRingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEAFBF2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.power_settings_new,
        size: 18.sp,
        color: const Color(0xFF10B981),
      ),
    );
  }
}

class _BlindGreenIcon extends StatelessWidget {
  const _BlindGreenIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEAFBF2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.blinds_outlined,
        size: 18.sp,
        color: const Color(0xFF84CC16),
      ),
    );
  }
}

class _PlayCircleIcon extends StatelessWidget {
  const _PlayCircleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEAF1FF),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_arrow,
        size: 18.sp,
        color: const Color(0xFF0088FE),
      ),
    );
  }
}

class _SunIcon extends StatelessWidget {
  const _SunIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBEB),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.wb_sunny_outlined,
        size: 18.sp,
        color: const Color(0xFFFBBF24),
      ),
    );
  }
}

class _BulbIcon extends StatelessWidget {
  const _BulbIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lightbulb_outline,
        size: 18.sp,
        color: const Color(0xFF84CC16),
      ),
    );
  }
}

class _BlindStatsRow extends StatelessWidget {
  const _BlindStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ModeDot(text: 'A', filled: false),
        SizedBox(width: 10.w),
        Icon(Icons.arrow_downward, size: 14.sp, color: const Color(0xFF111827)),
        SizedBox(width: 4.w),
        Text(
          '0%',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(width: 12.w),
        Icon(Icons.arrow_upward, size: 14.sp, color: const Color(0xFF111827)),
        SizedBox(width: 4.w),
        Text(
          '50%',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _BrightnessPill extends StatelessWidget {
  const _BrightnessPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          Container(
            width: 95.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10.w),
            child: Icon(
              Icons.wb_sunny_outlined,
              size: 16.sp,
              color: const Color(0xFF111827),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

class _ControlUnitRow extends StatelessWidget {
  const _ControlUnitRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.sub,
    this.sub2,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String sub;
  final String? sub2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18.sp, color: iconColor),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                if (sub2 != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    sub2!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleColorswitch extends StatelessWidget {
  const _ToggleColorswitch({required this.isOn});
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w, // ✅ closer to iOS toggle size
      height: 35.h,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isOn ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 28.w,
          height: 28.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}