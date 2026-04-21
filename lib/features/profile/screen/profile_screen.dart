import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
// Optional (for exact svg icons)
// import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool rolesEnabled = true;
  bool remoteAccessEnabled = true;

  static const _pageBg = Color(0xFFF3F4F6);
  static const _cardRadius = 26.0;
  static const _pageHorizontalPad = 16.0;

  @override
  Widget build(BuildContext context) {
    const screenBg = _pageBg;
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final headerChrome = 56.h;
    final scrollTopPadding = topInset + headerChrome + 10.h;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: screenBg,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(color: screenBg),
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: scrollTopPadding,
                    bottom: 8.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),

                        // Profile Card
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _pageHorizontalPad.w,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(_cardRadius.r),
                            ),
                            child: Row(
                            children: [
                              EditableAvatar(
                                imageAsset:
                                    'assets/b52badd361701e47675a4d4e9fd86fec8d5291c1.png',
                                cameraAsset: 'assets/image 44.png',
                                onTapCamera: () {},
                                size: 68,
                              ),

                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Oren Elimelech',
                                      style: TextStyle(
                                        fontSize: 21.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF111827),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'oren@aican.co.il',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00D1FF),
                                        borderRadius: BorderRadius.circular(
                                          5.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/Mask group (9).png',
                                            width: 14.w,
                                            height: 14.w,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            'Cloud',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Information Section
                        _Section(
                          title: 'Information',
                          horizontalPad: _pageHorizontalPad.w,
                          child: _CardList(
                            borderRadius: _cardRadius.r,
                            children: const [
                              _KeyValueRow(
                                label: 'Name',
                                value: 'Oren Elimelech',
                              ),
                              _DividerLine(),
                              _KeyValueRow(
                                label: 'Email',
                                value: 'oren@aican.co.il',
                              ),
                              _DividerLine(),
                              _KeyValueRow(label: 'Phone', value: '0547640189'),
                              _DividerLine(),
                              _KeyValueRow(
                                label: 'Address',
                                value: 'Margalit 54 Shoham Israel',
                              ),
                              _DividerLine(),
                              _KeyValueRow(
                                label: 'Categories',
                                value: 'Electrician',
                                showChevron: true,
                              ),
                            ],
                          ),
                        ),

                        // Account Section
                        _Section(
                          title: 'Account',
                          horizontalPad: _pageHorizontalPad.w,
                          child: _CardList(
                            borderRadius: _cardRadius.r,
                            children: [
                              const _KeyValueRow(
                                label: 'Email',
                                value: 'oren@aican.co.il',
                              ),
                              const _DividerLine(),
                              const _KeyValueRow(
                                label: 'Password',
                                value: '*****************',
                              ),
                              const _DividerLine(),
                              _ToggleCircleRow(
                                label: 'Roles',
                                enabled: rolesEnabled,
                                onTap: () => setState(
                                  () => rolesEnabled = !rolesEnabled,
                                ),
                                image1: 'assets/persion.png',
                                image2: 'assets/key.png',
                                image3: 'assets/seting.png',
                              ),
                              const _DividerLine(),
                              _RemoteAccessRow(
                                enabled: remoteAccessEnabled,
                                onChanged: (v) =>
                                    setState(() => remoteAccessEnabled = v),
                              ),
                            ],
                          ),
                        ),

                        // Connect Section
                        _Section(
                          title: 'Connect',
                          horizontalPad: _pageHorizontalPad.w,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 26.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(_cardRadius.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _ConnectItem(
                                  label: 'Apple',
                                  icon: Image.asset(
                                    'assets/apple.png',
                                    width: 32.w,
                                    height: 32.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                _ConnectItem(
                                  label: 'Google',
                                  icon: Image.asset(
                                    'assets/google.png',
                                    width: 29.w,
                                    height: 29.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Save (outline pill — design spec)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            _pageHorizontalPad.w,
                            8.h,
                            _pageHorizontalPad.w,
                            24.h + bottomInset,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(_cardRadius.r),
                              child: Ink(
                                height: 55.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(_cardRadius.r),
                                  border: Border.all(
                                    color: const Color(0xFF0088FE),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_circle_up_outlined,
                                      size: 22.sp,
                                      color: const Color(0xFF0088FE),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0088FE),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        padding: EdgeInsets.fromLTRB(
                          15.w,
                          topInset + 10.h,
                          15.w,
                          8.h,
                        ),
                        child: SizedBox(
                          height: 40.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GlobalCircleIconBtn(
                                color: Color(0xFFFFFFFF),
                                child: Image.asset(
                                  'assets/aro.png',
                                  width: 16.w,
                                  height: 16.h,
                                ),
                                onTap: () => Navigator.maybePop(context),
                              ),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF111827),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              GlobalCircleIconBtn(
                              color: Color(0xFFFFFFFF),
                                child: Image.asset(
                                  'assets/image 89 (1).png',
                                  width: 22.w,
                                  height: 22.w,
                                  fit: BoxFit.contain,
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditableAvatar extends StatelessWidget {
  const EditableAvatar({
    super.key,
    required this.imageAsset,
    required this.onTapCamera,
    this.size = 68,
    required this.cameraAsset,
  });

  final String imageAsset;
  final String cameraAsset;
  final VoidCallback onTapCamera;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = size.w;

    // Screenshot-like ratios
    final outer = s * 0.46; // big light circle
    final inner = s * 0.34; // small darker circle
    final badgeTop = s - (outer * 0.25); // 25% overlap into avatar

    return SizedBox(
      width: s,
      height: s + (outer * 0.75), // extra space for badge bottom
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Avatar
          Positioned(
            top: 0,
            child: ClipOval(
              child: Image.asset(
                imageAsset,
                width: s,
                height: s,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: s,
                  height: s,
                  color: const Color(0xFFE5E7EB),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person,
                    size: s * 0.40,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),

          // Badge (2 circles + icon)
          Positioned(
            top: badgeTop,
            child: GestureDetector(
              onTap: onTapCamera,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer light circle
                  Container(
                    width: outer,
                    height: outer,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF3F4F6).withOpacity(0.85),
                    ),
                  ),

                  // Inner darker circle
                  Container(
                    width: inner,
                    height: inner,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD1D5DB).withOpacity(0.90),
                    ),
                  ),

                  // Camera icon image
                  Image.asset(
                    cameraAsset,
                    width: inner * 0.82,
                    height: inner * 0.82,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------- Small Widgets -------------------- */

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    required this.horizontalPad,
  });

  final String title;
  final Widget child;
  final double horizontalPad;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPad, 0, horizontalPad, 16.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
              fontFamily: 'Inter',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPad),
          child: child,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _CardList extends StatelessWidget {
  const _CardList({
    required this.children,
    required this.borderRadius,
  });

  final List<Widget> children;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.label,
    required this.value,
    this.showChevron = false,
  });

  final String label;
  final String value;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      constraints: BoxConstraints(minHeight: 56.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
              fontFamily: 'Inter',
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (showChevron) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      color: const Color(0xFFE1E1E1),
    );
  }
}

// Roles (32x32 circle buttons) with 3 role icons
class _ToggleCircleRow extends StatelessWidget {
  const _ToggleCircleRow({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.image1,
    this.image2,
    this.image3,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final String? image1;
  final String? image2;
  final String? image3;

  @override
  Widget build(BuildContext context) {
    final hasImages = image1 != null && image2 != null && image3 != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      color: Color(0xFFFFFFFF),
      constraints: BoxConstraints(minHeight: 56.h),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          if (hasImages)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RoleIcon(asset: image1!, active: enabled),
                  SizedBox(width: 8.w),
                  _RoleIcon(asset: image2!, active: false),
                  SizedBox(width: 8.w),
                  _RoleIcon(asset: image3!, active: false),
                ],
              ),
            )
          else
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                width: 32.w,
                height: 32.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: enabled
                        ? const Color(0xFF0088FE)
                        : const Color(0xFFE1E1E1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoleIcon extends StatelessWidget {
  const _RoleIcon({
    required this.asset,
    required this.active,
    this.boxSize = 32, // tap area + visual size
  });

  final String asset;
  final bool active;
  final double boxSize;

  @override
  Widget build(BuildContext context) {
    final s = boxSize.w;

    if (active) {
      return Container(
        width: s,
        height: s,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE1E1E1),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          asset,
          width: s * 0.50, // smaller icon inside
          height: s * 0.50,
          fit: BoxFit.contain,
          color: Color(0xFF6B7280),
          colorBlendMode: BlendMode.srcIn,
        ),
      );
    }

    // inactive: only icon (no circle), but same tap area width
    return SizedBox(
      width: s,
      height: s,
      child: Center(
        child: Image.asset(
          asset,
          width: s * 0.56,
          height: s * 0.56,
          fit: BoxFit.contain,
          color: const Color(0xFF6B7280), // screenshot-like grey
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}

// Remote access (60x35 pill switch) like React
class _RemoteAccessRow extends StatelessWidget {
  const _RemoteAccessRow({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      constraints: BoxConstraints(minHeight: 56.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Remote access',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!enabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 60.w,
              height: 35.h,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: enabled
                    ? const Color(0xFF0088FE)
                    : const Color(0xFFE1E1E1),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: enabled
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 31.w,
                  height: 31.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectItem extends StatelessWidget {
  const _ConnectItem({required this.label, required this.icon});
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: 32.w,
            height: 32.w,
            child: FittedBox(child: icon),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,

            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '+',
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w100,
            height: 1,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}