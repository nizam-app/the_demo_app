import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Standalone bottom nav bar widget for individual screens (uses route navigation)
class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({
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
      NavItemData('Dashboard', 'assets/Mask group copy 6.png'),
      NavItemData('Notifications', 'assets/Group 43.png'),
      NavItemData('Settings', 'assets/seting.png'),
    ];

    return RepaintBoundary(
      child: Container(
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
                  left: w * selectedIndex + (w - 46.w) / 2,
                  child: Container(
                    width: 46.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(2.r),
                        bottomRight: Radius.circular(2.r),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(items.length, (i) {
                    return Expanded(
                      child: InkWell(
                        onTap: () => onItemTapped(i),
                        child: BottomNavItem(
                          label: items[i].label,
                          imagePath: items[i].imagePath,
                          isSelected: i == selectedIndex,
                          showBadge: items[i].label == 'Notifications',
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Primary container with IndexedStack for smooth transitions
class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    super.key,
    required this.children,
    this.initialIndex = 2,
    //this.drawer,
    this.backgroundColor,
  });

  final List<Widget> children;
  final int initialIndex;
 // final Widget? drawer;
  final Color? backgroundColor;

  static CustomBottomNavBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<CustomBottomNavBarState>();
  }

  @override
  State<CustomBottomNavBar> createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void setSelectedIndex(int index) {
    if (index != _selectedIndex && index >= 0 && index < widget.children.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onItemTapped(int index) {
    setSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      NavItemData('Devices', 'assets/Group 28.png'),
      NavItemData('Analytics', 'assets/bar 5.png'),
      NavItemData('Dashboard', 'assets/Mask group copy 6.png'),
      NavItemData('Notifications', 'assets/Group 43.png'),
      NavItemData('Settings', 'assets/seting.png'),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor ?? Colors.white,
      //drawer: widget.drawer,
      body: RepaintBoundary(
        child: IndexedStack(index: _selectedIndex, children: widget.children),
      ),
      bottomNavigationBar: RepaintBoundary(
        child: Container(
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
                    left: w * _selectedIndex + (w - 46.w) / 2,
                    child: Container(
                      width: 46.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(2.r),
                          bottomRight: Radius.circular(2.r),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(items.length, (i) {
                      return Expanded(
                        child: InkWell(
                          onTap: () => _onItemTapped(i),
                          child: BottomNavItem(
                            label: items[i].label,
                            imagePath: items[i].imagePath,
                            isSelected: i == _selectedIndex,
                            showBadge: items[i].label == 'Notifications',
                          ),
                        ),
                      );
                    }),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              imagePath,
              width: 26.sp,
              height: 26.sp,
              color: const Color(0xFF111827),
            ),
            if (showBadge)
              Positioned(
                right: -10.w,
                top: -6.h,
                child: Container(
                  width: 19.w,
                  height: 15.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFE019A),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Text(
                    '12',
                    style: TextStyle(
                      fontFamily: 'Inter',
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
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}