import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widget/global_back_button.dart';
import '../widget/categoryAddmenu.dart';
import '../widget/categoryMenuSheet.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  static const routeName = "/categories";

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void showCategoryMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.25),
      isScrollControlled: true,
      builder: (_) => const CategoryMenuSheet(),
    );
  }

  void showCategoryAddMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.25),
      isScrollControlled: true,
      builder: (_) => const CategoryAddMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;
    final zones = <ZoneItem>[
      ZoneItem(
        title: "Lighting",
        image: "assets/lighting.png",
        imageHeight: 156.w,
        imageWidth: 182.h,
      ),
      ZoneItem(
        title: "Shading",
        image: "assets/shading.png",
        imageHeight: 138.w,
        imageWidth: 169.h,
      ),
      ZoneItem(
        title: "HVAC",
        image: "assets/hvac.png",
        imageHeight: 150.w,
        imageWidth: 169.h,
      ),
      ZoneItem(
        title: "Ventilation",
        image: "assets/ventilation.png",
        imageHeight: 130.w,
        imageWidth: 130.h,
      ),
      ZoneItem(
        title: "Gates",
        image: "assets/gates.png",
        imageHeight: 102.w,
        imageWidth: 182.h,
      ),
      ZoneItem(
        title: "Security",
        image: "assets/security.png",
        imageHeight: 130,
        imageWidth: 130.h,
      ),
      ZoneItem(
        title: "Irrigation",
        image: "assets/irrigation.png",
        imageHeight: 143,
        imageWidth: 143.h,
      ),
      ZoneItem(
        title: "Machines",
        image: "assets/machines.png",
        imageHeight: 109,
        imageWidth: 169.h,
      ),
      ZoneItem(
        title: "Charging",                   
        image: "assets/charging.png",
        imageHeight: 139,
        imageWidth: 139.h,
      ),
      ZoneItem(
        title: "Maintenance",
        image: "assets/maintenance.png",
        imageHeight: 146,
        imageWidth: 169.h,
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
                onMenu: () => showCategoryMenuSheet(context),
                onAdd: () => showCategoryAddMenuSheet(context),
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
                    return ZoneCard(item: zones[i], onTap: () {});
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
            "Categories",
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
            child: GlobalCircleIconBtn(
              child: Image.asset('assets/aro.png', width: 16.w, height: 16.h),
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
    this.image,
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
        child: image != null
            ? Image.asset(image!, width: 22.w, height: 22.h)
            : Icon(icon, size: 22.sp, color: iconColor),
      ),
    );
  }
}

// ZoneItem  and Zone Card

class ZoneItem {
  final String title;
  final String image;
  final double? imageWidth;
  final double? imageHeight;
  const ZoneItem({
    required this.title,
    required this.image,
    this.imageWidth,
    this.imageHeight, 
  });
}

class ZoneCard extends StatelessWidget {
  const ZoneCard({super.key, required this.item, required this.onTap});

  final ZoneItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        width: 195.w,
        height: 183.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  item.image,
                  width: item.imageWidth,
                  height: item.imageHeight ?? 117.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111111),
                fontFamily: "Inter",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ZoneItem {
//   final String title;
//   final String bg;
//   final String icon;
//   final double? size;
//   final double? width;
//   final double? height;
//
//   const ZoneItem({
//     required this.title,
//     required this.bg,
//     required this.icon,
//     this.size,
//     this.width,
//     this.height,
//   });
// }
//
// class ZoneCard extends StatelessWidget {
//   const ZoneCard({super.key, required this.item, required this.onTap});
//
//   final ZoneItem item;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final iconH = item.size != null ? item.size!.h : 90.h;
//     final iconW = item.width != null ? item.width!.w : null;
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(26.r),
//       child: Container(
//         width: 195.w,
//         height: 183.h,
//         padding: EdgeInsets.all(12.w),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF3F4F6),
//           borderRadius: BorderRadius.circular(26.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 10,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Center(
//                 child: Image.asset(
//                   item.icon,
//                   width: iconW,
//                   height: iconH,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             SizedBox(height: 6.h),
//             Text(
//               item.title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF111111),
//                 fontFamily: "Inter",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


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
                    gradient: RadialGradient(
                      // ✅ radialGradient না, gradient হবে
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
        border: const Border(
          top: BorderSide(color: Color(0xFFE1E1E1), width: 1),
        ),
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
                              Image.asset(
                                item.icon,
                                width: 26.sp,
                                height: 26.sp,
                                color: color,
                              ),
                              if (item.label == "Notifications" &&
                                  notificationCount > 0)
                                Positioned(
                                  right: -10.w,
                                  top: -6.h,
                                  child: Container(
                                    width: 19.w,
                                    height: 15.h,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
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