import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/devices/screen/devices_screen.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/settings/screen/settings_screen.dart';

import '../../../core/widget/global_back_button.dart';

/// Controls which primary region appears below the hero (stats stay the same).
enum DeviceDetailsControlMode {
  /// Off / On row (hero + stats above).
  standard,

  /// Light scene: main title + "Values" + All On / Night / All Off (no power row, no tune row).
  lightSceneValues,

  /// RGBW fixture: hue/saturation wheel + intensity slider (no Off/On tune row).
  rgbwPicker,

  /// LED dimmer: circular gradient ring + centered % (no Off/On tune row).
  ledDimmer,
}

/// Carried on [GoRouterState.extra] so [DeviceDetailsControlMode] cannot be lost
/// while navigating (query-only payloads were unreliable in this app shell).
class DeviceDetailsRouteArgs {
  const DeviceDetailsRouteArgs({
    required this.deviceTitle,
    required this.imageAssetPath,
    this.controlButtonCount = 3,
    this.controlMode = DeviceDetailsControlMode.standard,
  });

  final String deviceTitle;
  final String imageAssetPath;
  final int controlButtonCount;
  final DeviceDetailsControlMode controlMode;
}

/// Full-screen device UI (formerly Light Dining Room). Only [deviceTitle],
/// [imageAssetPath], and [controlButtonCount] vary per device; the rest of the
/// layout is shared.
class DeviceDetailsScreen extends StatefulWidget {
  const DeviceDetailsScreen({
    super.key,
    required this.deviceTitle,
    required this.imageAssetPath,
    this.controlButtonCount = 3,
    this.controlMode = DeviceDetailsControlMode.standard,
  });

  final String deviceTitle;
  final String imageAssetPath;

  /// Kept for route/navigation compatibility; tune buttons are no longer shown.
  final int controlButtonCount;

  /// Switches between standard hero + Off/On vs light-scene "Values", RGBW picker, or LED dimmer ring.
  final DeviceDetailsControlMode controlMode;

  static const String routeName = '/device-details';

  /// Builds a location string for [GoRouter] with query parameters.
  static String routeUri({
    required String title,
    required String imageAssetPath,
    int controlButtonCount = 3,
    DeviceDetailsControlMode controlMode = DeviceDetailsControlMode.standard,
  }) {
    final n = controlButtonCount.clamp(1, 8);
    final Map<String, String> query = <String, String>{
      'title': title,
      'image': imageAssetPath,
      'buttons': '$n',
    };
    if (controlMode == DeviceDetailsControlMode.lightSceneValues) {
      query['mode'] = 'lightSceneValues';
    } else if (controlMode == DeviceDetailsControlMode.rgbwPicker) {
      query['mode'] = 'rgbw';
    } else if (controlMode == DeviceDetailsControlMode.ledDimmer) {
      query['mode'] = 'ledDimmer';
    }
    return Uri(path: routeName, queryParameters: query).toString();
  }

  /// Prefer this over raw [routeUri] + [context.push] so [controlMode] is always applied.
  static void go(
    BuildContext context, {
    required String deviceTitle,
    required String imageAssetPath,
    int controlButtonCount = 3,
    DeviceDetailsControlMode controlMode = DeviceDetailsControlMode.standard,
  }) {
    final int n = controlButtonCount.clamp(1, 8);
    context.push(
      routeUri(
        title: deviceTitle,
        imageAssetPath: imageAssetPath,
        controlButtonCount: n,
        controlMode: controlMode,
      ),
      extra: DeviceDetailsRouteArgs(
        deviceTitle: deviceTitle,
        imageAssetPath: imageAssetPath,
        controlButtonCount: n,
        controlMode: controlMode,
      ),
    );
  }

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

enum _DeviceTab { tools, automation, overview, chart, activity }

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  bool _isOn = true;
  _DeviceTab _tab = _DeviceTab.tools;
  String _label = 'Lighting';
  String _manualMode = 'A';

  /// Selected scene for [DeviceDetailsControlMode.lightSceneValues]: 0 All On, 1 Night, 2 All Off.
  int _selectedSceneIndex = 0;

  /// RGBW wheel: hue degrees [0,360), saturation [0,1], intensity [0,1] for brightness slider.
  double _rgbwHue = 88;
  double _rgbwSaturation = 0.52;
  double _rgbwIntensity = 0.7;

  /// LED dimmer ring: 0 = min, 1 = 100%.
  double _ledDimmerPercent = 1.0;

