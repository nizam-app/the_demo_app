import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Public widget
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
    'Lighting section name',
  ];

  // For perfect dropdown anchoring (no hardcoded top)
  final LayerLink _dropdownLink = LayerLink();

  // Colors
  static const Color _kTextPrimary = Color(0xFF111827);
  static const Color _kTextSecondary = Color(0xFF6B7280);
  static const Color _kIconGrey = Color(0xFF6B7280);
  static const Color _kDestructiveRed = Color(0xFFFE019A);
  static const Color _kSheetBg = Color(0xFFF3F4F6);
  static const Color _kCardBg = Colors.white;
  static const Color _kDivider = Color(0xFFE5E7EB);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSheetBg.withOpacity(0.74),
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
            // ===== Main content =====
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    children: [
                      // Rename Card
                      _Card(
                        child: _EditSheetRow(
                          imagePath: 'assets/images/rename.png',
                          iconWidth: 22.w,
                          iconHeight: 22.h,
                          label: 'Rename',
                          trailing: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 170.w),
                            child: Text(
                              _renameController.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: _kTextSecondary,
                                fontFamily: 'Inter',
                              ),
                            ),
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
                              onTap: () {},
                            ),

                            SizedBox(height: 12.h),

                            // Last activities (big switch)
                            _EditSheetRow(
                              imagePath: 'assets/images/last_active.png',
                              iconWidth: 26.w,
                              iconHeight: 26.h,
                              label: 'Last activities',
                              trailing: Transform.scale(
                                scale: 1.05,
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

            // ===== Outside tap closes dropdown =====
            if (_dashboardDropdownOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeDashboardMenu,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.shrink(),
                ),
              ),

            // ===== Dropdown overlay (on top, auto positioned under trigger) =====
            if (_dashboardDropdownOpen)
              CompositedTransformFollower(
                link: _dropdownLink,
                showWhenUnlinked: false,
                offset: Offset(-10.w, 36.h), // trigger এর নিচে
                child: _DashboardDropdownMenu(
                  width: 230.w,
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
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Edit smart device',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: _kTextPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          // close
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close_rounded,
                  size: 20.sp, color: _kTextPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
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

  static const Color _kCardBg = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: _kCardBg,
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
  static const Color _kIconGrey = Color(0xFF6B7280);
  static const Color _kDestructiveRed = Color(0xFFFF2D92);

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? _kDestructiveRed : _kTextPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26.r),
      child: Row(
        children: [
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: Center(
              child: imagePath == null
                  ? const SizedBox.shrink()
                  : Image.asset(
                imagePath!,
                width: iconWidth ?? 20.w,
                height: iconHeight ?? 20.w,
                fit: BoxFit.contain,
                color: isDestructive ? _kDestructiveRed : null,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
                fontFamily: 'Inter',
              ),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 10.w),
            trailing!,
          ],
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
              blurRadius: 26.r,
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
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
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