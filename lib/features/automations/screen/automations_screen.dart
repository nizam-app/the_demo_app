import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/core/widget/liquid_glass.dart';

import '../../nav_bar/screen/custom_bottom_nav_bar.dart';

class AutomationsScreen extends StatefulWidget {
  const AutomationsScreen({super.key, this.showBottomNav = true});

  static const String routeName = '/automations';
  final bool showBottomNav;

  @override
  State<AutomationsScreen> createState() => _AutomationsScreenState();
}

class _AutomationsScreenState extends State<AutomationsScreen> {
  int _selectedNavIndex = 4; // Automations is index 4

  void _onNavItemTapped(int index) {
    final routes = [
      '/devices',
      '/analytics',
      '/home', // Voice points to home
      '/notifications',
      '/automations',
    ];
    if (index < routes.length) {
      context.go(routes[index]);
    }
  }

  void _onBack() {
    if (!widget.showBottomNav) {
      final shell = CustomBottomNavBar.of(context);
      if (shell != null) {
        shell.setSelectedIndex(2);
        return;
      }
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Text(
              'Automations Screen',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: DecoratedBox(
                  decoration: LiquidGlass.barDecoration(),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
                      child: SizedBox(
                        height: 36.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalCircleIconBtn(
                                icon: Icons.arrow_back,
                                onTap: _onBack,
                              ),
                            ),
                            Text(
                              'Automations',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavBarWidget(
              selectedIndex: _selectedNavIndex,
              onItemTapped: _onNavItemTapped,
            )
          : null,
    );
  }
}
