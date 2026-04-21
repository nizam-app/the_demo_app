import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';
import 'package:workpleis/features/devices/widget/popup.dart';

import '../widget/assign_category_zone.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key, this.showBottomNav = true});

  static const String routeName = '/devices';
  final bool showBottomNav;

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  int _selectedNavIndex = 0; // Devices is index 0
  String? _selectedDeviceTitle =
      'Blind Living Room'; // Track selected device, initially "Blind Living Room"
  String _selectedFilter = 'All'; // Track selected filter chip

  // Local demo state for list controls (no backend).
  bool _rgbwOn = true;
  int _rgbwLevel = 50;
  bool _rgbwManual = false;
  bool _alarmDisarmed = true;
  double _bathroomTemp = 24.6;
  bool _bathroomManual = true;
  int _blindPctDown = 0;
  int _blindPctUp = 50;
  bool _irrigationPlaying = false;
  int _brightnessPct = 54;
  bool _cardReaderOn = false;

  void _onNavItemTapped(int index) {
    final routes = [
      '/devices',
      '/analytics',
      '/home', // Voice points to home
      '/notifications',
      '/settings',
    ];
    if (index < routes.length) {
      context.go(routes[index]);
    }
  }

  void _showEditDeviceBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const EditDeviceSheetContent(),
      ),
    );
  }

  void _showAssignCategoryPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AssignCategoryZoneSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Colors.white;
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final headerRowHeight = 36.w;
    final headerExtent = topInset + 8.h + headerRowHeight + 8.h;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    // Shell uses CustomBottomNavBar with extendBody — content draws under the 72px
    // track; keep the same bottom inset when this screen shows BottomNavBarWidget.
    final scrollBottomPad = 18.h + 72.h + bottomInset;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: bg,
        // Match HomeScreen: bottom false so scroll content can sit under the shell
        // (or standalone) translucent bar; BackdropFilter then blurs real pixels.
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: headerExtent,
                  bottom: scrollBottomPad,
                ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------- Header (top bar) ----------
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 10.h),
                    //   child: SizedBox(
                    //     height: 36.w,
                    //     child: Stack(
                    //       alignment: Alignment.center,
                    //       children: [
                    //         Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: GlobalCircleIconBtn(
                    //             color: Color(0xFFF3F4F6),
                    //             child: Image.asset(
                    //               'assets/aro.png',
                    //               width: 16.w,
                    //               height: 16.h,
                    //             ),
                    //             onTap: () {
                    //               if (!widget.showBottomNav) {
                    //                 final shell = CustomBottomNavBar.of(context);
                    //                 if (shell != null) {
                    //                   shell.setSelectedIndex(2);
                    //                   return;
                    //                 }
                    //               }
                    //               if (context.canPop()) {
                    //                 context.pop();
                    //               } else {
                    //                 context.go('/home');
                    //               }
                    //             },
                    //           ),
                    //         ),
                    //         Center(
                    //           child: Text(
                    //             'Devices',
                    //             style: TextStyle(
                    //               fontSize: 22.sp,
                    //               fontWeight: FontWeight.w600,
                    //               color: const Color(0xFF111827),
                    //               fontFamily: 'Inter',
                    //             ),
                    //           ),
                    //         ),
                    //         Align(
                    //           alignment: Alignment.centerRight,
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               _CircleIconButton(
                    //                 icon: Icons.more_horiz_rounded,
                    //                 onTap: () => _showEditDeviceBottomSheet(context),
                    //                 size: 32,
                    //                 bg: const Color(0xFFF3F4F6),
                    //                 iconColor: const Color(0xFF111827),
                    //                 iconSize: 22,
                    //               ),
                    //               SizedBox(width: 10.w),
                    //               _CircleIconButton(
                    //                 icon: Icons.add_rounded,
                    //                 onTap: () => _showAssignCategoryPopup(context),
                    //                 size: 32,
                    //                 bg: const Color(0xFF111827),
                    //                 //bg: const Color(0xFF0088FE),
                    //                 iconColor: Colors.white,
                    //                 iconSize: 23,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // -------- Search ----------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      child: _SearchBar(),
                    ),

                    SizedBox(height: 10.h),

                    // -------- Filter chips ----------
                    SizedBox(
                      height: 40.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        children: [
                          _FilterChipPill(
                            label: 'All',
                            selected: _selectedFilter == 'All',
                            onTap: () => setState(() => _selectedFilter = 'All'),
                          ),
                          SizedBox(width: 10),
                          _FilterChipPill(
                            label: 'Favorites',
                            selected: _selectedFilter == 'Favorites',
                            onTap: () =>
                                setState(() => _selectedFilter = 'Favorites'),
                          ),
                          SizedBox(width: 10),
                          _FilterChipPill(
                            label: 'Smart',
                            selected: _selectedFilter == 'Smart',
                            onTap: () => setState(() => _selectedFilter = 'Smart'),
                          ),
                          SizedBox(width: 10),
                          _FilterChipPill(
                            label: 'Groups',
                            selected: _selectedFilter == 'Groups',
                            onTap: () => setState(() => _selectedFilter = 'Groups'),
                          ),
                          SizedBox(width: 10),
                          _FilterChipPill(
                            label: 'Category',
                            selected: _selectedFilter == 'Category',
                            onTap: () => setState(() => _selectedFilter = 'Category'),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // -------- Section Title ----------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text(
                        'Devices',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // -------- List (rows) ----------
                    _DeviceListCard(
                      children: [
                        // RGBW
                        _DeviceRow(
                          outerPadding: EdgeInsets.only(top: 7.h, right: 10.w),
                          topRight: const _TimeTag(text: '18:32', blueIcon: true),
                          leading: const _GradientCircleIcon(size: 34),
                          title: 'RGBW',
                          selected: _selectedDeviceTitle == 'RGBW',
                          onTap: () => setState(() => _selectedDeviceTitle = 'RGBW'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _ModeDot(
                                    manual: _rgbwManual,
                                    onTap: () => setState(
                                      () => _rgbwManual = !_rgbwManual,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  _SmallText(_rgbwOn ? 'On' : 'Off'),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              const _TinyGreyText('LCD0C12'),
                              SizedBox(height: 4.h),
                              _TinyGreyText('Level $_rgbwLevel%'),
                              SizedBox(height: 6.h),
                              // Wrap(
                              //   spacing: 6.w,
                              //   runSpacing: 6.h,
                              //   children: const [
                              //     _TagChip(
                              //       text: 'Lighting',
                              //       bg: Color(0xFF0088fe),
                              //       outlined: true,
                              //     ),
                              //     _TagChip(
                              //       text: 'Bathroom',
                              //       bg: Color(0xFFFE019A),
                              //       outlined: false,
                              //     ),
                              //   ],
                              // ),

                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(color: Color(0xFF0088FE)),
                                    ),
                                    child: _TagChip(
                                      label: 'Lighting',
                                      bg: Color(0xFFFFFFFF),
                                      fg: Color(0xFF111827),
                                      onTap: () => _showAssignCategoryPopup(context),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  _TagChip(
                                    label: 'Bathroom',
                                    bg: Color(0xFFFF2D92),
                                    fg: Colors.white,
                                    onTap: () => _showAssignCategoryPopup(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CircleMiniBtn(
                                icon: Icons.remove,
                                onTap: () => setState(() {
                                  _rgbwLevel = (_rgbwLevel - 5).clamp(0, 100);
                                }),
                              ),
                              SizedBox(width: 14.w),
                              _CircleMiniBtn(
                                icon: Icons.add,
                                onTap: () => setState(() {
                                  _rgbwLevel = (_rgbwLevel + 5).clamp(0, 100);
                                }),
                              ),
                              SizedBox(width: 8.w),
                              _ToggleColorswitch(
                                value: _rgbwOn,
                                onChanged: (v) => setState(() => _rgbwOn = v),
                              ),
                              SizedBox(width: 8.w),
                            ],
                          ),
                        ),

                        const _RowDivider(),

                        // Alarm
                        _DeviceRow(
                          outerPadding: EdgeInsets.only(top: 7.h, right: 0.w),
                          topRight: const _PinOnly(),
                          leading: const _LockIcon(),
                          title: 'Alarm',
                          selected: _selectedDeviceTitle == 'Alarm',
                          onTap: () => setState(() => _selectedDeviceTitle = 'Alarm'),
                          subtitle: _SmallText(
                            _alarmDisarmed ? 'Disarmed' : 'Armed',
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: _CircleActionBlue(
                              imagePath: _alarmDisarmed ?'assets/Mask group (15).png':'assets/images/Group 48 (1).png',
                              // Must track armed state, not inverted: when disarmed, `active`
                              // must be false so the asset is tint-only (avoids wrong full-color glyph).
                              active: _alarmDisarmed,
                              onTap: () => setState(
                                () => _alarmDisarmed = !_alarmDisarmed,
                              ),
                            ),
                          ),
                        ),

                        const _RowDivider(),

                        // Bathroom
                        _DeviceRow(
                          outerPadding: EdgeInsets.only(
                            top: 7.h,
                            right: 20.w,
                            bottom: 7.h,
                          ),
                          leading: const _PowerRingIcon(),
                          title: 'Bathroom',
                          selected: _selectedDeviceTitle == 'Bathroom',
                          onTap: () =>
                              setState(() => _selectedDeviceTitle = 'Bathroom'),
                          subtitle: Row(
                            children: [
                              _ModeDot(
                                manual: _bathroomManual,
                                onTap: () => setState(
                                  () => _bathroomManual = !_bathroomManual,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                'assets/low-temperature 1.png',
                                width: 9.w,
                                height: 19.h,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_bathroomTemp.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                  fontSize: 14, // screenshot vibe
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CircleMiniBtn(
                                icon: Icons.remove,
                                onTap: () => setState(() {
                                  _bathroomTemp = (_bathroomTemp - 0.5)
                                      .clamp(10.0, 35.0);
                                }),
                              ),
                              SizedBox(width: 14.w),
                              _CircleMiniBtn(
                                icon: Icons.add,
                                onTap: () => setState(() {
                                  _bathroomTemp = (_bathroomTemp + 0.5)
                                      .clamp(10.0, 35.0);
                                }),
                              ),
                            ],
                          ),
                        ),

                        const _RowDivider(),

                        // Blind Living Room (selected highlight row)
                        _DeviceRow(
                          outerPadding: EdgeInsets.only(
                            top: 7.h,
                            right: 8.w,
                            bottom: 7.h,
                          ),
                          selected: _selectedDeviceTitle == 'Blind Living Room',
                          topRight: const _StarTimeTag(time: '20:36'),
                          leading: const _BlindGreenIcon(),
                          title: 'Blind Living Room',
                          onTap: () => setState(
                            () => _selectedDeviceTitle = 'Blind Living Room',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              _BlindStatsRow(
                                closedPct: _blindPctDown,
                                openPct: _blindPctUp,
                              ),
                              const _TinyGreyText('D012U12'),
                            ],
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(right: 4.w, top: 15.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _CircleMiniBtn(
                                  icon: Icons.keyboard_arrow_down,
                                  onTap: () => setState(() {
                                    
                                    _blindPctDown = (_blindPctDown - 5).clamp(0, 100);
                                  }),
                                ),
                                SizedBox(width: 14.w),
                                _CircleMiniBtn(
                                  icon: Icons.keyboard_arrow_up,
                                  onTap: () => setState(() {
                                    _blindPctDown = (_blindPctDown + 5).clamp(0, 100);
                                  }),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          ),
                        ),

                        const _RowDivider(),

                        // Block Irrigation Schedule (blue play row)
                        _DeviceRow(
                          outerPadding: EdgeInsets.only(
                            top: 7.h,
                            right: 20.w,
                            bottom: 5.h,
                          ),
                          leading: const _PlayCircleIcon(),
                          title: 'Block Irrigation Schedule',
                          selected:
                              _selectedDeviceTitle == 'Block Irrigation Schedule',
                          onTap: () => setState(
                            () => _selectedDeviceTitle = 'Block Irrigation Schedule',
                          ),
                          subtitle: _SmallText(
                            _irrigationPlaying ? 'Blocked' : 'Running',
                          ),
                          trailing: _CircleActionBlue(
                            imagePath: 'assets/play.png',
                            isPlay: true,
                            active: _irrigationPlaying,
                            onTap: () => setState(
                              () => _irrigationPlaying = !_irrigationPlaying,
                            ),
                          ),
                        ),

                        const _RowDivider(),

                        // Brightness (with pill slider)
                        _DeviceRow(
                          outerPadding: EdgeInsets.only(
                            top: 2.h,
                            right: 8.w,
                            bottom: 5.h,
                          ),
                          brightness: true,
                          topRight: const _StarOnly(),
                          leading: const _SunIcon(),
                          title: 'Brightness',
                          selected: _selectedDeviceTitle == 'Brightness',
                          onTap: () =>
                              setState(() => _selectedDeviceTitle = 'Brightness'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _BoldSmall('$_brightnessPct%'),
                              const SizedBox(height: 2),
                              const _TinyGreyText('W5BT'),
                            ],
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(top: 15.h, right: 15.w),
                            child: _BrightnessPill(
                              value: _brightnessPct / 100.0,
                              onChanged: (v) => setState(
                                () => _brightnessPct =
                                    (v * 100).round().clamp(0, 100),
                              ),
                            ),
                          ),
                        ),
                        const _RowDivider(),

                        // Card Reader(s)
                        _DeviceRow(
                          outerPadding: EdgeInsets.only(
                            top: 10.h,
                            right: 22.w,
                            bottom: 5.h,
                          ),
                          leading: const _BulbIcon(),
                          title: 'Card Reader(s)',
                          selected: _selectedDeviceTitle == 'Card Reader(s)',
                          onTap: () =>
                              setState(() => _selectedDeviceTitle = 'Card Reader(s)'),
                          subtitle: _SmallText(
                            _cardReaderOn ? 'Active' : 'Blocked',
                          ),
                          trailing: _ToggleSwitch(
                            value: _cardReaderOn,
                            onChanged: (v) =>
                                setState(() => _cardReaderOn = v),
                          ),
                        ),
                      ],
                    ),

                    const _RowDivider(),

                    SizedBox(height: 20.h),

                    // -------- Control units ----------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text(
                        'Control units',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    _DeviceListCard(
                      children: [
                        const _ControlUnitRow(
                          imagePath: 'assets/image 124.png',
                          title: 'CORE20',
                          sub2: 'CORE20-4B37-3419-363A',
                        ),
                        _RowDivider(
                          leftMargin: 56.w,
                        ), // 12 (padding) + 34 (icon) + 10 (spacing)
                        const _ControlUnitRow(
                          imagePath: 'assets/image 124.png',
                          title: 'D012',
                          sub: '11 Devices',
                          sub2: 'CORE20-4B37-3419-363A',
                        ),
                      ],
                    ),
                  ],
                ),
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
                      color: Colors.white.withOpacity(0.20),
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFFE5E7EB).withOpacity(0.18),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 14.w,
                        right: 14.w,
                        top: topInset + 8.h,
                        bottom: 12.h,
                      ),
                      child: SizedBox(
                        height: headerRowHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalCircleIconBtn(
                                color: Color(0xFFF3F4F6),
                                child: Image.asset(
                                  'assets/aro.png',
                                  width: 16.w,
                                  height: 16.h,
                                ),
                                onTap: () {
                                  if (!widget.showBottomNav) {
                                    final shell = CustomBottomNavBar.of(context);
                                    if (shell != null) {
                                      shell.setSelectedIndex(2);
                                      return;
                                    }
                                  }
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/home');
                                  }
                                },
                              ),
                            ),
                            Center(
                              child: Text(
                                'Devices',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF111827),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height:36.h,
                                    width: 36.w,
                                    child: _CircleIconButton(
                                      icon: Icons.more_horiz_rounded,
                                      onTap: () => _showEditDeviceBottomSheet(context),
                                      size: 22,
                                      bg: const Color(0xFFF3F4F6),
                                      iconColor: const Color(0xFF111827),
                                      iconSize: 22,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    height: 36.h,
                                    width: 36.w,
                                    child: _CircleIconButton(
                                      icon: Icons.add_rounded,
                                      onTap: () => _showAssignCategoryPopup(context),
                                      size: 23,
                                      bg: const Color(0xFF111827),
                                      iconColor: Colors.white,
                                      iconSize: 23,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.showBottomNav)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomNavBarWidget(
                  selectedIndex: _selectedNavIndex,
                  onItemTapped: _onNavItemTapped,
                  backgroundOpacity: 0,
                  useBackdropBlur: true,
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}

/* --------------------------- UI Pieces --------------------------- */

class _DeviceListCard extends StatelessWidget {
  const _DeviceListCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ Screenshot-এর মতো full width look
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(children: children),
    );
  }
}

/* --------------------------- Edit device bottom sheet --------------------------- */

class _DeviceRow extends StatelessWidget {
  _DeviceRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.topRight,
    this.selected = false,
    this.onTap,
    this.brightness = false,
    this.outerPadding,
  });

  final Widget leading;
  final String title;
  final Widget subtitle;
  final Widget trailing;
  final Widget? topRight;
  final bool selected;
  final VoidCallback? onTap;
  final bool brightness;
  final EdgeInsets? outerPadding;

  @override
  Widget build(BuildContext context) {
    final basePadding = EdgeInsets.fromLTRB(16.w, 0.h, 0.w, 5.h);
    final finalPadding = outerPadding != null
        ? EdgeInsets.fromLTRB(
            basePadding.left + outerPadding!.left,
            basePadding.top + outerPadding!.top,
            basePadding.right + outerPadding!.right,
            basePadding.bottom + outerPadding!.bottom,
          )
        : basePadding;

    return Container(
      color: selected ? const Color(0xFFEAF1FF) : Colors.white,
      padding: finalPadding,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 46.w,
                        height: 46.h,
                        child: Center(child: leading),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: brightness ? 11.h : 0.h),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF111827),
                                  height: 1.05,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            subtitle,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              trailing,
            ],
          ),
          if (topRight != null)
            Positioned(right: 0, top: 0, child: topRight!),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider({this.leftMargin});

  final double? leftMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.only(
        left: leftMargin ?? 74.w,
      ), // Default: 16 + 46 + 12 for device rows
      color: const Color(0xFFE5E7EB),
    );
  }
}

