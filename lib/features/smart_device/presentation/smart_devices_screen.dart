import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/devices/widget/assign_category_zone.dart';

import '../widget/addSmartDevicesPopup.dart';
import '../widget/menu_popup.dart';

class SmartDevicesScreen extends StatefulWidget {
  const SmartDevicesScreen({super.key});

  static const String routeName = '/smart-devices';

  @override
  State<SmartDevicesScreen> createState() => _SmartDevicesScreenState();
}

class _SmartDevicesScreenState extends State<SmartDevicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Local UI state for list controls (demo / no backend).
  bool _alarmPaused = true;
  bool _bathroomComfortOn = true;
  double _bathroomDimmerPercent = 0.5;
  bool _irrigationBoostOn = true;
  int _fanLevel = 0; // 0 = Off, 1–3 = levels
  double _heatSetpoint = 21.0;
  int _irrigationMinutes = 0;
  double _kitchenTemp = 24.6;
  int _kitchenHumidityPct = 35;
  bool _bathroomManual = false;
  bool _fanManual = true;
  bool _kitchenManual = false;

  /// Which device row is highlighted (persists until another row is tapped).
  String _selectedDeviceId = 'heating';

  /// Power state for the Light row (shown when [selectionId] `light` is selected).
  bool _lightPowerOn = true;

  static const _selectedRowBg = Color(0xFFEAF1FF);

  /// 0 = none; 1 = left button; 2 = right button.
  int _fanStepMark = 0;
  int _heatStepMark = 0;
  int _irrigationStepMark = 0;
  int _kitchenStepMark = 0;

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

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Colors (match screenshot)
  static const _bg = Colors.white;
  static const _primary = Color(0xFF111827);

  static const _muted = Color(0xFF6B7280);
  static const _divider = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF0088FE);
  static const _pink = Color(0xFFFF2D92);
  static const _green = Color(0xFF22C55E);

  // ✅ Your asset paths (change if needed)
  static const _icAlarm = 'assets/images/lock.png';
  static const _icBathroom = 'assets/images/bathroom.png';
  static const _icPlay = 'assets/images/play.png';
  static const _icFan =
      'assets/images/fan.png'; // Using ventilation as fan alternative
  static const _icHeatCool =
      'assets/images/heating_cooling.png'; // Using heating as alternative
  static const _icIrrigation = 'assets/images/irrigation.png';
  static const _icKitchen = 'assets/images/kitchen.png';
  static const _icFanUp = 'assets/Mask group copy 8.png';
  static const _icFanDown = 'assets/Mask group (1) copy 3.png';
  static const _icIrrigationLeft = 'assets/Mask group (2) copy 2.png';
  static const _icIrrigationRight = 'assets/Mask group copy 4.png';



  void showEditSmartDeviceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const EditDeviceSheetContent(),
      ),
    );
  }


  void showAddSmartDeviceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.62, // screenshot like
        minChildSize: 0.35,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, controller) => AddSmartDeviceSheet(scrollController: controller),
      ),
    );
  }

  void _showAssignCategoryPopup(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AssignCategoryZoneSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            _buildSectionTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  children: [
                    _buildDeviceList(), 
                    
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Header (like screenshot) – title centered on screen
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalCircleIconBtn(
                child: Image.asset(
                  'assets/aro.png',
                  width: 16.w,
                  height: 16.h,
                ),
                onTap: () => Navigator.maybePop(context),
                color: Color(0xFFF3F4F6),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => showEditSmartDeviceSheet(context),
                      customBorder: const CircleBorder(),
                      splashColor: const Color(0xFFE5E7EB),
                      highlightColor: const Color(0xFFE5E7EB),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.more_horiz_rounded,
                          size: 22.sp,
                          color: _primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => showAddSmartDeviceBottomSheet(context),
                      customBorder: const CircleBorder(),
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF111827),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 23,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              'Smart devices',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: _primary,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Search: gradient border only when focused, no border by default
  Widget _buildSearchBar() {
    return ListenableBuilder(
      listenable: _searchFocusNode,
      builder: (context, _) {
        final hasFocus = _searchFocusNode.hasFocus;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Container(
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
                      'assets/images/Mask group.png',
                      width: 22.w,
                      height: 22.w,
                      fit: BoxFit.contain,
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
          ),
        );
      },
    );
  }

  // ✅ Section title
  Widget _buildSectionTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Smart devices',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: _primary,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  // ✅ Divider aligned after icon
  Widget _buildDivider() {
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: 67.w,),
      color: _divider,
    );
  }

  // ✅ Left icon ring using Image.asset
  Widget _leftIconAsset({
    required String imagePath,
    required Color ringColor,
    IconData? fallbackIcon,
    double? iconWidth,
    double? iconHeight,
  }) {
    final w = (iconWidth ?? 39).w;
    final h = (iconHeight ?? 39).h;
    return Center(
      child: Image.asset(
        imagePath,
        width: w,
        height: h,
        fit: BoxFit.contain,
        // filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if image fails to load
          return Icon(
            fallbackIcon ?? Icons.devices_rounded,
            size: w,
            color: ringColor,
          );
        },
      ),
    );
  }

  // ✅ Reusable row (selection highlight + tap on main area only; trailing stays independent).
  Widget _buildDeviceRow({
    required String selectionId,
    required Widget leading,
    required String title,
    required Widget subtitle,
    required Widget trailing,
  }) {
    final selected = _selectedDeviceId == selectionId;
    return Container(
      color: selected ? _selectedRowBg : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _selectedDeviceId = selectionId),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leading,
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Inter',
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
          trailing,
        ],
      ),
    );
  }
  // Same circle size, gap, and trailing inset for all +/- and arrow pairs.
  
  Widget _deviceControlPair({
    required IconData left,
    required IconData right,
    VoidCallback? onLeft,
    VoidCallback? onRight,
    bool markedLeft = false,
    bool markedRight = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleButton(icon: left, onTap: onLeft, marked: markedLeft),
        SizedBox(width: 20.w),
        _CircleButton(icon: right, onTap: onRight, marked: markedRight),
        SizedBox(width: 10.w),
      ],
    );
  }

  

  Widget _deviceControlPairAssets({
    required String leftAsset,
    required String rightAsset,
    VoidCallback? onLeft,
    VoidCallback? onRight,
    bool disableLeft = false,
    bool disableRight = false,
    bool markedLeft = false,
    bool markedRight = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleAssetButton(
          assetPath: leftAsset,
          marked: markedLeft,
          onTap: disableLeft ? null : onLeft,
          iconColor: disableLeft ? const Color(0xFF6B7280) : null,
        ),
        SizedBox(width: 20.w),
        _CircleAssetButton(
          assetPath: rightAsset,
          marked: markedRight,
          onTap: disableRight ? null : onRight,
          iconColor: disableRight ? const Color(0xFF6B7280) : null,
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  /// Expanded strip under the Light list row: hero + stats + Off/On + warning (matches device detail reference).
  // Widget _buildLightOnOffDetailStrip() {
  //   return Container(
  //     width: double.infinity,
  //     color: const Color(0xFFF3F4F6),
  //     padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         // Center(
  //         //   child: Image.asset(
  //         //     'assets/Mask group (5).png',
  //         //     height: 88.h,
  //         //     width: 88.w,
  //         //     fit: BoxFit.contain,
  //         //     errorBuilder: (_, __, ___) => Icon(
  //         //       Icons.lightbulb_outline_rounded,
  //         //       size: 72.sp,
  //         //       color: const Color(0xFF22D3EE),
  //         //     ),
  //         //   ),
  //         // ),
  //         // SizedBox(height: 10.h),
  //         // Row(
  //         //   mainAxisAlignment: MainAxisAlignment.center,
  //         //   children: [
  //         //     Flexible(
  //         //       child: Text(
  //         //         'Light dinning room',
  //         //         textAlign: TextAlign.center,
  //         //         style: TextStyle(
  //         //           fontSize: 18.sp,
  //         //           fontWeight: FontWeight.w600,
  //         //           color: _primary,
  //         //           fontFamily: 'Inter',
  //         //         ),
  //         //       ),
  //         //     ),
  //         //     SizedBox(width: 8.w),
  //         //     Image.asset(
  //         //       'assets/Group 63.png',
  //         //       height: 13.h,
  //         //       width: 13.w,
  //         //       fit: BoxFit.cover,
  //         //       color: _primary,
  //         //       errorBuilder: (_, __, ___) =>
  //         //           Icon(Icons.edit_outlined, size: 14.sp, color: _primary),
  //         //     ),
  //         //   ],
  //         // ),
  //         // SizedBox(height: 6.h),
  //         // Text(
  //         //   'SWC 1326 39',
  //         //   textAlign: TextAlign.center,
  //         //   style: TextStyle(
  //         //     fontSize: 10.sp,
  //         //     fontWeight: FontWeight.w400,
  //         //     color: _muted,
  //         //     fontFamily: 'Inter',
  //         //   ),
  //         // ),
  //         // SizedBox(height: 14.h),
  //         // Padding(
  //         //   padding: EdgeInsets.symmetric(horizontal: 28.w),
  //         //   child: Row(
  //         //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         //     children: [
  //         //       _lightStatCell(top: '12:57', bottom: 'On time'),
  //         //       _lightStatCell(top: '5h 58m', bottom: '7 Days'),
  //         //       _lightStatCell(top: '1257', bottom: 'Cycles'),
  //         //     ],
  //         //   ),
  //         // ),
  //         SizedBox(height: 18.h),
  //         Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 48.w),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => setState(() => _lightPowerOn = false),
  //                   child: Container(
  //                     height: 39.h,
  //                     decoration: BoxDecoration(
  //                       color: _lightPowerOn ? Colors.white : _blue,
  //                       borderRadius: BorderRadius.circular(26.r),
  //                       border: _lightPowerOn
  //                           ? Border.all(color: const Color(0xFFE5E7EB))
  //                           : null,
  //                       boxShadow: _lightPowerOn
  //                           ? [
  //                               BoxShadow(
  //                                 color: Colors.black.withOpacity(0.06),
  //                                 blurRadius: 8.r,
  //                                 offset: const Offset(0, 2),
  //                               ),
  //                             ]
  //                           : null,
  //                     ),
  //                     child: Center(
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Icon(
  //                             Icons.arrow_drop_down_rounded,
  //                             size: 20.sp,
  //                             color: _lightPowerOn ? _primary : Colors.white,
  //                           ),
  //                           SizedBox(width: 4.w),
  //                           Text(
  //                             'Off',
  //                             style: TextStyle(
  //                               fontSize: 15.sp,
  //                               fontWeight: FontWeight.w600,
  //                               color: _lightPowerOn ? _primary : Colors.white,
  //                               fontFamily: 'Inter',
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: 12.w),
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => setState(() => _lightPowerOn = true),
  //                   child: Container(
  //                     height: 39.h,
  //                     decoration: BoxDecoration(
  //                       color: _lightPowerOn
  //                           ? _blue
  //                           : const Color(0xFF6B7280),
  //                       borderRadius: BorderRadius.circular(26.r),
  //                     ),
  //                     child: Center(
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Icon(
  //                             Icons.power_settings_new_rounded,
  //                             size: 17.sp,
  //                             color: Colors.white,
  //                           ),
  //                           SizedBox(width: 6.w),
  //                           Text(
  //                             'On',
  //                             style: TextStyle(
  //                               fontSize: 15.sp,
  //                               fontWeight: FontWeight.w600,
  //                               color: Colors.white,
  //                               fontFamily: 'Inter',
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 14.h),
  //         Center(
  //           child: Container(
  //             constraints: BoxConstraints(maxWidth: 340.w),
  //             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(26.r),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black.withOpacity(0.04),
  //                   blurRadius: 6.r,
  //                   offset: const Offset(0, 2),
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Image.asset(
  //                   'assets/message_icon.png',
  //                   height: 15.h,
  //                   width: 15.w,
  //                   fit: BoxFit.cover,
  //                   errorBuilder: (_, __, ___) =>
  //                       Icon(Icons.chat_bubble_outline_rounded,
  //                           size: 15.sp, color: _muted),
  //                 ),
  //                 SizedBox(width: 8.w),
  //                 Flexible(
  //                   child: Text(
  //                     'Don\'t ON this device while you sleeping',
  //                     style: TextStyle(
  //                       fontSize: 11.sp,
  //                       fontWeight: FontWeight.w400,
  //                       color: _muted,
  //                       fontFamily: 'Inter',
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _lightStatCell({required String top, required String bottom}) {
  //   return Column(
  //     children: [
  //       Text(
  //         top,
  //         style: TextStyle(
  //           fontSize: 15.sp,
  //           fontWeight: FontWeight.w600,
  //           color: _primary,
  //           fontFamily: 'Inter',
  //         ),
  //       ),
  //       SizedBox(height: 2.h),
  //       Text(
  //         bottom,
  //         style: TextStyle(
  //           fontSize: 10.sp,
  //           fontWeight: FontWeight.w400,
  //           color: _muted,
  //           fontFamily: 'Inter',
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // ✅ Whole list (match screenshot)
  Widget _buildDeviceList() {
    return Column(
      children: [
       
        _buildDeviceRow(
          selectionId: 'alarm',
          leading: _leftIconAsset(
            imagePath: _icAlarm,
            ringColor: _pink,
            fallbackIcon: Icons.pause,
          ),
          title: 'Alram',
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InlineText(_alarmPaused ? 'Paused' : 'Disarmed'),
              SizedBox(height: 5.h),
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
                      fg: _primary,
                      onTap: () => _showAssignCategoryPopup(context),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  _TagChip(
                    label: 'Bathroom',
                    bg: _pink,
                    fg: Colors.white,
                    onTap: () => _showAssignCategoryPopup(context),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/pin.png',
                    width: 16.w,
                    height: 16.w,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '18:32',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _muted,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _alarmPaused = !_alarmPaused),
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.r),
                      // Paused = active / “on” (blue + play). Disarmed = “off” — do not
                      // use pause here; it reads as media controls and matches the bad UI.
                      color: Color(0xFFF3F4F6),
                      // shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _alarmPaused
                          ? Image.asset(
                              "assets/images/001-2 1.png",
                              height: 15.h,
                              width: 14.w,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              "assets/images/Group 68.png",
                              height: 14.h,
                              width: 14.w,
                              fit: BoxFit.contain,
                            ),
                    )
                    // Icon(
                    //   _alarmPaused
                    //       ? Icons.play_arrow_rounded
                    //       : Icons.pause,
                    //   size: 20.sp,
                    //   color: _alarmPaused ?   Color(0xFF0088FE) : const Color(0xFF6B7280),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildDivider(),

        // 2) Bathroom
        _buildDeviceRow(
          selectionId: 'bathroom',
          leading: _leftIconAsset(
            imagePath: _icBathroom,
            ringColor: const Color(0xFF8B5CF6),
            fallbackIcon: Icons.water_drop_outlined,
          ),
          title: 'Bathroom',
          subtitle: Row(
            children: [
              _SmallCircleText(
                manual: _bathroomManual,
                onTap: () => setState(
                  () => _bathroomManual = !_bathroomManual,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.thermostat_rounded,
                size: 16.sp,
                color: const Color(0xFF3B82F6),
              ),
              SizedBox(width: 6.w),
              Text(
                _bathroomComfortOn ? 'On' : 'Off',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          trailing: _DimmerPill(
            percent: _bathroomDimmerPercent,
            comfortOn: _bathroomComfortOn,
            onChanged: (v) =>
                setState(() => _bathroomDimmerPercent = v.clamp(0.0, 1.0)),
            onSunTap: () =>
                setState(() => _bathroomComfortOn = !_bathroomComfortOn),
          ),
        ),
       
        _buildDivider(),

        // 3) Block Irrigation Schedule
        _buildDeviceRow(
          selectionId: 'block_irrigation',
          leading: _leftIconAsset(
            imagePath: _icPlay,
            ringColor: const Color(0xFF0EA5E9),
            fallbackIcon: Icons.play_circle_outline_rounded,
            iconWidth: 36,
            iconHeight: 36,
          ),
          title: 'Block Irrigation Schedule',
          subtitle: _InlineText(
            _irrigationBoostOn ? 'Active' : 'Boost on',
            bold: true,
          ),
          trailing: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () =>
                    setState(() => _irrigationBoostOn = !_irrigationBoostOn),
                child: Ink(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: _irrigationBoostOn
                        ? Color(0xFF26D344)
                        : const Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _irrigationBoostOn
                        ? Image.asset(
                            'assets/images/charge.png',
                            height: 22.h,
                          )
                        : Image.asset(
                            'assets/images/charge.png',
                            height: 22.h,
                            color: _muted,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildDivider(),

        // 4) Fan
        _buildDeviceRow(
          selectionId: 'fan',
          leading: _leftIconAsset(
            imagePath: _icFan,
            ringColor: const Color(0xFF0EA5E9),
            fallbackIcon: Icons.ac_unit_rounded,
            iconWidth: 36,
            iconHeight: 36,
          ),
          title: 'Fan(3 levels)',
          subtitle: Row(
            children: [
              _SmallCircleText(
                manual: _fanManual,
                onTap: () =>
                    setState(() => _fanManual = !_fanManual),
              ),
              SizedBox(width: 8.w),
              Text(
                _fanLevel == 0 ? 'Off' : 'Level $_fanLevel',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 24.sp,
                    color: const Color(0xFFFFDA0B),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '20:36',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _muted,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.w),
              _deviceControlPairAssets(
                leftAsset: _icFanUp,
                rightAsset: _icFanDown,
                disableLeft: false,
                disableRight: _fanLevel == 0,
                markedLeft: _fanStepMark == 1,
                markedRight: _fanStepMark == 2,
                onLeft: () => _flashMark(
                  value: 1,
                  getCurrent: () => _fanStepMark,
                  set: (v) => _fanStepMark = v,
                  action: () => _fanLevel = (_fanLevel + 1).clamp(0, 3),
                ),
                onRight: () => _flashMark(
                  value: 2,
                  getCurrent: () => _fanStepMark,
                  set: (v) => _fanStepMark = v,
                  action: () => _fanLevel = (_fanLevel - 1).clamp(0, 3),
                ),
              ),
            ],
          ),
        ),
        _buildDivider(),

        // 5) Heating & Cooling
        _buildDeviceRow(
          selectionId: 'heating',
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              _leftIconAsset(
                imagePath: _icHeatCool,
                ringColor: _blue,
                fallbackIcon: Icons.thermostat_rounded,
                iconWidth: 39,
                iconHeight: 36,
              ),
              if (_selectedDeviceId == 'heating')
                Positioned(
                  right: -4.w,
                  bottom: -2.h,
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0088FE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          title: 'Heating & Cooling',
          subtitle: _InlineText(
            'Heating · ${_heatSetpoint.toStringAsFixed(1)}°C',
            bold: true,
          ),
          trailing: _deviceControlPair(
            left: Icons.remove_rounded,
            right: Icons.add_rounded,
            markedLeft: _heatStepMark == 1,
            markedRight: _heatStepMark == 2,
            onLeft: () => _flashMark(
              value: 1,
              getCurrent: () => _heatStepMark,
              set: (v) => _heatStepMark = v,
              action: () =>
                  _heatSetpoint = (_heatSetpoint - 0.5).clamp(0.0, 35.0),
            ),
            onRight: () => _flashMark(
              value: 2,
              getCurrent: () => _heatStepMark,
              set: (v) => _heatStepMark = v,
              action: () =>
                  _heatSetpoint = (_heatSetpoint + 0.5).clamp(0.0, 35.0),
            ),
          ),
        ),
        _buildDivider(),

        // 6) Irrigation
        _buildDeviceRow(
          selectionId: 'irrigation',
          leading: _leftIconAsset(
            imagePath: _icIrrigation,
            ringColor: _green,
            fallbackIcon: Icons.local_florist_rounded,
          ),
          title: 'Irrigation',
          subtitle: _InlineText('$_irrigationMinutes', bold: true),
          trailing: _deviceControlPairAssets(
            leftAsset: _icIrrigationLeft,
            rightAsset: _icIrrigationRight,
            disableLeft: _irrigationMinutes == 0,
            disableRight: false,
            markedLeft: _irrigationStepMark == 1,
            markedRight: _irrigationStepMark == 2,
            onLeft: () => _flashMark(
              value: 1,
              getCurrent: () => _irrigationStepMark,
              set: (v) => _irrigationStepMark = v,
              action: () =>
                  _irrigationMinutes = (_irrigationMinutes - 5).clamp(0, 100),
            ),
            onRight: () => _flashMark(
              value: 2,
              getCurrent: () => _irrigationStepMark,
              set: (v) => _irrigationStepMark = v,
              action: () =>
                  _irrigationMinutes = (_irrigationMinutes + 5).clamp(0, 100),
            ),
          ),
        ),
        _buildDivider(),

        // 7) Kitchen
        _buildDeviceRow(
          selectionId: 'kitchen',
          leading: _leftIconAsset(
            imagePath: _icKitchen,
            ringColor: _green,
            fallbackIcon: Icons.kitchen_rounded,
          ),
          title: 'Kitchen',
          subtitle: Row(
            children: [
              _SmallCircleText(
                manual: _kitchenManual,
                onTap: () => setState(
                  () => _kitchenManual = !_kitchenManual,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.thermostat_rounded,
                size: 16.sp,
                color: const Color(0xFF3B82F6),
              ),
              SizedBox(width: 4.w),
              Text(
                '${_kitchenTemp.toStringAsFixed(1)}°C',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: _primary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(width: 10.w),
              Image.asset("assets/images/fire.png"),
              SizedBox(width: 4.w),
              Text(
                '$_kitchenHumidityPct%',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          trailing: _deviceControlPair(
            left: Icons.remove_rounded,
            right: Icons.add_rounded,
            markedLeft: _kitchenStepMark == 1,
            markedRight: _kitchenStepMark == 2,
            onLeft: () => _flashMark(
              value: 1,
              getCurrent: () => _kitchenStepMark,
              set: (v) => _kitchenStepMark = v,
              action: () {
                _kitchenTemp = (_kitchenTemp - 0.5).clamp(10.0, 35.0);
                _kitchenHumidityPct =
                    (_kitchenHumidityPct - 5).clamp(0, 100);
              },
            ),
            onRight: () => _flashMark(
              value: 2,
              getCurrent: () => _kitchenStepMark,
              set: (v) => _kitchenStepMark = v,
              action: () {
                _kitchenTemp = (_kitchenTemp + 0.5).clamp(10.0, 35.0);
                _kitchenHumidityPct =
                    (_kitchenHumidityPct + 5).clamp(0, 100);
              },
            ),
          ),
        ),
        //Sizedbox(height:200.h),  
      ],
    );
  }
}

// ---------- Small helpers ----------

class _InlineText extends StatelessWidget {
  const _InlineText(this.text, {this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w700,
        color: Colors.black,
        fontFamily: 'Inter',
      ),
    );
  }
}

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

class _SmallCircleText extends StatelessWidget {
  const _SmallCircleText({
    required this.manual,
    this.onTap,
  });

  /// `true` = manual (M), `false` = auto (A).
  final bool manual;
  final VoidCallback? onTap;

  static const _softGrey = Color(0xFFE1E1E1);
  static const _themeBlue = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final letter = manual ? 'M' : 'A';
    final badge = Container(
      width: 26.w,
      height: 26.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: manual ? _themeBlue : _softGrey,
        shape: BoxShape.circle,
        // border: manual
        //     ? null
        //     : Border.all(color: _themeBlue.withValues(alpha: 0.45)),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: manual ? Colors.white : _themeBlue,
          fontFamily: 'Inter',
          height: 1.0,
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


class _DimmerPill extends StatelessWidget {
  const _DimmerPill({
    required this.percent,
    required this.comfortOn,
    this.onChanged,
    this.onSunTap,
  });

  final double percent;
  final bool comfortOn;
  final ValueChanged<double>? onChanged;
  final VoidCallback? onSunTap;

  static const Color _onIconTint = Color(0xFF0088FE);
  static const Color _offIconTint = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);
    final w = 133.w;

    final pill = Container(
      height: 35.h,
      width: w,
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: (1 - p),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E1E1),
                  borderRadius: BorderRadius.horizontal(
                    right: const Radius.circular(999),
                    left: Radius.circular((1 - p) >= 0.98 ? 999 : 0),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _buildComfortLead(),
            ),
          ),
        ],
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

  Widget _buildComfortLead() {
    final glyph = comfortOn
        ? Image.asset(
            'assets/Mask group (15).png',
            height: 20.h,
            width: 20.w,
            fit: BoxFit.contain,
            color: _onIconTint,
          )
        : Image.asset(
            'assets/images/Group 48 (1).png',
            height: 20.h,
            width: 20.w,
            fit: BoxFit.contain,
            color: _offIconTint,
          );

    final padded = Padding(
      padding: EdgeInsets.all(6.w),
      child: glyph,
    );

    if (onSunTap == null) return padded;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onSunTap,
        splashColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFE5E7EB),
        child: padded,
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton ({
    required this.icon,
    this.onTap,
    this.marked = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool marked;

  /// Match `devices_screen` behavior: same idle + same pressed/marked fill.
  static const Color _idleFill = Color(0xFFF3F4F6);
  static const Color _markedOrPressFill = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return _PressableCircleSurface(
      side: 35.w,
      fill: _idleFill,
      pressedFill: _markedOrPressFill,
      marked: marked,
      onTap: onTap,
      child: Icon(icon, size: 23.sp, color: const Color(0xFF6B7280)),
    );
  }
}

class _PressableCircleSurface extends StatefulWidget {
  const _PressableCircleSurface({
    required this.side,
    required this.fill,
    required this.pressedFill,
    required this.child,
    this.onTap,
    this.marked = false,
  });

  final double side;
  final Color fill;
  final Color pressedFill;
  final Widget child;
  final VoidCallback? onTap;
  final bool marked;

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
    final circle = Container(
      width: widget.side,
      height: widget.side,
      decoration: BoxDecoration(
        color: (_pressed || widget.marked) ? widget.pressedFill : widget.fill,
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

class _CircleAssetButton extends StatelessWidget {
  const _CircleAssetButton({
    required this.assetPath,
    this.onTap,
    this.marked = false,
    this.iconColor,
  });

  final String assetPath;
  final VoidCallback? onTap;
  final bool marked;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return _PressableCircleSurface(
      side: 35.w,
      fill: _CircleButton._idleFill,
      pressedFill: _CircleButton._markedOrPressFill,
      marked: marked,
      onTap: onTap,
      child: Center(
        child: Image.asset(
          assetPath,
          width: 13.w,
          height: 13.h,
          fit: BoxFit.contain,
          color: iconColor,
          colorBlendMode: iconColor == null ? null : BlendMode.srcIn,
        ),
      ),
    );
  }
}