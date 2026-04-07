import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/devices/screen/devices_screen.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/settings/screen/settings_screen.dart';

import '../../../core/widget/global_back_button.dart';

class LightDinningRoomScreen extends StatefulWidget {
  const LightDinningRoomScreen({super.key});

  static const String routeName = '/light-dinning-room';

  @override
  State<LightDinningRoomScreen> createState() => _LightDinningRoomScreenState();
}

enum _DeviceTab { tools, automation, chart, activity }

class _LightDinningRoomScreenState extends State<LightDinningRoomScreen> {
  bool _isOn = true;
  _DeviceTab _tab = _DeviceTab.tools;
  String _label = 'Lighting';
  String _manualMode = 'A';

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      initialIndex: 2,
      backgroundColor: const Color(0xFFF3F4F6),
      //backgroundColor: Colors.black,
      children: [
        const RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        const RepaintBoundary(child: AnalyticsScreen(showBottomNav: false)),
        RepaintBoundary(child: _buildLightDinningRoomBody(context)),
        const RepaintBoundary(child: NotificationsScreen(showBottomNav: false)),
        const RepaintBoundary(child: SettingsScreen()),
      ],
    );
  }

  Widget _buildLightDinningRoomBody(BuildContext context) {
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
                  SizedBox(height: 18.h),
                  _buildOnOffRow(),
                  SizedBox(height: 21.h),
                  _buildInfoPill(),
                  SizedBox(height: 32.h),
                  _buildTabsRow(),
                  SizedBox(height: 12.h),
                  _buildTabContent(),
                  SizedBox(height: 6.h),
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
              color: Color(0xFFFFFFFFF),
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
              color: Color(0xFFFFFFFFF),
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
    return Column(
      children: [
        SizedBox(height: 4.h),
        Center(
          child: Image.asset(
            "assets/Mask group (5).png",
            height: 88.h,
            width: 88.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Light dinning room',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(width: 10.w),
            Image.asset(
              "assets/Group 63.png",
              height: 13.h,
              width: 13.w,
              fit: BoxFit.cover,
              color: const Color(0xFF111827),
            ),
          ],
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

  Widget _buildOnOffRow() {
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
                  color: _isOn ? Colors.white : const Color(0xFF0088FE),
                  borderRadius: BorderRadius.circular(26.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/off_logo.png",
                        height: 13.h,
                        width: 13.w,
                        fit: BoxFit.cover,
                        color: _isOn
                            ? Color(0xFF111827)
                            : const Color(0xFFFFFFFF),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Off',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _isOn
                              ? Color(0xFF111827)
                              : const Color(0xFFFFFFFF),
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
                  color: _isOn ? const Color(0xFF0088FE) : Colors.white,
                  borderRadius: BorderRadius.circular(26.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new_rounded,
                        size: 18.sp,
                        color: _isOn ? Colors.white : const Color(0xFF111827),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'On',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _isOn ? Colors.white : const Color(0xFF111827),
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
      (_DeviceTab.activity, 'Activity'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
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
                  Text(
                    tab.$2,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                      // active
                      //     ? const Color(0xFF111827)
                      //     : const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 3.h,
                    width: active ? 49.w : 0.w,
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
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: _automationCard(),
        );
      case _DeviceTab.chart:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: _chartCard(),
        );
      case _DeviceTab.activity:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
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
              height: 60.h,
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
              _Chip(
                label: 'Bathroom',
                bg: const Color(0xFFFE019A),
                textColor: Colors.white,
                border: Colors.transparent,
              ),
              SizedBox(width: 10.w),
              _Chip(
                label: _label,
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
          Padding(
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
          const Divider(height: 1, color: Color(0xFFE1E1E1)),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: _miniAutomationRow(
              title: 'Set actions based on value of',
              subtitle: 'Multi-Value Switch',
              image: "assets/set_actions_icon.png",
              imageheight: 40.h,
              imagewidth: 40.w,
            ),
          ),
           Padding(
             padding: EdgeInsets.fromLTRB(70.w, 0.h, 14.w, 0.h),
             child: Divider(height: 1, color: Color(0xFFE1E1E1)),
           ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
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
        borderRadius: BorderRadius.circular(20.r),
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
          Padding(
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
                          colors: [
                            Color(0xFFCDE5FF),
                            Color(0xFFFFFFFF),
                          ],
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
                            child: CustomPaint(painter: _SimpleChartPainter(),
                              child: Container(color: Colors.transparent),),
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
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Text(
              'Activity log',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.bg,
    required this.textColor,
    required this.border,
  });

  final String label;
  final Color bg;
  final Color textColor;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10.w, left: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
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