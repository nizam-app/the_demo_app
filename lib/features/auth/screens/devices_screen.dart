import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  static const String routeName = '/devices';

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  int _selectedNavIndex = 0; // Devices is index 0

  void _onNavItemTapped(int index) {
    final routes = [
      '/devices',
      '/analytics',
      '/home', // Voice points to home
      '/notifications',
      '/automations',
    ];
    if (index < routes.length) {
      context.go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- Header (top bar) ----------
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 10.h),
                child: Row(
  children: [
    _CircleIconButton(
      icon: Icons.chevron_left_rounded,
      onTap: () => Navigator.maybePop(context),
      size: 44,                // image-like
      bg: const Color(0xFFE5E7EB),
      iconColor: Colors.black87,
      iconSize: 26,
    ),

    // ✅ Keep title perfectly centered by reserving equal space on both sides
    Expanded(
      child: Center(
        child: Text(
          'Devices',
          style: TextStyle(
            fontSize: 22.sp,     // image-like (bigger)
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    ),

    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleIconButton(
          icon: Icons.more_horiz_rounded,
          onTap: () {},
          size: 44,
          bg: const Color(0xFFF3F4F6),
          iconColor: const Color(0xFF111827),
          iconSize: 22,
        ),
        SizedBox(width: 12.w),
        _CircleIconButton(
          icon: Icons.add_rounded,
          onTap: () {},
          size: 44,
          bg: const Color(0xFF0088FE),
          iconColor: Colors.white,   // ✅ fix
          iconSize: 24,
        ),
      ],
    ),
  ],
)

              ),

              // -------- Search ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: _SearchBar(),
              ),

              SizedBox(height: 10.h),

              // -------- Filter chips ----------
             SizedBox(
  height: 40.h,
  child: ListView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    children: const [
      _FilterChipPill(label: 'All', selected: true),
      SizedBox(width: 10),
      _FilterChipPill(label: 'Favorites'),
      SizedBox(width: 10),
      _FilterChipPill(label: 'Smart'),
      SizedBox(width: 10),
      _FilterChipPill(label: 'Groups'),
      SizedBox(width: 10),
      _FilterChipPill(label: 'Category'),
    ],
  ),
),


              SizedBox(height: 12.h),

              // -------- Section Title ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Text(
                  'Devicesssss',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // -------- List (rows) ----------
              _DeviceListCard(
                children: [
                  // RGBW
                  _DeviceRow(
                    topRight: const _TimeTag(text: '18:32', blueIcon: true),
                    leading: const _GradientCircleIcon(size: 34),
                    title: 'RGBW',
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            _ModeDot(text: 'A', filled: false),
                            SizedBox(width: 6),
                            _SmallText('Off'),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const _TinyGreyText('LCD0C12'),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            _TagChip(text: 'Lighting', bg: Color(0xFF0088FE)),
                            SizedBox(width: 6),
                            _TagChip(text: 'Bathroom', bg: Color(0xFFFE019A)),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _CircleMiniBtn(icon: Icons.remove),
                        SizedBox(width: 10.w),
                        const _CircleMiniBtn(icon: Icons.add),
                        SizedBox(width: 10.w),
                        const _ToggleSwitch(isOn: true),
                      ],
                    ),
                  ),

                  const _RowDivider(),

                  // Alarm
                  _DeviceRow(
                    leading: const _LockIcon(),
                    title: 'Security Alarm',
                    subtitle: const _SmallText('Disarmed'),
                    trailing: const _CircleActionBlue(icon: Icons.power_settings_new),
                  ),

                  const _RowDivider(),

                  // Bathroom
                  _DeviceRow(
                    leading: const _PowerRingIcon(),
                    title: 'Bathroom',
                    subtitle: Row(
                      children: const [
                        _ModeDot(text: 'M', filled: true),
                        SizedBox(width: 8),
                        Text(
                          '24.6°c',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _CircleMiniBtn(icon: Icons.remove),
                        SizedBox(width: 10.w),
                        const _CircleMiniBtn(icon: Icons.add),
                      ],
                    ),
                  ),

                  const _RowDivider(),

                  // Blind Living Room (selected highlight row)
                  _DeviceRow(
                    selected: true,
                    topRight: const _StarTimeTag(time: '20:36'),
                    leading: const _BlindGreenIcon(),
                    title: 'Blind Living Room',
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 2),
                        _BlindStatsRow(),
                        SizedBox(height: 3),
                        _TinyGreyText('D012U12'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        _CircleMiniBtn(icon: Icons.keyboard_arrow_up),
                        SizedBox(height: 10),
                        _CircleMiniBtn(icon: Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),

                  const _RowDivider(),

                  // Block Irrigation Schedule (blue play row)
                  _DeviceRow(
                    leading: const _PlayCircleIcon(),
                    title: 'Block Irrigation Schedule',
                    subtitle: const _SmallText('Blocked'),
                    trailing: const _CircleActionBlue(icon: Icons.play_arrow),
                  ),

                  const _RowDivider(),

                  // Brightness (with pill slider)
                  _DeviceRow(
                    topRight: const _StarOnly(),
                    leading: const _SunIcon(),
                    title: 'Brightness',
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _BoldSmall('54%'),
                        SizedBox(height: 2),
                        _TinyGreyText('W5BT'),
                      ],
                    ),
                    trailing: const _BrightnessPill(),
                  ),

                  const _RowDivider(),

                  // Card Reader(s)
                  _DeviceRow(
                    leading: const _BulbIcon(),
                    title: 'Card Reader(s)',
                    subtitle: const _SmallText('Blocked'),
                    trailing: const _ToggleSwitch(isOn: false),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              // -------- Control units ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Text(
                  'Control units',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              _DeviceListCard(
                children: const [
                  _ControlUnitRow(
                    icon: Icons.memory,
                    iconColor: Color(0xFF0088FE),
                    title: 'CORE20',
                    sub: 'CORE20-4B37-3419-363A',
                  ),
                  _RowDivider(),
                  _ControlUnitRow(
                    icon: Icons.warning_amber_rounded,
                    iconColor: Color(0xFFFE019A),
                    title: 'D012',
                    sub: '11 Devices',
                    sub2: 'CORE20-4B37-3419-363A',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedNavIndex == -1 ? 0 : _selectedNavIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
    
  }
}

/* --------------------------- UI Pieces --------------------------- */

class _DeviceListCard extends StatelessWidget {
  const _DeviceListCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(children: children),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.topRight,
    this.selected = false,
  });

  final Widget leading;
  final String title;
  final Widget subtitle;
  final Widget trailing;
  final Widget? topRight;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? const Color(0xFFEAF1FF) : Colors.white,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 6.w),
              SizedBox(width: 34.w, height: 34.w, child: Center(child: leading)),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    subtitle,
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              trailing,
              SizedBox(width: 4.w),
            ],
          ),
          if (topRight != null)
            Positioned(
              right: 0,
              top: 0,
              child: topRight!,
            ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.only(left: 56.w),
      color: const Color(0xFFF1F1F1),
    );
  }
}

