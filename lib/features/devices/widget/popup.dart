import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Public widget so that [DevicesScreen] can show the edit device bottom sheet.
class EditDeviceSheetContent extends StatelessWidget {
  const EditDeviceSheetContent({super.key});

  @override
  Widget build(BuildContext context) => const _EditDeviceSheetContent();
}

class _EditDeviceSheetContent extends StatefulWidget {
  const _EditDeviceSheetContent();

  @override
  State<_EditDeviceSheetContent> createState() => _EditDeviceSheetContentState();
}

class _EditDeviceSheetContentState extends State<_EditDeviceSheetContent> {
  final TextEditingController _renameController =
  TextEditingController(text: 'Light living room');

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
  ];

  // --------- Fallback colors (যদি তোমার constants না থাকে) ----------
  static const Color _kTextPrimary = Color(0xFF111827);
  static const Color _kTextSecondary = Color(0xFF6B7280);
  static const Color _kIconGrey = Color(0xFF6B7280);
  static const Color _kCloseBtnBg = Colors.white;
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
  final LayerLink _dropdownLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6).withOpacity(0.74),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ✅ Main content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // -------- Rename card --------
                      Container(
                        padding: EdgeInsets.all(14.sp),
                        height: 57.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.r),
                          color: _kCloseBtnBg,
                        ),
                        child: _EditSheetRow(
                          imagePath: 'assets/images/Erename.png',
                          iconHeight: 22.h,
                          iconWidth: 22.w,
                          label: 'Rename',
                          trailing: Padding(
                            padding: EdgeInsets.only(right: 14.w),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 160.w),
                              child: Text(
                                _renameController.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: _kTextSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // -------- Actions card (with dropdown trigger) --------
                      Container(
                        padding: EdgeInsets.all(14.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.r),
                          color: _kCloseBtnBg,
                        ),
                        child: Column(
                          children: [
                            _EditSheetRow(
                              imagePath: 'assets/images/pin1.png',
                              iconHeight: 20.h,
                              iconWidth: 20.w,
                              label: 'Pin device',
                              onTap: () {},
                            ),
                            SizedBox(height: 14.h),
                            _EditSheetRow(
                              imagePath: 'assets/images/star1.png',
                              iconHeight: 32.h,
                              iconWidth: 32.w,
                              label: 'Add to favorites',
                              onTap: () {},
                            ),
                            SizedBox(height: 14.h),

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

                            // ✅ Add to dashboard (ONE LINE)
                            // _EditSheetRow(
                            //   imagePath: 'assets/images/add_dashboard.png',
                            //   iconHeight: 21.h,
                            //   iconWidth: 21.w,
                            //   label: 'Add to dashboard',
                            //   trailing: _DashboardDropdownTrigger(
                            //     value: _dashboards[_selectedDashboardIndex],
                            //     isOpen: _dashboardDropdownOpen,
                            //     onTap: _toggleDashboardMenu,
                            //   ),
                            // ),

                            SizedBox(height: 14.h),
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
                                    bg: Colors. white,
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
                              onTap: () {},
                            ),
                            SizedBox(height: 14.h),
                            _EditSheetRow(
                              imagePath: 'assets/images/last_active.png',
                              iconHeight: 26.h,
                              iconWidth: 26.w,
                              label: 'Last activities',
                              onTap: () {},
                              trailing: Transform.scale(
                                scale: 1.00,
                                child: SizedBox(
                                  height: 35.h,
                                  width: 60.w,
                                  child: Switch(
                                    value: _lastActivitiesOn,
                                    onChanged: (v) =>
                                        setState(() => _lastActivitiesOn = v),
                                    activeColor: Colors.white,
                                    activeTrackColor: _kBlue,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor:
                                    const Color(0xFFE5E7EB),
                                  ),
                                ),
                              ),
                              
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // -------- Settings/Remove card --------
                      Container(
                        padding: EdgeInsets.only(top: 5.h, right: 10.w, left: 14.w, bottom: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.r),
                          color: _kCloseBtnBg,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            _EditSheetRow(
                              imagePath: 'assets/images/setting.png',
                              iconHeight: 18.h,
                              iconWidth: 18.w,
                              label: 'Settings',
                              onTap: () {},
                            ),
                            SizedBox(height: 16.h),
                            _EditSheetRow(
                              imagePath: 'assets/images/delete1.png',
                              iconWidth: 16.w,
                              iconHeight: 19.h,
                              label: 'Remove',
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
              ],
            ),

            // ✅ Outside tap -> close dropdown
            if (_dashboardDropdownOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeDashboardMenu,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.shrink(),
                ),
              ),

            // ✅ Dropdown overlay (ON TOP OF EVERYTHING)
            if (_dashboardDropdownOpen)
              Positioned(
                right: 32.w,
                top: 250.h, // ⚠️ Adjust this if needed (trigger position)
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
              'Edit device',
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
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: _kCloseBtnBg,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF111827).withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.close, size: 20.sp, color: _kTextPrimary),
              ),
            ),
          ),
        ],
      ),
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
    this.icon,
    this.isDestructive = false,
    this.onTap,
  });

  final String? imagePath;
  final String label;
  final IconData? icon;
  final Widget? trailing;
  final bool isDestructive;
  final double? iconWidth;
  final double? iconHeight;
  final VoidCallback? onTap;

  static const Color _kTextPrimary = Color(0xFF111827);
  static const Color _kIconGrey = Color(0xFF6B7280);
  static const Color _kDestructiveRed = Color(0xFFFE019A);

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? _kDestructiveRed : _kTextPrimary;
    final iconColor = isDestructive ? _kDestructiveRed : _kIconGrey;

    final Widget leading;
    if (imagePath != null) {
      leading = Image.asset(
        imagePath!,
        width: iconWidth ?? 20.w,
        height: iconHeight ?? 20.w,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      );
    } else if (icon != null) {
      leading = Icon(icon, size: iconWidth ?? 20.w, color: iconColor);
    } else {
      leading = SizedBox(width: 20.w, height: 20.w);
    }

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
          SizedBox(width: 8.w),
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
            SizedBox(width: 6.w),
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
        width: width,
        constraints: BoxConstraints(maxHeight: 220.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF111827).withOpacity(0.12),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox.shrink(),
          itemBuilder: (context, i) {
            final selected = i == selectedIndex;
            return InkWell(
              onTap: () => onSelect(i),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        items[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF111827),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    if (selected)
                      Icon(
                        Icons.check_rounded,
                        size: 20.sp,
                        color: const Color(0xFF2563EB),
                      ),
                  ],
                ),
              ),
            );
          },
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: border, width: 1.2.w),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          fontFamily: 'Inter',
          height: 1.0,
        ),
      ),
    );
  }
}