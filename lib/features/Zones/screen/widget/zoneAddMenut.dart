import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZoneAddMenu extends StatelessWidget {
  const ZoneAddMenu({super.key});

  // Keep the sheet clearly transparent like the dashboard header/footer.
  static final _bgTransparent = Colors.white.withOpacity(0.18);
  static final _card = Colors.white.withOpacity(0.6);
  static const _textPrimary = Color(0xFF111827);
  static const _textSecondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              color: _bgTransparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER – title centered in screen, close on right
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 0.w, 2.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Add zone',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                       // color: Colors.white.withOpacity(0.28),
                        color: Color(0xFFE5E7EB).withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Center(
                          child: Icon(Icons.close_rounded,
                              size: 20.sp, color: _textPrimary),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),



            /// CARD
            Container(
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [

                  /// Rename
                  _ItemRow(
                    iconPath: 'assets/images/Erename.png',
                    title: 'Name',
                    iconWidth: 22.w,
                    iconHeight: 22.h,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Living room',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: _textSecondary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Image.asset(
                          'assets/Group 63.png',
                          width: 14.w,
                          height: 13.h,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),



                  /// Upload image
                  _ItemRow(
                    iconPath: 'assets/images/uploadImage.png',
                    title: 'Upload image',
                    iconWidth: 18.w,
                    iconHeight: 18.h,
                    trailing: Image.asset(
                      'assets/images/image 147.png',
                      height: 29.h,
                      width: 52.w,
                      fit: BoxFit.cover,
                    ),
                  ),



                  /// Upload icon
                  _ItemRow(
                    iconPath: 'assets/images/Eupload.png',
                    title: 'Upload icon',
                    iconWidth: 24.w,
                    iconHeight: 24.h,
                    trailing: Image.asset(
                      'assets/images/image 148.png',
                      height: 26.h,
                      width: 26.w,
                      fit: BoxFit.cover,
                    ),
                  ),


                  //
                  // /// Remove
                  // _ItemRow(
                  //   iconPath: 'assets/images/delete1.png',
                  //   title: 'Delete category',
                  //   iconWidth: 16.w,
                  //   iconHeight: 19.h,
                  //   titleColor: _destructive,
                  //   iconColor: _destructive,
                  // ),

                  //SizedBox(height: 19.h,),
                 
                ],
              ),
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: (){

              },
              child: Container(
                
                margin: EdgeInsets.only(left: 20.w, right: 16.w,),
                

                height: 52.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xFF0088FE),
                    borderRadius: BorderRadius.circular(26.r),
                    border: Border.all(width: 1.w, color: Color(0xFF0088FE))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    // Image.asset(
                    //   'assets/images/+ (1).png',  color: Colors.white,
                    //
                    //   height: 14.h,
                    // ),
                    Padding(
                      padding:  EdgeInsets.only(bottom: 3.5.h),
                      child: Text(
                        '+',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400,
                          fontSize: 22.sp,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 47.h,),

           
          ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.iconPath,
    required this.title,
    this.trailing,
    this.iconWidth,
    this.iconHeight,
  });

  final String iconPath;
  final String title;
  final Widget? trailing;
  final double? iconWidth;
  final double? iconHeight;

  static const _textPrimary = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(26.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        // padding: EdgeInsets.only(left: 13.w,right: 28.w, top: 20.h, bottom: 20.h),
        child: Row(
          children: [

            /// ICON AREA (Fixed width for alignment stability)
            SizedBox(
              width: 28.w,
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: iconWidth ?? 22.w,
                  height: iconHeight ?? 22.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(width: 14.w),

            /// TITLE
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: _textPrimary,
                ),
              ),
            ),

            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}