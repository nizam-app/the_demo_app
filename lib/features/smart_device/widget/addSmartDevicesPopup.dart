// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// class AddSmartDeviceSheet extends StatefulWidget {
//   const AddSmartDeviceSheet({super.key});
//
//   @override
//   State<AddSmartDeviceSheet> createState() => _AddSmartDeviceSheetState();
// }
//
// class _AddSmartDeviceSheetState extends State<AddSmartDeviceSheet> {
//   static const _bg = Colors.white;
//   static const _textPrimary = Color(0xFF000000);
//   static const _divider = Color(0xFFE5E7EB);
//   static const _closeBg = Color(0xFFF3F4F6);
//   static const _selectedBg = Color(0xFFE8F4FF);
//
//   late final List<_AddDeviceItem> items;
//   int _selectedIndex = 7; // Heating & Cooling (match screenshot)
//
//   @override
//   void initState() {
//     super.initState();
//     items = <_AddDeviceItem>[
//       _AddDeviceItem(imagePath: 'assets/images/irrigation.png', title: 'Irrigation', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/sensor.png', title: 'Brightness sensor', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/Rectangle.png', title: 'RGB light', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/lock.png', title: 'Alram', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/meter.png', title: 'Electric meter', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/play.png', title: 'Push button', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/fan.png', title: 'Vent (3 levels)', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/heating_cooling.png', title: 'Heating & Cooling', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/irrigation.png', title: 'Irrigation', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/sensor.png', title: 'Brightness sensor', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/Rectangle.png', title: 'RGB light', iconW: 26, iconH: 26),
//       _AddDeviceItem(imagePath: 'assets/images/kitchen.png', title: 'Motion sensor', iconW: 26, iconH: 26),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _bg,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24.r),
//           topRight: Radius.circular(24.r),
//         ),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header: title centered, X on right
//             SizedBox(
//               height: 56.h,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Add smart device',
//                       style: TextStyle(
//                         fontSize: 17.sp,
//                         fontWeight: FontWeight.w700,
//                         color: _textPrimary,
//                         fontFamily: 'Inter',
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     right: 20.w,
//                     child: GestureDetector(
//                       onTap: () => Navigator.of(context).pop(),
//                       child: Container(
//                         width: 32.w,
//                         height: 32.w,
//                         decoration: const BoxDecoration(
//                           color: _closeBg,
//                           shape: BoxShape.circle,
//                         ),
//                         alignment: Alignment.center,
//                         child: Icon(Icons.close, size: 20.sp, color: _textPrimary),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // List with separators and selected highlight
//             Flexible(
//               child: ListView.separated(
//                 padding: EdgeInsets.only(bottom: 18.h),
//                 itemCount: items.length,
//                 separatorBuilder: (_, __) => Container(
//                   height: 1,
//                   margin: EdgeInsets.only(left: 64.w),
//                   color: _divider,
//                 ),
//                 itemBuilder: (context, i) {
//                   final it = items[i];
//                   final selected = i == _selectedIndex;
//                   return _AddDeviceRow(
//                     imagePath: it.imagePath,
//                     title: it.title,
//                     iconW: it.iconW,
//                     iconH: it.iconH,
//                     selected: selected,
//                     onTap: () => setState(() => _selectedIndex = i),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _AddDeviceRow extends StatelessWidget {
//   const _AddDeviceRow({
//     required this.imagePath,
//     required this.title,
//     required this.onTap,
//     this.iconW = 26,
//     this.iconH = 26,
//     this.selected = false,
//   });
//
//   final String imagePath;
//   final String title;
//   final VoidCallback onTap;
//   final double iconW;
//   final double iconH;
//   final bool selected;
//
//   static const _textPrimary = Color(0xFF111827);
//   static const _selectedBg = Color(0xFFE8F4FF);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: selected ? _selectedBg : Colors.white,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 34.w,
//                 height: 34.w,
//                 child: Center(
//                   child: Image.asset(
//                     imagePath,
//                     width: iconW.w,
//                     height: iconH.h,
//                     fit: BoxFit.contain,
//                     filterQuality: FilterQuality.high,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                     color: _textPrimary,
//                     fontFamily: 'Inter',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _AddDeviceItem {
//   final String imagePath;
//   final String title;
//   final double iconW;
//   final double iconH;
//
//   const _AddDeviceItem({
//     required this.imagePath,
//     required this.title,
//     this.iconW = 26,
//     this.iconH = 26,
//   });
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ✅ Call this to open the bottom sheet (always from bottom + draggable + scroll)
void showAddSmartDeviceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,             
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: Colors.black.withOpacity(0.25),
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.62, // ✅ screenshot-like height
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => AddSmartDeviceSheet(
        scrollController: controller,
      ),
    ),
  );
}