/* ---------------- Search + Chips ---------------- */

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipPill extends StatelessWidget {
  const _FilterChipPill({
    required this.label,
    this.selected = false,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFF0088FE) : const Color(0xFFE1E1E1);

    final textColor =
        selected ? const Color(0xFF0088FE) : const Color(0xFF111827);

    return Container(
      height: 36.h, // ✅ exact pill height
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999), // ✅ fully rounded pill
        border: Border.all(
          color: borderColor,
          width: 1.5, // ✅ thicker border like image
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,          // ✅ slightly bigger text
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1,
        ),
      ),
    );
  }
}

/* ---------------- Buttons / Toggles ---------------- */

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.bg = const Color(0xFFF3F4F6),
    this.iconColor = const Color(0xFF111827),
    this.iconSize = 22,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color bg;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: iconSize.sp,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class _CircleMiniBtn extends StatelessWidget {
  const _CircleMiniBtn({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18.sp, color: const Color(0xFF111827)),
    );
  }
}

class _CircleActionBlue extends StatelessWidget {
  const _CircleActionBlue({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFF0088FE),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18.sp, color: Colors.white),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.isOn});
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.w,
      height: 30.h,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isOn ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 26.w,
          height: 26.w,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/* ---------------- Small texts ---------------- */

class _SmallText extends StatelessWidget {
  const _SmallText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      ),
    );
  }
}