  static const List<String> _sceneLabels = <String>[
    'All On',
    'Night',
    'All Off',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      initialIndex: 2,
      backgroundColor: const Color(0xFFF3F4F6),
      //backgroundColor: Colors.black,
      children: [
        const RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        const RepaintBoundary(child: AnalyticsScreen(showBottomNav: false)),
        RepaintBoundary(child: _buildBody(context)),
        const RepaintBoundary(child: NotificationsScreen(showBottomNav: false)),
        const RepaintBoundary(child: SettingsScreen()),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final bool isLightSceneValues =
        widget.controlMode == DeviceDetailsControlMode.lightSceneValues;
    return SafeArea(
      top: true,
      bottom: false,

      child: Column(
        children: [
          _buildTopHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHero(),
                  SizedBox(height: isLightSceneValues ? 10.h : 18.h),
                  if (widget.controlMode ==
                      DeviceDetailsControlMode.lightSceneValues) ...[
                    _buildSceneValuesSection(),
                  ] else if (widget.controlMode !=
                          DeviceDetailsControlMode.rgbwPicker &&
                      widget.controlMode !=
                          DeviceDetailsControlMode.ledDimmer) ...[
                    _buildOnOffRow(),
                  ],
                  SizedBox(height: isLightSceneValues ? 10.h : 16.h),
                  _buildInfoPill(),
                  SizedBox(height: 32.h),
                  _buildTabsRow(),
                  SizedBox(height: 12.h),
                  _buildTabContent(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14.w, right: 14.w),
      child: SizedBox(
        height: 40.h,
        child: Row(
          children: [
            GlobalCircleIconBtn(
              color: const Color(0xFFFFFFFF),
              child: Image.asset('assets/aro.png', width: 16.w, height: 16.h),
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go('/setting-device');
                }
              },
            ),

            const Spacer(),
            // Ellipsis button + blue plus
            GlobalCircleIconBtn(
              color: const Color(0xFFFFFFFF),
              onTap: () {},
              child: Icon(Icons.more_horiz_rounded, color: Colors.black),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    if (widget.controlMode == DeviceDetailsControlMode.rgbwPicker) {
      return _buildRgbwHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.ledDimmer) {
      return _buildLedDimmerHeroContent();
    }
    return Column(
      children: [
        SizedBox(height: 4.h),
        Center(
          child: Image.asset(
            widget.imageAssetPath,
            height: 88.h,
            width: 88.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/Mask group (5).png',
              height: 88.h,
              width: 88.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 9,
                child: Text(
                  widget.deviceTitle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Image.asset(
                  "assets/Group 63.png",
                  height: 13.h,
                  width: 13.w,
                  fit: BoxFit.cover,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          'SWC 1326 39',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 80.w, right: 90.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBlock(top: '12:57', bottom: 'On time'),
              _StatBlock(top: '5h 58m', bottom: '7 Days'),
              _StatBlock(top: '1257', bottom: 'Cycles'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLedDimmerHeroContent() {
    final double ringSize = 228.w;
    final double stroke = 12.r;

    return Column(
      children: [
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  widget.deviceTitle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Image.asset(
                  'assets/Group 63.png',
                  height: 13.h,
                  width: 13.w,
                  fit: BoxFit.cover,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          'SWC 1326 39',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 80.w, right: 90.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBlock(top: '12:57', bottom: 'On time'),
              _StatBlock(top: '5h 58m', bottom: '7 Days'),
              _StatBlock(top: '1257', bottom: 'Cycles'),
            ],
          ),
        ),
        // SizedBox(height: 22.h),
        // Text(
        //   'LED Dimmer',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontFamily: 'Inter',
        //     fontSize: 20.sp,
        //     fontWeight: FontWeight.w600,
        //     color: const Color(0xFF111827),
        //   ),
        // ),
        SizedBox(height: 14.h),
        Center(
          child: SizedBox(
            width: ringSize,
            height: ringSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final Size sz = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) =>
                      _ledDimmerUpdateFromLocal(d.localPosition, sz),
                  onPanUpdate: (d) =>
                      _ledDimmerUpdateFromLocal(d.localPosition, sz),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      CustomPaint(
                        size: sz,
                        painter: _LedDimmerRingPainter(
                          percent: _ledDimmerPercent.clamp(0.0, 1.0),
                          strokeWidth: stroke,
                        ),
                      ),
                      Text(
                        '${(_ledDimmerPercent * 100).round()}%',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 52.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final Offset c = Offset(sz.width / 2, sz.height / 2);
                          final double radius =
                              sz.shortestSide / 2 - stroke / 2 - 2;
                          final double ang =
                              -math.pi / 2 +
                              2 * math.pi * _ledDimmerPercent.clamp(0.0, 1.0);
                          final Offset thumb =
                              c + Offset(math.cos(ang), math.sin(ang)) * radius;
                          return Positioned(
                            left: thumb.dx - 11.r,
                            top: thumb.dy - 11.r,
                            child: IgnorePointer(
                              child: Container(
                                width: 22.r,
                                height: 22.r,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E52A),
                                  borderRadius: BorderRadius.circular(26.r),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white,
                                  ),
                                  //shape: BoxShape.circle,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.white,
                                  //     blurRadius: 5.r,
                                  //     offset: const Offset(0, 8),
                                  //   ),
                                  // ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _ledDimmerUpdateFromLocal(Offset local, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final Offset d = local - c;
    final double angle = math.atan2(d.dy, d.dx);
    double p = (angle + math.pi / 2) / (2 * math.pi);
    if (p < 0) {
      p += 1;
    }
    if (p >= 1) {
      p -= 1;
    }
    setState(() => _ledDimmerPercent = p.clamp(0.0, 1.0));
  }

  Widget _buildRgbwHeroContent() {
    final Color preview = HSVColor.fromAHSV(
      1.0,
      _rgbwHue.clamp(0.0, 359.99),
      _rgbwSaturation.clamp(0.0, 1.0),
      _rgbwIntensity.clamp(0.0, 1.0),
    ).toColor();
    final String hex = preview.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();

    final double wheelSize = 260.w;

    return Column(
      children: [
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  widget.deviceTitle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Image.asset(
                  'assets/Group 63.png',
                  height: 13.h,
                  width: 13.w,
                  fit: BoxFit.cover,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          'SWC 1326 39',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 80.w, right: 90.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBlock(top: '12:57', bottom: 'On time'),
              _StatBlock(top: '5h 58m', bottom: '7 Days'),
              _StatBlock(top: '1257', bottom: 'Cycles'),
            ],
          ),
        ),
        // SizedBox(height: 22.h),
        // Text(
        //   'RGBW',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontFamily: 'Inter',
        //     fontSize: 20.sp,
        //     fontWeight: FontWeight.w600,
        //     color: const Color(0xFF111827),
        //   ),
        // ),
        SizedBox(height: 14.h),
        Center(
          child: SizedBox(
            width: wheelSize,
            height: wheelSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final Size layoutSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) =>
                      _rgbwUpdateFromLocal(d.localPosition, layoutSize),
                  onPanUpdate: (d) =>
                      _rgbwUpdateFromLocal(d.localPosition, layoutSize),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: layoutSize,
                        painter: _RgbHueWheelPainter(),
                      ),
                      Builder(
                        builder: (context) {
                          final Offset c = Offset(
                            layoutSize.width / 2,
                            layoutSize.height / 2,
                          );
                          final double maxR =
                              layoutSize.shortestSide / 2 - 10.r;
                          final double r =
                              maxR * _rgbwSaturation.clamp(0.0, 1.0);
                          final double rad = _rgbwHue * math.pi / 180;
                          final Offset thumb =
                              c + Offset(math.cos(rad) * r, -math.sin(rad) * r);
                          return Positioned(
                            left: thumb.dx - 20.w,
                            top: thumb.dy - 20.w,
                            child: IgnorePointer(
                              child: Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26.r),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.0),
                                      blurRadius: 6.r,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          hex,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 22.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.sp,
                    height: 1.2,
                    // color: Color(0xFF111827)  ,
                    // fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Intensity: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: '${(_rgbwIntensity * 100).round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(
                    Icons.wb_sunny_outlined,
                    size: 15.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8.h,
                        trackShape: const _RgbwIntensityGradientTrackShape(),
                        thumbShape: _RgbwMagentaThumbShape(
                          enabledOuterRadius: 15.5.r,
                          enabledInnerRadius: 12.r,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 22.r,
                        ),
                        activeTrackColor: const Color(0xFFE91EAC),
                        inactiveTrackColor: const Color(0xFFFFFFFF),
                        disabledActiveTrackColor: const Color(0xFFE91EAC),
                        disabledInactiveTrackColor: const Color(0xFFFFFFFF),
                        thumbColor: const Color(0xFFE91EAC),
                        disabledThumbColor: const Color(0xFFE91EAC),
                      ),
                      child: Slider(
                        value: _rgbwIntensity.clamp(0.0, 1.0),
                        min: 0,
                        max: 1,
                        activeColor: const Color(0xFFE91EAC),
                        inactiveColor: const Color(0xFFFFFFFF),
                        onChanged: (v) =>
                            setState(() => _rgbwIntensity = v.clamp(0.0, 1.0)),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.wb_sunny,
                    size: 28.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _rgbwUpdateFromLocal(Offset local, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final Offset d = local - c;
    final double maxR = size.shortestSide / 2 - 18.r;
    final double dist = d.distance.clamp(0.0, maxR);
    double hueDeg = math.atan2(-d.dy, d.dx) * 180 / math.pi;
    if (hueDeg < 0) {
      hueDeg += 360;
    }
    setState(() {
      _rgbwHue = hueDeg;
      _rgbwSaturation = maxR <= 0 ? 0 : dist / maxR;
    });
  }

  Widget _buildOnOffRow() {
    const Color offSelectedBg = Color(0xFF6B7280);
    const Color onSelectedBg = Color(0xFF0088FE);
    const Color inactiveBg = Colors.white;
    const Color inactiveBorder = Color(0xFFE5E7EB);
    const Color inactiveFg = Color(0xFF6B7280);

    return Padding(
      padding: EdgeInsets.only(left: 130.w, right: 130.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isOn = false),
              child: Container(
                height: 39.h,
                width: 78.w,
                decoration: BoxDecoration(
                  color: !_isOn ? offSelectedBg : inactiveBg,
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(
                    color: !_isOn ? offSelectedBg : inactiveBg,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/off_logo.png',
                        height: 13.h,
                        width: 13.w,
                        fit: BoxFit.cover,
                        color: !_isOn ? Colors.white : inactiveFg,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Off',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: !_isOn ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isOn = true),
              child: Container(
                height: 39.h,
                width: 78.w,
                decoration: BoxDecoration(
                  color: _isOn ? onSelectedBg : inactiveBg,
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(
                    color: _isOn ? onSelectedBg : inactiveBg,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new_rounded,
                        size: 18.sp,
                        color: _isOn ? Colors.white : inactiveFg,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'On',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _isOn ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneValuesSection() {
    final String headline = _sceneLabels[_selectedSceneIndex.clamp(0, 2)];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            headline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Values',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(3, (int i) {
              final option = _SceneValueOption(
                label: _sceneLabels[i],
                selected: _selectedSceneIndex == i,
                child: _sceneValueIcon(i),
                onTap: () => setState(() => _selectedSceneIndex = i),
              );
              if (i == 0) return option;
              return Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: option,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _sceneValueIcon(int sceneSlot) {
    final String path = widget.imageAssetPath;
    
    switch (sceneSlot) {
      case 0:
        return ClipOval(
          child: Image.asset(
            path,
            width: 28.w,
            height: 28.w,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            Image.asset(
                "assets/light_image.png",
                height:28.h,
                width:28.w,
                fit:BoxFit.contain,
                //color: const Color(0xFF6B7280),
              ),
          ),
        );
      case 1:
        return Opacity(
          opacity: 0.42,
          child: ClipOval(
            child: Image.asset(
              path,
              width: 28.w,
              height: 28.w,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                "assets/gray_image.png",
                height: 28.h,
                width: 28.w,
                fit: BoxFit.contain,
                //color: const Color(0xFF6B7280),
              ),
            ),
          ),
        );
      case 2:
      default:
        return ClipOval(
          child: Image.asset(
            "assets/black_image.png",
            height: 28.h,
            width: 28.w,
            fit: BoxFit.contain,
            //color: const Color(0xFF6B7280),
          ),
        );

        // Icon(Icons.cloud_rounded, size: 28.sp, color: const Color(0xFF6B7280));
    }
  }

  Widget _buildInfoPill() {
    return Center(
      child: Container(
        height: 22.h,
        padding: EdgeInsets.only(right: 10.w, left: 10.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/message_icon.png",
              height: 15.h,
              width: 15.w,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.w),
            Text(
              'Don\'t ON this device while you sleeping',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabsRow() {
    const tabs = [
      (_DeviceTab.tools, 'Tools'),
      (_DeviceTab.automation, 'Automation'),
      (_DeviceTab.chart, 'Chart'),
      (_DeviceTab.overview, 'Overview'),

      (_DeviceTab.activity, 'Activity'),
    ];

    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final active = _tab == tab.$1;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _tab = tab.$1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 6.h),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        tab.$2,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827),
                          // active
                          //     ? const Color(0xFF111827)
                          //     : const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 3.h,
                    width: active ? 49.w : 0.w,
                    //width: active ? double.infinity : 0, // ✅ FIX
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tab) {
      case _DeviceTab.tools:
        return _buildManageDeviceCard();
      case _DeviceTab.automation:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: _automationCard(),
        );
      case _DeviceTab.overview:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: deviceOverviewCard(),
        );
      case _DeviceTab.chart:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: _chartCard(),
        );
      case _DeviceTab.activity:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: _activityCard(),
        );
    }
  }

  Widget _buildManageDeviceCard() {
    return Padding(
      padding: EdgeInsets.only(right: 15.w, left: 15.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 55.h,
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Text(
                'Manage your device',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
            _manageRowLabels(),
            Padding(
              padding: EdgeInsets.only(right: 14.w, left: 48.w),
              child: const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE1E1E1),
              ),
            ),
            _manageRowAlerts(),
            Padding(
              padding: EdgeInsets.only(right: 14.w, left: 48.w),
              child: const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE1E1E1),
              ),
            ),
            _manageRowSafeValue(),
            Padding(
              padding: EdgeInsets.only(right: 14.w, left: 48.w),
              child: const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE1E1E1),
              ),
            ),
            _manageRowManualOverride(),
            //SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }

  Widget _manageRowLabels() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/labels_icon.png",
            height: 23.h,
            width: 23.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Labels',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _ChipPill(
                text: 'Bathroom',
                bg: const Color(0xFFFE019A),
                textColor: Colors.white,
                border: Colors.transparent,
              ),

              SizedBox(width: 10.w),
              _ChipPill(
                text: _label,
                bg: Colors.white,
                textColor: const Color(0xFF0088FE),
                border: const Color(0xFF0088FE),
              ),
              SizedBox(width: 8.w),
              Image.asset(
                "assets/back_arro.png",
                height: 13.h,
                width: 13.w,
                fit: BoxFit.cover,
                color: Color(0xFF6B7280),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _manageRowAlerts() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/alerts_icon.png",
            height: 23.h,
            width: 23.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Alerts',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Container(
            width: 38.w,
            height: 29.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                '12',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Image.asset(
            "assets/back_arro.png",
            height: 13.h,
            width: 13.w,
            fit: BoxFit.cover,
            color: Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _manageRowSafeValue() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/sate_icon.png",
            height: 21.h,
            width: 21.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Safe Value',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Text(
            'On',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(width: 8.w),
          Image.asset(
            "assets/back_arro.png",
            height: 13.h,
            width: 13.w,
            fit: BoxFit.cover,
            color: Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _manageRowManualOverride() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/manual_icon.png",
            height: 23.h,
            width: 23.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Manual Override',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Container(
            height: 36.h,
            width: 69.w,
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ModeButton(
                  label: 'A',
                  active: _manualMode == 'A',
                  onTap: () => setState(() => _manualMode = 'A'),
                ),
                //SizedBox(width: 10.w),
                _ModeButton(
                  label: 'M',
                  active: _manualMode == 'M',
                  onTap: () => setState(() => _manualMode = 'M'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _automationCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 55.h,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Text(
                'Organize automation',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE1E1E1)),
          Padding(
            padding: EdgeInsets.only(
              left: 5.w,
              top: 5.h,
              right: 5.w,
              bottom: 5.h,
            ),
            child: _miniAutomationRow(
              title: 'Set actions based on value of',
              subtitle: 'Multi-Value Switch',
              image: "assets/set_actions_icon.png",
              imageheight: 40.h,
              imagewidth: 40.w,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 65.w, right: 14.w),
            child: Divider(height: 1, color: Color(0xFFE1E1E1)),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5.w,
              top: 5.h,
              right: 5.w,
              bottom: 5.h,
            ),
            child: _miniAutomationRow(
              title: 'Temperature hysteresis controller (2)',
              subtitle: 'Multi-Value Switch',
              image: "assets/temperature_icon.png",
              imageheight: 34.h,
              imagewidth: 34.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 55.h,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Text(
                'Live chart',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          Divider(height: 1.h, color: const Color(0xFFE1E1E1)),
          Padding(
            padding: EdgeInsets.only(top: 15.h, right: 12.w),
            child: SizedBox(
              height: 150.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFCDE5FF), Color(0xFFFFFFFF)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(14.r),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias, // 👈 important
                      child: Stack(
                        children: [
                          /// ✅ Chart (transparent background হওয়া লাগবে)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _SimpleChartPainter(),
                              child: Container(color: Colors.transparent),
                            ),
                          ),

                          /// ✅ Top Right Tag
                          Positioned(
                            top: 15.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088FF),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Light ON',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          /// ✅ Bottom Time Axis
                          Positioned(
                            bottom: 12.h,
                            left: 10.w,
                            right: 10.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                _TimeAxis('12:00'),
                                _TimeAxis('14:00'),
                                _TimeAxis('16:00'),
                                _TimeAxis('18:00'),
                                _TimeAxis('20:00'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  /// ✅ Right Side Labels
                  Padding(
                    padding: EdgeInsets.only(top: 0.h, bottom: 58.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'On',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        Text(
                          'Off',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ],
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

  Widget _activityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 55.h,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Text(
                'History log',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE1E1E1)),
          _activityRow(
            leading: const Icon(
              Icons.person_rounded,
              size: 17,
              color: Color(0xFF0088FE),
            ),
            time: '18.12.25',
            clock: '18:26',
            name: 'User name 1',
            statusText: 'On',
            //statusColor: const Color(0xFF111827),
          ),
          Padding(
            padding: EdgeInsets.only(left: 58.w),
            child: const Divider(height: 1, color: Color(0xFFE1E1E1)),
          ),
          _activityRow(
            leading: const Icon(
              Icons.person_rounded,
              size: 17,
              color: Color(0xFF0088FE),
            ),
            time: '18.12.25',
            clock: '17:55',
            name: 'User name 2',
            statusText: 'Off',
            //statusColor: const Color(0xFF),
          ),
          Padding(
            padding: EdgeInsets.only(left: 58.w),
            child: const Divider(height: 1, color: Color(0xFFE1E1E1)),
          ),
          _activityRow(
            leading: const Text(
              'M',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF),
                fontSize: 16,
              ),
            ),
            time: '18.12.25',
            clock: '16:13',
            name: 'User name 3',
            statusText: '78%',
            // statusColor: const Color(0xFFEC4899),
            statusIsPercent: true,
            avatarBgColor: const Color(0xFFFE019A),
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget _miniAutomationRow({
    required String title,
    required String subtitle,
    required String image,
    Color? iconColor,
    required double imageheight,
    required double imagewidth,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: imageheight,
            width: imagewidth,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Image.asset(
            "assets/images/back_arro.png",
            height: 13.h,
            width: 13.w,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _activityRow({
    required Widget leading,
    required String time,
    required String clock,
    required String name,
    required String statusText,
    //required Color statusColor,
    bool statusIsPercent = false,
    Color? avatarBgColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            height: 33.h,
            width: 33.w,
            child: CircleAvatar(
              radius: 33.r,
              backgroundColor: avatarBgColor ?? const Color(0xFFF3F4F6),
              child: leading,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: time,
                        style: TextStyle(color: const Color(0xFF6B7280)),
                      ),
                      const TextSpan(text: '   '),
                      TextSpan(
                        text: clock,
                        style: TextStyle(color: const Color(0xFF6B7280)),
                      ),
                      const TextSpan(text: '   '),
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          //SizedBox(width: 10.w),
          Text(
            statusText,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

Widget deviceOverviewCard() {
  const overviewTitle = Color(0xFF111827);
  const overviewValueGreen = Color(0xFF5AB56B);
  const overviewLabel = Color(0xFF6B7280);

  return Container(
    //height: 203.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 55.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              top: 14.h,
              bottom: 14.h,
              right: 14.w,
            ),
            child: Text(
              'Device overview',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: overviewTitle,
              ),
            ),
          ),
        ),
        Divider(color: const Color(0xFFE1E1E1), height: 1, thickness: 1),
        Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 14.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _deviceOverviewGridCell(
                    'Savings',
                    '₪ 268.7',
                    valueColor: overviewValueGreen,
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                    shekelSymbolUsesTitleColor: true,
                  ),
                  _deviceOverviewGridCell(
                    'Peak',
                    '1.3 kWh',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Usage',
                    '13.8%',
                    valueColor: overviewValueGreen,
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _deviceOverviewGridCell(
                    'Energy',
                    '0.52 kWh',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Avr cost',
                    '₪ 139.8',
                    valueColor: overviewValueGreen,
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                    shekelSymbolUsesTitleColor: true,
                  ),
                  _deviceOverviewGridCell(
                    'Runtime',
                    '5h 58m',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _deviceOverviewGridCell(
                    'Last action',
                    '26% 12:45',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Status',
                    '78%',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Next action',
                    'Off 13:26',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _deviceOverviewGridCell(
  String label,
  String value, {
  Color? valueColor,
  required Color labelColor,
  required Color titleColor,
  bool shekelSymbolUsesTitleColor = false,
}) {
  final Color resolvedValueColor = valueColor ?? titleColor;
  final TextStyle valueStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  final String trimmedValue = value.trimLeft();
  final bool splitShekel =
      shekelSymbolUsesTitleColor &&
      trimmedValue.startsWith('₪') &&
      trimmedValue.length > 1;

  late final Widget valueChild;
  if (splitShekel) {
    final String afterShekel = trimmedValue.substring(1).trimLeft();
    valueChild = Text.rich(
      TextSpan(
        style: valueStyle,
        children: [
          TextSpan(
            text: '₪',
            style: valueStyle.copyWith(color: titleColor),
          ),
          if (afterShekel.isNotEmpty)
            TextSpan(
              text: ' $afterShekel',
              style: valueStyle.copyWith(color: resolvedValueColor),
            ),
        ],
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  } else {
    valueChild = Text(
      value,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: valueStyle.copyWith(color: resolvedValueColor),
    );
  }

  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            height: 1,
            color: labelColor,
          ),
        ),
        SizedBox(height: 4.h),
        valueChild,
      ],
    ),
  );
}

class _SceneValueOption extends StatelessWidget {
  const _SceneValueOption({
    required this.label,
    required this.selected,
    required this.child,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 84.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE1E1E1) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFD1D5DB)
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: selected
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: child,
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Light pink → magenta active track; white inactive (matches RGBW intensity spec).
class _RgbwIntensityGradientTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const _RgbwIntensityGradientTrackShape();

  static const List<Color> _gradientColors = <Color>[
    Color(0xFFFFD6EC),
    Color(0xFFE91EAC),
  ];

  @override
  bool get isRounded => true;

  static Paint _gradientPaint(Rect bounds, {required bool ltrActive}) {
    return Paint()
      ..shader = LinearGradient(
        begin: ltrActive ? Alignment.centerLeft : Alignment.centerRight,
        end: ltrActive ? Alignment.centerRight : Alignment.centerLeft,
        colors: _gradientColors,
      ).createShader(bounds);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final double trackHeight = sliderTheme.trackHeight!;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    const double additionalActiveTrackHeight = 0;
    final Radius activeTrackRadius = Radius.circular(
      (trackRect.height + additionalActiveTrackHeight) / 2,
    );
    final bool isLTR = textDirection == TextDirection.ltr;
    final bool isRTL = textDirection == TextDirection.rtl;

    final Paint inactivePaint = Paint()..color = const Color(0xFFFFFFFF);

    // Same segment map as [RoundedRectSliderTrackShape]: leading segment uses
    // "left" paint, trailing uses "right" paint. Active (gradient) follows the
    // slider start edge (LTR = left, RTL = right).
    final bool leadingSegmentGradient = isLTR;
    final bool trailingSegmentGradient = isRTL;

    final bool drawInactiveTrack =
        thumbCenter.dx < (trackRect.right - (trackHeight / 2));
    if (drawInactiveTrack) {
      final RRect trailing = RRect.fromLTRBR(
        thumbCenter.dx - (trackHeight / 2),
        isRTL
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        isRTL
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? trackRadius : activeTrackRadius,
      );
      context.canvas.drawRRect(
        trailing,
        trailingSegmentGradient
            ? _gradientPaint(trailing.outerRect, ltrActive: false)
            : inactivePaint,
      );
    }
    final bool drawActiveTrack =
        thumbCenter.dx > (trackRect.left + (trackHeight / 2));
    if (drawActiveTrack) {
      final RRect leading = RRect.fromLTRBR(
        trackRect.left,
        isLTR
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx + (trackHeight / 2),
        isLTR
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? activeTrackRadius : trackRadius,
      );
      context.canvas.drawRRect(
        leading,
        leadingSegmentGradient
            ? _gradientPaint(leading.outerRect, ltrActive: true)
            : inactivePaint,
      );
    }
  }
}

/// Magenta fill with white outer ring (RGBW intensity thumb).
class _RgbwMagentaThumbShape extends SliderComponentShape {
  _RgbwMagentaThumbShape({
    required this.enabledOuterRadius,
    required this.enabledInnerRadius,
    this.disabledOuterRadius,
    this.disabledInnerRadius,
  });

  final double enabledOuterRadius;
  final double enabledInnerRadius;
  final double? disabledOuterRadius;
  final double? disabledInnerRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    final double r = isEnabled
        ? enabledOuterRadius
        : (disabledOuterRadius ?? enabledOuterRadius);
    return Size.fromRadius(r);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final double outer = Tween<double>(
      begin: disabledOuterRadius ?? enabledOuterRadius,
      end: enabledOuterRadius,
    ).evaluate(enableAnimation);
    final double inner = Tween<double>(
      begin: disabledInnerRadius ?? enabledInnerRadius,
      end: enabledInnerRadius,
    ).evaluate(enableAnimation);
    final Canvas canvas = context.canvas;
    canvas.drawCircle(center, outer, Paint()..color = Colors.white);
    canvas.drawCircle(center, inner, Paint()..color = const Color(0xFFE91EAC));
  }
}

/// Cyan→green gradient arc track + filled sweep for LED dimmer percent.
//Final code; 

// class _LedDimmerRingPainter extends CustomPainter {
//   _LedDimmerRingPainter({
//     required this.percent,
//     required this.strokeWidth,
//   });
//
//   final double percent;
//   final double strokeWidth;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Offset center =
//     Offset(size.width / 2, size.height / 2);
//
//     final double midRadius =
//         size.shortestSide / 2 - strokeWidth / 2 - 2;
//
//     final Rect arcRect =
//     Rect.fromCircle(center: center, radius: midRadius);
//
//     // ----------------------
//     // 🔘 Track (Background)
//     // ----------------------
//     final Paint trackPaint = Paint()
//       ..color = const Color(0xFFE1E1E1)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;
//
//     canvas.drawArc(
//       arcRect,
//       math.pi / 2, // ✅ bottom start
//       2 * math.pi,
//       false,
//       trackPaint,
//     );
//
//     // ----------------------
//     // 🔘 Progress Arc
//     // ----------------------
//     final double clamped = percent.clamp(0.0, 1.0);
//     if (clamped <= 0.001) return;
//
//     final SweepGradient gradient = SweepGradient(
//       colors: const <Color>[
//         Color(0xFF00E52A),
//         Color(0xFF00D1FF),
//         Color(0xFF00E52A),
//       ],
//       stops: const <double>[0.0, 0.50, 1.0],
//       transform: GradientRotation(math.pi / 2), // ✅ match start
//       tileMode: TileMode.clamp,
//     );
//
//     final Paint fgPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round
//       ..shader = gradient.createShader(arcRect);
//
//     canvas.drawArc(
//       arcRect,
//       math.pi / 2, // ✅ bottom start
//       2 * math.pi * clamped,
//       false,
//       fgPaint,
//     );
//
//     // ----------------------
//     // 🔘 Pointer (Dot)
//     // ----------------------
//     final double angle =
//         math.pi / 2 + (2 * math.pi * clamped);
//
//     final Offset pointer = Offset(
//       center.dx + midRadius * math.cos(angle),
//       center.dy + midRadius * math.sin(angle),
//     );
//
//     final Paint dotPaint = Paint()
//       ..color = const Color(0xFF00E52A)
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(pointer, strokeWidth * 0.6, dotPaint);
//   }
//
//   @override
//   bool shouldRepaint(
//       covariant _LedDimmerRingPainter oldDelegate) {
//     return oldDelegate.percent != percent ||
//         oldDelegate.strokeWidth != strokeWidth;
//   }
// }

class _LedDimmerRingPainter extends CustomPainter {
  _LedDimmerRingPainter({
    required this.percent,
    required this.strokeWidth,
  });

  final double percent;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center =
    Offset(size.width / 2, size.height / 2);

    final double midRadius =
        size.shortestSide / 2 - strokeWidth / 2 - 2;

    final Rect arcRect =
    Rect.fromCircle(center: center, radius: midRadius);

    // ----------------------
    // 🔘 Track (Background)
    // ----------------------
    final Paint trackPaint = Paint()
      ..color = const Color(0xFFE1E1E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      math.pi / 2,
      2 * math.pi,
      false,
      trackPaint,
    );

    // ----------------------
    // 🔘 Progress Arc
    // ----------------------
    final double clamped = percent.clamp(0.0, 1.0);
    if (clamped <= 0.001) return;

    final SweepGradient gradient = SweepGradient(
      colors: const <Color>[
        Color(0xFF00E52A),
        Color(0xFF00D1FF),
        Color(0xFF00E52A),
      ],
      stops: const <double>[0.0, 0.50, 1.0],
      transform: GradientRotation(math.pi / 2),
      tileMode: TileMode.clamp,
    );

    final Paint fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt // 🔥 important fix
      ..shader = gradient.createShader(arcRect);

    canvas.drawArc(
      arcRect,
      math.pi / 2,
      2 * math.pi * clamped,
      false,
      fgPaint,
    );

    // ----------------------
    // 🔘 Pointer (Single Dot)
    // ----------------------
    final double angle =
        math.pi / 2 + (2 * math.pi * clamped);

    final Offset pointer = Offset(
      center.dx + midRadius * math.cos(angle),
      center.dy + midRadius * math.sin(angle),
    );

    // Outer white border (optional but matches your image look)
    final Paint outerDot = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pointer, strokeWidth * 1.5, outerDot);

    // Inner green dot
    final Paint innerDot = Paint()
      ..color = const Color(0xFF00E52A)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pointer, strokeWidth * 1, innerDot);
  }

  @override
  bool shouldRepaint(
      covariant _LedDimmerRingPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}


// class _LedDimmerRingPainter extends CustomPainter {
//   _LedDimmerRingPainter({required this.percent, required this.strokeWidth});
//
//   final double percent;
//   final double strokeWidth;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Offset center = Offset(size.width / 2, size.height / 2);
//     final double midRadius = size.shortestSide / 2 - strokeWidth / 2 - 2;
//     final Rect arcRect = Rect.fromCircle(center: center, radius: midRadius);
//
//     final Paint trackPaint = Paint()
//       ..color = const Color(0xFFE1E1E1)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;
//
//     canvas.drawArc(arcRect, -math.pi / 2, 2 * math.pi, false, trackPaint);
//
//     final double clamped = percent.clamp(0.0, 1.0);
//     if (clamped <= 0.001) {
//       return;
//     }
//
//     final SweepGradient gradient = SweepGradient(
//       colors: const <Color>[
//         Color(0xFF00E52A),
//         Color(0xFF00D1FF),
//         Color(0xFF00E52A),
//       ],
//       stops: const <double>[0.0, 0.70, 1.0],
//       transform: GradientRotation(-math.pi / 2),
//       tileMode: TileMode.clamp,
//     );
//
//     final Paint fgPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round
//       ..shader = gradient.createShader(
//         Rect.fromCircle(center: center, radius: midRadius),
//       );
//
//     canvas.drawArc(
//       arcRect,
//       -math.pi / 2,
//       2 * math.pi * clamped,
//       false,
//       fgPaint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant _LedDimmerRingPainter oldDelegate) {
//     return oldDelegate.percent != percent ||
//         oldDelegate.strokeWidth != strokeWidth;
//   }
// }

/// Hue spectrum disk + radial fade toward white (RGBW picker).
class _RgbHueWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.shortestSide / 2;
    final Rect bounds = Rect.fromCircle(center: center, radius: radius);

    final Paint sweep = Paint()
      ..shader = const SweepGradient(
        colors: <Color>[
          Color(0xFFFF0000),
          Color(0xFFFF00FF),
          Color(0xFF0000FF),
          Color(0xFF00FFFF),
          Color(0xFF00FF00),
          Color(0xFFFFFF00),
          Color(0xFFFF0000),
        ],
        stops: <double>[0, 0.1666, 0.3333, 0.5, 0.6666, 0.8333, 1],
      ).createShader(bounds);
    canvas.drawCircle(center, radius, sweep);

    final Paint soften = Paint()
      ..shader = RadialGradient(
        colors: <Color>[Colors.white, Colors.white.withOpacity(0.0)],
        stops: const <double>[0.05, 1],
      ).createShader(bounds)
      ..blendMode = BlendMode.softLight;
    canvas.drawCircle(center, radius * 0.98, soften);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.top, required this.bottom});

  final String top;
  final String bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          top,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          bottom,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _ChipPill extends StatelessWidget {
  const _ChipPill({
    required this.text,
    required this.bg,
    required this.border,
    required this.textColor,
  });

  final String text;
  final Color bg;
  final Color border;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: border, width: 1.2.w),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontFamily: 'Inter',
            // height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE1E1E1) : Colors.transparent,
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: active ? const Color(0xFF111827) : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    // final bg = Paint()..color = const Color(0xFFDBEBFF);
    // canvas.drawRect(Offset.zero & size, bg);

    // Screenshot-style: single thick top line + endpoint dot.
    final blue = const Color(0xFF0088FF);

    final y = size.height * 0.03; // near the top
    final startX = size.width * 0.01;
    final endX = size.width * 0.98;

    final linePaint = Paint()
      ..color = blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(startX, y), Offset(endX, y), linePaint);

    final dotPaint = Paint()
      ..color = blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(endX, y), 4.5.r, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TimeAxis extends StatelessWidget {
  const _TimeAxis(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      ),
    );
  }
}