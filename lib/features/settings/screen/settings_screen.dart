import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/cores/screen/cores_screen.dart';

/// Single base size for all settings row icons (Profile, Core, Interfaces, etc.).
const double _settingsIconSize = 20;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';

  // Colors (match design)
  static const _bg = Color(0xFFF3F4F6);
  static const _card = Colors.white;
  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);
  static const _divider = Color(0xFFE5E7EB);
  static const _pink = Color(0xFFFE019A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 22.h),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    // Account Information Card
                    _buildAccountCard(),
                    SizedBox(height: 30.h),
                    // General Settings Card
                    _buildGeneralSettingsCard(context),
                    SizedBox(height: 30.h),
                    // Assistance and Preferences Card
                    _buildAssistanceCard(),
                    SizedBox(height: 30.h),
                    // Sign Out Card
                    _buildSignOutCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Row(
        children: [
          GlobalCircleIconBtn(
            child: Image.asset(
              'assets/aro.png',
              width: 16.w,
              height: 16.h,
            ),
            onTap: () => Navigator.maybePop(context),
            // color: Color(0xFFF3F4F6),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          // Account Info Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Profile Picture
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF3F4F6),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profileimage.png',
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 32.sp,
                          color: _secondary,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Account Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Account',
                        style: TextStyle(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w400,
                          color: _primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'demo@aican.com',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: _secondary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 15,),

                      Container(
                        height: 1.h,
                        color: _divider,
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          // Profile Option
         Padding(
           padding:  EdgeInsets.only(left: 22.w, right: 18.w,bottom: 18.w),
           child: Row(
              children: [
                  SizedBox(
                    width:18.w,
                    height: 18.h,
                    child: Center(
                      child: Image.asset(
                        "assets/images/profile_icon.png",
                        width: 18.w,
                        height: 18.h,
                        fit: BoxFit.contain,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color:  _primary,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),

                Image.asset(
                  "assets/Mask group copy 4.png",
                  width: 13.sp,
                  height: 13.sp,

                ),
              ],
            ),
         ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingsCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          _SettingsRow(
            imagePath: 'assets/images/core.png',
            title: 'Core',
            iconWidth: 22.w,
            iconHeight: 22.h,
            onTap: () => context.push(CoresScreen.routeName),
          ),
          _Divider(),
          _SettingsRow(
            imagePath: 'assets/images/interface.png',
            title: 'Interfaces',
            iconWidth: 20.w,
            iconHeight: 20.h,
            onTap: () {},
          ),
          _Divider(),
          _SettingsRow(
            imagePath: 'assets/images/itegrations.png',
            title: 'Integrations',
            iconWidth: 20.w,
            iconHeight: 20.h,
            onTap: () {},
          ),
          _Divider(),
          _SettingsRow(
            imagePath: 'assets/images/user.png',
            title: 'User Management',
            badge: '1',
            iconWidth: 22.w,
            iconHeight: 22.h,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAssistanceCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          _SettingsRow(
            imagePath: 'assets/images/voice.png',
            title: 'Voice Assistance',
            iconWidth: 14.w,
            iconHeight: 21.h,
            onTap: () {},
          ),
          _Divider(),
          _SettingsRow(
            imagePath: 'assets/images/apps.png',
            title: 'App Preferences',
            iconWidth: 30.w,
            iconHeight: 30.h,
            onTap: () {},
            
          ),

        ],
      ),
    );
  }

  Widget _buildSignOutCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: _SettingsRow(
        imagePath: 'assets/images/sign-out.png',
        title: 'Sign Out',
        titleColor: _pink,
        showTrailingIcon: false,
        iconWidth: 25.w,
        iconHeight: 25.h,
        onTap: () {
          // Handle sign out
        },
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    this.imagePath,
    required this.title,
    this.onTap,
    this.badge,
    this.titleColor,
    this.showTrailingIcon = true,
    this.iconWidth,
    this.iconHeight,
  });

  final String? imagePath;
  final String title;
  final VoidCallback? onTap;
  final String? badge;
  final Color? titleColor;
  final bool showTrailingIcon;
  final double? iconWidth;
  final double? iconHeight;

  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);
  static const _blue = Color(0xFF15DFFE);

  @override
  Widget build(BuildContext context) {
    final imgW = (iconWidth ?? _settingsIconSize).w;
    final imgH = (iconHeight ?? _settingsIconSize).h;
    
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: _primary.withOpacity(0.04),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            if (imagePath != null) ...[
              SizedBox(
                width: _settingsIconSize.w,
                height: _settingsIconSize.h,
                child: Center(
                  child: Image.asset(
                    imagePath!,
                    width: imgW,
                    height: imgH,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: titleColor ?? _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                width: 30.w,
                height: 30.h,
                decoration:  BoxDecoration(
                  color: _blue,
                 borderRadius: BorderRadius.circular(30.sp),
                 // shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
            if (showTrailingIcon)
              Image.asset(
                'assets/Mask group copy 4.png',
                width: 13.w,
                height: 13.h,

              ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  static const _divider = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    // Align with text: horizontal padding (16) + icon size + gap (12)
    final leftMargin = 16.w + _settingsIconSize.w + 12.w;
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: leftMargin, right: 17.w),
      color: _divider,
    );
  }
}