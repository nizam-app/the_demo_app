import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workpleis/features/devices/widget/assign_category_zone.dart';

/// Public widget
class EditDeviceSheetContent extends StatelessWidget {
  const EditDeviceSheetContent({super.key});

  @override
  Widget build(BuildContext context) => const _EditDeviceSheetContent();
}

class _EditDeviceSheetContent extends StatefulWidget {
  const _EditDeviceSheetContent();

  @override
  State<_EditDeviceSheetContent> createState() =>
      _EditDeviceSheetContentState();
}

class _EditDeviceSheetContentState extends State<_EditDeviceSheetContent> {
  final TextEditingController _renameController = TextEditingController(
    text: 'Light living room',
  );

  bool _dashboardDropdownOpen = false;
  int _selectedDashboardIndex = 0;
  bool _lastActivitiesOn = true;

  final List<String> _dashboards = const [
    'Lighting section name',
    'Lighting section name',
    'Lighting section name',
    'Lighting section name',
    'Lighting section name',
    'Lighting section name',
    'Lighting section name',
    'Lighting section name',
  ];

  // For perfect dropdown anchoring (no hardcoded top)
  final LayerLink _dropdownLink = LayerLink();

  // Colors
  static const Color _kTextPrimary = Color(0xFF111827);
  static const Color _kTextSecondary = Color(0xFF6B7280);
  static const Color _kDestructiveRed = Color(0xFFFE019A);
  static const Color _kBlue = Color(0xFF0088FE);

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  void _toggleDashboardMenu() {
    setState(() => _dashboardDropdownOpen = !_dashboardDropdownOpen);
  }

  void _closeDashboardMenu() {
    if (_dashboardDropdownOpen) {
      setState(() => _dashboardDropdownOpen = false);
    }
  }

