import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/liquid_glass.dart';

/// Theme so [Scaffold.bottomNavigationBar] stays transparent (content shows through blur).
ThemeData liquidGlassBottomNavTheme(ThemeData base) {
  return base.copyWith(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: Colors.transparent,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Colors.transparent,
      elevation: 0,
    ),
  );
}

/// Scroll/list bottom padding when body extends under the floating glass tab bar.
double floatingGlassTabBarScrollPadding(BuildContext context) {
  final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
  return 18.h + 68.h + 10.h + bottomInset + 8.h;
}

/// WhatsApp-style shell: [extendBody] + floating frosted footer on every screen.
class GlassBottomNavScaffold extends StatelessWidget {
  const GlassBottomNavScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onItemTapped,
    this.backgroundColor,
    this.floatingActionButton,
    this.appBar,
    this.showBottomNav = true,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: liquidGlassBottomNavTheme(Theme.of(context)),
      child: Scaffold(
        extendBody: true,
        backgroundColor: backgroundColor ?? Colors.white,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: body,
        bottomNavigationBar: showBottomNav
            ? BottomNavBarWidget(
                selectedIndex: selectedIndex,
                onItemTapped: onItemTapped,
              )
            : null,
      ),
    );
  }
}

/// Standard iOS tab bar: opaque white + hairline top separator.
BoxDecoration iosTabBarDecoration() {
  return const BoxDecoration(
    color: Colors.white,
    border: Border(
      top: BorderSide(color: Color(0xFFE1E1E1), width: 1),
    ),
  );
}

// Standalone bottom nav bar widget for individual screens (uses route navigation)
class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.backgroundOpacity = 0.10,
    this.useBackdropBlur = true,
    this.trackColor,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  /// White wash over content behind the bar (default matches previous look).
  final double backgroundOpacity;

  /// When true, blurs content behind the bar and uses a soft top edge.
  final bool useBackdropBlur;

  /// When set, used as the bar fill instead of [Colors.white] with [backgroundOpacity].
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    const items = [
      NavItemData('Devices', 'assets/Group 28.png'),
      NavItemData('Analytics', 'assets/bar 5.png'),
      NavItemData('Dashboard', 'assets/Mask group copy 6.png'),
      NavItemData('Notifications', 'assets/Group 43.png'),
      NavItemData('Settings', 'assets/seting.png'),
    ];

    if (trackColor == null) {
      return RepaintBoundary(
        child: Material(
          type: MaterialType.transparency,
          elevation: 0,
          color: Colors.transparent,
          child: LiquidGlassFloatingTabBar(
            items: items,
            selectedIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ),
      );
    }

    final track = Material(
      type: MaterialType.transparency,
      child: Container(
        height: 72.h,
        decoration: trackColor != null
            ? BoxDecoration(
                color: trackColor,
                border: const Border(
                  top: BorderSide(color: Color(0xFFE1E1E1), width: 1),
                ),
              )
            : iosTabBarDecoration(),
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
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
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

    return RepaintBoundary(child: track);
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
    this.translucentBottomBar = true,
    this.bottomBarBackgroundOpacity = 0.10,
  });

  final List<Widget> children;
  final int initialIndex;
 // final Widget? drawer;
  final Color? backgroundColor;

  /// When true, the shell bottom bar uses a translucent track (dashboard shell).
  final bool translucentBottomBar;

  /// Used when [translucentBottomBar] is true.
  final double bottomBarBackgroundOpacity;

  static CustomBottomNavBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<CustomBottomNavBarState>();
  }

  @override
  State<CustomBottomNavBar> createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;
  bool _bottomBarVisible = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const String _dashboardRoute = '/home';

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

  void setBottomBarVisible(bool visible) {
    if (_bottomBarVisible == visible) return;
    setState(() => _bottomBarVisible = visible);
  }

  void _onItemTapped(int index) {
    // "Dashboard" in the footer must always open the main dashboard screen,
    // not just switch the local IndexedStack (which can display zone/category
    // pages under the dashboard tab).
    if (index == 2) {
      context.go(_dashboardRoute);
      // When already on `/home`, [context.go] does not rebuild the shell; the
      // IndexedStack would otherwise stay on Devices/Analytics/etc.
      setSelectedIndex(2);
      return;
    }
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

    return Theme(
      data: liquidGlassBottomNavTheme(Theme.of(context)),
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: widget.backgroundColor ?? Colors.white,
        //drawer: widget.drawer,
        body: RepaintBoundary(
          child: IndexedStack(index: _selectedIndex, children: widget.children),
        ),
        bottomNavigationBar: _bottomBarVisible
            ? RepaintBoundary(
                child: Material(
                  type: MaterialType.transparency,
                  elevation: 0,
                  color: Colors.transparent,
                  child: _buildShellBottomBar(items),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildShellBottomBar(List<NavItemData> items) {
    return LiquidGlassFloatingTabBar(
      items: items,
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}

/// Full-width tab track with top selection line (Devices / Analytics / …).
class _FlatShellTabTrack extends StatelessWidget {
  const _FlatShellTabTrack({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<NavItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: iosTabBarDecoration(),
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
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
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
    );
  }
}

/// Floating frosted pill tab bar (Liquid Glass — app-wide shell / standalone nav).
class LiquidGlassFloatingTabBar extends StatelessWidget {
  const LiquidGlassFloatingTabBar({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<NavItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    // Sit closer to the home indicator (WhatsApp-style), not floating high above it.
    final double bottomGap = bottomInset > 0 ? 0.h : 6.h;
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: false,
      minimum: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, bottomGap + bottomInset),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: LiquidGlass.floatingPillShadow(),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
              child: Container(
                height: 68.h,
                decoration: LiquidGlass.floatingTabBarDecoration(),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final tabWidth = c.maxWidth / items.length;
                    final barHeight = 68.h;
                    final capsuleInsetH = 3.w;
                    final capsuleWidth = tabWidth - capsuleInsetH * 2;
                    final capsuleHeight = 58.h;
                    final capsuleTop = (barHeight - capsuleHeight) / 2;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOutCubic,
                          left: tabWidth * selectedIndex + capsuleInsetH,
                          top: capsuleTop,
                          width: capsuleWidth,
                          height: capsuleHeight,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827)
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(items.length, (i) {
                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => onTap(i),
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
            ),
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