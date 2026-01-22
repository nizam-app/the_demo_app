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
    final items = const [
      NavItemData('Devices', 'assets/Group 28.png'),
      NavItemData('Analytics', 'assets/bar 5.png'),
      NavItemData('Voice', 'assets/image 98.png'),
      NavItemData('Notifications', 'assets/Group 43.png'),
      NavItemData('Automations', 'assets/Mask group (8).png'),
    ];

    return Container(
      height: 92.h,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.90)),
      child: Column(
        children: [
          Container(height: 1, color: const Color(0xFFE1E1E1)),
          Expanded(
            child: Stack(
              children: [
                // ✅ Top indicator (like Image-1)
                Positioned(
                  top: 6.h, // ✅ indicator stays above icons
                  left: -26,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(items.length, (i) {
                      final isSelected = i == selectedIndex;
                      return SizedBox(
                        width: 56.w, // same slot width for every item
                        child: isSelected
                            ? Container(
                                height: 4.h,
                                width: 86.w, // ✅ wider bar like Image-1
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0088FE),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    }),
                  ),
                ),

                // ✅ Items row (icons + labels)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h, top: 18.h), // ✅ space for big icon
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(items.length, (i) {
                        final isSelected = i == selectedIndex;
                        return GestureDetector(
                          onTap: () => onItemTapped(i),
                          child: BottomNavItem(
                            label: items[i].label,
                            imagePath: items[i].imagePath,
                            isSelected: isSelected,
                            showBadge: items[i].label == 'Notifications',
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
        ],
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
    final iconSize = isSelected ? 38.w : 26.w; // ✅ perfect + no overflow

    return SizedBox(
      width: 70.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: showBadge ? 30 : iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF0088FE) : const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