/* ---------------- Search + Chips ---------------- */

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);
  static const _muted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _searchFocusNode,
      builder: (context, _) {
        final hasFocus = _searchFocusNode.hasFocus;
        return Container(
          padding: EdgeInsets.all(hasFocus ? 1.5.w : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: hasFocus
                ? const LinearGradient(
                    colors: [Color(0xFF0088FE), Color(0xFF8B5CF6)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 46.h,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(hasFocus ? 22.r : 24.r),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                  filled: false,
                  prefixIcon: Image.asset(
                    'assets/images/Mask group copy.png',
                    width: 22.w,
                    height: 22.w,
                    fit: BoxFit.contain,
                    color: Color(0xFF6B7280),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 40.w,
                    minHeight: 24.h,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 0,
                  ),
                  isDense: true,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  color: _primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilterChipPill extends StatelessWidget {
  const _FilterChipPill({
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: selected
          ? Container(
              height: 32.h,
              padding: EdgeInsets.all(1.5), // border thickness
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF111827), // blue
                    Color(0xFF111827), // pink
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal:label == "All" ? 20.w : 13.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white, // inside color
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            )
          : Container(
              height: 32.h,
              padding: EdgeInsets.symmetric(horizontal: label == "All" ? 20.w : 13.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(999),
                // border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF111827),
                  fontFamily: 'Inter',
                ),
              ),
            ),
    );
  }
}

/* ---------------- Buttons / Toggles ---------------- */

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    this.icon,
    this.imagePath,
    required this.onTap,
    this.size = 44,
    this.bg = const Color(0xFFF3F4F6),
    this.iconColor = const Color(0xFF111827),
    this.iconSize = 22,
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

  final IconData? icon;
  final String? imagePath;
  final VoidCallback onTap;
  final double size;
  final Color bg;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        splashColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFD1D5DB),
        child: Ink(
          width: size.w,
          height: size.h,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Center(
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    width: iconSize.w,
                    height: iconSize.h,
                    fit: BoxFit.contain,
                  )
                : Icon(icon!, size: iconSize.sp, color: iconColor),
          ),
        ),
      ),
    );
  }
}

