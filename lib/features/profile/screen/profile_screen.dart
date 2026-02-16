import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 17.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlobalCircleIconBtn(
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
                          fontFamily: "Inter",
                        ),
                      ),
                      GlobalCircleIconBtn(
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
                SizedBox(height: 15.h),

                // Profile Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26.r),
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
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF111827),
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
                                borderRadius: BorderRadius.circular(5.r),
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
                SizedBox(height: 24.h),

                // Information Section
                _Section(
                  title: 'Information',
                  child: _CardList(
                    children: const [
                      _KeyValueRow(label: 'Name', value: 'Oren Elimelech'),
                      _DividerLine(),
                      _KeyValueRow(label: 'Email', value: 'oren@aican.co.il'),
                      _DividerLine(),
                      _KeyValueRow(label: 'Phone', value: '0547640189'),
                      _DividerLine(),
                      _KeyValueRow(
                        label: 'Address',
                        value: 'Margalit 54 Shoham Israel',
                      ),
                      _DividerLine(),
                      _KeyValueRow(label: 'Categories', value: 'Electrician'),
                    ],
                  ),
                ),

                // Account Section
                _Section(
                  title: 'Account',
                  child: _CardList(
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
                        onTap: () =>
                            setState(() => rolesEnabled = !rolesEnabled),
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
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 26.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26.r),
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

                // Update Account Button
                Padding(
                  padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 40.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(26.r),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5D65FF), Color(0xFF0088FE)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/download.png',
                                width: 18.w,
                                height: 18.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 8.w),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        Color(0xFF0088FE),
                                        Color(0xFF0088FE),
                                      ],
                                    ).createShader(bounds),
                                child: Text(
                                  'Update Account',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
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
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6.w, bottom: 16.h),
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
          child,
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _CardList extends StatelessWidget {
  const _CardList({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Column(children: children),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});
  final String label;
  final String value;

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
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
                fontFamily: 'Inter',
              ),
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
                    color:
                     enabled
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