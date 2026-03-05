import 'package:flutter/cupertino.dart';
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
class UserEdit extends StatefulWidget {
  const UserEdit({super.key});

  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _line = Color(0xFFE5E7EB);
  static const Color _blue = Color(0xFF0088FE);
  static const Color _chipBg = Color(0xFFF3F4F6);

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  bool _sliderWidget = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(33.w, 16.h, 12.w, 22.h),
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Edit user',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: UserEdit._textDark,
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
                            color: UserEdit._textDark,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              // Fields
              _RowField(
                left: 'Name',
                right: 'Demo Account',
              ),
              SizedBox(height: 13.h,),
              _DividerLine(),
              SizedBox(height: 13.h,),
              _RowField(
                left: 'Email',
                right: 'Aican@gmail.com',
              ),
              SizedBox(height: 13.h,),
              _DividerLine(),
              SizedBox(height: 13.h,),

              // Roles row
              Padding(
                padding:  EdgeInsets.only(right: 20.w),
                child: SizedBox(
                  height: 30.h,
                  child: Row(

                    children: [
                      Expanded(
                        child: Text(
                          'Roles',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: UserEdit._textDark,
                          ),
                        ),
                      ),
                      _RoleIcons(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 13.h,),
              _DividerLine(),
              SizedBox(height: 13.h,),

              // Enable cloud control row
              Padding(
                padding:  EdgeInsets.only(right: 20.w),
                child: SizedBox(
                  height: 30.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Enable cloud control',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: UserEdit._textDark,
                          ),
                        ),
                      ),
                      CupertinoSwitch(
                        value: _sliderWidget,
                        onChanged: (v) => setState(() => _sliderWidget = v),
                        activeColor: Color(0xFF0088FE),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 13.h,),
              _DividerLine(),
              SizedBox(height: 13.h,),
             Padding(
               padding:  EdgeInsets.only(right: 20.w),
               child: SizedBox(
                 height: 30.h,
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delete user',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFE019A),
                        ),
                      ),
                      Image.asset("assets/images/delete1.png", height: 19.h, width: 16.w, fit: BoxFit.contain,)

                    ],
                  ),
               ),
             ),

              SizedBox(height: 43.h),

              // Add button
              Padding(
                padding:  EdgeInsets.only(right: 20.w),
                child: GestureDetector(
                  onTap: (){},
                  child: Container(

                    width: double.infinity,
                    height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r),
                        border: Border.all(width: 1.w, color: UserEdit._blue),
                      ),
                      child: Center(
                            child: Padding(
                              padding:  EdgeInsets.only(bottom: 3.5.h),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: UserEdit._blue,
                                ),                   ),
                            ),

                  ), ),
                ),
              ), 

              // Small bottom spacing so content isn't glued to the edge
              SizedBox(height: 40.h),
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
    return Padding(
      padding:  EdgeInsets.only(right: 20.w),
      child: SizedBox(
        height: 30.h,
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
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: 20.w),
      child: Divider(
        height: 1.h,
        thickness: 1.h,
        color: const Color(0xFFE5E7EB),
      ),
    );
  }
}

class _RoleIcons extends StatefulWidget {
  const _RoleIcons();

  static const Color _textDark = Color(0xFF111827);
  static const Color _chipBg = Color(0xFFF3F4F6);
  static const Color _iconColor = Color(0xFF6B7280);

  @override
  State<_RoleIcons> createState() => _RoleIconsState();
}

class _RoleIconsState extends State<_RoleIcons> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildChip(
          index: 0,
          asset: "assets/Mask group (1) copy 2.png",
          height: 20.h,
          width: 20.w,
        ),
        SizedBox(width: 10.w),
        _buildChip(
          index: 1,
          asset: "assets/key.png",
          height: 19.9.h,
          width: 19.9.w,
        ),
        SizedBox(width: 14.w),
        _buildChip(
          index: 2,
          asset: "assets/images/setting.png",
          height: 20.55.h,
          width: 20.55.w,
        ),
      ],
    );
  }

  Widget _buildChip({
    required int index,
    required String asset,
    required double height,
    required double width,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Container(
        width: 32.w,
        height: 31.w,
        decoration: BoxDecoration(
          color: isSelected ? _RoleIcons._chipBg : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AppAssetIcon(
            asset,
            height: height,
            width: width,
            color: isSelected ? _RoleIcons._textDark : _RoleIcons._iconColor,
          ),
        ),
      ),
    );
  }
}