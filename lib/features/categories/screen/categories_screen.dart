import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/devices/screen/devices_screen.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/settings/screen/settings_screen.dart';

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
    final zones = <ZoneItem>[
      ZoneItem(
        title: "Lighting",
        image: "assets/images/667x571 1.png",
        imageHeight: 160.w,
        imageWidth: 186.h,
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
        imageHeight: 130.h,
        imageWidth: 130.w,
      ),
      ZoneItem(
        title: "Irrigation",
        image: "assets/irrigation.png",
        imageHeight: 143.h,
        imageWidth: 143.w,
      ),
      ZoneItem(
        title: "Machines",
        image: "assets/machines.png",
        imageHeight: 109.h,
        imageWidth: 169.w,
      ),
      ZoneItem(
        title: "Charging",
        image: "assets/charging.png",
        imageHeight: 139.h,
        imageWidth: 139.w,
      ),
      ZoneItem(
        title: "Maintenance",
        image: "assets/maintenance.png",
        imageHeight: 146.h,
        imageWidth: 169.w,
      ),
    ];

    return CustomBottomNavBar(
      initialIndex: 2,
      children: [
        const RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        const RepaintBoundary(child: AnalyticsScreen(showBottomNav: false)),
        RepaintBoundary(child: _buildCategoriesBody(context, zones)),
        const RepaintBoundary(child: NotificationsScreen(showBottomNav: false)),
        const RepaintBoundary(child: SettingsScreen()),
      ],
    );
  }

  Widget _buildCategoriesBody(BuildContext context, List<ZoneItem> zones) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            _TopBar(
              onBack: () => Navigator.pop(context),
              onMenu: () => showCategoryMenuSheet(context),
              onAdd: () => showCategoryAddMenuSheet(context),
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 16.h),
                physics: const BouncingScrollPhysics(),
                itemCount: zones.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 1.13,
                ),
                itemBuilder: (_, i) {
                  return ZoneCard(item: zones[i], onTap: () {});
                },
              ),
            ),
          ],
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
                InkWell(
                  onTap: onMenu,
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/image 89.png',
                        width: 22.w,
                        height: 22.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // _CircleIconButton(
                // // icon: Icons.more_horiz,
                //   onTap: onMenu,
                //   borderColor: const Color(0xFFF3F4F6),
                //   iconColor: const Color(0xFF111827), icon: null,
                // ),
                SizedBox(width: 12.w),

                _CircleIconButton(
                  icon: Icons.add,
                  onTap: onAdd,
                  borderColor: const Color(0xFFF3F4F6),
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
  });

  final IconData? icon;
  final VoidCallback onTap;
  final Color borderColor;
  final Color iconColor;

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
        child: Icon(icon, size: 22.sp, color: iconColor),
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
        padding: EdgeInsets.all(8.w),
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
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 2.h),
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111827),
                  fontFamily: "Inter",
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