class AddSmartDeviceSheet extends StatefulWidget {
  const AddSmartDeviceSheet({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<AddSmartDeviceSheet> createState() => _AddSmartDeviceSheetState();
}

class _AddSmartDeviceSheetState extends State<AddSmartDeviceSheet> {
  static const _bg = Colors.white;
  static const _textPrimary = Color(0xFF000000);
  static const _divider = Color(0xFFE5E7EB);
  static const _closeBg = Color(0xFFF3F4F6);
  static const _selectedBg = Color(0xFFE8F4FF);

  late final List<_AddDeviceItem> items;
  int _selectedIndex = 7; // Heating & Cooling (match screenshot)

  @override
  void initState() {
    super.initState();
    items = <_AddDeviceItem>[
      _AddDeviceItem(
          imagePath: 'assets/images/irrigation.png',
          title: 'Irrigation',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/sensor.png',
          title: 'Brightness sensor',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/Rectangle.png',
          title: 'RGB light',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/lock.png',
          title: 'Alram',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/meter.png',
          title: 'Electric meter',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/play.png',
          title: 'Push button',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/fan.png',
          title: 'Vent (3 levels)',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/heating_cooling.png',
          title: 'Heating & Cooling',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/irrigation.png',
          title: 'Irrigation',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/sensor.png',
          title: 'Brightness sensor',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/Rectangle.png',
          title: 'RGB light',
          iconW: 26,
          iconH: 26),
      _AddDeviceItem(
          imagePath: 'assets/images/kitchen.png',
          title: 'Motion sensor',
          iconW: 26,
          iconH: 26),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: Container(
        color: _bg,
        child: Column(
          children: [
            // Header: title centered, X on right
            SizedBox(
              height: 56.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Add smart device',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.w,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: _closeBg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child:
                        Icon(Icons.close, size: 20.sp, color: _textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List with separators and selected highlight
            Expanded(
              child: ListView.separated(
                controller: widget.scrollController, // ✅ makes sheet draggable + list scroll
                padding: EdgeInsets.only(bottom: 18.h),
                itemCount: items.length,
                separatorBuilder: (_, __) => Container(
                  height: 1,
                  margin: EdgeInsets.only(left: 64.w),
                  color: _divider,
                ),
                itemBuilder: (context, i) {
                  final it = items[i];
                  final selected = i == _selectedIndex;
                  return _AddDeviceRow(
                    imagePath: it.imagePath,
                    title: it.title,
                    iconW: it.iconW,
                    iconH: it.iconH,
                    selected: selected,
                    onTap: () => setState(() => _selectedIndex = i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddDeviceRow extends StatelessWidget {
  const _AddDeviceRow({
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.iconW = 26,
    this.iconH = 26,
    this.selected = false,
  });

  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final double iconW;
  final double iconH;
  final bool selected;

  static const _textPrimary = Color(0xFF111827);
  static const _selectedBg = Color(0xFFE8F4FF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _selectedBg : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          child: Row(
            children: [
              SizedBox(
                width: 34.w,
                height: 34.w,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: iconW.w,
                    height: iconH.h,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddDeviceItem {
  final String imagePath;
  final String title;
  final double iconW;
  final double iconH;

  const _AddDeviceItem({
    required this.imagePath,
    required this.title,
    this.iconW = 26,
    this.iconH = 26,
  });
}