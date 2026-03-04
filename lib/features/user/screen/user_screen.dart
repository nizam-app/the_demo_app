import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widget/global_back_button.dart';
import '../widget/userAdd_popup.dart';
import '../widget/user_edit.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});
  static const routeName = "/UserScreen";

  static const _bg = Color(0xFFF3F4F6);
  static const _textDark = Color(0xFF111827);
  static const _textGrey = Color(0xFF6B7280);
  static const _activeBlue = Color(0xFF0088FE);
  static const _selectedRow = Color(0xFFEAF1FF);
  static const _divider = Color(0xFFE5E7EB);
  static const _inactiveChipBg = Color(0xFFF2F3F5);
  static const _globeCyan = Color(0xFF00D1FF);



  static Future<void> showAddUserBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // keep dim + rounded corners clean
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) => const AddUserBottomSheet(),
    );
  }

  static Future<void> showEditUserBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) => const UserEdit(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: const _FabPlus(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 120.h),
          children: [
            const _TopBar(),
            SizedBox(height: 16.h),
             _SearchBar(),
            SizedBox(height: 22.h),

            const _SectionTitle('Local users'),
            SizedBox(height: 12.h),
            _UserCardSingle(
              data: _UserRowData(
                name: 'Aican Support',
                subtitle: 'admin',
                isActive: true,
                image:  [
                  _InlineIcon("assets/images/setting.png",15.h, 15.w,  color: _textDark),
                  _InlineIcon("assets/images/glog.png",15.h, 15.w,  color: _globeCyan),

                  //Image.asset("assets/images/glog.png", height: 15.h, width: 15.w,fit: BoxFit.contain,color: UsersScreen._globeCyan,)  ,
                ],
              ),
            ),

            SizedBox(height: 22.h),
            const _SectionTitle('Remote users'),
            SizedBox(height: 12.h),
            _UserCardGrouped(
              top: _UserRowData(
                name: 'Demo Account',
                subtitle: 'demo@aican.com',
                isActive: true,
                image:  [
                
                  _InlineIcon("assets/Mask group (1) copy 2.png",15.h, 15.w,   color: _textDark),
                  _InlineIcon("assets/images/glog.png", 15.h, 15.w, color: _globeCyan),
                ],
              ),
              bottom: _UserRowData(
                name: 'Aican Support',
                subtitle: 'demo@aican.com',
                isActive: false,
                isSelected: true,
                image:  [
                  _InlineIcon( "assets/key.png",15.h, 15.w,  color: _textDark, ),
                  _InlineIcon("assets/images/Group 55.png", 15.h, 15.w,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  static const _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Row(
      
      children: [
        GlobalCircleIconBtn(
          child: Image.asset('assets/aro.png', width: 16.w, height: 16.h),
          onTap: (){},
          color: const Color(0xFFFFFFFF),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Users',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
        ),
        //SizedBox(width: 44.w), // keeps title centered
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
   _SearchBar();

  static const _textGrey = Color(0xFF6B7280);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  // String? _selectedCoreId = 'aican_demo';

  @override

  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _searchFocusNode,
      builder: (context, _) {
        //final hasFocus = _searchFocusNode.hasFocus;
        return Container(
            height: 46.h,
            //alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 17.w, right: 13.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular( 26.r),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xFF6B7280), // 0xFF6B7280 - visible on white0xFF6B7280
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
                filled: false,
                prefixIcon: Image.asset(
                  'assets/images/Mask group.png',
                  width: 22.w,
                  height: 22.w,
                  fit: BoxFit.contain,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 22.w,
                  minHeight: 22.h,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 0,
                ),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                color: _textGrey,
              ),
            ),
          );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  static const _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: _textDark,
        height: 1.1,
      ),
    );
  }
}



class _UserCardSingle extends StatelessWidget {
  const _UserCardSingle({required this.data});
  final _UserRowData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        color: Colors.white,
        child: _UserRow(
          data: data,
          topRadius: 34.r,
          bottomRadius: 34.r,
        ),
      ),
    );
  }
}

class _UserCardGrouped extends StatelessWidget {
  const _UserCardGrouped({required this.top, required this.bottom});
  final _UserRowData top;
  final _UserRowData bottom;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _UserRow(data: top, topRadius: 34.r, bottomRadius: 0),
            Divider(height: 1.h, thickness: 1.h, color: UsersScreen._divider),
            _UserRow(data: bottom, topRadius: 0, bottomRadius: 26.r),
          ],
        ),
      ),
    );
  }
}

class _InlineIcon {
  const _InlineIcon(this.image, this.height, this.width  ,{ this.color});
  //final IconData icon;
  final Color? color;
   final String image;

  final double? height;
  final double? width; 
   
  
}

class _UserRowData {
  const _UserRowData({
    required this.name,
    required this.subtitle,
    required this.image,
    required this.isActive,
    this.isSelected = false,
   
  });

  final String name;
  final String subtitle;
  final List<_InlineIcon> image;
  final bool isActive;
  final bool isSelected;

}

class _UserRow extends StatefulWidget {
  const _UserRow({
    required this.data,
    required this.topRadius,
    required this.bottomRadius,
  });

  final _UserRowData data;
  final double topRadius;
  final double bottomRadius;

  @override
  State<_UserRow> createState() => _UserRowState();
}

class _UserRowState extends State<_UserRow> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.data.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final bg =   Colors.white;
       // widget.data.isSelected ? UsersScreen._selectedRow : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topRadius),
          topRight: Radius.circular(widget.topRadius),
          bottomLeft: Radius.circular(widget.bottomRadius),
          bottomRight: Radius.circular(widget.bottomRadius),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.data.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: UsersScreen._textDark,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    ...widget.data.image.map(
                      (e) => Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Container(
                          height: 20.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.r),
                            color: const Color(0xFFF3F4F6),
                          ),
                          child: Center(
                            child: Image.asset(
                              e.image,
                              height: e.height,
                              width: e.width,
                              fit: BoxFit.contain,
                              color: e.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 8.h),
                Text(
                  widget.data.subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: UsersScreen._textGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Right side: status chip + menu
          Padding(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(26.r),
                  onTap: () {
                    setState(() {
                      _isActive = !_isActive;
                    });
                  },
                  child: _StatusChip(isActive: _isActive),
                ),
                SizedBox(width: 18.w),
                InkWell(
                  onTap: () => UsersScreen.showEditUserBottomSheet(context),
                  child: Icon(
                    CupertinoIcons.ellipsis,
                    size: 22.sp,
                    color: UsersScreen._textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
    
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? UsersScreen._activeBlue : UsersScreen._inactiveChipBg,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : UsersScreen._textDark,
        ),
      ),
    );
  }
}

class _FabPlus extends StatelessWidget {
  const _FabPlus();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26.r),
        onTap: () => UsersScreen.showAddUserBottomSheet(context),

        child: Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x10111827),
                blurRadius: 26.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.add,
              size: 24.sp,
              color: UsersScreen._textDark,
            ),
          ),
        ),
      ),
    );
  }
}