// class _CircleMiniBtn extends StatelessWidget {
//   const _CircleMiniBtn({required this.icon, this.onTap});
//   final IconData icon;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final isArrow =
//         icon == Icons.keyboard_arrow_up || icon == Icons.keyboard_arrow_down;
//
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         customBorder: const CircleBorder(),
//         onTap: onTap,
//         splashColor: const Color(0xFFE5E7EB),
//         highlightColor: const Color(0xFFD1D5DB),
//         child: Ink(
//           width: 36.w,
//           height: 36.h,
//           decoration: const BoxDecoration(
//             color: Color(0xFFE1E1E1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             size: (isArrow ? 36 : 22).sp,
//             color: const Color(0xFF6B7280),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _CircleMiniBtn extends StatelessWidget {
  const _CircleMiniBtn({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  static const Color _plusColor = Color(0xFFE1E1E1);
  static const Color _minusColor = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    final isEmphasized =
        icon == Icons.add || icon == Icons.keyboard_arrow_down;

    final bgColor = isEmphasized ? _plusColor : _minusColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        splashColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFD1D5DB),
        child: Ink(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 22.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

class _CircleActionBlue extends StatelessWidget {
  const _CircleActionBlue({
    this.icon,
    this.imagePath,
    this.isPlay = true,
    this.onTap,
    this.active = false,
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

  final IconData? icon;
  final String? imagePath;
  final bool isPlay;
  final VoidCallback? onTap;
  final bool active;

  static const Color _softGrey = Color(0xFFF3F4F6);
  static const Color _themeBlue = Color(0xFF0088FE);

  @override
  Widget build(BuildContext context) {
    final bg = active ? _themeBlue : _softGrey;
    final fg = active ? Colors.white : const Color(0xFF6B7280);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        splashColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFD1D5DB),
        child: Ink(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ClipOval(
              child: SizedBox(
                width: 30.w,
                height: 30.h,
                child: Center(
                  child: imagePath != null
                      ? (active
                          ? Image.asset(
                              imagePath!,
                              width: isPlay ? 27.sp : 21.sp,
                              height: isPlay ? 24.sp : 20.sp,
                              fit: BoxFit.scaleDown,
                            )
                          : Image.asset(
                              imagePath!,
                              width: isPlay ? 27.sp : 21.sp,
                              height: isPlay ? 24.sp : 20.sp,
                              fit: BoxFit.scaleDown,
                              color: fg,
                              colorBlendMode: BlendMode.srcIn,
                            ))
                      : Icon(icon!, size: 20.sp, color: fg),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      width: 60.w,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF0088FE),
      ),
    );
  }
}

class _ToggleColorswitch extends StatelessWidget {
  const _ToggleColorswitch({
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      width: 60.w,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF0088FE),
      ),
    );
  }
}

class _SmallText extends StatelessWidget {
  const _SmallText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final v = text.trim().toLowerCase();
    final isStrong = v == 'disarmed' ||
        v == 'armed' ||
        v == 'blocked' ||
        v == 'active' ||
        v == 'running' ||
        v == 'off' ||
        v == 'on';

    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: isStrong ? FontWeight.w700 : FontWeight.w400,
        color: isStrong ? const Color(0xFF111827) : const Color(0xFF6B7280),
        height: 1.05,
        fontFamily: 'Inter',
      ),
    );
  }
}

