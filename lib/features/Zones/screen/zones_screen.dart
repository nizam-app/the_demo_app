import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/Zones/screen/widget/zoneAddMenut.dart';
import 'package:workpleis/features/Zones/screen/widget/zonesMenuSheet.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/devices/screen/devices_screen.dart';
import 'package:workpleis/features/home/screen/home_screen.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/settings/screen/settings_screen.dart';
import 'package:workpleis/features/zone%20category%20screen/screen/zone-category-screen.dart';

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
    final zones = <ZoneItem>[
      ZoneItem(
        title: "Whole House",
        image: "assets/f42caf20d96bf050fe012c258152cc1bc4bdd276 (1).png",
        imageWidth: 183.w,
        imageHeight: 117.h,
      ),
      ZoneItem(
        title: "Living room",
        image: "assets/chopha.png",
        imageWidth: 183.w,
        imageHeight: 90.h,
      ),
      ZoneItem(
        title: "Kitchen",
        image: "assets/images/alcitchen.png",
        imageWidth: 208.w,
        imageHeight: 139.h,
      ),
      ZoneItem(
        title: "Parents Room",
        image: "assets/477e3ecc12df23d25069637a302522f7a1c29a83.png",
        imageWidth: 196.w,
        imageHeight: 110.h,
      ),
      ZoneItem(
        title: "Kids Room",
        image: "assets/3413f848c083863be8465b5b7b8236d6eb36012a.png",
        imageWidth: 169.w,
        imageHeight: 113.h,
      ),
      ZoneItem(
        title: "Bathroom",
        image: "assets/75560e6d8e9934269e2ebe8e8cf9f3fea730b1dc.png",
        imageWidth: 169.w,
        imageHeight: 169.h,
      ),
      ZoneItem(
        title: "Garden",
        image: "assets/images/garden-design-flower.png",
        imageWidth: 208.w,
        imageHeight: 119.h,
      ),
      ZoneItem(
        title: "Garage",
        image: "assets/1f2ecff214be9b8f973af70a365e210f04e99a57.png",
        imageWidth: 269.w,
        imageHeight: 103.h,
      ),
    ];

    return CustomBottomNavBar(
      initialIndex: 2,
      children: [
        const RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        const RepaintBoundary(child: AnalyticsScreen(showBottomNav: false)),
        RepaintBoundary(child: _buildZonesBody(context, zones)),
        const RepaintBoundary(child: NotificationsScreen(showBottomNav: false)),
        const RepaintBoundary(child: SettingsScreen()),
      ],
    );
  }

  Widget _buildZonesBody(BuildContext context, List<ZoneItem> zones) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            _TopBar(
              onBack: () => Navigator.pop(context),
              onMenu: () => showZonesMenuSheet(context),
              onAdd: () => showZonesAddMenuSheet(context),
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
                itemBuilder: (_, i) => ZoneCard(item: zones[i], onTap: () {
                   context.push(Zone_Category_Screen.routeName);
                }),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalCircleIconBtn(
                child: Image.asset('assets/aro.png', width: 16.w, height: 16.h),
                onTap: onBack,
                color: const Color(0xFFF3F4F6),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: onMenu,
                    borderRadius: BorderRadius.circular(26.r),
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
                  //     icon: Icons.more_horiz,
                  //     onTap: onMenu,
                  // ),
                  SizedBox(width: 12.w),
                  _CircleIconButton(icon: Icons.add, onTap: onAdd),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              "Zones",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22.sp, color: const Color(0xFF111827)),
      ),
    );
  }
}

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