class _BoldSmall extends StatelessWidget {
  const _BoldSmall(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827),
      ),
    );
  }
}

class _TinyGreyText extends StatelessWidget {
  const _TinyGreyText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }
}

/* ---------------- Badges / Tags ---------------- */

class _ModeDot extends StatelessWidget {
  const _ModeDot({required this.text, required this.filled});
  final String text;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        color: filled ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : const Color(0xFF111827),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text, required this.bg});
  final String text;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

/* ---------------- Top right tags (time/star) ---------------- */

class _TimeTag extends StatelessWidget {
  const _TimeTag({required this.text, this.blueIcon = false});
  final String text;
  final bool blueIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wifi,
          size: 12.sp,
          color: blueIcon ? const Color(0xFF0088FE) : const Color(0xFF9CA3AF),
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StarTimeTag extends StatelessWidget {
  const _StarTimeTag({required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24)),
        SizedBox(width: 4.w),
        Text(
          time,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StarOnly extends StatelessWidget {
  const _StarOnly();

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24));
  }
}

/* ---------------- Leading icons (approx same) ---------------- */

class _GradientCircleIcon extends StatelessWidget {
  const _GradientCircleIcon({this.size = 34});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Color(0xFF15DFFE),
            Color(0xFF0088FE),
            Color(0xFFFE019A),
            Color(0xFFFFD700),
            Color(0xFF15DFFE),
          ],
        ),
      ),
    );
  }
}

class _LockIcon extends StatelessWidget {
  const _LockIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFFFE4F1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.lock_outline, size: 18.sp, color: const Color(0xFFFE019A)),
    );
  }
}

class _PowerRingIcon extends StatelessWidget {
  const _PowerRingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEAFBF2),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.power_settings_new, size: 18.sp, color: const Color(0xFF10B981)),
    );
  }
}

class _BlindGreenIcon extends StatelessWidget {
  const _BlindGreenIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEAFBF2),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.blinds_outlined, size: 18.sp, color: const Color(0xFF84CC16)),
    );
  }
}

class _PlayCircleIcon extends StatelessWidget {
  const _PlayCircleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEAF1FF),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.play_arrow, size: 18.sp, color: const Color(0xFF0088FE)),
    );
  }
}

class _SunIcon extends StatelessWidget {
  const _SunIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBEB),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.wb_sunny_outlined, size: 18.sp, color: const Color(0xFFFBBF24)),
    );
  }
}

class _BulbIcon extends StatelessWidget {
  const _BulbIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.lightbulb_outline, size: 18.sp, color: const Color(0xFF84CC16)),
    );
  }
}

/* ---------------- Blind stats row ---------------- */

class _BlindStatsRow extends StatelessWidget {
  const _BlindStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ModeDot(text: 'A', filled: false),
        SizedBox(width: 10.w),
        Icon(Icons.arrow_downward, size: 14.sp, color: const Color(0xFF111827)),
        SizedBox(width: 4.w),
        Text('0%', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827))),
        SizedBox(width: 12.w),
        Icon(Icons.arrow_upward, size: 14.sp, color: const Color(0xFF111827)),
        SizedBox(width: 4.w),
        Text('50%', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827))),
      ],
    );
  }
}

/* ---------------- Brightness pill slider ---------------- */

class _BrightnessPill extends StatelessWidget {
  const _BrightnessPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          // left active (white block)
          Container(
            width: 95.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10.w),
            child: Icon(Icons.wb_sunny_outlined, size: 16.sp, color: const Color(0xFF111827)),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

/* ---------------- Control unit row ---------------- */

class _ControlUnitRow extends StatelessWidget {
  const _ControlUnitRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.sub,
    this.sub2,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String sub;
  final String? sub2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18.sp, color: iconColor),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                if (sub2 != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    sub2!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
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
