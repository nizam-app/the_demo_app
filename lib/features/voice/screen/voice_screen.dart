import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../nav_bar/screen/custom_bottom_nav_bar.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  static const String routeName = '/voice';

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  int _selectedNavIndex = 2; // Voice is index 2

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Voice',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Voice Screen',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedNavIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}