class _PinOnly extends StatelessWidget {
  const _PinOnly();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/image 81 (1).png',
      width: 16.sp,
      height: 16.sp,
      fit: BoxFit.contain,
      color: const Color(0xFF0088FE),
      colorBlendMode: BlendMode.srcIn,
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
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827),
        fontFamily: 'Inter',
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
        // ✅ Screenshot: id/text খুব ছোট (18 ❌)
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
        height: 1.05,
        fontFamily: 'Inter',
      ),
    );
  }
}
/* ---------------- Badges / Tags ---------------- */

class _ModeDot extends StatelessWidget {
  const _ModeDot({required this.manual, this.onTap});

  /// `true` = manual (M), `false` = auto (A).
  final bool manual;
  final VoidCallback? onTap;

  static const Color _softGrey = Color(0xFFE1E1E1);
  static const Color _themeBlue = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final letter = manual ? 'M' : 'A';
    final badge = Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: manual ? _themeBlue : _softGrey,
        shape: BoxShape.circle,
        // border: manual
        //     ? null
        //     : Border.all(color: _themeBlue.withValues(alpha: 0.45)),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: manual ? Colors.white : _themeBlue,
          height: 1.0,
          fontFamily: 'Inter',
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

// class _TagChip extends StatelessWidget {
//   const _TagChip({required this.text, required this.bg, this.outlined = false});
//   final String text;
//   final Color bg;
//   final bool outlined;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 22.h,
//       width: 75.w,
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
//       decoration: BoxDecoration(
//         color: outlined ? Colors.white : bg,
//         borderRadius: BorderRadius.circular(4.r),
//         border: outlined ? Border.all(color: bg, width: 1.5) : null,
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 11.sp,
//           fontWeight: FontWeight.w600,
//           color: outlined ? bg : Colors.white,
//           height: 1.0,
//           fontFamily: 'Inter',
//         ),
//       ),
//     );
//   }
// }

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.bg,
    required this.fg,
    this.onTap,
  });

  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: fg,
          fontFamily: 'Inter',
          height: 1.0,
        ),
      ),
    );
    if (onTap == null) return chip;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: chip,
    );
  }
}
/* ---------------- Top right tags (time/star) ---------------- */

