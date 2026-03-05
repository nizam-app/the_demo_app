import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widget/global_back_button.dart';

/// Resize only these values; card layout (padding, container sizes) stays the same.
class _InterfacesResize {
  _InterfacesResize._();
  // Card: images
  static const double cardLogo = 36;
  static const double cardStatusBadge = 22;
  static const double cardStatusBadgeIcon = 16;
  static const double cardMoreIcon = 22;
  // Card: text
  static const double cardTitleSp = 24;
  static const double cardSubtitleSp = 18;
  static const double cardDevicePillSp = 18;
  // Screen
  static const double screenTitleSp = 22;
  static const double manageTitleSp = 20;
  // Top bar
  static const double topBarBackIcon = 16;
  // Bottom nav
  static const double bottomNavIcon = 26;
  static const double bottomNavLabelSp = 9;
  static const double bottomNavNotificationSp = 10;
  // FAB
  static const double fabIcon = 24;
}

class InterfacesScreen extends StatefulWidget {
  const InterfacesScreen({super.key});
  static const routeName = "/Interfaces";

  @override
  State<InterfacesScreen> createState() => _InterfacesScreenState();
}

class _InterfacesScreenState extends State<InterfacesScreen> {
  // Colors (matched to screenshot)
  static const Color _bg = Color(0xFFF3F4F6);
  static const Color _card = Colors.white;
  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _pillGrey = Color(0xFFF1F3F6);
  static const Color _blue = Color(0xFF0A84FF);
  static const Color _magenta = Color(0xFFFF00A8);

  int _selectedIndex = 2;// Dashboard selected in screenshot (center)

