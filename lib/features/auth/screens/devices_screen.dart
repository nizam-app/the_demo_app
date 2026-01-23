import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


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
      imagePath: 'assets/aro.png',
      onTap: () => Navigator.maybePop(context),
      size: 32,                // image-like
      bg: const Color(0xFFE5E7EB),
      iconColor: Colors.black87,
      iconSize: 14,
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
          size: 32,
          bg: const Color(0xFFF3F4F6),
          iconColor: const Color(0xFF111827),
          iconSize: 22,
        ),
        SizedBox(width: 12.w),
        _CircleIconButton(
          icon: Icons.add_rounded,
          onTap: () {},
          size: 32,
          bg: const Color(0xFF0088FE),
          iconColor: Colors.white,   // ✅ fix
          iconSize: 23,
        ),
      ],
    ),
  ],
)

              ),

              // -------- Search ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h  ),
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
                  'Devices',
                  style: TextStyle(
                    fontSize: 20.sp,
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
                    leading: ClipOval(
                      child: Image.asset(
                        'assets/Rectangle.png',
                        width: 34.w,
                        height: 34.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
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
                            _TagChip(text: 'Lighting', bg: Color(0xFF0088FE), outlined: true),
                            SizedBox(width: 6),
                            _TagChip(text: 'Bathroom', bg: Color(0xFFFE019A), outlined: false),
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
                    topRight: const _PinOnly(),
                    leading: const _LockIcon(),
                    title: 'Alarm',
                    subtitle: const _SmallText('Disarmed'),
                    trailing: const _CircleActionBlue(imagePath: 'assets/Mask group (15).png'),
                  ),

                  const _RowDivider(),

                  // Bathroom
            _DeviceRow(
  leading: const _PowerRingIcon(),
  title: 'Bathroom',
  subtitle: Row(
    children: const [
      _ModeDot(text: 'M', filled: true),
      SizedBox(width: 10),
      Icon(Icons.thermostat, size: 18, color: Color(0xFF38BDF8)), // চাইলে image asset দিন
      SizedBox(width: 6),
      Text(
        '24.6°C',
        style: TextStyle(
          fontSize: 20, // screenshot vibe
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
      ),
    ],
  ),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const _CircleMiniBtn(icon: Icons.remove),
      SizedBox(width: 14.w),
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
                    trailing: const _CircleActionBlue(imagePath: 'assets/play.png'),
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
                    imagePath: 'assets/image 124.png',
                    title: 'CORE20',
                    sub: 'CORE20-4B37-3419-363A',
                  ),
                  _RowDivider(),
                  _ControlUnitRow(
                    imagePath: 'assets/image 124.png',
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
    this.icon,
    this.imagePath,
    required this.onTap,
    this.size = 44,
    this.bg = const Color(0xFFF3F4F6),
    this.iconColor = const Color(0xFF111827),
    this.iconSize = 22,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');

  final IconData? icon;
  final String? imagePath;
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
          child: imagePath != null
              ? Image.asset(
                  imagePath!,
                  width: iconSize.sp,
                  height: iconSize.sp,
                  fit: BoxFit.contain,
                )
              : Icon(
                  icon!,
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
      width: 56.w,
      height: 56.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 30.sp, color: const Color(0xFF111827)),
    );
  }
}

class _CircleActionBlue extends StatelessWidget {
  const _CircleActionBlue({
    this.icon,
    this.imagePath,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');
  
  final IconData? icon;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h), // ✅ pin-এর নিচে নামায়
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: const BoxDecoration(
          color: Color(0xFF0088FE),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: imagePath != null
            ? Image.asset(
                imagePath!,
                width: 28.sp,
                height: 28.sp,
                fit: BoxFit.contain,
              )
            : Icon(icon!, size: 28.sp, color: Colors.white),
      ),
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

class _SmallText extends StatelessWidget {
  const _SmallText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDisarmed = text.trim().toLowerCase() == 'disarmed';

    return Text(
      text,
      style: TextStyle(
        fontSize: isDisarmed ? 16.sp : 12.sp,
        fontWeight: isDisarmed ? FontWeight.w700 : FontWeight.w400,
        color: isDisarmed ? const Color(0xFF111827) : const Color(0xFF6B7280),
        height: 1.05,
      ),
    );
  }
}
class _PinOnly extends StatelessWidget {
  const _PinOnly();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h, right: 2.w),
        child: Image.asset(
          'assets/image 81 (1).png',
          width: 16.sp,
          height: 16.sp,
          fit: BoxFit.contain,
          color: const Color(0xFF0088FE),
          colorBlendMode: BlendMode.srcIn,
        ),
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
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF6B7280),
        height: 1.0,
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
      width: 34.w,  // ✅ bigger
      height: 34.w,
      decoration: BoxDecoration(
        color: filled ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.sp, // ✅ bigger
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : const Color(0xFF111827),
          height: 1.0,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.text,
    required this.bg,
    this.outlined = false,
  });
  final String text;
  final Color bg;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: outlined ? Colors.white : bg,
        borderRadius: BorderRadius.circular(6.r),
        border: outlined
            ? Border.all(
                color: bg,
                width: 2,
              )
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: outlined ? bg : Colors.white,
        ),
      ),
    );
  }
}