class _TimeTag extends StatelessWidget {
  const _TimeTag({required this.text, this.blueIcon = true});

  final String text;
  final bool blueIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/image 81 (1).png', // pin
            width: 16.sp,
            height: 16.sp,
            fit: BoxFit.contain,
            color: blueIcon ? const Color(0xFF0088FE) : const Color(0xFFF3F4F6),
            colorBlendMode: BlendMode.srcIn,
          ),
          SizedBox(width: 11.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              height: 1.0,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _StarTimeTag extends StatelessWidget {
  const _StarTimeTag({required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 24.sp, color: const Color(0xFFFFDA0B)),
          SizedBox(width: 5.w),
          Text(
            time,
            style: TextStyle(
              fontSize: 13.sp, // ✅ screenshot small
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              height: 1.0,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _StarOnly extends StatelessWidget {
  const _StarOnly();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      width: 24.h,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.sp,
          color: const Color(0xFF000000).withOpacity(0.25),
        ),
        //borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(
        child: Icon(
          Icons.star_rounded,
          size: 24.sp,
          color: Color(0xFFFFDA0B),
          //color: const Color(0xFFFBBF24),
        ),
      ),
    );
  }
}

/* ---------------- Leading icons (approx same) ---------------- */

class _GradientCircleIcon extends StatelessWidget {
  const _GradientCircleIcon({this.size = 36});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
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
    return SizedBox(
      width: 39.w,
      height: 39.h,
      child: Center(
        child: Image.asset(
          'assets/Mask group (10).png',
          width: 39.w,
          height: 39.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _PowerRingIcon extends StatelessWidget {
  const _PowerRingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child:
          // Power glyph (looks like screenshot)
          Image.asset(
            'assets/Mask group (11).png',
            width: 22.sp,
            height: 22.sp,
            fit: BoxFit.contain,
          ),
    );
  }
}

class _BlindGreenIcon extends StatelessWidget {
  const _BlindGreenIcon();

  @override
  Widget build(BuildContext context) {
    final base = 44.w; // ✅ main icon size
    final badge = 20; // ✅ blue check badge size

    return SizedBox(
      width: base,
      height: base,
      child: Stack(
        clipBehavior: Clip.none, // ✅ allow badge to sit outside a bit
        children: [
          Center(
            child: Image.asset(
              'assets/Mask group (12).png',
              width: base,
              height: base,
              fit: BoxFit.contain,
            ),
          ),

          // ✅ Blue check badge (bottom-right)
          Positioned(
            right: -2.w,
            bottom: -2.w,
            child: Container(
              width: badge.w,
              height: badge.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0088FE),
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.check_rounded,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFBBF24),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PlayCircleIcon extends StatelessWidget {
  const _PlayCircleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.w,
      height: 36.w,
      child: Center(
        child: Image.asset(
          'assets/Mask group (13).png',
          width: 36.w,
          height: 36.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _SunIcon extends StatelessWidget {
  const _SunIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 39.w,
      height: 39.w,
      child: Center(
        child: Image.asset(
          'assets/Mask group (14).png',
          width: 39.w,
          height: 39.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _BulbIcon extends StatelessWidget {
  const _BulbIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 39.w,
      height: 39.w,
      child: Center(
        child: Image.asset(
          'assets/Mask group (5).png',
          width: 39.w,
          height: 39.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

/* ---------------- Blind stats row ---------------- */

class _BlindStatsRow extends StatefulWidget {
  const _BlindStatsRow({
    required this.closedPct,
    required this.openPct,
  });

  final int closedPct;
  final int openPct;

  @override
  State<_BlindStatsRow> createState() => _BlindStatsRowState();
}

class _BlindStatsRowState extends State<_BlindStatsRow> {
  bool _rgbwManual = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ModeDot(
          manual: _rgbwManual,
          onTap: () => setState(
                () => _rgbwManual = !_rgbwManual,
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
          '${widget.closedPct.clamp(0, 100)}%',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            fontFamily: 'Inter',
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
          '${widget.openPct.clamp(0, 100)}%',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

/// black “up/down triangles” icon
class _DoubleTriangleIcon extends StatelessWidget {
  const _DoubleTriangleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.w,
      height: 28.h,
      child: CustomPaint(painter: _DoubleTrianglePainter()),
    );
  }
}

class _DoubleTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF111827);

    // up triangle
    final up = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2 - 2)
      ..lineTo(0, size.height / 2 - 2)
      ..close();

    // down triangle
    final down = Path()
      ..moveTo(0, size.height / 2 + 2)
      ..lineTo(size.width, size.height / 2 + 2)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(up, p);
    canvas.drawPath(down, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// black wedge icon (like screenshot)
class _WedgeIcon extends StatelessWidget {
  const _WedgeIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18.w,
      height: 28.h,
      child: CustomPaint(painter: _WedgePainter()),
    );
  }
}

class _WedgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF111827);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.75)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* ---------------- Brightness pill slider ---------------- */

class _BrightnessPill extends StatelessWidget {
  const _BrightnessPill({
    required this.value,
    this.onChanged,
  });

  /// Filled portion 0.0 - 1.0 (brighter / higher level to the left).
  final double value;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final f = value.clamp(0.0, 1.0);
    final w = 150.w;
    final h = 34.h;

    void applyFromDx(double dx) {
      if (onChanged == null) return;
      onChanged!((dx / w).clamp(0.0, 1.0));
    }

    final pill = SizedBox(
      width: w,
      height: h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: Stack(
          children: [
            Container(color: const Color(0xFFE5E7EB)),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: f,
                child: Container(color: const Color(0xFFF3F4F6)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: f,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 1.w,
                    height: double.infinity,
                    color: const Color(0xFFD1D5DB),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 14.w),
                child: Icon(
                  Icons.wb_sunny_outlined,
                  size: 20.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (onChanged == null) return pill;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (d) => applyFromDx(d.localPosition.dx),
      onHorizontalDragUpdate: (d) => applyFromDx(d.localPosition.dx),
      child: pill,
    );
  }
}

/* ---------------- Control unit row ---------------- */

class _ControlUnitRow extends StatelessWidget {
  const _ControlUnitRow({
    this.icon,
    this.iconColor,
    this.imagePath,
    required this.title,
    this.sub,
    required this.sub2,
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

  final IconData? icon;
  final Color? iconColor;
  final String? imagePath;
  final String title;
  final String? sub;
  final String sub2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 12.h, 12.w, 12.h),
      child: Row(
        children: [
          imagePath != null
              ? Image.asset(
                  'assets/image 125.png',
                  width: 34.sp,
                  height: 34.sp,
                  fit: BoxFit.contain,
                )
              : Icon(icon!, size: 18.sp, color: iconColor!),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                    fontFamily: 'Inter',
                  ),
                ),
                if (sub != null) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Image.asset(
                        'assets/Mask group (18).png',
                        width: 14.sp,
                        height: 14.sp,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        sub!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 2.h),
                Text(
                  sub2,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                    fontFamily: 'Inter',
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