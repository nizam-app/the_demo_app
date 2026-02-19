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
  int _selectedIndex = 2;

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
    // Use your existing assets (I’m using your "icon" images as the main picture like the screenshot)
    final zones = <ZoneItem>[
      ZoneItem(
        title: "Whole House",
        image: "assets/f42caf20d96bf050fe012c258152cc1bc4bdd276 (1).png",
                imageWidth: 183.w,
        imageHeight: 117.h,
      ),
      ZoneItem(
        title: "Living room",
        image: "assets/64b800555a0a813dc12aabe1da7c0d4ed1273346 (1).png",
        imageWidth: 183.w,
        imageHeight: 90.h,
      ),
      ZoneItem(
        title: "Kitchen",
        image: "assets/62ce324979a0ecd38f8c2f40960a4a58eca3c836.png",
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
        image: "assets/aa4e7e9dd3a7adf204473d4aa4b3e2f33973a876.png",
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

              // ✅ Top bar like screenshot
              _TopBar(
                onBack: () => Navigator.maybePop(context),
                onMenu: () => showZonesMenuSheet(context),
                onAdd: () => showZonesAddMenuSheet(context),
              ),

              SizedBox(height: 14.h),

              // ✅ Grid like screenshot
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 16.h),
                  physics: const BouncingScrollPhysics(),
                  itemCount: zones.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio:
                        0.95, // closer to screenshot (slightly taller)
                  ),
                  itemBuilder: (_, i) => ZoneCard(item: zones[i], onTap: () {}),
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
                  _CircleIconButton(icon: Icons.more_horiz, onTap: onMenu),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: onAdd,
                    icon: Icon(Icons.add, size: 26.sp, color: const Color(0xFF111111)),
                    splashRadius: 22,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              "Zones",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111111),
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
        width: 36.w,
        height: 36.w,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22.sp, color: const Color(0xFF111111)),
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

/* -------------------- Your existing bottom nav (unchanged) -------------------- */

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
