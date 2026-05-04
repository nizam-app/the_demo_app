import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/device_details/screen/device_details_screen.dart';

import '../../devices/screen/devices_screen.dart';
import '../../menu/screen/menu_screen.dart';
import '../../nav_bar/screen/custom_bottom_nav_bar.dart';
import '../../notifications/screen/notifications_screen.dart';
import '../../profile/screen/profile_screen.dart';
import '../../settings/screen/settings_screen.dart';
import '../widget/Add_section.dart';
import '../widget/editAddSectionSheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';


  static void showEditAddSectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const EditAddSectionSheet(),
      ),
    );
  }

  static void showAddSectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const AddSectionSheet(),
      ),
    );
  }


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Dashboard category pills (0 Light … 3 Security).
  int _homeCategoryIndex = 0;
  int _brightnessPct = 50;

  double _bedroomDimmer = 0.72;
  double _bathroomThermostat = 24.6;
  int _blindNorthDown = 0;
  int _blindNorthUp = 72;
  final List<int> _shadeDown = [100, 100, 100];
  final List<int> _shadeUp = [50, 50, 50];
  /// Shading list rows: manual (M) vs auto (A), matches prior static modes.
  final List<bool> _shadeManual = [true, false, true];
  double _favThermostatM = 24.6;
  double _favThermostatA = 24.6;

  /// A/M mode badges (tap to toggle auto vs manual) — dashboard + lighting.
  bool _bedroomManual = false;
  bool _bathroomManual = true;
  bool _blindManual = true;
  bool _lightingLedBadge1Manual = false;
  bool _lightingLedBadge2Manual = true;
  bool _favThermoMManual = true;
  bool _favThermoAManual = false;

  /// 0 = neither circle "marked"; 1 = minus/down; 2 = plus/up (gray when marked).
  int _bathroomThermoMark = 0;
  int _blindNorthMark = 0;
  final List<int> _shadeStepMark = [0, 0, 0];
  int _favThermoMMark = 0;
  int _favThermoAMark = 0;

  void _flashMark({
    required int value,
    required int Function() getCurrent,
    required void Function(int v) set,
    VoidCallback? action,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    setState(() {
      set(value);
      action?.call();
    });
    Future.delayed(duration, () {
      if (!mounted) return;
      if (getCurrent() == value) {
        setState(() => set(0));
      }
    });
  }

  Widget _buildHomeBody(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final headerChrome = 56.h;
    final scrollTopPadding = topInset + headerChrome + 10.h;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    scrollTopPadding,
                    16.w,
                    24.h,
                  ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // ✅ Category pills (Light selected)
                        SizedBox(
                          height: 63.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            // padding: EdgeInsets.symmetric(horizontal: 12.w),
                            children: [
                              _CategoryPill(
                                label: 'Light',
                                isSelected: _homeCategoryIndex == 0,
                                icon: Icons.lightbulb_outline,
                                imagePath: 'assets/Mask group (3).png',
                                onTap: () {
                                  setState(() => _homeCategoryIndex = 0);
                                  DeviceDetailsScreen.go(
                                    context,
                                    deviceTitle: 'Light dinning room',
                                    imageAssetPath: 'assets/Mask group (5).png',
                                    controlButtonCount: 3,
                                  );
                                },
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'Shading',
                                isSelected: _homeCategoryIndex == 1,
                                icon: Icons.blinds_outlined,
                                imagePath: 'assets/Mask group (2).png',
                                onTap: () => setState(() => _homeCategoryIndex = 1),
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'HVAC',
                                isSelected: _homeCategoryIndex == 2,
                                icon: Icons.ac_unit_outlined,
                                imagePath: 'assets/Mask group (4).png',
                                onTap: () => setState(() => _homeCategoryIndex = 2),
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'Security',
                                isSelected: _homeCategoryIndex == 3,
                                icon: Icons.ac_unit_outlined,
                                imagePath: 'assets/securety.png',
                                onTap: () => setState(() => _homeCategoryIndex = 3),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        const _SectionTitle('Light'),
                        SizedBox(height: 12.h),

                        // ✅ Light section 2x2 (same spacing as prior GridView)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 185.h,
                                    child: _LightDimmerCard(
                                      title:
                                          'Bedroom spot light \n small patio blue light',
                                      percent: _bedroomDimmer,
                                      mode: _bedroomManual ? 'M' : 'A',
                                      modeFilled: _bedroomManual,
                                      imagePath: 'assets/Mask group (5).png',
                                      onModeTap: () => setState(
                                        () => _bedroomManual = !_bedroomManual,
                                      ),
                                      onPercentChanged: (v) => setState(
                                        () => _bedroomDimmer = v.clamp(0, 72),
                                      ),
                                      onNavigate: () => DeviceDetailsScreen.go(
                                        context,
                                        deviceTitle:
                                            'Bedroom spot light\nsmall patio blue light',
                                        imageAssetPath:
                                            'assets/Mask group (5).png',
                                        controlButtonCount: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: SizedBox(
                                    height: 185.h,
                                    child: _ThermostatCard(
                                      title:
                                          'Bathroom heating and boiler thermostat',
                                      value: _bathroomThermostat,
                                      mode: _bathroomManual ? 'M' : 'A',
                                      modeFilled: _bathroomManual,
                                      imagePath: 'assets/Mask group (6).png',
                                      minusMarked: _bathroomThermoMark == 1,
                                      plusMarked: _bathroomThermoMark == 2,
                                      onNavigate: () => DeviceDetailsScreen.go(
                                        context,
                                        deviceTitle:
                                            'Bathroom heating and boiler thermostat',
                                        imageAssetPath:
                                            'assets/Mask group (6).png',
                                        controlButtonCount: 3,
                                      ),
                                      onModeTap: () => setState(
                                        () => _bathroomManual = !_bathroomManual,
                                      ),
                                      onMinus: () => _flashMark(
                                        value: 1,
                                        getCurrent: () => _bathroomThermoMark,
                                        set: (v) => _bathroomThermoMark = v,
                                        action: () => _bathroomThermostat =
                                            (_bathroomThermostat - 0.5)
                                                .clamp(10.0, 35.0),
                                      ),
                                      onPlus: () => _flashMark(
                                        value: 2,
                                        getCurrent: () => _bathroomThermoMark,
                                        set: (v) => _bathroomThermoMark = v,
                                        action: () => _bathroomThermostat =
                                            (_bathroomThermostat + 0.5)
                                                .clamp(10.0, 35.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 185.h,
                                    child: _BlindCard(
                                      title: 'Blind Living Room\nnorth window',
                                      downPercent: _blindNorthDown,
                                      upPercent: _blindNorthUp,
                                      mode: _blindManual ? 'M' : 'A',
                                      modeFilled: _blindManual,
                                      imagePath: 'assets/Rectangle 823.png',
                                      downMarked: _blindNorthMark == 1,
                                      upMarked: _blindNorthMark == 2,
                                      onNavigate: () => DeviceDetailsScreen.go(
                                        context,
                                        deviceTitle:
                                            'Blind Living Room\nnorth window',
                                        imageAssetPath:
                                            'assets/Rectangle 823.png',
                                        controlButtonCount: 2,
                                      ),
                                      onModeTap: () => setState(
                                        () => _blindManual = !_blindManual,
                                      ),
                                      onDown: () => _flashMark(
                                        value: 1,
                                        getCurrent: () => _blindNorthMark,
                                        set: (v) => _blindNorthMark = v,
                                        action: () => _blindNorthDown =
                                            (_blindNorthDown + 5).clamp(0, 100),
                                      ),
                                      onUp: () => _flashMark(
                                        value: 2,
                                        getCurrent: () => _blindNorthMark,
                                        set: (v) => _blindNorthMark = v,
                                        action: () => _blindNorthUp =
                                            (_blindNorthUp + 5).clamp(0, 100),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: SizedBox(
                                    height: 185.h,
                                    child: _ToggleCard(
                                      title:
                                          'Irrigation entry and front home two valve',
                                      isOn: true,
                                      imagePath: 'assets/Mask group (7).png',
                                      onNavigate: () => DeviceDetailsScreen.go(
                                        context,
                                        deviceTitle:
                                            'Irrigation entry and front home two valve',
                                        imageAssetPath:
                                            'assets/Mask group (7).png',
                                        controlButtonCount: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

                        SizedBox(height: 70.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFE5E7EB).withOpacity(0.18),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      15.w,
                      topInset + 10.h,
                      15.w,
                      8.h,
                    ),
                    child: Builder(
                      builder: (ctx) => _Header(
                        onMenuTap: () {
                          ctx.push(MenuScreen.routeName);
                        },
                        onEditTap: () =>
                            HomeScreen.showEditAddSectionSheet(ctx),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      initialIndex: 2,
      translucentBottomBar: true,
      bottomBarBackgroundOpacity: 0,
      backgroundColor: Colors.white,
      children: [
        // Index 0: Devices
        RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        // Index 1: Analytics (single shell nav: no second bottom bar)
        const RepaintBoundary(
          child: AnalyticsScreen(showBottomNav: false),
        ),
        // Index 2: Home/Voice
        RepaintBoundary(child: _buildHomeBody(context)),
        // Index 3: Notifications
        RepaintBoundary(child: NotificationsScreen(showBottomNav: true)),
        // Index 4: Settings
        const RepaintBoundary(child: SettingsScreen()),
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
          rowIndex: 0,
          deviceName: 'Blind Living Room south window upside right',
        ),
        SizedBox(height: 12.h),
        _buildShadingControl(
          rowIndex: 1,
          deviceName: 'Blind Living Room south window upside right',
        ),
        SizedBox(height: 12.h),
        _buildShadingControl(
          rowIndex: 2,
          deviceName: 'Blind Living Room south window upside right',
        ),
        SizedBox(height: 18.h),
        // _buildTemperatureSetPointCard(),
      ],
    );
  }

  Widget _buildShadingControl({
    required int rowIndex,
    required String deviceName,
  }) {
    final manual = _shadeManual[rowIndex];
    final downPercent = _shadeDown[rowIndex];
    final upPercent = _shadeUp[rowIndex];
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
                    fontWeight: FontWeight.w400,
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
                    _ModeBadge(
                      mode: manual ? 'M' : 'A',
                      filled: manual,
                      onTap: () => setState(
                        () => _shadeManual[rowIndex] = !manual,
                      ),
                    ),
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
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
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
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
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
                    marked: _shadeStepMark[rowIndex] == 1,
                    onTap: () => _flashMark(
                      value: 1,
                      getCurrent: () => _shadeStepMark[rowIndex],
                      set: (v) => _shadeStepMark[rowIndex] = v,
                      action: () => _shadeDown[rowIndex] =
                          (_shadeDown[rowIndex] - 5).clamp(0, 100),
                    ),
                    child: Image.asset(
                      'assets/Mask group (17).png',
                      width: 13.w,
                      height: 13.h,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(width: 17.w),
                  _CircleBtn(
                    size: 35,
                    marked: _shadeStepMark[rowIndex] == 2,
                    onTap: () => _flashMark(
                      value: 2,
                      getCurrent: () => _shadeStepMark[rowIndex],
                      set: (v) => _shadeStepMark[rowIndex] = v,
                      action: () => _shadeUp[rowIndex] =
                          (_shadeUp[rowIndex] + 5).clamp(0, 100),
                    ),
                    child: Transform.rotate(
                      angle: math.pi,
                      child: Image.asset(
                        'assets/Mask group (17).png',
                        width: 13.w,
                        height: 13.h,
                          color: Color(0xFF6B7280),
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
            Expanded(
              child: _buildThermostatCard(
                mode: _favThermoMManual ? 'M' : 'A',
                filled: _favThermoMManual,
                value: _favThermostatM,
                minusMarked: _favThermoMMark == 1,
                plusMarked: _favThermoMMark == 2,
                onModeTap: () => setState(
                  () => _favThermoMManual = !_favThermoMManual,
                ),
                onMinus: () => _flashMark(
                  value: 1,
                  getCurrent: () => _favThermoMMark,
                  set: (v) => _favThermoMMark = v,
                  action: () => _favThermostatM =
                      (_favThermostatM - 0.5).clamp(10.0, 35.0),
                ),
                onPlus: () => _flashMark(
                  value: 2,
                  getCurrent: () => _favThermoMMark,
                  set: (v) => _favThermoMMark = v,
                  action: () => _favThermostatM =
                      (_favThermostatM + 0.5).clamp(10.0, 35.0),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Row 2
        Row(
          children: [
            Expanded(child: _buildCameraCard()),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildThermostatCard(
                mode: _favThermoAManual ? 'M' : 'A',
                filled: _favThermoAManual,
                value: _favThermostatA,
                minusMarked: _favThermoAMark == 1,
                plusMarked: _favThermoAMark == 2,
                onModeTap: () => setState(
                  () => _favThermoAManual = !_favThermoAManual,
                ),
                onMinus: () => _flashMark(
                  value: 1,
                  getCurrent: () => _favThermoAMark,
                  set: (v) => _favThermoAMark = v,
                  action: () => _favThermostatA =
                      (_favThermostatA - 0.5).clamp(10.0, 35.0),
                ),
                onPlus: () => _flashMark(
                  value: 2,
                  getCurrent: () => _favThermoAMark,
                  set: (v) => _favThermoAMark = v,
                  action: () => _favThermostatA =
                      (_favThermostatA + 0.5).clamp(10.0, 35.0),
                ),
              ),
            ),
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

  Widget _buildThermostatCard({
    required String mode,
    required bool filled,
    required double value,
    bool minusMarked = false,
    bool plusMarked = false,
    VoidCallback? onModeTap,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
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
                  _CircleBtn(
                    marked: minusMarked,
                    onTap: onMinus,
                    size: 35,
                    child: Icon(
                      Icons.remove,
                      size: 20.sp,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${value.toStringAsFixed(1)}°c',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                  _CircleBtn(
                    marked: plusMarked,
                    onTap: onPlus,
                    size: 35,
                    child: Icon(
                      Icons.add,
                      size: 20.sp,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(
            mode: mode,
            filled: filled,
            onTap: onModeTap,
          ),
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
                onTap: () => DeviceDetailsScreen.go(
                  context,
                  deviceTitle: 'Light Scene child room',
                  imageAssetPath:
                      'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
                  controlButtonCount: 3,
                  controlMode: DeviceDetailsControlMode.lightSceneValues,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildLightingCard(
                deviceName: 'RGBW light patio entry',
                status: '100%',
                iconImage:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                onTap: () => DeviceDetailsScreen.go(
                  context,
                  deviceTitle: 'RGBW light patio entry',
                  imageAssetPath:
                      'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                  controlButtonCount: 2,
                  controlMode: DeviceDetailsControlMode.rgbwPicker,
                ),
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
                          onTap: () => DeviceDetailsScreen.go(
                            context,
                            deviceTitle: 'LED Dimmer living room',
                            imageAssetPath:
                                'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                            controlButtonCount: 1,
                            controlMode: DeviceDetailsControlMode.ledDimmer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 7.w, // ✅ outside, but doesn't shrink the card
                    top: 7.h,
                    child: _ModeBadge(
                      mode: _lightingLedBadge1Manual ? 'M' : 'A',
                      filled: _lightingLedBadge1Manual,
                      onTap: () => setState(
                        () => _lightingLedBadge1Manual =
                            !_lightingLedBadge1Manual,
                      ),
                    ),
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
                onTap: () => DeviceDetailsScreen.go(
                  context,
                  deviceTitle: 'Light Scene child room',
                  imageAssetPath:
                      'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
                  controlButtonCount: 3,
                  controlMode: DeviceDetailsControlMode.lightSceneValues,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildLightingCard(
                deviceName: 'RGBW light\npatio entry',
                status: '100%',
                iconImage:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                onTap: () => DeviceDetailsScreen.go(
                  context,
                  deviceTitle: 'RGBW light\npatio entry',
                  imageAssetPath:
                      'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                  controlButtonCount: 2,
                  controlMode: DeviceDetailsControlMode.rgbwPicker,
                ),
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
                          onTap: () => DeviceDetailsScreen.go(
                            context,
                            deviceTitle: 'LED Dimmer living room',
                            imageAssetPath:
                                'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                            controlButtonCount: 1,
                            controlMode: DeviceDetailsControlMode.ledDimmer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 7.w,
                    top: 7.h,
                    child: _ModeBadge(
                      mode: _lightingLedBadge2Manual ? 'M' : 'A',
                      filled: _lightingLedBadge2Manual,
                      onTap: () => setState(
                        () => _lightingLedBadge2Manual =
                            !_lightingLedBadge2Manual,
                      ),
                    ),
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
    VoidCallback? onTap,
  }) {
    final radius = BorderRadius.circular(26.r);
    final card = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: radius,
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
                fontWeight: FontWeight.w400,
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
              fontFamily: "Inter",
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: card,
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
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

// ---------------------------
// Header



class _Header extends StatelessWidget {
  const _Header({
    required this.onMenuTap,
    required this.onEditTap});

  final VoidCallback onMenuTap;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final double rightWidth = 32.w + 13.w + 32.w; // = 77.w

    return Row(
      children: [
        // Left area (match right width)
        SizedBox(
          width: rightWidth,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _PressableCircleSurface(
              side: 44.w,
              onTap: onMenuTap,
              child: Image.asset(
                'assets/Group 35 (1).png',
                width: 26.w,
                height: 17.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Title (now truly centered)
        Expanded(
          child: Center(
            child: Text(
              'Dashboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),

        // Right area
        SizedBox(
          width: rightWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PressableCircleSurface(
                  side: 32.w,
                  onTap: onEditTap,
                  child: Image.asset(
                    'assets/image 89.png',
                    width: 22.w,
                    height: 22.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 13.w),
                _PressableCircleSurface(
                  side: 32.w,
                  onTap: () => HomeScreen.showAddSectionSheet(context),
                  child: Icon(
                    Icons.add_rounded,
                    color: const Color(0xFF111827),
                    size: 23.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
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
      const iconBgColor = Color(0xFFF3F4F6);
      const iconActiveOnWhite = Color(0xFFFAB300);
      const iconActiveOnGray = Color(0xFF6B7280);
      const iconInactive = Color(0xFF111827);
      final iconActiveColor =
          (iconBgColor == Colors.white) ? iconActiveOnWhite : iconActiveOnGray;

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
                color: iconBgColor,
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
                  : Icon(
                      icon,
                      size: 20.sp,
                      color: selected ? iconActiveColor : iconInactive,
                    ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
            fontFamily: 'Inter',
          ),
        ),
        
        GestureDetector(
          onTap: () => HomeScreen.showEditAddSectionSheet(context),
          child: 
            Row(
              children: [
                Text("Edit", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp, fontFamily: "Inter", color: Color(0xFf0088FE)),),
                SizedBox(width: 5.w,), 
                Image.asset(
                  "assets/images/back_arro.png",
                  height: 11.h,
                  width: 11.w,
                  fit: BoxFit.contain,
                  color: Color(0xFf0088FE),
                ),
              ],
            ),
          
        ),
      ],
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
  const _ModeBadge({
    required this.mode,
    required this.filled,
    this.onTap,
  });

  final String mode;
  final bool filled;
  final VoidCallback? onTap;

  static const Color _softGrey = Color(0xFFE1E1E1);
  static const Color _themeBlue = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: filled ? _themeBlue : _softGrey,
        shape: BoxShape.circle,
        // border: filled
        //     ? null
        //     : Border.all(color: _themeBlue.withValues(alpha: 0.45)),
      ),
      alignment: Alignment.center,
      child: Text(
        mode,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : _themeBlue,
        ),
      ),
    );
    if (onTap == null) return badge;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        splashColor: _softGrey,
        highlightColor: const Color(0xFFE5E7EB),
        child: badge,
      ),
    );
  }
}

/// White at rest; gray fill only while the pointer is down (Material 3 ink
/// does not reliably match that).
class _PressableCircleSurface extends StatefulWidget {
  const _PressableCircleSurface({
    required this.side,
    required this.child,
    this.onTap,
    this.marked = false,
  });

  final double side;
  final Widget child;
  final VoidCallback? onTap;
  /// When true, fill stays gray (last-used / "marked" control).
  final bool marked;

  static const Color _pressedFill = Color(0xFFE5E7EB);

  @override
  State<_PressableCircleSurface> createState() =>
      _PressableCircleSurfaceState();
}

class _PressableCircleSurfaceState extends State<_PressableCircleSurface> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final fill = (widget.marked || _pressed)
        ? _PressableCircleSurface._pressedFill
        : Colors.white;
    final circle = Container(
      width: widget.side,
      height: widget.side,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: widget.child,
    );
    if (widget.onTap == null) return circle;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        widget.onTap!();
        _setPressed(false);
      },
      child: circle,
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({
    required this.child,
    this.size,
    this.onTap,
    this.marked = false,
  });

  final Widget child;
  final double? size;
  final VoidCallback? onTap;
  final bool marked;

  @override
  Widget build(BuildContext context) {
    final s = (size ?? 32).w;
    return _PressableCircleSurface(
      side: s,
      onTap: onTap,
      marked: marked,
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
    this.onPercentChanged,
    this.onNavigate,
    this.onModeTap,
  });

  final String title;
  final double percent;
  final String mode;
  final bool modeFilled;
  final String? imagePath;
  final ValueChanged<double>? onPercentChanged;
  final VoidCallback? onNavigate;
  final VoidCallback? onModeTap;

  @override
  Widget build(BuildContext context) {
    final top = Column(
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
                Icons.lightbulb_outline,
                size: 52.sp,
                color: const Color(0xFF15DFFE),
              ),
        SizedBox(height: 10.h),
        Text(
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
      ],
    );

    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onNavigate != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onNavigate,
                    borderRadius: BorderRadius.circular(18.r),
                    child: top,
                  ),
                )
              else
                top,
              const Spacer(),
              Row(
                children: [
                  SizedBox(
                    width: 52.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${(percent * 100).round()}%',
                        style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                        textAlign: TextAlign.left,
                        // maxLines: 1,
                        softWrap: false
                      ),
                    ),
                  ),
                  //SizedBox(width: 10.w),
                  Expanded(
                    child: _DimmerPill(
                      percent: percent,
                      onChanged: onPercentChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(
            mode: mode,
            filled: modeFilled,
            onTap: onModeTap,
          ),
        ),
      ],
    );
  }
}


class _DimmerPill extends StatelessWidget {
  const _DimmerPill({
    required this.percent,
    this.onChanged,
  });

  final double percent;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);

    // Bigger button width
    final w = 133.w;
    final h = 35.h;
    final radius = 24.r;

    //final textValue = '${(p * 100).round()}%';

    final pill = Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            /// Right gray dim area
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: (1 - p),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E1E1),

                      /// Fix right corner radius
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(radius),
                        left: Radius.circular(
                          (1 - p) >= 0.98 ? radius : 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Sun Icon
            Positioned(
              left: 12.w,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.wb_sunny_outlined,
                  size: 18.sp,
                  color: p <= 0
                      ? const Color(0xFF6B7280)
                      : const Color(0xFFFAB300),
                ),
              ),
            ),

          ],
        ),
      ),
    );

    if (onChanged == null) return pill;

    void applyDx(double dx) {
      onChanged!((dx / w).clamp(0.0, 1.0));
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (d) => applyDx(d.localPosition.dx),
      onHorizontalDragUpdate: (d) => applyDx(d.localPosition.dx),
      child: pill,
    );
  }
}




class _ThermostatCard extends StatelessWidget {
  const _ThermostatCard({
    required this.title,
    required this.value,
    required this.mode,
    required this.modeFilled,
    required this.onMinus,
    required this.onPlus,
    this.minusMarked = false,
    this.plusMarked = false,
    this.imagePath,
    this.onModeTap,
    this.onNavigate,
  });

  final String title;
  final double value;
  final String mode;
  final bool modeFilled;
  final String? imagePath;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback? onModeTap;
  final VoidCallback? onNavigate;
  final bool minusMarked;
  final bool plusMarked;


  @override
  Widget build(BuildContext context) {
    final Widget headerColumn = Column(
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
                  title.split('\n').isNotEmpty ? title.split('\n')[0] : title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
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
                    title.split('\n').length > 1 ? title.split('\n')[1] : '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF111827),
                      height: 1.15,
                      //fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: onNavigate != null
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onNavigate,
                          borderRadius: BorderRadius.circular(18.r),
                          child: headerColumn,
                        ),
                      )
                    : headerColumn,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleBtn(
                    size: 35,
                    marked: minusMarked,
                    onTap: onMinus,
                    child: Icon(
                      Icons.remove,
                      size: 23.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    '${value.toStringAsFixed(1)}° c',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  _CircleBtn(
                    size: 35,
                    marked: plusMarked,
                    onTap: onPlus,
                    child: Icon(
                      Icons.add,
                      size: 23.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(
            mode: mode,
            filled: modeFilled,
            onTap: onModeTap,
          ),
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
    required this.onDown,
    required this.onUp,
    this.downMarked = false,
    this.upMarked = false,
    this.imagePath,
    this.onModeTap,
    this.onNavigate,
  });

  final String title;
  final int downPercent;
  final int upPercent;
  final String mode;
  final bool modeFilled;
  final String? imagePath;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final VoidCallback? onModeTap;
  final VoidCallback? onNavigate;
  final bool downMarked;
  final bool upMarked;

  @override
  Widget build(BuildContext context) {
    Widget titleInkWell(Widget child) {
      if (onNavigate == null) return child;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onNavigate,
          borderRadius: BorderRadius.circular(18.r),
          child: child,
        ),
      );
    }

    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePath != null)
                titleInkWell(
                  Image.asset(
                    imagePath!,
                    width: 65.w,
                    height: 65.w,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: 10.h),
              Expanded(
                child: titleInkWell(
                  SizedBox.expand(
                    child: Align(
                      alignment: Alignment.topLeft,
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
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CircleBtn(
                                marked: downMarked,
                                onTap: onDown,
                                child: Image.asset(
                                  'assets/Mask group (17).png',
                                  width: 13.sp,
                                  height: 13.sp,
                                  fit: BoxFit.contain,
                                  color: Color(0xFF6B7280),
                                ),
                                size: 35,
                              ),
                              SizedBox(width: 5.w),
                              Image.asset(
                                'assets/Group 32.jpg',
                                width: 10.w,
                                height: 17.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '$downPercent%',
                                style: TextStyle(
                                  fontSize:18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                             SizedBox(width: 5.w),
                              Image.asset(
                                'assets/Vector 4.jpg',
                                width: 8.w,
                                height: 17.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '$upPercent%',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              _CircleBtn(
                                marked: upMarked,
                                onTap: onUp,
                                child: Transform.rotate(
                                  angle: math.pi,
                                  child: Image.asset(
                                    'assets/Mask group (17).png',
                                    width: 13.sp,
                                    height: 13.sp,
                                    fit: BoxFit.contain,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                size: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(
            mode: mode,
            filled: modeFilled,
            onTap: onModeTap,
          ),
        ),
      ],
    );
  }
}

class _ToggleCard extends StatefulWidget {
  const _ToggleCard({
    required this.title,
    required this.isOn,
    this.imagePath,
    this.onNavigate,
  });

  final String title;
  final bool isOn;
  final String? imagePath;
  final VoidCallback? onNavigate;

  @override
  State<_ToggleCard> createState() => _ToggleCardState();
}

class _ToggleCardState extends State<_ToggleCard> {
  late bool _on;
  late bool _manualMode;

  @override
  void initState() {
    super.initState();
    _on = widget.isOn;
    _manualMode = false;
  }

  @override
  void didUpdateWidget(covariant _ToggleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOn != widget.isOn) {
      _on = widget.isOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget headerColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.imagePath != null
            ? Image.asset(
                widget.imagePath!,
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
            widget.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
              height: 1.15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Stack(
      children: [
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: widget.onNavigate != null
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onNavigate,
                          borderRadius: BorderRadius.circular(18.r),
                          child: headerColumn,
                        ),
                      )
                    : headerColumn,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _on ? 'On' : 'Off',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(
                    height: 35.h,
                    width: 60.w,
                    child: CupertinoSwitch(
                      value: _on,
                      onChanged: (v) => setState(() => _on = v),
                      activeColor: const Color(0xFF0088FE),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(
            mode: _manualMode ? 'M' : 'A',
            filled: _manualMode,
            onTap: () => setState(() => _manualMode = !_manualMode),
          ),
        ),
      ],
    );
  }
}

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
// class _CircularProgressPainter extends CustomPainter {
//   _CircularProgressPainter({required this.progress, required this.strokeWidth});
//
//   final double progress;
//   final double strokeWidth;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;
//
//     final bg = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..color = const Color(0xFFE1E1E1);
//
//     final fg = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round
//       ..color = const Color(0xFF0088FE);
//
//     canvas.drawCircle(center, radius, bg);
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       -math.pi / 2,
//       2 * math.pi * progress,
//       false,
//       fg,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
//     return oldDelegate.progress != progress ||
//         oldDelegate.strokeWidth != strokeWidth;
//   }
// }

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
            fontWeight: FontWeight.w700,
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


// Devices Screen Helper Widgets


//
// class _DeviceListCard extends StatelessWidget {
//   const _DeviceListCard({required this.children});
//   final List<Widget> children;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 14.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18.r),
//       ),
//       child: Column(children: children),
//     );
//   }
// }
//
// class _DeviceRow extends StatelessWidget {
//   const _DeviceRow({
//     required this.leading,
//     required this.title,
//     required this.subtitle,
//     required this.trailing,
//     this.topRight,
//     this.selected = false,
//   });
//
//   final Widget leading;
//   final String title;
//   final Widget subtitle;
//   final Widget trailing;
//   final Widget? topRight;
//   final bool selected;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: selected ? const Color(0xFFEAF1FF) : Colors.white,
//       padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
//       child: Stack(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(width: 6.w),
//               SizedBox(
//                 width: 34.w,
//                 height: 34.w,
//                 child: Center(child: leading),
//               ),
//               SizedBox(width: 10.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF111827),
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     subtitle,
//                   ],
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               trailing,
//               SizedBox(width: 4.w),
//             ],
//           ),
//           if (topRight != null) Positioned(right: 0, top: 0, child: topRight!),
//         ],
//       ),
//     );
//   }
// }
//
// class _RowDivider extends StatelessWidget {
//   const _RowDivider();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 1,
//       margin: EdgeInsets.only(left: 56.w),
//       color: const Color(0xFFF1F1F1),
//     );
//   }
// }
//
// class _SearchBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40.h,
//       padding: EdgeInsets.symmetric(horizontal: 12.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(22.r),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.search, size: 18.sp, color: const Color(0xFF6B7280)),
//           SizedBox(width: 8.w),
//           Text(
//             'Search',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: const Color(0xFF9CA3AF),
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _FilterChipPill extends StatelessWidget {
//   const _FilterChipPill({required this.label, this.selected = false});
//   final String label;
//   final bool selected;
//
//   @override
//   Widget build(BuildContext context) {
//     final border = selected ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB);
//     final text = selected ? const Color(0xFF0088FE) : const Color(0xFF111827);
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: border, width: 1),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 12.sp,
//           color: text,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
//
// class _CircleIconButton extends StatelessWidget {
//   const _CircleIconButton({
//     required this.icon,
//     required this.onTap,
//     this.bg = const Color(0xFFF3F4F6),
//     this.iconColor = const Color(0xFF111827),
//   });
//
//   final IconData icon;
//   final VoidCallback onTap;
//   final Color bg;
//   final Color iconColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(999),
//       child: Container(
//         width: 32.w,
//         height: 32.w,
//         decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
//         alignment: Alignment.center,
//         child: Icon(icon, size: 18.sp, color: iconColor),
//       ),
//     );
//   }
// }
//
// class _CircleMiniBtn extends StatelessWidget {
//   const _CircleMiniBtn({required this.icon});
//   final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 30.w,
//       height: 30.w,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         shape: BoxShape.circle,
//       ),
//       alignment: Alignment.center,
//       child: Icon(icon, size: 18.sp, color: const Color(0xFF111827)),
//     );
//   }
// }
//
// class _CircleActionBlue extends StatelessWidget {
//   const _CircleActionBlue({required this.icon});
//   final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFF0088FE),
//         shape: BoxShape.circle,
//       ),
//       alignment: Alignment.center,
//       child: Icon(icon, size: 18.sp, color: Colors.white),
//     );
//   }
// }
//
// class _ToggleSwitch extends StatelessWidget {
//   const _ToggleSwitch({required this.isOn});
//   final bool isOn;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 52.w,
//       height: 30.h,
//       padding: EdgeInsets.all(2.w),
//       decoration: BoxDecoration(
//         color: isOn ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB),
//         borderRadius: BorderRadius.circular(99),
//       ),
//       child: Align(
//         alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           width: 30.86.w,
//           height: 30.86.w,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _SmallText extends StatelessWidget {
//   const _SmallText(this.text);
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w400,
//         color: const Color(0xFF6B7280),
//       ),
//     );
//   }
// }
//
// class _BoldSmall extends StatelessWidget {
//   const _BoldSmall(this.text);
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w700,
//         color: const Color(0xFF111827),
//       ),
//     );
//   }
// }
//
// class _TinyGreyText extends StatelessWidget {
//   const _TinyGreyText(this.text);
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 10.sp,
//         fontWeight: FontWeight.w400,
//         color: const Color(0xFF9CA3AF),
//       ),
//     );
//   }
// }

// class _ModeDot extends StatelessWidget {
//   const _ModeDot({required this.text, required this.filled});
//   final String text;
//   final bool filled;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 18.w,
//       height: 18.w,
//       decoration: BoxDecoration(
//         color: filled ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB),
//         shape: BoxShape.circle,
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 10.sp,
//           fontWeight: FontWeight.w700,
//           color: filled ? Colors.white : const Color(0xFF111827),
//         ),
//       ),
//     );
//   }
// }


// Not working this code; 
//
// class _TagChip extends StatelessWidget {
//   const _TagChip({required this.text, required this.bg});
//   final String text;
//   final Color bg;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(6.r),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 10.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
//
// class _TimeTag extends StatelessWidget {
//   const _TimeTag({required this.text, this.blueIcon = false});
//   final String text;
//   final bool blueIcon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           Icons.wifi,
//           size: 12.sp,
//           color: blueIcon ? const Color(0xFF0088FE) : const Color(0xFF9CA3AF),
//         ),
//         SizedBox(width: 4.w),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 10.sp,
//             color: const Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _StarTimeTag extends StatelessWidget {
//   const _StarTimeTag({required this.time});
//   final String time;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24)),
//         SizedBox(width: 4.w),
//         Text(
//           time,
//           style: TextStyle(
//             fontSize: 10.sp,
//             color: const Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _StarOnly extends StatelessWidget {
//   const _StarOnly();
//
//   @override
//   Widget build(BuildContext context) {
//     return Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24));
//   }
// }
//
// class _GradientCircleIcon extends StatelessWidget {
//   const _GradientCircleIcon({this.size = 34});
//   final double size;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size.w,
//       height: size.w,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: SweepGradient(
//           colors: [
//             Color(0xFF15DFFE),
//             Color(0xFF0088FE),
//             Color(0xFFFE019A),
//             Color(0xFFFFD700),
//             Color(0xFF15DFFE),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _LockIcon extends StatelessWidget {
//   const _LockIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFFFE4F1),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.lock_outline,
//         size: 18.sp,
//         color: const Color(0xFFFE019A),
//       ),
//     );
//   }
// }
//
// class _PowerRingIcon extends StatelessWidget {
//   const _PowerRingIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFEAFBF2),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.power_settings_new,
//         size: 18.sp,
//         color: const Color(0xFF10B981),
//       ),
//     );
//   }
// }
//
// class _BlindGreenIcon extends StatelessWidget {
//   const _BlindGreenIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFEAFBF2),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.blinds_outlined,
//         size: 18.sp,
//         color: const Color(0xFF84CC16),
//       ),
//     );
//   }
// }
//
// class _PlayCircleIcon extends StatelessWidget {
//   const _PlayCircleIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFEAF1FF),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.play_arrow,
//         size: 18.sp,
//         color: const Color(0xFF0088FE),
//       ),
//     );
//   }
// }
//
// class _SunIcon extends StatelessWidget {
//   const _SunIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFFFFBEB),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.wb_sunny_outlined,
//         size: 18.sp,
//         color: const Color(0xFFFBBF24),
//       ),
//     );
//   }
// }
//
// class _BulbIcon extends StatelessWidget {
//   const _BulbIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFF3F4F6),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.lightbulb_outline,
//         size: 18.sp,
//         color: const Color(0xFF84CC16),
//       ),
//     );
//   }
// }
//
// class _BlindStatsRow extends StatelessWidget {
//   const _BlindStatsRow();
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const _ModeDot(text: 'A', filled: false),
//         SizedBox(width: 10.w),
//         Icon(Icons.arrow_downward, size: 14.sp, color: const Color(0xFF111827)),
//         SizedBox(width: 4.w),
//         Text(
//           '0%',
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF111827),
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Icon(Icons.arrow_upward, size: 14.sp, color: const Color(0xFF111827)),
//         SizedBox(width: 4.w),
//         Text(
//           '50%',
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF111827),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _BrightnessPill extends StatelessWidget {
//   const _BrightnessPill();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150.w,
//       height: 30.h,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(99),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 95.w,
//             height: 30.h,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(99),
//             ),
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.only(left: 10.w),
//             child: Icon(
//               Icons.wb_sunny_outlined,
//               size: 16.sp,
//               color: const Color(0xFF111827),
//             ),
//           ),
//           Expanded(child: Container()),
//         ],
//       ),
//     );
//   }
// }
//
// class _ControlUnitRow extends StatelessWidget {
//   const _ControlUnitRow({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.sub,
//     this.sub2,
//   });
//
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String sub;
//   final String? sub2;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
//       child: Row(
//         children: [
//           Container(
//             width: 34.w,
//             height: 34.w,
//             decoration: const BoxDecoration(
//               color: Color(0xFFF3F4F6),
//               shape: BoxShape.circle,
//             ),
//             alignment: Alignment.center,
//             child: Icon(icon, size: 18.sp, color: iconColor),
//           ),
//           SizedBox(width: 10.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF111827),
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   sub,
//                   style: TextStyle(
//                     fontSize: 11.sp,
//                     color: const Color(0xFF6B7280),
//                   ),
//                 ),
//                 if (sub2 != null) ...[
//                   SizedBox(height: 2.h),
//                   Text(
//                     sub2!,
//                     style: TextStyle(
//                       fontSize: 10.sp,
//                       color: const Color(0xFF9CA3AF),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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