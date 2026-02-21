import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZoneAddMenu extends StatelessWidget {
  const ZoneAddMenu({super.key});

  static const _bg = Color(0xFFF3F4F6);
  static final _bgTransparent = _bg.withOpacity(0.74);
  static const _card = Colors.white;
  static const _textPrimary = Color(0xFF111827);
  static const _textSecondary = Color(0xFF6B7280);
  static const _dividerColor = Color(0xFFE5E7EB);
  static const _destructive = Color(0xFFFF2D92);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: _bgTransparent,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26.r),
          ),
        ),
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 0.w, 2.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
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
                  ),
                  // close
                  Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
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
                    title: 'Rename',
                    iconWidth: 22.w,
                    iconHeight: 22.h,
                    trailing: Text(
                      'Living room',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: _textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),



                  /// Upload image
                  _ItemRow(
                    iconPath: 'assets/images/uploadImage.png',
                    title: 'Upload image',
                    iconWidth: 18.w,
                    iconHeight: 18.h,
                  ),



                  /// Upload icon
                  _ItemRow(
                    iconPath: 'assets/images/Eupload.png',
                    title: 'Upload icon',
                    iconWidth: 24.w,
                    iconHeight: 24.h,
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

                  SizedBox(height: 30.h,),
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.w, right: 16.w, bottom: 35.h),
                      height: 55.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.r),
                          border: Border.all(width: 1.w, color: Color(0xFF0088FE))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Image.asset(
                            'assets/images/+ (1).png',

                            height: 14.h,
                          ),
                          SizedBox(width: 5.w,),
                          Text(
                            "Add zone", style: TextStyle(fontFamily: "Inter",color: Color(0xFF0088FE), fontSize: 16.sp, fontWeight: FontWeight.w600 ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 15.h),
          ],
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
    this.titleColor,
    this.iconColor,
    this.iconWidth,
    this.iconHeight,
  });

  final String iconPath;
  final String title;
  final Widget? trailing;
  final Color? titleColor;
  final Color? iconColor;
  final double? iconWidth;
  final double? iconHeight;

  static const _textPrimary = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                  color: iconColor,
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
                  color: titleColor ?? _textPrimary,
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

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.only(left: 58.w),
      color: const Color(0xFFE5E7EB),
    );
  }
}