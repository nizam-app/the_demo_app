import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _textPrimary = Color(0xFF111827);
const _textSecondary = Color(0xFF6B7280);
const _danger = Color(0xFFFE019A);
const _blue = Color(0xFF007AFF);

class EditAddSectionSheet extends StatefulWidget {
  const EditAddSectionSheet({super.key});

  @override
  State<EditAddSectionSheet> createState() => _EditAddSectionSheetState();
}

class _EditAddSectionSheetState extends State<EditAddSectionSheet> {
  String _selectedSize = 'S';
  bool _sliderWidget = true;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h, bottom: 0.h),
          decoration: BoxDecoration(
            // Keep the sheet clearly transparent like the dashboard header/footer.
            // color: Colors.white.withOpacity(0.28),
            color: Color(0xFFFFFFFF).withOpacity(0.4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w, right: 0.w, bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left spacer (same size as close button)
                  SizedBox(width: 30.w, height: 30.w),

                  Expanded(
                    child: Center(
                      child: Text(
                        'Edit Section',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),

                  // Close button (right)
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20.sp,
                        color: _textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// CARD 1
           

            SizedBox(height: 10.h),

            /// CARD 2
            _Card(
              child: Column(
                children: [
                  // _SimpleRow(
                  //   imagePath: 'assets/images/add_device.png',
                  //   title: 'Add device',
                  //   imageWidth: 23.w,
                  //   imageHeight: 23.h,
                  // ),
                  _SimpleRow(
                    imagePath: 'assets/images/rename.png',
                    title: 'Rename',
                    trailingText: 'Light',
                    iconPath: 'assets/images/edit_image.png',
                    imageWidth: 26.w,
                    imageHeight: 26.h,
                    iconHeight: 13.h,
                    iconWidth: 14.w,
                  ),
                  
                  _SimpleRow(
                    imagePath: 'assets/images/add_device.png',
                    title: 'Add device',
                    imageWidth: 23.w,
                    imageHeight: 23.h,
                  ),

                  
                ],
              ),
            ),
              SizedBox(height:10.h,),
           // Card 2
            _Card(
              child: Column(
                children: [
                  _RowItem(
                    imagePath: 'assets/images/header_icon.png',
                    title: 'Header background',
                    imageHeight: 26.h,
                    imageWidth: 26.w,
                    trailing: Image.asset("assets/images/header_image.png", height: 39.h, width: 39.w,fit: BoxFit.cover,),
                  ),
                  _SimpleRow(
                    imagePath: 'assets/images/move_up.png',
                    title: 'Move up',
                    imageWidth: 22.w,
                    imageHeight: 22.h,
                  ),

                  _SimpleRow(
                    title: 'Move down',
                    imagePath: 'assets/images/move_down.png',
                    imageWidth: 22.w,
                    imageHeight: 22.h,
                  ),

                  
                  
                  _RowItem(
                    imagePath: 'assets/images/Slider.png',
                    title: 'Horizontal scrolling',
                    imageHeight: 22.h,
                    imageWidth: 22.w,
                    trailing: SizedBox(
                      height: 35.h,
                      width: 60.w,
                      child: CupertinoSwitch(
                        value: _sliderWidget,
                        onChanged: (v) => setState(() => _sliderWidget = v),
                        activeColor: _blue,
                      ),
                    ),
                  ),

                  _RowItem(
                    imagePath: 'assets/images/widget_size.png',
                    title: 'Widget size',
                    trailing: _SizeSegment(
                      value: _selectedSize,
                      onChanged: (v) => setState(() => _selectedSize = v),
                      imageWidth: 22.w, // custom image width
                      imageHeight: 22.h, // custom image height
                    ),
                  ),
                  SizedBox(
                    height: 13.h,
                  )
                ],
              ),
            ), 

            SizedBox(height: 10.h),
            /// REMOVE
            Container(
              width: double.infinity,
              height: 49.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(26.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/cross.png',
                    width: 26.w,
                    height: 26.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Remove',
                    style: TextStyle(
                      color: _danger,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            )
         
          ],
            ),
          ),
        ),
      ),
    );
  }
}

/// CARD CONTAINER
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }
}

/// ROW WITH TRAILING
class _RowItem extends StatelessWidget {
  final String? imagePath;
  final IconData? icon;
  final String title;
  final Widget trailing;
  final double imageWidth;
  final double imageHeight;

  const _RowItem({
    this.imagePath,
    this.icon,
    required this.title,
    required this.trailing,
    this.imageWidth = 20,
    this.imageHeight = 20,
  }) : assert(imagePath != null || icon != null, 'Provide imagePath or icon');

  @override
  Widget build(BuildContext context) {
    final Widget leading = imagePath != null
        ? Image.asset(
            imagePath!,
            width: imageWidth.w,
            height: imageHeight.h,
            fit: BoxFit.contain,
          )
        : Icon(icon!, size: 20.sp, color: _textSecondary);

    return Container(
      height: 55.h,
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 14.w),
        child: Row(
          children: [
            leading,
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  color: _textPrimary,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// SIMPLE ROW
class _SimpleRow extends StatelessWidget {
  final String? imagePath;
  final String? iconPath; 
  final IconData? icon;
  final String title;
  final String? trailingText;
  final double imageWidth;
  final double imageHeight;
  final double iconWidth;
  final double iconHeight;

  const _SimpleRow({
    this.imagePath,
    this.iconPath, 
    this.icon,
    required this.title,
    this.trailingText,
    this.imageWidth = 20,
    this.imageHeight = 20,
    this.iconWidth = 14,
    this.iconHeight = 14,

    
  }) : assert(imagePath != null || icon != null, 'Provide imagePath or icon');

  @override
  Widget build(BuildContext context) {
    final Widget leading = imagePath != null
        ? Image.asset(
            imagePath!,
            width: imageWidth.w,
            height: imageHeight.h,
            fit: BoxFit.contain,
          )
        : Icon(icon!, size: 20.sp, color: _textSecondary);

    return Container(
      height: 55.h,
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 17.w,),
        child: Row(
          children: [
            leading,
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  color: _textPrimary,
                ),
              ),
            ),
            if (trailingText != null)
              Row(
                children: [
                  Text(
                    trailingText!,
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),


                  ),
                  SizedBox(width: 5.w,),
                  Image.asset(
                    iconPath!,
                    width: iconWidth.w,
                    height: iconHeight.h,
                    fit: BoxFit.contain,
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// SIZE SEGMENT
class _SizeSegment extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final double imageWidth;
  final double imageHeight;

  const _SizeSegment({
    required this.value,
    required this.onChanged,
    this.imageWidth = 26,
    this.imageHeight = 17,
  });

  @override
  Widget build(BuildContext context) {
    Widget item(String label, String img) {
      final selected = label == value;

      return GestureDetector(
        onTap: () => onChanged(label),
        child: Container(
          width: 56.w,
          height: 35.h,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Label on top
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
              // SizedBox(height: 4.h),
              // Image below
              Image.asset(
                img,
                width: imageWidth.w,
                height: imageHeight.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item('S', 'assets/images/size_S.png'),
          item('M', 'assets/images/size_M.png'),
          item('L', 'assets/images/size_L.png'),
          item('XL', 'assets/images/size_XL.png'),
        ],
      ),
    );
  }
}