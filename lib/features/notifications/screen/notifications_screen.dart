import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import '../../nav_bar/screen/custom_bottom_nav_bar.dart';

/// Design: light grey screen, circular back, "Notifications" title, filter chips,
/// grouped lists (Errors, Security, Alerts, System) with Clear + cards.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static const String routeName = '/notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedNavIndex = 3; // Notifications is index 3

  static const Color _screenBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF111827);
  static const Color _chipActiveBg = Color(0xFFF3F4F6);
  static const Color _chipInactiveBorder = Color(0xFFE1E1E1);
  static const Color _chipInactiveText = Color(0xFF757575);
  static const Color _clearText = Color(0xFF9E9E9E);

  final List<String> _filters = const [
    'All',
    'Errors',
    'Security',
    'Alerts',
    'System',
  ];

  String _selectedFilter = 'All';

  late List<_NotifItem> _errorsItems;
  late List<_NotifItem> _securityItems;
  late List<_NotifItem> _alertsItems;
  late List<_NotifItem> _systemItems;

  @override
  void initState() {
    super.initState();
    _errorsItems = List<_NotifItem>.from(_kErrorsSeed);
    _securityItems = List<_NotifItem>.from(_kSecuritySeed);
    _alertsItems = List<_NotifItem>.from(_kAlertsSeed);
    _systemItems = List<_NotifItem>.from(_kSystemSeed);
  }
  void _clearSection(_NotifSection section) {
    setState(() {
      switch (section) {
        case _NotifSection.errors:
          _errorsItems = [];
        case _NotifSection.security:
          _securityItems = [];
        case _NotifSection.alerts:
          _alertsItems = [];
        case _NotifSection.system:
          _systemItems = [];
      }
    });
  }

  bool _showSection(String title) {
    if (_selectedFilter == 'All') return true;
    return _selectedFilter == title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 10.h),
              child: SizedBox(
                height: 40.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GlobalCircleIconBtn(
                        color: const Color(0xFFF3F4F6),
                        child: Image.asset(
                          'assets/aro.png',
                          width: 16.w,
                          height: 16.h,
                        ),
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            context.go('/home');
                          }
                        },
                      ),
                    ),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 32.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final label = _filters[index];
                  final selected = _selectedFilter == label;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(horizontal: 14.w, ),
                      decoration: BoxDecoration(
                        color: selected ? _chipActiveBg : Colors.white,
                        borderRadius: BorderRadius.circular(26.r),
                        border: Border.all(
                          color: selected ? _chipActiveBg.withOpacity(0.72) : _chipInactiveBorder.withOpacity(0.72),
                          width: 1.w,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                children: [
                  if (_showSection('Errors')) ...[
                    _SectionHeader(
                      title: 'Errors',
                      onClear: () => _clearSection(_NotifSection.errors),
                      clearColor: _clearText,
                    ),
                    SizedBox(height: 12.h),
                    ..._errorsItems.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _NotificationCard(item: e),
                        )),
                    SizedBox(height: 20.h),
                  ],
                  if (_showSection('Security')) ...[
                    _SectionHeader(
                      title: 'Security',
                      onClear: () => _clearSection(_NotifSection.security),
                      clearColor: _clearText,
                    ),
                    SizedBox(height: 12.h),
                    ..._securityItems.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _NotificationCard(item: e),
                        )),
                    SizedBox(height: 20.h),
                  ],
                  if (_showSection('Alerts')) ...[
                    _SectionHeader(
                      title: 'Alerts',
                      onClear: () => _clearSection(_NotifSection.alerts),
                      clearColor: _clearText,
                    ),
                    SizedBox(height: 12.h),
                    ..._alertsItems.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _NotificationCard(item: e),
                        )),
                    SizedBox(height: 20.h),
                  ],
                  if (_showSection('System')) ...[
                    _SectionHeader(
                      title: 'System',
                      onClear: () => _clearSection(_NotifSection.system),
                      clearColor: _clearText,
                    ),
                    SizedBox(height: 12.h),
                    ..._systemItems.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _NotificationCard(item: e),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _NotifSection { errors, security, alerts, system }

class _NotifItem {
  const _NotifItem({
    required this.title,
    required this.time,
    required this.description,
    this.asset,
    this.width,
    this.height

    
  });

  final String title;
  final String time;
  final String description;
  final String? asset;
  final double? width;
  final double? height; 

}

const List<_NotifItem> _kErrorsSeed = [

  //Errors items; 
  _NotifItem(
    title: 'Badroom spot light',
    time: 'Yesterday 13:25',
    description:
        'BUS error please check wiring and reset module.',
    asset: "assets/images/heating_cooling.png",
    height: 39,
    width:39, 
  ),
  _NotifItem(
    title: 'Bathroom heating',
    time: 'Yesterday 13:25',
    description:
        'Something may wrong the heating ON over 4 hours.',
    asset: 'assets/images/bathroom.png',
    height: 39,
    width:39,
  ),
  _NotifItem(
    title: 'Living room lamp',
    time: 'Today',
    description:
        'Communication error with control unit, some wire maybe disconnected.',
    asset: 'assets/Mask group (5).png',
    height: 39,
    width:39,
  ),
  _NotifItem(
    title: 'Blind living room',
    time: 'Today',
    description:
        'Blind in error state please check if some object prevent from blind to roll up.',
    asset: 'assets/images/livingRoom.png',
    height: 49,
    width:39,
  ),
  _NotifItem(
    title: 'Garden entry irrigation',
    time: 'Today',
    description:
        'You forgot to turn off the irrigation please use weekly timer to automate it.',
    asset: 'assets/images/irrigation.png',
    height: 39,
    width:39,
  ),
];

// Security items ; 

const List<_NotifItem> _kSecuritySeed = [
  _NotifItem(
    title: 'LED light',
    time: 'Yesterday 13:25',
    description:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    asset: "assets/images/LED_light.png",
    height: 41,
    width:39,
  ),
  _NotifItem(
    title: 'RGB light',
    time: 'Yesterday 13:25',
    description:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    asset: "assets/images/Rectangle.png",
    height: 39,
    width:39,
  ),
  _NotifItem(
    title: 'Badroom thermostat',
    time: 'Yesterday 13:25',
    description:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    asset: "assets/images/6376d7bf4226592678854fa38ee9afdd47741881.png",
    height: 39,
    width:39,
  ),
];

// Alerts items; 
const List<_NotifItem> _kAlertsSeed = [
  _NotifItem(
    title: 'Living room lamp',
    time: 'Today',
    description:
        'Communication error with control unit, some wire maybe disconnected.',
    asset: 'assets/Mask group (5).png',
    height: 39,
    width:39,
  ),
  _NotifItem(
    title: 'Blind living room',
    time: 'Today',
    description:
        'Blind in error state please check if some object prevent from blind to roll up.',
    asset: 'assets/images/livingRoom.png',
    height: 49,
    width:39,
  ),
  _NotifItem(
    title: 'Garden entry irrigation',
    time: 'Today',
    description:
        'You forgot to OFF the irrigation please use weekly timer to automate it.',
    asset: 'assets/images/irrigation.png',
    height: 39,
    width:39,
  ),

  _NotifItem(
    title: 'LED light',
    time: 'Yesterday 13:25',
    description:
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    asset: "assets/images/LED_light.png",
    height: 39,
    width:39,
  ),
];

// System items;  

const List<_NotifItem> _kSystemSeed = [
  _NotifItem(
    title: 'Living room lamp',
    time: 'Today',
    description:
        'Communication error with control unit, some wire maybe disconnected.',
    asset: 'assets/Mask group (5).png',
    height: 39,
    width:39,
  ),
  _NotifItem(
    title: 'Blind living room',
    time: 'Today',
    description:
        'Blind in error state please check if some object prevent from blind to roll up.',
    asset: 'assets/images/livingRoom.png',
    height: 49,
    width:39,
  ),
  _NotifItem(
    title: 'Garden entry irrigation',
    time: 'Today',
    description:
        'You forgot to OFF the irrigation please use weekly timer to automate it.',
    asset: 'assets/images/irrigation.png',
    height: 39,
    width:39,
    
  ),
  _NotifItem(
    title: 'LED light',
    time: 'Yesterday 13:25',
    description:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    asset: "assets/images/LED_light.png",
    height: 39,
    width:39,
   
  ),
];

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onClear,
    required this.clearColor,
  });

  final String title;
  final VoidCallback onClear;
  final Color clearColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        InkWell(
          onTap: onClear,
          borderRadius: BorderRadius.circular(26.r),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.r),
              color: Color(0xFFF3F4F6).withOpacity(0.74)
              
            ),
            height: 23.h,
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Clear',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color:Color(0xFF111827),
                  ),
                ),
                SizedBox(width: 5.w,),
                Image.asset("assets/images/clearBrsh.png", height: 18.h,width: 18.w,fit: BoxFit.cover,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final _NotifItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(18.w, 14.h, 14.w, 18.h),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(26.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.04),
          //     blurRadius: 12.r,
          //     offset: Offset(0, 4.h),
          //   ),
          // ],
        ),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            _NotificationLeading(
                item: item),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                            height: 1.25,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _NotificationLeading extends StatelessWidget {
  const _NotificationLeading({required this.item});

  final _NotifItem item;

  final  double imagewidth = 39;
  final double imageheight=39;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Image.asset(
        item.asset!,
        width: imagewidth, 
        height: imageheight,
        fit: BoxFit.contain,
      )
          
    );
    
  }
}