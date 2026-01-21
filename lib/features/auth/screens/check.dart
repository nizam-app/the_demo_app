import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  static const String routeName = '/home';

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
                  left: 349.26.w,
                  top: 28.73.h,
                  width: 58.274.w,
                  height: 11.92.h,
                  child: Image.asset(
                    'assets/images/ba5ceecf7cc01a2fffd885ecd245d48e8746cdee.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                ),
                
                // Header Section
                _buildHeader(),
              
              // Category Buttons with Icons
              _buildCategoryButtons(),
              
              // Light Section Title
              Positioned(
                left: 39.3.w,
                top: 186.7.h,
                child: Text(
                  'Light',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              
              // Light Section Cards
              _buildLightSectionCards(),
              
              // Lighting Section Title
              Positioned(
                left: 15.05.w,
                top: 607.6.h,
                child: Text(
                  'Lighting',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              
              // Lighting Section Cards
              _buildLightingSectionCards(),
              
              // Favorites Section
              _buildFavoritesSection(),
              
              // Shading Section
              _buildShadingSection(),
              
              // Chart Section Title
              Positioned(
                left: 15.996.w,
                top: 1591.5.h,
                child: Text(
                  'Chart Section',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              
              // Bottom Navigation
              _buildBottomNavigation(),
              
              // All other elements
              ..._buildAllOtherElements(),
                ],
              ),
            ),
          ),
        ),
    );
  }

  // Header with hamburger menu, Dashboard title, and edit icon
  Widget _buildHeader() {
    return Stack(
      children: [
        // Hamburger menu (Group6) - 3 horizontal lines
        // React: left-[17px] top-[70px]
        // Lines are absolutely positioned within the parent:
        // - Line 1: left-[27px] top-[70px] = relative to parent: left: 10px (27-17), top: 0
        // - Line 2: left-[17px] top-[77px] = relative to parent: left: 0px (17-17), top: 7px (77-70)
        // - Line 3: left-[17px] top-[85px] = relative to parent: left: 0px (17-17), top: 15px (85-70)
        Positioned(
          left: 17.w,
          top: 70.h,
          child: Stack(
            children: [
              // Top line - React: left-[27px] top-[70px] w-[16px] h-[2px]
              // Relative to parent at (17, 70): left = 27-17 = 10px
              Positioned(
                left: 10.w,
                top: 0,
                child: Container(
                  width: 16.w,
                  height: 2.h,
                  color: const Color(0xFF111827),
                ),
              ),
              // Middle line - React: left-[17px] top-[77px] w-[23px] h-[2px]
              // Relative to parent at (17, 70): left = 17-17 = 0px, top = 77-70 = 7px
              Positioned(
                left: 0,
                top: 7.h,
                child: Container(
                  width: 23.w,
                  height: 2.h,
                  color: const Color(0xFF111827),
                ),
              ),
              // Bottom line - React: left-[17px] top-[85px] w-[15px] h-[2px]
              // Relative to parent at (17, 70): left = 17-17 = 0px, top = 85-70 = 15px
              Positioned(
                left: 0,
                top: 15.h,
                child: Container(
                  width: 15.w,
                  height: 2.h,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
        
        // Dashboard title - centered
        // React: inset-[3.24%_34.11%_95.48%_36.21%] which is approximately left: 156.3px, top: 63.1px
        Positioned(
          left: 156.3.w,
          top: 63.1.h,
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        
        // Edit icon on the right (circle with icon inside)
        // React: left-[380px] size-[32px] top-[62px] for circle
        // React: left-[385px] size-[22px] top-[67px] for image
        Positioned(
          left: 380.w,
          top: 62.h,
          width: 32.w,
          height: 32.h,
          child: Stack(
            children: [
              // Circle background
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
              ),
              // Icon inside (image 89) - edit/more icon
              // React position: left-[385px] top-[67px] relative to parent at 380px,62px means left: 5px, top: 5px
              Positioned(
                left: 5.w,
                top: 5.h,
                width: 22.w,
                height: 22.h,
                child: Image.asset(
                  'assets/images/7ae4c10963406f3ddb5095a7c443f8cdd1f539c9.png',
                  width: 22.w,
                  height: 22.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.edit,
                    size: 18.sp,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Category Buttons with Icons
  Widget _buildCategoryButtons() {
    return Stack(
      children: [
        // HVAC Button - with icon (NOT selected)
        Positioned(
          left: 13.w,
          top: 104.h,
          width: 123.w,
          height: 63.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.74),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Stack(
              children: [
                // Icon circle
                Positioned(
                  left: 24.w,
                  top: 11.h,
                  width: 41.492.w,
                  height: 41.492.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/69a3898d4d99365bd54ea33ab3198a8948ae7ee6.png',
                        width: 22.w,
                        height: 22.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.ac_unit,
                          size: 20.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                ),
                // Text
                Positioned(
                  left: 75.w,
                  top: 23.h,
                  child: Text(
                    'HVAC',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Shading Button 1 (middle) - with icon
        Positioned(
          left: 146.w,
          top: 105.h,
          width: 138.w,
          height: 63.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.74),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Stack(
              children: [
                // Icon circle
                Positioned(
                  left: 24.w,
                  top: 11.h,
                  width: 41.492.w,
                  height: 41.492.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/3a1c6c51277e57ef3c7686f8dac1a65d194f54b8.png',
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.blinds,
                          size: 20.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                ),
                // Text
                Positioned(
                  left: 75.w,
                  top: 23.h,
                  child: Text(
                    'Shading',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Light Button (SELECTED) - with icon and gradient border
        Positioned(
          left: 294.w,
          top: 105.h,
          width: 123.w,
          height: 63.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.74),
              border: Border.all(color: const Color(0xFF15DFFE), width: 1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Stack(
              children: [
                // Icon circle
                Positioned(
                  left: 24.w,
                  top: 11.h,
                  width: 41.492.w,
                  height: 41.492.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/1314ed055bf407712ad772a2a7eff0726623029d.png',
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.lightbulb_outline,
                          size: 20.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                ),
                // Text
                Positioned(
                  left: 75.w,
                  top: 23.h,
                  child: Text(
                    'Light',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Shading Button 2 (far right) - with icon
        Positioned(
          left: 428.w,
          top: 105.h,
          width: 137.w,
          height: 63.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.74),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Stack(
              children: [
                // Icon circle
                Positioned(
                  left: 24.w,
                  top: 11.h,
                  width: 41.492.w,
                  height: 41.492.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/ba96eabfd645481cd8c1fbf5383c9b1a45a26e14.png',
                        width: 23.w,
                        height: 23.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.blinds_closed,
                          size: 20.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                ),
                // Text
                Positioned(
                  left: 75.w,
                  top: 23.h,
                  child: Text(
                    'Shading',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF111827),
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

  // Light Section Cards (4 cards in 2x2 grid)
  Widget _buildLightSectionCards() {
    return Stack(
      children: [
        // Card 1 - Top Left (Bedroom spot light)
        _buildDeviceCard(
          left: 16.w,
          top: 212.h,
          width: 195.w,
          height: 183.h,
          deviceName: 'Bedroom spot light small patio blue light',
          iconImage: 'assets/images/ed37700e6f98c9d247787c0e49ab4772c685501f.png',
          statusText: '72%',
          modeButton: Positioned(
            left: 171.w,
            top: 222.h,
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
        ),
        
        // Card 2 - Top Right (Bathroom heating)
        _buildDeviceCard(
          left: 220.w,
          top: 212.h,
          width: 195.w,
          height: 183.h,
          deviceName: 'Bathroom heating and boiler thermostat',
          iconImage: 'assets/images/f35c494b5d9323837c65a010d22059070aa6f37b.png',
          statusText: '24.6°',
          modeButton: Positioned(
            left: 375.w,
            top: 223.h,
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
          controlButtons: [
            Positioned(
              left: 232.w,
              top: 346.h,
              width: 35.w,
              height: 35.h,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
            Positioned(
              left: 371.w,
              top: 347.h,
              width: 35.w,
              height: 35.h,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
          ],
        ),
        
        // Card 3 - Bottom Left (Blind Living Room)
        _buildDeviceCard(
          left: 15.w,
          top: 404.h,
          width: 195.w,
          height: 185.h,
          deviceName: 'Blind Living Room north window',
          iconImage: 'assets/images/70b35b712009e4fb765c1e3b1b72fd6d7e4c92a7.png',
          statusText: '0% / 72%',
          modeButton: Positioned(
            left: 171.w,
            top: 417.h,
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
          controlButtons: [
            Positioned(
              left: 25.w,
              top: 540.h,
              width: 35.w,
              height: 35.h,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 166.w,
              top: 540.h,
              width: 35.w,
              height: 35.h,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 20.sp,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Card 4 - Bottom Right (Irrigation)
        _buildDeviceCard(
          left: 220.w,
          top: 404.h,
          width: 195.w,
          height: 185.h,
          deviceName: 'Irrigation entry and front home two valve',
          iconImage: 'assets/images/a2b985126ef03e050674ff1db5daca52af4c4e57.png',
          statusText: 'On',
          modeButton: Positioned(
            left: 375.w,
            top: 417.h,
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
        ),
      ],
    );
  }

  Widget _buildDeviceCard({
    required double left,
    required double top,
    required double width,
    required double height,
    required String deviceName,
    required String iconImage,
    required String statusText,
    required Positioned modeButton,
    List<Positioned>? controlButtons,
  }) {
    return Stack(
      children: [
        // Card background
        Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(26.r),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with gradient mask
                Container(
                  width: 52.w,
                  height: 52.h,
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: Image.asset(
                    iconImage,
                    width: 52.w,
                    height: 52.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                // Device name
                Expanded(
                  child: Text(
                    deviceName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF111827),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Status text
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Mode button
        modeButton,
        // Control buttons
        if (controlButtons != null) ...controlButtons,
      ],
    );
  }

  // Lighting Section Cards
  Widget _buildLightingSectionCards() {
    return Stack(
      children: [
        // First row of cards
        _buildLightingCard(
          left: 16.w,
          top: 646.96.h,
          deviceName: 'Light Scene child room',
          status: 'All On',
          iconImage: 'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
        ),
        _buildLightingCard(
          left: 152.w,
          top: 646.96.h,
          deviceName: 'RGBW light patio entry',
          status: '100%',
          iconImage: 'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
        ),
        _buildLightingCard(
          left: 289.w,
          top: 646.96.h,
          deviceName: 'LED Dimmer living room',
          status: '100%',
          iconImage: 'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          progressCircle: true,
          modeButton: Positioned(
            left: 382.w,
            top: 658.h,
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
        ),
        
        // Second row of cards
        _buildLightingCard(
          left: 16.w,
          top: 791.h,
          deviceName: 'Light Scene child room',
          status: 'All On',
          iconImage: 'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
        ),
        _buildLightingCard(
          left: 152.w,
          top: 791.h,
          deviceName: 'RGBW light patio entry',
          status: '100%',
          iconImage: 'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
        ),
        _buildLightingCard(
          left: 289.w,
          top: 791.h,
          deviceName: 'LED Dimmer living room',
          status: '100%',
          iconImage: 'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          progressCircle: true,
          modeButton: Positioned(
            left: 382.w,
            top: 800.h,
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
        ),
      ],
    );
  }

  Widget _buildLightingCard({
    required double left,
    required double top,
    required String deviceName,
    required String status,
    required String iconImage,
    bool progressCircle = false,
    Positioned? modeButton,
  }) {
    return Stack(
      children: [
        // Card background
        Positioned(
          left: left,
          top: top,
          width: 127.w,
          height: 135.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(26.r),
            ),
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  width: 52.w,
                  height: 52.h,
                  child: Image.asset(
                    iconImage,
                    width: 52.w,
                    height: 52.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                // Device name
                Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF111827),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Status
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Progress circle if needed
        if (progressCircle)
          Positioned(
            left: left + 82.w,
            top: top + 8.h,
            width: 52.w,
            height: 52.h,
            child: CustomPaint(
              painter: CircularProgressPainter(
                progress: 1.0,
                strokeWidth: 3,
                colors: [
                  const Color(0xFF0088FE),
                  const Color(0xFF15DFFE),
                ],
              ),
              child: Center(
                child: Text(
                  '100%',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ),
        // Mode button if provided
        if (modeButton != null) modeButton,
      ],
    );
  }

  // Favorites Section
  Widget _buildFavoritesSection() {
    return Stack(
      children: [
        // Title
        Positioned(
          left: 16.18.w,
          top: 939.5.h,
          child: Text(
            'Favorites',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        
        // Camera Card 1
        Positioned(
          left: 16.w,
          top: 975.h,
          width: 194.w,
          height: 144.h,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(26.r),
                child: Image.asset(
                  'assets/images/328a2c5e933681916f5ce64c1952942a7ea4e97e.png',
                  width: 194.w,
                  height: 144.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0175F0).withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26.r),
                ),
              ),
              Positioned(
                bottom: 16.h,
                left: 16.w,
                child: Text(
                  'Front Door Camera',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Thermostat Card 1
        Positioned(
          left: 220.w,
          top: 975.h,
          width: 196.w,
          height: 144.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(26.r),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bedroom Thermostat parents room',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF111827),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                    SizedBox(width: 24.w),
                    Text(
                      '24.6°',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Camera Card 2
        Positioned(
          left: 13.w,
          top: 1129.h,
          width: 194.w,
          height: 144.h,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(26.r),
                child: Image.asset(
                  'assets/images/328a2c5e933681916f5ce64c1952942a7ea4e97e.png',
                  width: 194.w,
                  height: 144.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0175F0).withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26.r),
                ),
              ),
              Positioned(
                bottom: 16.h,
                left: 16.w,
                child: Text(
                  'Front Door Camera',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Thermostat Card 2
        Positioned(
          left: 217.w,
          top: 1129.h,
          width: 196.w,
          height: 144.h,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(26.r),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bedroom Thermostat parents room',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF111827),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                    SizedBox(width: 24.w),
                    Text(
                      '24.6°',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Shading Section
  Widget _buildShadingSection() {
    return Stack(
      children: [
        // Title
        Positioned(
          left: 15.996.w,
          top: 1281.8.h,
          child: Text(
            'Shading',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        
        // Shading Control 1
        _buildShadingControl(
          left: 15.8.w,
          top: 1321.h,
          deviceName: 'Blind Living Room south window upside right',
        ),
        
        // Shading Control 2
        _buildShadingControl(
          left: 16.w,
          top: 1409.h,
          deviceName: 'Blind Living Room south window upside right',
        ),
        
        // Shading Control 3
        _buildShadingControl(
          left: 16.w,
          top: 1496.87.h,
          deviceName: 'Blind Living Room south window upside right',
        ),
        
        // Temperature Set Point Card
        Positioned(
          left: 15.w,
          top: 1632.33.h,
          width: 400.w,
          height: 216.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE1E1E1)),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bathroom Temperature set point',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: 44.066.w,
                          height: 19.878.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0088FE),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Center(
                            child: Text(
                              '24.6°C',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 37.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(26.r),
                      bottomRight: Radius.circular(26.r),
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

  Widget _buildShadingControl({
    required double left,
    required double top,
    required String deviceName,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: 400.w,
      height: 77.861.h,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(26.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deviceName,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '50%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20.sp,
                      color: const Color(0xFF111827),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.keyboard_arrow_up,
                      size: 20.sp,
                      color: const Color(0xFF111827),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation
  Widget _buildBottomNavigation() {
    return Positioned(
      left: 0,
      top: 1874.33.h,
      width: 430.w,
      height: 73.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.74),
        ),
        child: Column(
          children: [
            Container(
              height: 1,
              color: const Color(0xFFE1E1E1),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem('Devices', false, 'assets/images/93bac95a0aa875d37420920632c915302a505c7e.png'),
                _buildNavItem('Automations', false, 'assets/images/ec74ce76d8a44411ccfe4f8d735def08095b55f7.png'),
                _buildNavItem('Analytics', false, null),
                _buildNavItem('Voice', true, 'assets/images/97192ece6ce16b343f22927981399518de1c79ae.png'),
                _buildNavItem('Notifications', false, 'assets/images/cff9d677e416cc8452f4e666a4e2cc929b22151f.png'),
              ],
            ),
            SizedBox(height: 4.h),
            Container(
              width: 77.w,
              height: 3.h,
              margin: EdgeInsets.only(left: 177.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0088FE),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, bool isSelected, String? iconPath) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30.w,
              height: 30.h,
              child: iconPath != null
                  ? Image.asset(
                      iconPath,
                      width: 30.w,
                      height: 30.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.home,
                        size: 24.sp,
                        color: isSelected ? const Color(0xFF0088FE) : const Color(0xFF111827),
                      ),
                    )
                  : Icon(
                      Icons.analytics,
                      size: 24.sp,
                      color: isSelected ? const Color(0xFF0088FE) : const Color(0xFF111827),
                    ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF0088FE) : const Color(0xFF111827),
              ),
            ),
          ],
        ),
        // Notification badge for Notifications - positioned over the icon
        if (label == 'Notifications')
          Positioned(
            right: -2.w,
            top: -2.h,
            child: Container(
              width: 19.w,
              height: 15.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFE019A),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Center(
                child: Text(
                  '12',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // All other elements (mode buttons, control buttons, etc.)
  List<Widget> _buildAllOtherElements() {
    return [
      // Additional mode buttons for shading controls
      Positioned(
        left: 93.w,
        top: 1367.h,
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
      Positioned(
        left: 93.w,
        top: 1544.h,
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
      Positioned(
        left: 92.w,
        top: 1455.h,
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
      Positioned(
        left: 382.w,
        top: 984.h,
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
      Positioned(
        left: 379.w,
        top: 1138.h,
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
    ];
  }
}

// Custom Painter for Circular Progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final gradient = SweepGradient(
      colors: colors,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