/* ---------------- Top right tags (time/star) ---------------- */

class _TimeTag extends StatelessWidget {
  const _TimeTag({
    required this.text,
    this.blueIcon = true,
    this.iconSize,
    this.fontSize,
  });

  final String text;
  final bool blueIcon;
  final double? iconSize;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final iSize = (iconSize ?? 16).sp;   // screenshot vibe
    final tSize = (fontSize ?? 13).sp;   // screenshot vibe

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/image 81 (1).png',
          width: iSize,
          height: iSize,
          color: blueIcon ? const Color(0xFF0088FE) : const Color(0xFF9CA3AF),
          colorBlendMode: BlendMode.srcIn,
        ),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: tSize,
            color: const Color(0xFF111827), // screenshot মতো ডার্ক
            fontWeight: FontWeight.w600,    // bold look
            height: 1.0,
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
        Icon(Icons.star_rounded, size: 22.sp, color: const Color(0xFFFBBF24)),
        SizedBox(width: 10.w),
        Text(
          time,
          style: TextStyle(
            fontSize: 20.sp,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w500,
            height: 1.0,
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
    return SizedBox(
      width: 44.w,
      height: 44.w,
      child: Center(
        child: Image.asset(
          'assets/Mask group (10).png',
          width: 40.w,
          height: 40.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _PowerRingIcon extends StatelessWidget {
  const _PowerRingIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.w,
      height: 44.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ring
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  Color(0xFF22C55E), // green
                  Color(0xFF38BDF8), // light blue
                  Color(0xFF3B82F6), // blue
                  Color(0xFF22C55E), // back to green
                ],
              ),
            ),
          ),

          // inner cut (makes ring)
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),

          // Power glyph (looks like screenshot)
          Image.asset(
            'assets/Mask group (11).png',
            width: 22.sp,
            height: 22.sp,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _BlindGreenIcon extends StatelessWidget {
  const _BlindGreenIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34.w,
      height: 34.w,
      child: Center(
        child: Image.asset(
          'assets/Mask group (12).png',
          width: 34.w,
          height: 34.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFBBF24),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PlayCircleIcon extends StatelessWidget {
  const _PlayCircleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34.w,
      height: 34.w,
      child: Center(
        child: Image.asset(
          'assets/Mask group (14).png',
          width: 34.w,
          height: 34.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _SunIcon extends StatelessWidget {
  const _SunIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34.w,
      height: 34.w,
      child: Center(
        child: Image.asset(
          'assets/Mask group (5).png',
          width: 34.w,
          height: 34.w,
          fit: BoxFit.contain,
        ),
      ),
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
        // A badge (light grey circle)
        Container(
          width: 40.w,
          height: 40.w,
          decoration: const BoxDecoration(
            color: Color(0xFFE5E7EB),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            'A',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B7280),
              height: 1.0,
            ),
          ),
        ),
        SizedBox(width: 14.w),

        // icon + 0%
        Image.asset(
          'assets/Group 32.jpg',
          width: 22.w,
          height: 28.h,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 8.w),
        Text(
          '0%',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            height: 1.0,
          ),
        ),

        SizedBox(width: 18.w),

        // icon + 50%
        Image.asset(
          'assets/Vector 4.jpg',
          width: 18.w,
          height: 28.h,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 8.w),
        Text(
          '50%',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

/// black “up/down triangles” icon
class _DoubleTriangleIcon extends StatelessWidget {
  const _DoubleTriangleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.w,
      height: 28.h,
      child: CustomPaint(painter: _DoubleTrianglePainter()),
    );
  }
}

class _DoubleTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF111827);

    // up triangle
    final up = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2 - 2)
      ..lineTo(0, size.height / 2 - 2)
      ..close();

    // down triangle
    final down = Path()
      ..moveTo(0, size.height / 2 + 2)
      ..lineTo(size.width, size.height / 2 + 2)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(up, p);
    canvas.drawPath(down, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// black wedge icon (like screenshot)
class _WedgeIcon extends StatelessWidget {
  const _WedgeIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18.w,
      height: 28.h,
      child: CustomPaint(painter: _WedgePainter()),
    );
  }
}

class _WedgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF111827);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.75)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    this.icon,
    this.iconColor,
    this.imagePath,
    required this.title,
    required this.sub,
    this.sub2,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');

  final IconData? icon;
  final Color? iconColor;
  final String? imagePath;
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
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    width: 18.sp,
                    height: 18.sp,
                    fit: BoxFit.contain,
                  )
                : Icon(icon!, size: 18.sp, color: iconColor!),
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
