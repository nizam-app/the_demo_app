import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  static const routeName = "/zones";

  @override
  Widget build(BuildContext context) {
    final zones = <ZoneItem>[
      ZoneItem(
        title: "Whole House",
        bg: "assets/zones/whole_house.jpg",
        icon: "assets/zones/icons/house.png",
      ),
      ZoneItem(
        title: "Living room",
        bg: "assets/zones/living_room.jpg",
        icon: "assets/zones/icons/sofa.png",
      ),
      ZoneItem(
        title: "Kitchen",
        bg: "assets/zones/kitchen.jpg",
        icon: "assets/zones/icons/kitchen.png",
      ),
      ZoneItem(
        title: "Parents Room",
        bg: "assets/zones/parents_room.jpg",
        icon: "assets/zones/icons/bed.png",
      ),
      ZoneItem(
        title: "Kids Room",
        bg: "assets/zones/kids_room.jpg",
        icon: "assets/zones/icons/kids.png",
      ),
      ZoneItem(
        title: "Bathroom",
        bg: "assets/zones/bathroom.jpg",
        icon: "assets/zones/icons/bath.png",
      ),
      ZoneItem(
        title: "Garden",
        bg: "assets/zones/garden.jpg",
        icon: "assets/zones/icons/garden.png",
      ),
      ZoneItem(
        title: "Garage",
        bg: "assets/zones/garage.jpg",
        icon: "assets/zones/icons/garage.png",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),

              // ✅ Top bar (same to same)
              _TopBar(
                onBack: () => Navigator.pop(context),
                onMenu: () {},
                onAdd: () {},
              ),

              SizedBox(height: 14.h),

              // ✅ Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 16.h),
                  physics: const BouncingScrollPhysics(),
                  itemCount: zones.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14.w,
                    mainAxisSpacing: 14.h,
                    childAspectRatio: 1.15, // ✅ screenshot-like
                  ),
                  itemBuilder: (_, i) {
                    return ZoneCard(
                      item: zones[i],
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onBack,
    required this.onMenu,
    required this.onAdd,
  });

  final VoidCallback onBack;
  final VoidCallback onMenu;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center title
          Text(
            "Zones",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
              fontFamily: "Inter",
            ),
          ),

          // Left back
          Align(
            alignment: Alignment.centerLeft,
            child: _CircleIconButton(
              icon: Icons.chevron_left,
              onTap: onBack,
              borderColor: const Color(0xFFE6E8EE),
              iconColor: const Color(0xFF111827),
            ),
          ),

          // Right actions (menu + add)
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CircleIconButton(
                  icon: Icons.more_horiz,
                  onTap: onMenu,
                  borderColor: const Color(0xFFE6E8EE),
                  iconColor: const Color(0xFF111827),
                ),
                SizedBox(width: 10.w),
                _CircleIconButton(
                  icon: Icons.add,
                  onTap: onAdd,
                  borderColor: const Color(0xFF0088FE),
                  iconColor: const Color(0xFF0088FE),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.borderColor,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color borderColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Icon(icon, size: 22.sp, color: iconColor),
      ),
    );
  }
}

class ZoneItem {
  final String title;
  final String bg;
  final String icon;

  const ZoneItem({
    required this.title,
    required this.bg,
    required this.icon,
  });
}

class ZoneCard extends StatelessWidget {
  const ZoneCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final ZoneItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = 18.r;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            // ✅ Background image with blur (same vibe)
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Image.asset(
                  item.bg,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ✅ Soft overlay (to match screenshot)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.10),
                      Colors.black.withOpacity(0.40),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ top-left icon bubble
            Positioned(
              top: 12.h,
              left: 12.w,
              child: _FrostCircle(
                size: 44.w,
                child: Image.asset(
                  item.icon,
                  width: 26.w,
                  height: 26.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ✅ bottom-left title
            Positioned(
              left: 12.w,
              bottom: 12.h,
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: "Inter",
                ),
              ),
            ),

            // ✅ bottom-right arrow bubble
            Positioned(
              right: 10.w,
              bottom: 10.h,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrostCircle extends StatelessWidget {
  const _FrostCircle({
    required this.size,
    required this.child,
  });

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}