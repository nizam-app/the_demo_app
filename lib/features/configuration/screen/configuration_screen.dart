import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widget/global_back_button.dart';

/// Device **Configuration** screen — Details + Properties cards, Replace / Delete actions.
class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  static const String routeName = '/configuration';

  static const Color _screenBg = Color(0xFFF3F4F6);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _titleColor = Color(0xFF111827);
  static const Color _labelColor = Color(0xFF6B7280);
  static const Color _valueColor = Color(0xFF74777F);
  static const Color _dividerColor = Color(0xFFE1E2E4);
  static const Color _replaceBlue = Color(0xFF2196F3);
  static const Color _deletePink = Color(0xFFE91E63);

  static const List<({String label, String value})> _detailsRows = [
    (label: 'Serial Number', value: 'BLIND-4B37-3419-363A'),
    (label: 'Communication Port', value: 'BUS1'),
    (label: 'Protocol Version', value: '3'),
    (label: 'Hardware Revision', value: '2.3'),
    (label: 'Uptime', value: '119d 6h 35m 31s'),
    (label: 'Vcc', value: '3.29 V'),
    (label: 'Temperature', value: '2.3'),
    // Screenshot shows label "Uptime" with temperature value — kept as in design.
    (label: 'Uptime', value: '46.31°C'),
    (label: '24VDC', value: '24.4V'),
  ];

  static const List<({String title, String subtitle, String trailing})>
      _propertyRows = [
    (
      title: 'Salon 1',
      subtitle: 'BLIND-4B37…',
      trailing: 'Encoder Blind',
    ),
    (
      title: 'Salon 2',
      subtitle: 'BLIND-4B37…',
      trailing: 'Encoder Blind',
    ),
    (
      title: 'Kitchen 1',
      subtitle: 'BLIND-4B37…',
      trailing: 'Encoder Blind',
    ),
    (
      title: 'Kitchen 2',
      subtitle: 'BLIND-4B37…',
      trailing: 'Encoder Blind',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Details'),
                    SizedBox(height: 12.h),
                    _roundedCard(
                      child: Column(
                        children: [
                          for (var i = 0; i < _detailsRows.length; i++) ...[
                            if (i > 0) _rowDivider(),
                            _detailRow(
                              _detailsRows[i].label,
                              _detailsRows[i].value,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    _sectionTitle('Properties'),
                    SizedBox(height: 10.h),
                    _roundedCard(
                      child: Column(
                        children: [
                          for (var i = 0; i < _propertyRows.length; i++) ...[
                            if (i > 0) _rowDivider(),
                            _propertyRow(
                              context,
                              title: _propertyRows[i].title,
                              subtitle: _propertyRows[i].subtitle,
                              trailing: _propertyRows[i].trailing,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    _pillButton(
                      context,
                      label: 'Replace',
                      color: _replaceBlue,
                      icon: Icons.sync_rounded,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),
                    _pillButton(
                      context,
                      label: 'Delete',
                      color: _deletePink,
                      icon: Icons.delete_outline_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17.w, 6.h, 17.w, 10.h),
      child: SizedBox(
        height: 40.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GlobalCircleIconBtn(
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
            ),
            Text(
              'Configuration',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: _titleColor,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GlobalCircleIconBtn(
                onTap: () {},
                icon: Icons.more_horiz_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: _titleColor,
        // height: 1.2,
      ),
    );
  }

  Widget _roundedCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: child,
      ),
    );
  }

  Widget _rowDivider() {
    return Divider(height: 1.h, thickness: 1, color: _dividerColor);
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: _labelColor,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: _valueColor,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _propertyRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: _titleColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: _valueColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                trailing,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: _valueColor,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: _valueColor.withOpacity(0.85),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pillButton(
    BuildContext context, {
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22.sp),
              SizedBox(width: 10.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleHeaderButton extends StatelessWidget {
  const _CircleHeaderButton({
    required this.onTap,
    this.child,
    this.icon,
  }) : assert(child != null || icon != null);

  final VoidCallback onTap;
  final Widget? child;
  final IconData? icon;

  static const Color _primaryText = Color(0xFF1A1C1E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: child ??
              Icon(icon, size: 20.sp, color: _primaryText),
        ),
      ),
    );
  }
}