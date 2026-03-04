import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon(
      this.path, {
        super.key,
       required this.height,
        required this.width,
        this.color   , 
          this.size,
       
      });

  final String path;
  final double height;
  final double? size;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );
  }
}

/// ✅ Bottom Sheet UI (same to same)
class AddUserBottomSheet extends StatefulWidget {
  const AddUserBottomSheet({super.key});

  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _line = Color(0xFFE5E7EB);
  static const Color _blue = Color(0xFF0088FE);
  static const Color _chipBg = Color(0xFFF3F4F6);

  @override
  State<AddUserBottomSheet> createState() => _AddUserBottomSheetState();
}

class _AddUserBottomSheetState extends State<AddUserBottomSheet> {
  bool _lastActivitiesOn = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22.w, 16.h, 22.w, 22.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30.r,
                offset: Offset(0, -8.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 0.h, 0.w, 2.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Add user',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AddUserBottomSheet._textDark,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Center(
                            child: Icon(
                              Icons.close_rounded,
                              size: 20.sp,
                              color: AddUserBottomSheet._textDark,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 13.h),

              // Fields
              // _RowField(
              //   left: 'Name',
              //   right: 'Demo Account',
              // ),
              // SizedBox(height: 8.h,),
              // _DividerLine(),
              // SizedBox(height: 13.h,),
              _RowField(
                left: 'Email',
                right: 'Aican@gmail.com',
              ),
              SizedBox(height: 13.h,),
              _DividerLine(),
              SizedBox(height: 13.h,),

              // Roles row
              SizedBox(
                height: 46.h,
                child: Row(
                  
                  children: [
                    Expanded(
                      child: Text(
                        'Roles',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AddUserBottomSheet._textDark,
                        ),
                      ),
                    ),
                    _RoleIcons(),
                  ],
                ),
              ),
              _DividerLine(),
              SizedBox(height: 13.h,),

              // Enable cloud control row
              SizedBox(
                height: 46.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Enable cloud control',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AddUserBottomSheet._textDark,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.05,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque, // ✅ tap area improve
                        onTap: () {
                          setState(() {
                            _lastActivitiesOn = !_lastActivitiesOn;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 60.w,
                          height: 35.h,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: _lastActivitiesOn
                                ? const Color(0xFF0088FE)
                                : const Color(0xFFE1E1E1),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            alignment: _lastActivitiesOn
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 31.w,
                              height: 31.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 36.h),

              // Add button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AddUserBottomSheet._blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppAssetIcon(
                        "assets/images/+.png",
                        height: 20.h,
                        width: 20.w,
                        color: Colors.white,
                        
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Small bottom spacing so content isn't glued to the edge
              SizedBox(height: 43.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowField extends StatelessWidget {
  const _RowField({
    required this.left,
    required this.right,
  });

  final String left;
  final String right;

  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28.h,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _textDark,
              ),
            ),
          ),
          Flexible(
            child: Text(
              right,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      thickness: 1.h,
      color: const Color(0xFFE5E7EB),
    );
  }
}

class _RoleIcons extends StatelessWidget {
  const _RoleIcons();

  static const Color _textDark = Color(0xFF111827);
  static const Color _chipBg = Color(0xFFF3F4F6);
  static const Color _iconColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // First icon in a light circle (as screenshot)
        Container(
          width: 32.w,
          height: 31.w,
          decoration: const BoxDecoration(
            color: _chipBg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AppAssetIcon(
              "assets/Mask group (1) copy 2.png" ,
              height: 20.h,
              width: 20.w,
              color: _textDark,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        AppAssetIcon(
          "assets/key.png",
          height: 19.9.h,
          width: 19.9.w,
          color: _iconColor,
        ),
        SizedBox(width: 14.w),
        AppAssetIcon(
          "assets/images/setting.png",
          height: 20.55.h,
          width: 20.55.w,
          color: _iconColor,
        ),
      ],
    );
  }
}