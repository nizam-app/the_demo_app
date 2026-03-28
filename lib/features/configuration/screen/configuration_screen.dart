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
  static const Color _valueColor = Color(0xFF6B7280);
  static const Color _dividerColor = Color(0xFFE1E1E1);
  static const Color _replaceBlue = Color(0xFF0088FE);
  static const Color _deletePink = Color(0xFFFE019A);

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
      title: 'Blind 1',
      subtitle: 'BLIND-4B37-3419-363A-BL1',
      trailing: 'Encoder Blind',
    ),
    (
      title: 'Blind 2',
      subtitle: 'BLIND-4B37-3419-363A-BL2',
      trailing: 'Encoder Blind',
    ),
    (
      title: 'Blind 3',
      subtitle: 'BLIND-4B37-3419-363A-BL3',
      trailing: 'Encoder Blind',
    ),
    (
      title: 'Blind 4',
      subtitle: 'BLIND-4B37-3419-363A-BL4',
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
                    SizedBox(height: 10.h),
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
                    SizedBox(height: 31.h),
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
                    SizedBox(height: 26.h),
                    _pillButton(
                      context,
                      label: 'Replace',
                      color: _replaceBlue,
                      image: "assets/images/Peplace_icon.png",
                      onTap: () {},
                      height: 30.h,
                      width: 30.w, 
                    ),
                    SizedBox(height: 10.h),
                    _pillButton(
                      context,
                      label: 'Delete',
                      color: _deletePink,
                      image: "assets/images/delete1.png",
                      onTap: () {},
                      height: 19.h,
                      width: 16.w, 
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
              'Blinds control unit',
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
                child: Icon(Icons.more_horiz_rounded,color: Colors.black,),
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
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _titleColor,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
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
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: 7.h),
                child: Image.asset("assets/Group 60.png", height: 45.h, width: 30.w, fit: BoxFit.cover),
              ),
              SizedBox(width: 12.w),
              
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
                        color: _titleColor,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: _valueColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 26.h,
                // width: 96.w,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                decoration: BoxDecoration(color: Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(26.r)),
                child: Text(
                  trailing,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover,color:_valueColor )  ,

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
    required String image,
        required double height,
        required double width,
        Color? imageColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: EdgeInsets.only(right: 16.w, left: 16.w),
          child: Container(
            height: 50.h,
            width: double.infinity,
            
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: color, width: 1),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.03),
              //     blurRadius: 6.r,
              //     offset: Offset(0, 2.h),
              //   ),
              // ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image,height: height.h, width: width.w, fit: BoxFit.cover,color:imageColor,),
                SizedBox(width: 5.w),
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
      ),
    );
  }
}