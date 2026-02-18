import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/Zones/screen/widget/zoneAddMenut.dart';
import 'package:workpleis/features/Zones/screen/widget/zonesMenuSheet.dart';

class ZonesScreen extends StatefulWidget {
  const ZonesScreen({super.key});

  static const routeName = "/zones";

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends State<ZonesScreen> {



  void showZonesMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) => const ZonesMenuSheet(),
    );
  }


  void showZonesAddMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) => const ZoneAddMenu(),
    );
  }
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;
    final zones = <ZoneItem>[
      ZoneItem(
        title: "Whole House",
        bg: "assets/98eb2684310ab18008ede377735225af3ef22101.png",
        icon: "assets/4571bc2cde1beae6838435b553faf4e77efc01d1.png",
        size: 50,

      ),
      ZoneItem(
        title: "Living room",
        bg: "assets/f1e17ad5dda594d0cc21fb5068b22bc5c22a2489.png",
        icon: "assets/eec51f862769e6c37854c3412aff2118bb691d54.png",
        size: 50,
      ),
      ZoneItem(
        title: "Kitchen",
        bg: "assets/2ff95c96a8143b019b8e4ed8d69742b6df1d72ab.png",
        icon: "assets/a5056e4a921f2da7d1cc6391346361e7a7d336ef.png",
        size: 45
      ),
      ZoneItem(
        title: "Parents Room",
        bg: "assets/9bedd9c8bea97d3df5ad0147e6187f98cfd42cb2.png",
        icon: "assets/58aa8be59342d3e6964753dd24cb65170c8e15d6.png",
        size: 50
      ),
      ZoneItem(
        title: "Kids Room",
        bg: "assets/52fac8eb06e8c352ab1393d69a7ae69b6fe1a9da.png",
        icon: "assets/a3a03e471df0f73d577f8b37f964f75ceb49fe8f.png",
        size: 50
      ),
      ZoneItem(
        title: "Bathroom",
        bg: "assets/7bf026095b9241a5afe48b828185f782f69cca92.png",
        icon: "assets/529c89d71c4e0797f38a54e5d7e0b0096e56c216.png",
        size: 45
      ),
      ZoneItem(
        title: "Garden",
        bg: "assets/7bba25d3aee68355dd57c88a16b17f66a79cfe7f.png",
        icon: "assets/05368c1f8bdc752213d272196f7a9ff7256ae819.png",
        size: 50
      ),
      ZoneItem(
        title: "Garage",
        bg: "assets/d15c22b1cfc0d0e08bc9b11cc2f23191dbc196a5 (1).png",
        icon: "assets/2792d320e0174da3ed955218cabab43cd6a00781.png",
        size: 50
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        notificationCount: 12,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),

              // ✅ Top bar (same to same)
              _TopBar(
                onBack: () => Navigator.pop(context),
                onMenu: () => showZonesMenuSheet(context),
                onAdd: () =>showZonesAddMenuSheet(context),
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
                    childAspectRatio: 1.13, // ✅ screenshot-like
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
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
              fontFamily: "Inter",
            ),
          ),

          // Left back
          Align(
            alignment: Alignment.centerLeft,
            child:   GlobalCircleIconBtn(
              child: Image.asset(
                'assets/aro.png',
                width: 16.w,
                height: 16.h,
              ),
              onTap: () => Navigator.maybePop(context),
              color: const Color(0xFFF3F4F6),
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
                SizedBox(width: 15.w),

                _CircleIconButton(
                  icon: Icons.add,
                  onTap: onAdd,
                  borderColor: const Color(0xFFE6E8EE),
                  iconColor: const Color(0xFF111827),
                ), 
                // _CircleIconButton(
                //   image: "assets/6458ec77e1fc16af4bcfaa1f33295b2acb661edb.png",
                //   icon: Icons.add,
                //   onTap: onAdd,
                //   borderColor: const Color(0xFF0088FE),
                //   iconColor: const Color(0xFF0088FE),
                // ),
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
    this.image  ,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color borderColor;
  final Color iconColor;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: Color(0xFFf3f4f6),
          shape: BoxShape.circle,
          // border: Border.all(color: borderColor, width: 1),
        ),
        child: image != null ? Image.asset(image!, width: 22.w, height: 22.h) : Icon(icon, size: 22.sp, color: iconColor),
      ),
    );
  }
}

class ZoneItem {
  final String title;
  final String bg;
  final String icon;
  final double? size;
  final double? width;
  final double? height;

  const ZoneItem({
    required this.title,
    required this.bg,
    required this.icon,
    this.size,
    this.width,
    this.height,
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
    final radius = 26.r;
    final iconW = item.size ?? item.width;
    final iconH = item.size ?? item.height;

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
              child: FrostCircle(
                size: 74,
                child: Image.asset(
                  item.icon,
                  width: iconW?.w,
                  height: iconH?.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ✅ bottom-left title
            Positioned(
              left: 12.w,
              bottom: 35.h,
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
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
                width: 32.w,
                height: 32.h,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white30.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "assets/Mask group copy 5.png"
                  ,width: 21.w,
                  height: 21.h,
                 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FrostCircle extends StatelessWidget {
  const FrostCircle({
    super.key,
    required this.size,
    required this.child,
    this.blurSigma = 5,
  });

  final double size;
  final Widget child;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white38.withOpacity(0.10),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Stack(
            children: [
              // Frost layer (radial gradient like your screenshots)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient( // ✅ radialGradient না, gradient হবে
                      center: Alignment.topLeft,
                      radius: 1.05,
                      colors: [
                        Colors.white.withOpacity(0.28),
                        Colors.white.withOpacity(0.55),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.22),
                      width: 1,
                    ),
                  ),

                ),
              ),

              // slight top-left glossy highlight
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white30.withOpacity(0.9999),
                        Colors.transparent,
                        Colors.black.withOpacity(0.04),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),

              Center(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.notificationCount,
  });

  final int selectedIndex;
  final void Function(int) onTap;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    const selected = Color(0xFF0088FE);
    const unselected = Color(0xFF111827);

    final items = <_NavItem>[
      const _NavItem(label: "Devices", icon: "assets/Group 28.png"),
      const _NavItem(label: "Analytics", icon: "assets/bar 5.png"),
      const _NavItem(label: "Dashboard", icon: "assets/Mask group copy 6.png"),
      const _NavItem(label: "Notifications", icon: "assets/Group 43.png"),
      const _NavItem(label: "Automations", icon: "assets/Mask group (8).png"),
    ];

    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.74),
        border: const Border(top: BorderSide(color: Color(0xFFE1E1E1), width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / items.length;
          return Stack(
            children: [
              // selection indicator (blue 3px bar like your figma)
              Positioned(
                top: 0,
                left: w * selectedIndex + (w - 77.w) / 2,
                child: Container(
                  width: 77.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: selected,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2.r),
                      bottomRight: Radius.circular(2.r),
                    ),
                  ),
                ),
              ),

              Row(
                children: List.generate(items.length, (i) {
                  final isSel = i == selectedIndex;
                  final color = isSel ? selected : unselected;
                  final item = items[i];

                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset(item.icon, width: 26.sp, height: 26.sp, color: color),
                              if (item.label == "Notifications" && notificationCount > 0)
                                Positioned(
                                  right: -10.w,
                                  top: -6.h,
                                  child: Container(
                                    width: 19.w,
                                    height: 15.h,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFE019A),
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: Text(
                                      notificationCount.toString(),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  const _NavItem({required this.label, required this.icon});
}