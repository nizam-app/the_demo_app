import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});
  static const routeName = "/UserScreen";

  static const _bg = Color(0xFFF3F4F6);
  static const _textDark = Color(0xFF111827);
  static const _textGrey = Color(0xFF6B7280);
  static const _enabledBlue = Color(0xFF0088FE);
  static const _selectedRow = Color(0xFFEAF1FF);
  static const _divider = Color(0xFFE5E7EB);
  static const _chipDisabledBg = Color(0xFFE1E1E1);
  static const _globeCyan = Color(0xFF00D1FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: const _FabPlus(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(18.w, 14.h, 20.w, 120.h),
          children: [
            const _TopBar(),
            SizedBox(height: 16.h),
            const _SearchBar(),
            SizedBox(height: 22.h),
            const _SectionTitle('Local users'),
            SizedBox(height: 12.h),
            const _UserCardSingle(
              name: 'Aican Support',
              subtitle: 'admin',
              showGlobe: true,
              enabled: true,
            ),
            SizedBox(height: 22.h),
            const _SectionTitle('Remote users'),
            SizedBox(height: 12.h),
            const _UserCardGrouped(
              top: _UserRowData(
                name: 'Demo Account',
                subtitle: 'demo@aican.com',
                showGlobe: true,
                enabled: true,
              ),
              bottom: _UserRowData(
                name: 'Aican Support',
                subtitle: 'demo@aican.com',
                showGlobe: false,
                enabled: false,
                isSelected: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  static const _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(22.r),
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              CupertinoIcons.chevron_left,
              size: 22.sp,
              color: _textDark,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Users',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
          ),
        ),
        SizedBox(width: 44.w), // keeps title centered
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  static const _textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, size: 22.sp, color: _textGrey),
          SizedBox(width: 12.w),
          Text(
            'Search',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: _textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  static const _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        color: _textDark,
        height: 1.1,
      ),
    );
  }
}

class _UserCardSingle extends StatelessWidget {
  const _UserCardSingle({
    required this.name,
    required this.subtitle,
    required this.showGlobe,
    required this.enabled,
  });

  final String name;
  final String subtitle;
  final bool showGlobe;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A111827),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: _UserRow(
        data: _UserRowData(
          name: name,
          subtitle: subtitle,
          showGlobe: showGlobe,
          enabled: enabled,
        ),
        topRadius: 34.r,
        bottomRadius: 34.r,
      ),
    );
  }
}

class _UserCardGrouped extends StatelessWidget {
  const _UserCardGrouped({
    required this.top,
    required this.bottom,
  });

  final _UserRowData top;
  final _UserRowData bottom;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A111827),
              blurRadius: 22.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          children: [
            _UserRow(
              data: top,
              topRadius: 34.r,
              bottomRadius: 0,
            ),
            Divider(height: 1.h, thickness: 1.h, color: UsersScreen._divider),
            _UserRow(
              data: bottom,
              topRadius: 0,
              bottomRadius: 34.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserRowData {
  const _UserRowData({
    required this.name,
    required this.subtitle,
    required this.showGlobe,
    required this.enabled,
    this.isSelected = false,
  });

  final String name;
  final String subtitle;
  final bool showGlobe;
  final bool enabled;
  final bool isSelected;
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.data,
    required this.topRadius,
    required this.bottomRadius,
  });

  final _UserRowData data;
  final double topRadius;
  final double bottomRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.isSelected ? UsersScreen._selectedRow : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        data.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                          color: UsersScreen._textDark,
                        ),
                      ),
                    ),
                    if (data.showGlobe) ...[
                      SizedBox(width: 10.w),
                      Icon(
                        CupertinoIcons.globe,
                        size: 22.sp,
                        color: UsersScreen._globeCyan,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  data.subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: UsersScreen._textGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          const _ActionIcon(CupertinoIcons.person),
          SizedBox(width: 18.w),
          //const _ActionIcon(CupertinoIcons.key),
          SizedBox(width: 18.w),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.gear,
              size: 22.sp,
              color: UsersScreen._textDark,
            ),
          ),
          SizedBox(width: 18.w),
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: data.enabled ? UsersScreen._enabledBlue : UsersScreen._chipDisabledBg,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              data.enabled ? 'Enabled' : 'Disabled',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: data.enabled ? Colors.white : UsersScreen._textGrey,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Icon(
            CupertinoIcons.ellipsis,
            size: 22.sp,
            color: UsersScreen._textGrey,
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 26.sp, color: UsersScreen._textGrey);
  }
}

class _FabPlus extends StatelessWidget {
  const _FabPlus();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: () {},
        child: Container(
          width: 66.w,
          height: 66.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x10111827),
                blurRadius: 22.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.plus,
              size: 34.sp,
              color: UsersScreen._textDark,
            ),
          ),
        ),
      ),
    );
  }
}