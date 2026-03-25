import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';

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

  final List<String> _navRoutes = const [
    '/devices',
    '/analytics',
    '/Dashboard',
    '/notifications',
    '/Settings',
  ];

  void _onNavItemTapped(int index) {
    if (index >= 0 && index < _navRoutes.length) {
      context.go(_navRoutes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
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
                   // SizedBox(height: 18.h),
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
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: 2,
        onItemTapped: _onNavItemTapped,
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
              color: Colors. white,
              child: Image.asset(
                'assets/aro.png',
                width: 16.w,
                height: 16.h,
              ),
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
              onTap: () {},
              icon: Icons.more_horiz_rounded,
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
          child: Image.asset("assets/Mask group (5).png", height: 88.h, width: 88.w, fit: BoxFit.cover,)
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
            Image.asset("assets/images/edit_image.png", height: 13, width: 13.w, fit: BoxFit.cover, color: const Color(0xFF111827) )
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
              _StatBlock(
                top: '5h 58m',
                bottom: '7 Days',
              ),
              _StatBlock(
                top: '12:57',
                bottom: 'Operations',
              ),
              _StatBlock(
                top: '36%',
                bottom: 'Average',
              ),
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
                      Image.asset("assets/off_logo.png", height: 13.h, width: 13.w, fit: BoxFit.cover,
                          color: _isOn
                          ? Color(0xFF111827)
                          : const Color(0xFFFFFFFF),),
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
                              color: _isOn
                                  ? Colors.white
                                  : const Color(0xFF111827),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'On',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                                color: _isOn
                                    ? Colors.white
                                    : const Color(0xFF111827),
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
        padding: EdgeInsets.only(right: 10.w, left: 10.w ),
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
            Image.asset("assets/message_icon.png", height: 15.h, width: 15.w,fit: BoxFit.cover,),
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
      padding: EdgeInsets.symmetric(horizontal: 22.w),
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color:  Color(0xFF111827) ,
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
      padding: EdgeInsets.only(right: 22.w, left: 22.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10.r,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
              padding:  EdgeInsets.only(right: 14.w, left: 48.w),
              child: const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
            ),
            _manageRowAlerts(),
            Padding(
              padding:  EdgeInsets.only(right: 14.w, left: 48.w),
              child: const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
            ),
            _manageRowSafeValue(),
            Padding(
              padding:  EdgeInsets.only(right: 14.w, left: 48.w),
              child: const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
            ),
            _manageRowManualOverride(),
            //SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }

  Widget _manageRowLabels() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Image.asset("assets/labels_icon.png", height: 23.h, width: 23.w, fit: BoxFit.cover,), 
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
              Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover,color: Color(0xFF6B7280)), 
            ],
          ),
        ],
      ),
    );
  }

  Widget _manageRowAlerts() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Image.asset("assets/alerts_icon.png", height: 23.h, width: 23.w, fit: BoxFit.cover),  
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
          SizedBox(width: 8.w, ),
             Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover,color: Color(0xFF6B7280),), 
        ],
      ),
    );
  }

  Widget _manageRowSafeValue() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Image.asset("assets/sate_icon.png", height: 21.h, width: 21.w, fit: BoxFit.cover),  
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
          Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover,color: Color(0xFF6B7280),), 
        ],
      ),
    );
  }

  Widget _manageRowManualOverride() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Image.asset("assets/manual_icon.png", height: 23.h, width: 23.w, fit: BoxFit.cover), 
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
          _miniAutomationRow(
            title: 'Set actions based on value of',
            subtitle: 'Multi-Value Switch',
            image: "assets/set_actions_icon.png",
            //iconColor: const Color(0xFF00BFA5),
              imageheight: 40.h,
              imagewidth: 40.w
          ),
          Padding(
            padding:  EdgeInsets.only(left: 60.w, right: 14.w),
            child: const Divider(height: 1, color: Color(0xFFE1E1E1)),
          ),
          _miniAutomationRow(
            title: 'Temperature hysteresis controller (2)',
            subtitle: 'Multi-Value Switch',
            image: "assets/temperature_icon.png",
            //iconColor: const Color(0xFFFF4D4D),
            imageheight: 34.h,
            imagewidth: 34.w
          ),
          //SizedBox(height: 8.h),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Live chart',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B5DFA),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Light On',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              height: 150.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: CustomPaint(
                        painter: _SimpleChartPainter(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 8.w,
                    child: Text(
                      'On',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0B5DFA),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.h,
                    left: 10.w,
                    right: 10.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _TimeAxis('12:00'),
                        _TimeAxis('14:00'),
                        _TimeAxis('16:00'),
                        _TimeAxis('18:00'),
                        _TimeAxis('20:00'),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 62.h,
                    right: 14.w,
                    child: Text(
                      'Off',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _activityCard() {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
            child: Text(
              'Activity log',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _activityRow(
            leading: const Icon(Icons.person_rounded, color: Color(0xFF0B5DFA)),
            time: '18.12.25',
            clock: '18:26',
            name: 'User name 1',
            statusText: 'On',
            statusColor: const Color(0xFF0B5DFA),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _activityRow(
            leading: const Icon(Icons.person_rounded, color: Color(0xFF0B5DFA)),
            time: '18.12.25',
            clock: '17:55',
            name: 'User name 2',
            statusText: 'Off',
            statusColor: const Color(0xFF6B7280),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _activityRow(
            leading: const Text(
              'M',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFFEC4899),
              ),
            ),
            time: '18.12.25',
            clock: '16:13',
            name: 'User name 3',
            statusText: '78%',
            statusColor: const Color(0xFFEC4899),
            statusIsPercent: true,
          ),
          SizedBox(height: 10.h),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image,height:imageheight, width: imagewidth,fit: BoxFit.cover, ),
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
          Image.asset("assets/images/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover,)
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
    required Color statusColor,
    bool statusIsPercent = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          leading,
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$time   $clock   $name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          if (statusIsPercent)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            )
          else
            Text(
              statusText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
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
            fontSize: 14.sp,
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
          color: active
              ? const Color(0xFFE1E1E1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: active
                  ? const Color(0xFF111827)
                  : const Color(0xFF6B7280),
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
    // Background fill + grid feel
    final bg = Paint()..color = const Color(0xFFDBEBFF);
    canvas.drawRect(Offset.zero & size, bg);

    final grid = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * (0.15 + i * 0.2);
      canvas.drawLine(Offset(10, y), Offset(size.width - 10, y), grid);
    }

    // Blue line
    final line = Paint()
      ..color = const Color(0xFF0B5DFA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.48)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.22,
        size.width * 0.45,
        size.height * 0.58,
        size.width * 0.62,
        size.height * 0.32,
      )
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.14,
        size.width * 0.88,
        size.height * 0.40,
        size.width * 0.93,
        size.height * 0.28,
      );
    canvas.drawPath(path, line);
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