import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/configuration/screen/configuration_screen.dart';

import '../../../core/widget/global_back_button.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static const String routeName = '/setting-device';

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const Color _screenBg = Color(0xFFF3F4F6);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _primaryText = Color(0xFF111827);
  static const Color _secondaryText = Color(0xFF6B7280);
  static const Color _dividerColor = Color(0xFFE1E1E1);
  static const Color _blue = Color(0xFF0088FE);
  static const Color _deletePink = Color(0xFFD81B60);

  bool _useOtherWhenOff = false;
  bool _negateOutput = true;
  bool _relativeLuminance = true;
  bool _acDimming = true;

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
                padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Inputs'),
                    SizedBox(height: 10.h),
                    _whiteCard(
                      child: Column(
                        children: [
                          _chevronValueRow('Min Value', '0%'),
                          _rowDivider(),
                          _chevronValueRow('Max Value', '100%'),
                          _rowDivider(),
                          _toggleRow(
                            label: 'Use Other value when output is turned off',
                            value: _useOtherWhenOff,
                            onChanged: (v) => setState(() => _useOtherWhenOff = v),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _whiteCard(
                      child: _titleSubtitleToggleRow(
                        title: 'Negate Output',
                        subtitle:
                            'E.g value 80% sets physical device to 20%',
                        value: _negateOutput,
                        onChanged: (v) => setState(() => _negateOutput = v),
                      ),
                    ),


                    //Work is done in check. 


                    SizedBox(height: 14.h),
                    _whiteCard(
                      child: _titleSubtitleToggleRow(
                        title: 'Relative Luminance',
                        subtitle:
                            'Based on CIE 1391 standard, Increase of light.'
                            'non-linear curve so dimming feels more natural to the eye.',
                        value: _relativeLuminance,
                        onChanged: (v) =>
                            setState(() => _relativeLuminance = v),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _whiteCard(
                      child: _titleSubtitleToggleRow(
                        title: 'AC Dimming',
                        subtitle:
                            'Linearizes electrical power delivery for AC loads so '
                            'brightness changes more evenly across the dimming range.',
                        value: _acDimming,
                        onChanged: (v) => setState(() => _acDimming = v),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    _sectionTitle('Adaptations'),
                    SizedBox(height: 10.h),
                    _whiteCard(
                      child: Column(
                        children: [
                          _chevronValueRow('Dimmer Step Time', '200 ms'),
                          _rowDivider(),
                          _chevronOnlyRow('Icon'),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    _sectionTitle('PMW'),
                    SizedBox(height: 10.h),
                    _whiteCard(
                      child: _chevronValueRow(
                        'PMW frequency for UO1-2, UO7-8',
                        '25000Hz',
                        titleMaxLines: 2,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    _pillOutlineButton(
                      label: 'Configuration',
                      color: _blue,
                      icon: Icons.tune_rounded,
                      onTap: () {
                        context.push(ConfigurationScreen.routeName); 
                      },
                    ),
                    SizedBox(height: 12.h),
                    _pillOutlineButton(
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
      padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GlobalCircleIconBtn(
                    color: Colors.white,
                    child: Image.asset(
                      'assets/aro.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.go('/menu');
                      }
                    },
                  ),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: _primaryText,
                  ),
                ),
             
                Align(
                  alignment: Alignment.centerRight,
                  child: GlobalCircleIconBtn(
                    icon: Icons.more_horiz_rounded,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h,),  
          Text(
            'Original value is set as it was before the failure',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: _secondaryText,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
  /// White circle with soft shadow (back / overflow menu).
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: _primaryText,
      ),
    );
  }
  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(26.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.04),
        //     blurRadius: 8.r,
        //     offset: Offset(0, 2.h),
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: child,
      ),
    );
  }
  Widget _rowDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Divider(height: 1.h, thickness: 1, color: _dividerColor),
    );
  }
  Widget _chevronValueRow(
    String title,
    String value, {
    int titleMaxLines = 1,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: titleMaxLines,
                overflow: titleMaxLines > 1
                    ? TextOverflow.clip
                    : TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: _primaryText,
                  height: 1.25,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _secondaryText,
              ),
            ),
            SizedBox(width: 4.w),
             Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit:BoxFit.cover,color: _secondaryText)  ,
          ],
        ),
      ),
    );
  }
  Widget _chevronOnlyRow(String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: _primaryText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: _secondaryText.withOpacity(0.7),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 12.w, 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _primaryText,
                height: 1.3,
              ),
            ),
          ),
          Transform. scale(
            scale: 0.82,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: _blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleSubtitleToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 12.w, 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontWeight: FontWeight.w400,
                    color: _primaryText,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w300,
                    color: _primaryText,
                     height: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5.w),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Transform.scale(
              scale: 0.82,
              child: CupertinoSwitch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: _blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillOutlineButton({
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
            border: Border.all(color: color, width: 1.5),
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