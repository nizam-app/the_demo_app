import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});
  
  static const String routeName = '/devices';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            width: 430.w,
            height: 1947.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Status Bar - Time
                Positioned(
                  left: 32.9.w,
                  top: 25.7.h,
                  child: Text(
                    '9:41',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
                
                // Status Bar - Signal icons
                Positioned(
                  left: 348.33.w,
                  top: 29.23.h,
                  width: 58.274.w,
                  height: 11.92.h,
                  child: Image.asset(
                    'assets/images/ba5ceecf7cc01a2fffd885ecd245d48e8746cdee.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                ),
                
                // Background blue section
                Positioned(
                  left: 0,
                  top: 475.h,
                  width: 430.w,
                  height: 88.h,
                  child: Container(
                    color: const Color(0xFFEAF1FF),
                  ),
                ),
                
                // Header "Devices" title
                Positioned(
                  left: 165.98.w,
                  top: 48.16.h,
                  child: Text(
                    'Devices',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
                
                // All other content
                ..._buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      // Devices title (second one)
      Positioned(
        left: 18.17.w,
        top: 410.09.h,
        child: Text(
          'Devices',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      
      // Control units title
      Positioned(
        left: 21.59.w,
        top: 1573.13.h,
        child: Text(
          'Control units',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      
      // Search bar
      Positioned(
        left: 16.w,
        top: 107.h,
        width: 400.w,
        height: 46.h,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: Center(
            child: Text(
              'Search',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
      
      // Filter buttons
      _buildFilterButtons(),
      
      // Device list items
      _buildDeviceItems(),
      
      // Mode buttons and controls
      _buildModeButtons(),
      
      // Toggle switches
      _buildToggleSwitches(),
      
      // Control buttons (+ and -)
      _buildControlButtons(),
      
      // Images
      _buildImages(),
      
      // Dividers
      _buildDividers(),
      
      // Category buttons
      _buildCategoryButtons(),
      
      // Time labels
      _buildTimeLabels(),
      
      // Additional UI elements
      ..._buildAdditionalElements(),
    ];
  }

  Widget _buildFilterButtons() {
    return Stack(
      children: [
        // All button (selected)
        Positioned(
          left: 18.w,
          top: 171.h,
          width: 62.w,
          height: 32.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF0088FE), width: 1),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                'All',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0088FE),
                ),
              ),
            ),
          ),
        ),
        
        // Groups button
        Positioned(
          left: 90.w,
          top: 171.h,
          width: 92.w,
          height: 32.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.74),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                'Groups',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Smart button
        Positioned(
          left: 194.w,
          top: 171.h,
          width: 70.w,
          height: 32.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                'Smart',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Favorites button
        Positioned(
          left: 276.w,
          top: 171.h,
          width: 75.w,
          height: 32.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Category button
        Positioned(
          left: 361.w,
          top: 171.h,
          width: 88.w,
          height: 32.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceItems() {
    return Stack(
      children: [
        // RGBW item
        _buildDeviceRow(
          left: 75.31.w,
          top: 412.33.h,
          deviceName: 'RGBW',
          status: 'Off',
          id: 'LCDOC12',
        ),
        
        // Alarm item
        _buildDeviceRow(
          left: 76.54.w,
          top: 562.08.h,
          deviceName: 'Alram',
          status: 'Disarmed',
          id: 'DO12UI12',
        ),
        
        // Bathroom item
        _buildDeviceRow(
          left: 75.01.w,
          top: 651.45.h,
          deviceName: 'Bathroom',
          status: '24.6°C',
          id: null,
        ),
        
        // Block Irrigation Schedule item
        _buildDeviceRow(
          left: 76.18.w,
          top: 841.05.h,
          deviceName: 'Block Irrigation Schedule',
          status: 'Blocked',
          id: null,
        ),
        
        // Card Reader(s) item
        _buildDeviceRow(
          left: 76.28.w,
          top: 1018.35.h,
          deviceName: 'Card Reader(s)',
          status: 'Blocked',
          id: null,
        ),
        
        // Brightness item
        _buildDeviceRow(
          left: 75.94.w,
          top: 730.83.h,
          deviceName: 'Brightness',
          status: '54%',
          id: null,
        ),
        
        // Blind Living Room item
        _buildDeviceRow(
          left: 73.82.w,
          top: 624.08.h,
          deviceName: 'Blind Living Room',
          status: '0%',
          secondStatus: '50%',
          id: null,
        ),
        
        // CORE20 item
        _buildDeviceRow(
          left: 76.18.w,
          top: 1668.7.h,
          deviceName: 'CORE20',
          status: null,
          id: 'CORE20-4B37-3419-363A',
        ),
        
        // DO12 item
        _buildDeviceRow(
          left: 75.89.w,
          top: 1797.93.h,
          deviceName: 'DO12',
          status: null,
          id: 'CORE20-4B37-3419-363A',
        ),
        
        // WSBT item
        _buildDeviceRow(
          left: 75.89.w,
          top: 610.47.h,
          deviceName: 'WSBT',
          status: null,
          id: null,
        ),
        
        // 11 Devices count
        Positioned(
          left: 254.01.w,
          top: 1848.75.h,
          child: Text(
            '11 Devices',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceRow({
    required double left,
    required double top,
    required String deviceName,
    String? status,
    String? secondStatus,
    String? id,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            deviceName,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF111827),
            ),
          ),
          if (status != null || secondStatus != null) ...[
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (status != null)
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                if (secondStatus != null) ...[
                  SizedBox(width: 8.w),
                  Text(
                    secondStatus,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ],
            ),
          ],
          if (id != null) ...[
            SizedBox(height: 2.h),
            Text(
              id,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeButtons() {
    return Stack(
      children: [
        // Mode button A (top)
        Positioned(
          left: 75.w,
          top: 280.47.h,
          width: 26.w,
          height: 26.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ),
        
        // Mode button M (middle)
        Positioned(
          left: 75.w,
          top: 436.23.h,
          width: 26.w,
          height: 26.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6B7280),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Center(
              child: Text(
                'M',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        
        // Mode button A (bottom)
        Positioned(
          left: 76.w,
          top: 507.h,
          width: 26.w,
          height: 26.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSwitches() {
    return Stack(
      children: [
        // Toggle switch 1 (top, off)
        Positioned(
          left: 347.w,
          top: 269.46.h,
          width: 60.w,
          height: 35.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0088FE),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 31.w,
                  top: 2.h,
                  width: 30.856.w,
                  height: 30.856.h,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Toggle switch 2 (bottom, off)
        Positioned(
          left: 347.w,
          top: 744.h,
          width: 60.w,
          height: 35.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 3.13.w,
                  top: 2.27.h,
                  width: 30.856.w,
                  height: 30.856.h,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Stack(
      children: [
        // Plus button (top)
        Positioned(
          left: 251.w,
          top: 269.5.h,
          width: 35.w,
          height: 35.h,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Plus button (second)
        Positioned(
          left: 304.w,
          top: 269.5.h,
          width: 35.w,
          height: 35.h,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Plus button (third)
        Positioned(
          left: 319.w,
          top: 413.5.h,
          width: 35.w,
          height: 35.h,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Plus button (fourth)
        Positioned(
          left: 372.w,
          top: 413.5.h,
          width: 35.w,
          height: 35.h,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Plus button (fifth)
        Positioned(
          left: 319.w,
          top: 498.h,
          width: 35.w,
          height: 35.h,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Minus button (top)
        Positioned(
          left: 372.w,
          top: 498.h,
          width: 35.w,
          height: 35.h,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
        ),
        
        // Large plus button (blue background)
        Positioned(
          left: 381.w,
          top: 58.h,
          width: 32.w,
          height: 32.h,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0088FE),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        
        // Large minus button (white background)
        Positioned(
          left: 112.w,
          top: 346.h,
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 60.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        
        // Arrow down button
        Positioned(
          left: 112.w,
          top: 510.56.h,
          width: 11.668.w,
          height: 11.668.h,
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 12.sp,
            color: const Color(0xFF111827),
          ),
        ),
        
        // Arrow up button
        Positioned(
          left: 112.w,
          top: 517.6.h,
          width: 11.668.w,
          height: 11.668.h,
          child: Transform.rotate(
            angle: 3.14159, // 180 degrees
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 12.sp,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImages() {
    return Stack(
      children: [
        // Temperature icon
        Positioned(
          left: 110.w,
          top: 439.28.h,
          width: 8.683.w,
          height: 19.h,
          child: Image.asset(
            'assets/images/60219ebec605e1574a1e3bcff44027efec6c1696.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.thermostat,
              size: 19.sp,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        
        // Image 55 (top)
        Positioned(
          left: 354.w,
          top: 474.h,
          width: 24.w,
          height: 24.h,
          child: Image.asset(
            'assets/images/60219ebec605e1574a1e3bcff44027efec6c1696.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
        ),
        
        // Image 81 (top)
        Positioned(
          left: 358.w,
          top: 250.h,
          width: 16.w,
          height: 16.h,
          child: Image.asset(
            'assets/images/60219ebec605e1574a1e3bcff44027efec6c1696.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
        ),
        
        // Image 81 (middle)
        Positioned(
          left: 411.w,
          top: 350.h,
          width: 16.w,
          height: 16.h,
          child: Image.asset(
            'assets/images/60219ebec605e1574a1e3bcff44027efec6c1696.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
        ),
        
        // Image 55 (bottom)
        Positioned(
          left: 400.w,
          top: 638.h,
          width: 24.w,
          height: 24.h,
          child: Image.asset(
            'assets/images/60219ebec605e1574a1e3bcff44027efec6c1696.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
        ),
        
        // Image 124 (top)
        Positioned(
          left: 23.w,
          top: 891.h,
          width: 33.w,
          height: 33.h,
          child: Image.asset(
            'assets/images/60219ebec605e1574a1e3bcff44027efec6c1696.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
        ),
        
        // Image 124 (bottom)
        Positioned(
          left: 23.w,
          top: 975.h,
          width: 33.w,
          height: 33.h,
          child: Image.asset(
            'assets/images/60219ebec605e1574a1e3bcff44027efec6c1696.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
        ),
        
        // Rectangle image (light icon)
        Positioned(
          left: 19.98.w,
          top: 283.5.h,
          width: 35.02.w,
          height: 35.02.h,
          child: Image.asset(
            'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildDividers() {
    return Stack(
      children: [
        // Divider 1
        Positioned(
          left: 75.w,
          top: 346.h,
          width: 356.w,
          height: 1,
          child: Container(
            color: const Color(0xFFE1E1E1),
          ),
        ),
        
        // Divider 2
        Positioned(
          left: 75.w,
          top: 402.h,
          width: 355.w,
          height: 1,
          child: Container(
            color: const Color(0xFFE1E1E1),
          ),
        ),
        
        // Divider 3
        Positioned(
          left: 75.w,
          top: 635.h,
          width: 355.w,
          height: 1,
          child: Container(
            color: const Color(0xFFE1E1E1),
          ),
        ),
        
        // Divider 4
        Positioned(
          left: 76.w,
          top: 720.h,
          width: 362.w,
          height: 1,
          child: Container(
            color: const Color(0xFFE1E1E1),
          ),
        ),
        
        // Divider 5
        Positioned(
          left: 76.w,
          top: 796.h,
          width: 354.w,
          height: 1,
          child: Container(
            color: const Color(0xFFE1E1E1),
          ),
        ),
        
        // Divider 6
        Positioned(
          left: 76.w,
          top: 940.h,
          width: 354.w,
          height: 1,
          child: Container(
            color: const Color(0xFFE1E1E1),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButtons() {
    return Stack(
      children: [
        // Lighting button
        Positioned(
          left: 75.w,
          top: 325.47.h,
          width: 62.w,
          height: 18.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF0088FE), width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                'Lighting',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0088FE),
                ),
              ),
            ),
          ),
        ),
        
        // Bathroom button
        Positioned(
          left: 147.w,
          top: 325.47.h,
          width: 68.w,
          height: 18.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFE019A),
              border: Border.all(color: const Color(0xFFFE019A), width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                'Bathroom',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        
        // Time control buttons
        Positioned(
          left: 255.w,
          top: 659.h,
          width: 152.w,
          height: 39.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE1E1E1),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 93.w,
                  height: 39.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      bottomLeft: Radius.circular(30.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLabels() {
    return Stack(
      children: [
        Positioned(
          left: 378.99.w,
          top: 419.19.h,
          child: Text(
            '18:32',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        
        Positioned(
          left: 378.63.w,
          top: 608.87.h,
          child: Text(
            '20:36',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAdditionalElements() {
    return [
      // Hamburger menu button
      Positioned(
        left: 19.w,
        top: 58.h,
        width: 32.w,
        height: 32.h,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.menu,
              size: 20.sp,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ),
      
      // Settings/more button
      Positioned(
        left: 332.w,
        top: 58.h,
        width: 32.w,
        height: 32.h,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.more_vert,
              size: 20.sp,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ),
      
      // Blue circles for indicators
      Positioned(
        left: 363.w,
        top: 353.h,
        width: 44.w,
        height: 44.h,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0088FE),
            shape: BoxShape.circle,
          ),
        ),
      ),
      
      Positioned(
        left: 363.w,
        top: 579.h,
        width: 44.w,
        height: 44.h,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0088FE),
            shape: BoxShape.circle,
          ),
        ),
      ),
      
      // Blue circle with border
      Positioned(
        left: 42.w,
        top: 524.h,
        width: 22.w,
        height: 22.h,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF0088FE), width: 1),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
  }
}
