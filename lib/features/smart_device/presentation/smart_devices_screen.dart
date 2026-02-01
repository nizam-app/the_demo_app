import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SmartDevicesScreen extends StatefulWidget {
  const SmartDevicesScreen({super.key});

  static const String routeName = '/smart-devices';

  @override
  State<SmartDevicesScreen> createState() => _SmartDevicesScreenState();
}

class _SmartDevicesScreenState extends State<SmartDevicesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Colors (match screenshot)
  static const _bg = Colors.white;
  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);
  static const _muted = Color(0xFF9CA3AF);
  static const _divider = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF0088FE);
  static const _pink = Color(0xFFFF2D92);
  static const _green = Color(0xFF22C55E);

  // ✅ Your asset paths (change if needed)
  static const _icAlarm = 'assets/images/lock.png';
  static const _icBathroom = 'assets/images/bathroom.png';
  static const _icPlay = 'assets/images/play.png';
  static const _icFan =
      'assets/images/fan.png'; // Using ventilation as fan alternative
  static const _icHeatCool =
      'assets/images/heating_cooling.png'; // Using heating as alternative
  static const _icIrrigation = 'assets/images/irrigation.png';
  static const _icKitchen = 'assets/images/kitchen.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            _buildSectionTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(children: [_buildDeviceList()]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Header (like screenshot)
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                size: 24.sp,
                color: _primary,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Smart devices',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 22.sp,
                  color: _primary,
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/images/+.png"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Search (gradient border only)
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.all(1.5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF0088FE), Color(0xFF8B5CF6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          height: 46.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: 22.sp, color: const Color(0xFF6B7280)),
              SizedBox(width: 8.w),
              Text(
                'Search',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Section title
  Widget _buildSectionTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Smart devices',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: _primary,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  // ✅ Divider aligned after icon
  Widget _buildDivider() {
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: 72.w, right: 16.w),
      color: _divider,
    );
  }

  // ✅ Left icon ring using Image.asset
  Widget _leftIconAsset({
    required String imagePath,
    required Color ringColor,
    IconData? fallbackIcon,
  }) {
    return Center(
      child: Image.asset(
        imagePath,
        width: 39.w,
        height: 39.w,
        fit: BoxFit.contain,
        // filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if image fails to load
          return Icon(
            fallbackIcon ?? Icons.devices_rounded,
            size: 39.sp,
            color: ringColor,
          );
        },
      ),
    );
  }

  // ✅ Reusable row
  Widget _buildDeviceRow({
    required Widget leading,
    required String title,
    required Widget subtitle,
    required Widget trailing,
    Color? backgroundColor,
  }) {
    return Container(
      color: backgroundColor ?? Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          leading,
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: _primary,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 4.h),
                subtitle,
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  // ✅ Whole list (match screenshot)
  Widget _buildDeviceList() {
    return Column(
      children: [
        // 1) Alarm
        _buildDeviceRow(
          leading: _leftIconAsset(
            imagePath: _icAlarm,
            ringColor: _pink,
            fallbackIcon: Icons.lock_outline_rounded,
          ),
          title: 'Alram',
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InlineText('Disarmed'),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: Color(0xFF0088FE)),
                    ),
                    child: _TagChip(
                      label: 'Lighting',
                      bg: Color(0xFFFFFFFF),
                      fg: _primary,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  _TagChip(label: 'Bathroom', bg: _pink, fg: Colors.white),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/pin.png',
                    width: 16.w,
                    height: 16.w,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '18:32',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: _muted,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),

              SizedBox(width: 10.w),
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pause_rounded,
                  size: 20.sp,
                  color: _secondary,
                ),
              ),
            ],
          ),
        ),
        _buildDivider(),

        // 2) Bathroom
        _buildDeviceRow(
          leading: _leftIconAsset(
            imagePath: _icBathroom,
            ringColor: const Color(0xFF8B5CF6),
            fallbackIcon: Icons.water_drop_outlined,
          ),
          title: 'Bathroom',
          subtitle: Row(
            children: [
              const _SmallCircleText('A'),
              SizedBox(width: 6.w),
              Icon(
                Icons.thermostat_rounded,
                size: 16.sp,
                color: const Color(0xFF3B82F6),
              ),
              SizedBox(width: 6.w),
              Text(
                'Off',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          trailing: Container(
            width: 152.w,
            height: 39.h,
            padding: EdgeInsets.only(left: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(999.r),
            ),
            alignment: Alignment.centerLeft,
            child: Image.asset("assets/images/power.png"),
          ),
        ),
        _buildDivider(),

        // 3) Block Irrigation Schedule
        _buildDeviceRow(
          leading: _leftIconAsset(
            imagePath: _icPlay,
            ringColor: const Color(0xFF0EA5E9),
            fallbackIcon: Icons.play_circle_outline_rounded,
          ),
          title: 'Block Irrigation Schedule',
          subtitle: const _InlineText('Active', bold: true),
          trailing: Container(
            width: 42.w,
            height: 42.w,
            decoration: const BoxDecoration(
              color: _green,
              shape: BoxShape.circle,
            ),
            child: Image.asset("assets/images/charge.png", height: 22.h),
          ),
        ),
        _buildDivider(),

        // 4) Fan
        _buildDeviceRow(
          leading: _leftIconAsset(
            imagePath: _icFan,
            ringColor: const Color(0xFF0EA5E9),
            fallbackIcon: Icons.ac_unit_rounded,
          ),
          title: 'Fan(3 levels)',
          subtitle: Row(
            children: [
              const _SmallCircleText('M'),
              SizedBox(width: 8.w),
              Text(
                'Off',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 18.sp,
                    color: const Color(0xFFFBBF24),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '20:36',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _muted,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.w),
              Row(
                children: [
                  _CircleButton(
                    icon: Icons.keyboard_arrow_up_rounded,

                    onTap: () {},
                  ),
                  SizedBox(width: 8.w),
                  _CircleButton(
                    icon: Icons.keyboard_arrow_down_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildDivider(),

        // 5) Heating & Cooling (selected)
        _buildDeviceRow(
          backgroundColor: const Color(0xFFEAF1FF),
          leading: _leftIconAsset(
            imagePath: _icHeatCool,
            ringColor: _blue,
            fallbackIcon: Icons.thermostat_rounded,
          ),
          title: 'Heating & Cooling',
          subtitle: const _InlineText('Heating', bold: true),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleButton(icon: Icons.remove_rounded, onTap: () {}),
              SizedBox(width: 10.w),
              _CircleButton(icon: Icons.add_rounded, onTap: () {}),
            ],
          ),
        ),
        _buildDivider(),

        // 6) Irrigation
        _buildDeviceRow(
          leading: _leftIconAsset(
            imagePath: _icIrrigation,
            ringColor: _green,
            fallbackIcon: Icons.local_florist_rounded,
          ),
          title: 'Irrigation',
          subtitle: const _InlineText('0', bold: true),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleButton(icon: Icons.chevron_left_rounded, onTap: () {}),
              SizedBox(width: 10.w),
              _CircleButton(icon: Icons.chevron_right_rounded, onTap: () {}),
            ],
          ),
        ),
        _buildDivider(),

        // 7) Kitchen
        _buildDeviceRow(
          leading: _leftIconAsset(
            imagePath: _icKitchen,
            ringColor: _green,
            fallbackIcon: Icons.kitchen_rounded,
          ),
          title: 'Kitchen',
          subtitle: Row(
            children: [
              const _SmallCircleText('A'),
              SizedBox(width: 8.w),
              Icon(
                Icons.thermostat_rounded,
                size: 16.sp,
                color: const Color(0xFF3B82F6),
              ),
              SizedBox(width: 4.w),
              Text(
                '24.6°C',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _primary,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(width: 10.w),
              Image.asset("assets/images/fire.png"),
              SizedBox(width: 4.w),
              Text(
                '35%',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _primary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleButton(icon: Icons.remove_rounded, onTap: () {}),
              SizedBox(width: 10.w),
              _CircleButton(icon: Icons.add_rounded, onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------- Small helpers ----------

class _InlineText extends StatelessWidget {
  const _InlineText(this.text, {this.bold = false});

  final String text;
  final bool bold;

  static const _primary = Color(0xFF111827);
  static const _secondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w600,
        color: bold ? _primary : _secondary,
        fontFamily: 'Inter',
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: fg,
          fontFamily: 'Inter',
          height: 1.0,
        ),
      ),
    );
  }
}

class _SmallCircleText extends StatelessWidget {
  const _SmallCircleText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.w,
      height: 26.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6B7280),
          fontFamily: 'Inter',
          height: 1.0,
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 35.sp, color: const Color(0xFF111827)),
      ),
    );
  }
}