  void _showAssignCategoryPopup(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AssignCategoryZoneSheet(),
    );
  }

  // bool select = true;
  // late  ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.viewPaddingOf(context).top;
    final headerH = 56.h;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF).withOpacity(0.4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  0,
                  topPad + headerH + 8.h,
                  0,
                  16.h,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Rename Card
                      _Card(
                        child: _EditSheetRow(
                          imagePath: 'assets/images/Erename.png',
                          iconWidth: 22.w,
                          iconHeight: 22.h,
                          label: 'Rename',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 155.w),
                                child: Text(
                                  _renameController.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: _kTextSecondary,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Image.asset(
                                'assets/Group 63.png',
                                width: 14.w,
                                height: 13.h,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          onTap: () {
                            // TODO: open rename dialog if needed
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Actions Card
                      _Card(
                        child: Column(
                          children: [
                            _EditSheetRow(
                              imagePath: 'assets/images/pin1.png',
                              iconWidth: 20.w,
                              iconHeight: 20.h,
                              label: 'Pin device',
                              onTap: () {},
                            ),
                            SizedBox(height: 12.h),
                            _EditSheetRow(
                              imagePath: 'assets/images/star1.png',
                              iconWidth: 32.w,
                              iconHeight: 32.h,
                              label: 'Add to favorites',
                              onTap: () {},
                            ),
                            SizedBox(height: 12.h),

                            // Add to dashboard (anchor target)
                            _EditSheetRow(
                              imagePath: 'assets/images/add_dashboard.png',
                              iconWidth: 21.w,
                              iconHeight: 21.h,
                              label: 'Add to dashboard',
                              trailing: CompositedTransformTarget(
                                link: _dropdownLink,
                                child: _DashboardDropdownTrigger(
                                  value: _dashboards[_selectedDashboardIndex],
                                  isOpen: _dashboardDropdownOpen,
                                  onTap: _toggleDashboardMenu,
                                ),
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Category & zone (chips)
                            _EditSheetRow(
                              imagePath: 'assets/images/category&zone.png',
                              iconWidth: 20.w,
                              iconHeight: 20.h,
                              label: 'Category & zone',
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _ChipPill(
                                    text: 'Light',
                                    bg: Colors.white,
                                    border: _kBlue,
                                    textColor: _kBlue,
                                  ),
                                  SizedBox(width: 8.w),
                                  _ChipPill(
                                    text: 'Living room',
                                    bg: _kDestructiveRed,
                                    border: _kDestructiveRed,
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                              onTap: () => _showAssignCategoryPopup(context),
                            ),

                            SizedBox(height: 10.h),

                            // Last activities (big switch)
                            _EditSheetRow(
                              imagePath: 'assets/images/last_active.png',
                              iconWidth: 26.w,
                              iconHeight: 26.h,
                              label: 'Last activities',
                              trailing: SizedBox(
                                height: 35.h,
                                width: 60.w,
                                child: CupertinoSwitch(
                                  value: _lastActivitiesOn,
                                  onChanged: (v) =>
                                      setState(() => _lastActivitiesOn = v),
                                  activeColor: _kBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Settings / Remove Card
                      _Card(
                        child: Column(
                          children: [
                            _EditSheetRow(
                              imagePath: 'assets/images/setting.png',
                              iconWidth: 18.w,
                              iconHeight: 18.h,
                              label: 'Settings',
                              onTap: () {},
                            ),
                            SizedBox(height: 12.h),
                            _EditSheetRow(
                              imagePath: 'assets/images/delete1.png',
                              iconWidth: 16.w,
                              iconHeight: 19.h,
                              label: 'Delete',
                              isDestructive: true,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: topPad),
                  child: _buildHeader(context),
                ),
              ),

            // ===== Outside tap closes dropdown =====
            if (_dashboardDropdownOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeDashboardMenu,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.shrink(),
                ),
              ),

            // ===== Dropdown overlay (anchored just under the trigger, like design) =====
            if (_dashboardDropdownOpen)
              CompositedTransformFollower(
                link: _dropdownLink,
                showWhenUnlinked: false,
                offset: Offset(0, 34.h), // small gap under text+arrow row
                child: _DashboardDropdownMenu(
                  width: 220.w,
                  items: _dashboards,
                  selectedIndex: _selectedDashboardIndex,
                  onSelect: (index) => setState(() {
                    _selectedDashboardIndex = index;
                    _dashboardDropdownOpen = false;
                  }),
                ),
              ),
          ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Edit smart device',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: _kTextPrimary,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Positioned(
            right: 20.w,
            top: 14.h,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: const Color(0xFF111827).withOpacity(0.06),
                  //     blurRadius: 12,
                  //     offset: const Offset(0, 6),
                  //   ),
                  // ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close_rounded,
                  size: 20.sp,
                  color: _kTextPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== UI PARTS ======================

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: child,
    );
  }
}

class _EditSheetRow extends StatelessWidget {
  const _EditSheetRow({
    required this.label,
    this.imagePath,
    this.iconHeight,
    this.iconWidth,
    this.trailing,
    this.isDestructive = false,
    this.onTap,
  });

  final String? imagePath;
  final String label;
  final Widget? trailing;
  final bool isDestructive;
  final double? iconWidth;
  final double? iconHeight;
  final VoidCallback? onTap;

  static const Color _kTextPrimary = Color(0xFF111827);
  static const Color _kDestructiveRed = Color(0xFFFE019A);

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? _kDestructiveRed : _kTextPrimary;

    final Widget leading = imagePath != null
        ? Image.asset(
            imagePath!,
            width: iconWidth ?? 20.w,
            height: iconHeight ?? 20.w,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          )
        : SizedBox(width: 20.w, height: 20.w);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Row(
        children: [
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: Center(child: leading),
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: 'Inter',
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _DashboardDropdownTrigger extends StatelessWidget {
  const _DashboardDropdownTrigger({
    required this.value,
    required this.isOpen,
    required this.onTap,
  });

  final String value;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 190.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            SizedBox(width: 7.w),
            Icon(
              isOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 22.sp,
              color: const Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardDropdownMenu extends StatelessWidget {
  const _DashboardDropdownMenu({
    required this.width,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  final double width;
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 185.w,
        constraints: BoxConstraints(maxHeight: 150.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color(0xFF111827).withOpacity(0.12),
          //     blurRadius: 26.r,
          //     offset: const Offset(0, 12),
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26.r),
          child: ListView.separated(
            //padding: EdgeInsets.symmetric(vertical: 8.h),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox.shrink(),
            itemBuilder: (context, i) {
              final selected = i == selectedIndex;
              final bgColor = selected
                  ? const Color(
                      0xFFE5F0FF,
                    ) // light blue row highlight as in design
                  : Colors.white;
              return InkWell(
                onTap: () => onSelect(i),
                child: Container(
                  color: bgColor,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                  child: Row(
                    children: [
                      // Reserve space for check icon so text lines up in all rows
                      SizedBox(
                        width: 23.w,
                        //height: 26.h,
                        child: selected
                            ? Image.asset(
                                "assets/popup_done.png",
                                height: 23.h,
                                width: 23.w,
                                fit: BoxFit.cover,
                              )
                            // Icon(
                            //         Icons.check_rounded,
                            //         size: 18.sp,
                            //         color: const Color(0xFF0088FE),
                            //       )
                            : const SizedBox.shrink(),
                      ),
                      // SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          items[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF111827),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
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