  final List<_InterfaceItem> _items = const [
    _InterfaceItem(
      title: 'Aican Bus',
      subtitle: 'Port 1  •  Port 2',
      deviceCountText: '46 Devices',
      logoAsset: 'assets/image 66.png',
      status: _InterfaceStatus.ok,
      pillStyle: _PillStyle.grey,
    ),
    _InterfaceItem(
      title: 'ModBus RTU',
      subtitle: 'Port 3',
      deviceCountText: '11 Devices',
      logoAsset: 'assets/image 145.png',
      status: _InterfaceStatus.warn,
      pillStyle: _PillStyle.magenta,
    ),
    _InterfaceItem(
      title: 'ZigBee',
      subtitle: 'Port 4',
      deviceCountText: '12 Devices',
      logoAsset: 'assets/zigport.png',
      status: _InterfaceStatus.ok,
      pillStyle: _PillStyle.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: const _FabPlus(),
      
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        notificationCount: 12,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              SizedBox(height: 23.h),
              Text(
                'Manage interfaces',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: _InterfacesResize.manageTitleSp.sp,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),

              SizedBox(height: 15.h),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 90.h),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (_, index) => _InterfaceCard(
                    item: _items[index],
                    bg: _card,
                    textDark: _textDark,
                    textGrey: _textGrey,
                    pillGrey: _pillGrey,
                    blue: _blue,
                    magenta: _magenta,
                    onMore: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------- Card --------------------

class _InterfaceCard extends StatelessWidget {
  const _InterfaceCard({
    required this.item,
    required this.bg,
    required this.textDark,
    required this.textGrey,
    required this.pillGrey,
    required this.blue,
    required this.magenta,
    required this.onMore,
  });

  final _InterfaceItem item;
  final Color bg;
  final Color textDark;
  final Color textGrey;
  final Color pillGrey;
  final Color blue;
  final Color magenta;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final pillBg = item.pillStyle == _PillStyle.magenta ? magenta : pillGrey;
    final pillTextColor = item.pillStyle == _PillStyle.magenta ? Colors.white : textDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18.r,
            offset: Offset(0, 10.h),
          )
        ],
      ),
      child: Row(
        children: [
          // Left logo container
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: AppAssetIcon(
                item.logoAsset,
                size: _InterfacesResize.cardLogo,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: _InterfacesResize.cardTitleSp.sp,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    _StatusBadge(status: item.status),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  item.subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: _InterfacesResize.cardSubtitleSp.sp,
                    fontWeight: FontWeight.w500,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Devices pill
          Container(
            height: 34.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              item.deviceCountText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: _InterfacesResize.cardDevicePillSp.sp,
                fontWeight: FontWeight.w700,
                color: pillTextColor,
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // More (...)
          InkWell(
            onTap: onMore,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Icon(
                Icons.more_horiz_rounded,
                size: _InterfacesResize.cardMoreIcon.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final _InterfaceStatus status;

  static const Color _blue = Color(0xFF0A84FF);
  static const Color _magenta = Color(0xFFFF00A8);

  @override
  Widget build(BuildContext context) {
    if (status == _InterfaceStatus.ok) {
      return Container(
        width: _InterfacesResize.cardStatusBadge.w,
        height: _InterfacesResize.cardStatusBadge.w,
        decoration: const BoxDecoration(
          color: _blue,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            size: _InterfacesResize.cardStatusBadgeIcon.sp,
            color: Colors.white,
          ),
        ),
      );
    }

    // warning triangle
    return Icon(
      Icons.warning_rounded,
      size: _InterfacesResize.cardStatusBadge.sp,
      color: _magenta,
    );
  }
}

/// -------------------- Bottom Nav --------------------

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.notificationCount,
  });

  final int selectedIndex;
  final void Function(int) onTap;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    const selected = Color(0xFF111827);
    const unselected = Color(0xFF111827);

    final items = <_NavItem>[
      const _NavItem(label: "Devices", icon: "assets/Group 28.png"),
      const _NavItem(label: "Analytics", icon: "assets/bar 5.png"),
      const _NavItem(label: "Dashboard", icon: "assets/Mask group copy 6.png"),
      //const _NavItem(label: "Voice", icon: "assets/image 98.png"),
      const _NavItem(label: "Notifications", icon: "assets/Group 43.png"),
      const _NavItem(label: "Automations", icon: "assets/Mask group (8).png"),
    ];

    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.74),
        border: const Border(
          top: BorderSide(color: Color(0xFFE1E1E1), width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / items.length;
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: w * selectedIndex + (w - 46.w) / 2,
                child: Container(
                  width: 46.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: selected,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2.r),
                      bottomRight: Radius.circular(2.r),
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(items.length, (i) {
                  final isSel = i == selectedIndex;
                  final color = isSel ? selected : unselected;
                  final item = items[i];

                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset(
                                item.icon,
                                width: _InterfacesResize.bottomNavIcon.sp,
                                height: _InterfacesResize.bottomNavIcon.sp,
                                color: color,
                              ),
                              if (item.label == "Notifications" &&
                                  notificationCount > 0)
                                Positioned(
                                  right: -10.w,
                                  top: -6.h,
                                  child: Container(
                                    width: 19.w,
                                    height: 15.h,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFE019A),
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: Text(
                                      notificationCount.toString(),
                                      style: TextStyle(
                                        fontSize: _InterfacesResize.bottomNavNotificationSp.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: _InterfacesResize.bottomNavLabelSp.sp,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  const _NavItem({required this.label, required this.icon});
}



class _FabPlus extends StatelessWidget {
  const _FabPlus();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26.r),
        onTap: () {}, 

        child: Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x10111827),
                blurRadius: 26.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.add,
              size: _InterfacesResize.fabIcon.sp,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }
}

/// -------------------- Reusable UI Bits --------------------

class _TopBar extends StatelessWidget {
  const _TopBar();

  static const _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlobalCircleIconBtn(
          child: Image.asset(
            'assets/aro.png',
            width: _InterfacesResize.topBarBackIcon.w,
            height: _InterfacesResize.topBarBackIcon.h,
          ),
          onTap: (){
            Navigator.maybePop(context);
          },
          color: const Color(0xFFFFFFFF),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Interfaces',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: _InterfacesResize.screenTitleSp.sp,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
        ),
        SizedBox(width: 44.w), // keeps title visually centered
      ],
    );
  }
}




class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon(
      this.path, {
        super.key,
        required this.size,
        this.color,
      });

  final String path;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size.w,
      height: size.w,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );
  }
}

/// -------------------- Models --------------------

enum _InterfaceStatus { ok, warn }
enum _PillStyle { grey, magenta }

class _InterfaceItem {
  const _InterfaceItem({
    required this.title,
    required this.subtitle,
    required this.deviceCountText,
    required this.logoAsset,
    required this.status,
    required this.pillStyle,
  });

  final String title;
  final String subtitle;
  final String deviceCountText;
  final String logoAsset;
  final _InterfaceStatus status;
  final _PillStyle pillStyle;
}