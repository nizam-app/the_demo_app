import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:workpleis/core/widget/global_back_button.dart';

/// Core settings screen — layout matches design: grouped white cards on light grey.
class CoreScreen extends StatefulWidget {
  const CoreScreen({super.key});

  static const String routeName = '/core';

  @override
  State<CoreScreen> createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> {
  static const Color _screenBg = Color(0xFFF3F4F6);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _titleColor = Color(0xFF111827);
  static const Color _valueColor = Color(0xFF6B7280);
  static const Color _dividerColor = Color(0xFFE1E1E1);
  static const Color _linkBlue = Color(0xFF0088FE);
  static const Color _badgeGreyBg = Color(0xFFDAE0E8);
  static const Color _cloudBadgeBg = Color(0xFF00D1FF);
  static const Color _dhcpGreen = Color(0xFF53DB6C);

  bool _dhcpEnabled = true;

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
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Information'),
                    SizedBox(height: 18.h),
                    _whiteCard(
                      child: Column(
                        children: [
                          _kvRow('Version', '2025.1.31472'),
                          _divider(),
                          _kvRow('Core Process Uptime', '0d 10h 7m 32s'),
                          _divider(),
                          _kvRow('OS Image Version', '2.4(lh)'),
                          _divider(),
                          _kvRow('Current Time', '08.05.2025 10:08:02'),
                          _divider(),
                          _kvRow('IP Address', '192.168.103.192'),
                          _divider(),
                          _kvRow('Mac Address', '00:81:14:72:72:D0'),
                          _divider(),
                          _kvRow('mDNS Name', 'Demo-Account.local'),
                          _divider(),
                          _accessTokenRow(),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    _sectionTitle('Connected users'),
                    SizedBox(height: 18.h),
                    _whiteCard(
                      child: _connectedUserRow(),
                    ),
                    SizedBox(height: 18.h),
                    _sectionTitle('Inputs'),
                    SizedBox(height: 21.h),
                    _whiteCard(
                      child: Column(
                        children: [
                          _chevronRow('Latitude', '48.208579°'),
                          _divider(),
                          _chevronRow('Longitude', '16.374124°'),
                          _divider(),
                          _chevronRow('Timezone', 'Europe/Berlin'),
                          _divider(),
                          _languageRow(),
                          _divider(),
                          _kvRow('Currency', '\$'),
                          _divider(),
                          _kvRow('Currency position', '123.45\$'),
                          _divider(),
                          _linkChevronRow('Date Periods'),
                          _divider(),
                          _linkChevronRow('Media Library'),
                        ],
                      ),
                    ),
                    SizedBox(height: 39.h),
                    _sectionTitle('Network'),
                    SizedBox(height: 6.h),
                    _dhcpRow(),
                    SizedBox(height: 10.h),
                    _whiteCard(
                      child: Column(
                        children: [
                          _kvRow('Ip Address', '192.168.103.192'),
                          _divider(),
                          _kvRow('Network Mask', '255.255.255.0'),
                          _divider(),
                          _kvRow('Gateway', '192.168.103.1'),
                          _divider(),
                          _kvRow('DNS Server', '192.168.103.1'),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    _sectionTitle('Backup & Restore'),
                    SizedBox(height: 10.h),
                    _whiteCard(
                      child: Column(
                        children: [
                          _linkOnlyRow('Create a backup'),
                          _divider(),
                          _linkOnlyRow('Restore from backup'),
                          _divider(),
                          _linkOnlyRow('Clone control unit from backup'),
                          _divider(),
                          _linkOnlyRow('Factory reset'),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    _sectionTitle('Log'),
                    SizedBox(height: 10.h),
                    _whiteCard(
                      child: _chevronRowSimple('User and Updates'),
                    ),
                    SizedBox(height: 26.h),
                    _outlineActionButton(
                      label: 'Update firmware',
                      image: "assets/download.png",
                      onTap: () {},
                    ),
                    SizedBox(height: 10.h),
                    _outlineActionButton(
                      label: 'Restart Core',
                      image: "assets/images/reload_icon.png",
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
      padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 10.h),
      child: SizedBox(
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
                    context.go('/settings');
                  }
                },
              ),
            ),
            Text(
              'Core',
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
                color: Colors.white,
                icon: Icons.more_horiz_rounded,
                onTap: () {},
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
        height: 1.2,
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
        //     blurRadius: 10.r,
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

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Divider(height: 1.h, thickness: 1, color: _dividerColor),
    );
  }

  Widget _kvRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: Text(
              label,
              textAlign: TextAlign.start,
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
            flex: 7,
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

  Widget _accessTokenRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Access token',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _titleColor,
              ),
            ),
          ),
          Container(
            height: 23.h,
            padding: EdgeInsets.symmetric(horizontal: 6.w, ),
            decoration: BoxDecoration(
              color: _badgeGreyBg,
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Center(
              child: Text(
                '*KX5Z',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: _titleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectedUserRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Demo Account',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _titleColor,
              ),
            ),
          ),
          Container(
            height: 23.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, ),
            decoration: BoxDecoration(
              color: _cloudBadgeBg,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Image.asset("assets/images/glog.png", height: 13.h, width: 13.w,color: Colors.white, ),
                SizedBox(width: 4.w),
                Text(
                  'Cloud',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chevronRow(String label, String value) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: _titleColor,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _valueColor,
              ),
            ),
            SizedBox(width: 6.w),
            Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover,),
          ],
        ),
      ),
    );
  }

  Widget _languageRow() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Language',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: _titleColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Affects the language settings of devices connected to this location. '
                    'Language settings of mobile devices are not affected.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w300,
                      color: _valueColor,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w,),
            Image.asset('assets/back_arro.png', height: 13.h, width: 13.w, fit: BoxFit.cover,)
          ],
        ),
      ),
    );
  }

  Widget _linkChevronRow(String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: _linkBlue,
                ),
              ),
            ),
            Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover, color: _linkBlue,)
          ],
        ),
      ),
    );
  }

  Widget _linkOnlyRow(String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: _linkBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _chevronRowSimple(String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: _titleColor,
                ),
              ),
            ),
            Image.asset("assets/back_arro.png", height: 13.h, width: 13.w, fit: BoxFit.cover,),
          ],
        ),
      ),
    );
  }

  Widget _dhcpRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Enable DHCP',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: _valueColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _dhcpEnabled = !_dhcpEnabled),
            child: Icon(
              _dhcpEnabled ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: _dhcpEnabled ? _dhcpGreen : _dividerColor,
              size: 26.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineActionButton({
    required String label,
    required String image,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26.r),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.r),
              color: Colors.white,
              border: Border.all(color: _linkBlue, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, height: 18.h, width: 18.w, fit: BoxFit.cover,),
                SizedBox(width: 7.w),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: _linkBlue,
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