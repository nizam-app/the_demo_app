import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    const items = [
      NavItemData('Devices', 'assets/Group 28.png'),
      NavItemData('Analytics', 'assets/bar 5.png'),
      NavItemData('Voice', 'assets/image 98.png'),
      NavItemData('Notifications', 'assets/Group 43.png'),
      NavItemData('Automations', 'assets/Mask group (8).png'),
    ];

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
        child: Container(
          height: 86.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.95),
            border: const Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final slotW = c.maxWidth / items.length;
              final indicatorW = 56.w;
              final indicatorH = 4.h;

              final left = selectedIndex >= 0 && selectedIndex < items.length
                  ? (slotW * selectedIndex) + (slotW - indicatorW) / 2
                  : -1000.0; // Hide indicator when no selection

              return Stack(
                children: [
                  // ✅ Smooth top indicator (centered)
                  if (selectedIndex >= 0 && selectedIndex < items.length)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      top: 6.h,
                      left: left,
                      child: Container(
                        width: indicatorW,
                        height: indicatorH,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088FE),
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                      ),
                    ),

                  // ✅ Items
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h, top: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(items.length, (i) {
                          final isSelected = i == selectedIndex;
                          return InkResponse(
                            onTap: () => onItemTapped(i),
                            radius: 28.r,
                            child: RepaintBoundary( // ✅ smoother (less repaint)
                              child: BottomNavItem(
                                label: items[i].label,
                                imagePath: items[i].imagePath,
                                isSelected: isSelected,
                                showBadge: items[i].label == 'Notifications',
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class NavItemData {
  const NavItemData(this.label, this.imagePath);
  final String label;
  final String imagePath;
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.showBadge,
  });

  final String label;
  final String imagePath;
  final bool isSelected;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final slotW = 70.w;

    // ✅ fixed sizes (no jump)
    final iconBox = 36.w;
    final iconSize = 26.w;

    return SizedBox(
      width: slotW,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            scale: isSelected ? 1.05 : 1.0,
            child: SizedBox(
              width: iconBox,
              height: iconBox,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // ✅ selected blue circle behind icon (like screenshot)
                  if (isSelected)
                    Container(
                      width: iconBox,
                      height: iconBox,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0088FE),
                      ),
                    ),

                  // ✅ icon (tint to match)
                  Image.asset(
                    imagePath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.medium,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF111827), // black-ish
                    colorBlendMode: BlendMode.srcIn,
                  ),

                  // ✅ small badge (if you need later)
                  if (showBadge)
                    Positioned(
                      top: -6.h,
                      right: -6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48),
                          borderRadius: BorderRadius.circular(99.r),
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: Text(
                          '12',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 6.h),

          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF0088FE) : const Color(0xFF111827),
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
