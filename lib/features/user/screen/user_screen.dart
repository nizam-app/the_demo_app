// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../core/widget/global_back_button.dart';
//
// class UsersScreen extends StatelessWidget {
//   const UsersScreen({super.key});
//   static const routeName = "/UserScreen";
//
//   static const _bg = Color(0xFFF3F4F6);
//   static const _textDark = Color(0xFF111827);
//   static const _textGrey = Color(0xFF6B7280);
//   static const _enabledBlue = Color(0xFF0088FE);
//   static const _selectedRow = Color(0xFFEAF1FF);
//   static const _divider = Color(0xFFE5E7EB);
//   static const _chipDisabledBg = Color(0xFFE1E1E1);
//   static const _globeCyan = Color(0xFF00D1FF);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       floatingActionButton: const _FabPlus(),
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.fromLTRB(17.w, 14.h, 13.w, 120.h),
//           children: [
//             const _TopBar(),
//             SizedBox(height: 13.h),
//              _SearchBar(),
//             SizedBox(height: 19.h),
//             const _SectionTitle('Local users'),
//             SizedBox(height: 15.h),
//             const _UserCardSingle(
//               name: 'Aican Support',
//               subtitle: 'admin',
//               showGlobe: true,
//               enabled: true,
//             ),
//             SizedBox(height: 22.h),
//             const _SectionTitle('Remote users'),
//             SizedBox(height: 12.h),
//             const _UserCardGrouped(
//               top: _UserRowData(
//                 name: 'Demo Account',
//                 subtitle: 'demo@aican.com',
//                 showGlobe: true,
//                 enabled: true,
//               ),
//               bottom: _UserRowData(
//                 name: 'Aican Support',
//                 subtitle: 'demo@aican.com',
//                 showGlobe: false,
//                 enabled: false,
//                 isSelected: true,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _TopBar extends StatelessWidget {
//   const _TopBar();
//
//   static const _textDark = Color(0xFF111827);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         GlobalCircleIconBtn(
//           child: Image.asset('assets/aro.png', width: 16.w, height: 16.h),
//           onTap: (){},
//           color: const Color(0xFFFFFFFF),
//         ),
//         Expanded(
//           child: Center(
//             child: Text(
//               'Users',
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.w600,
//                 color: _textDark,
//               ),
//             ),
//           ),
//         ),
//         //SizedBox(width: 44.w), // keeps title centered
//       ],
//     );
//   }
// }
//
// class _SearchBar extends StatelessWidget {
//    _SearchBar();
//
//   static const _textGrey = Color(0xFF6B7280);
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   // String? _selectedCoreId = 'aican_demo';
//
//   @override
//
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: _searchFocusNode,
//       builder: (context, _) {
//         //final hasFocus = _searchFocusNode.hasFocus;
//         return Container(
//             height: 46.h,
//             //alignment: Alignment.centerLeft,
//             padding: EdgeInsets.only(left: 17.w, right: 13.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFFFFF),
//               borderRadius: BorderRadius.circular( 26.r),
//             ),
//             child: TextField(
//               controller: _searchController,
//               focusNode: _searchFocusNode,
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 hintStyle: TextStyle(
//                   fontSize: 16.sp,
//                   color: Color(0xFF6B7280), // 0xFF6B7280 - visible on white0xFF6B7280
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Inter',
//                 ),
//                 filled: false,
//                 prefixIcon: Image.asset(
//                   'assets/images/Mask group.png',
//                   width: 22.w,
//                   height: 22.w,
//                   fit: BoxFit.contain,
//                 ),
//                 prefixIconConstraints: BoxConstraints(
//                   minWidth: 22.w,
//                   minHeight: 22.h,
//                 ),
//                 border: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 12.h,
//                   horizontal: 0,
//                 ),
//                 isDense: true,
//               ),
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: 'Inter',
//                 color: _textGrey,
//               ),
//             ),
//           );
//       },
//     );
//   }
// }
//
// class _SectionTitle extends StatelessWidget {
//   const _SectionTitle(this.text);
//
//   final String text;
//
//   static const _textDark = Color(0xFF111827);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontFamily: 'Inter',
//         fontSize: 20.sp,
//         fontWeight: FontWeight.w600,
//         color: _textDark,
//         height: 1.1,
//       ),
//     );
//   }
// }
//
// class _UserCardSingle extends StatelessWidget {
//   const _UserCardSingle({
//     required this.name,
//     required this.subtitle,
//     required this.showGlobe,
//     required this.enabled,
//   });
//
//   final String name;
//   final String subtitle;
//   final bool showGlobe;
//   final bool enabled;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 67.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(26.r),
//       ),
//       child: _UserRow(
//         data: _UserRowData(
//           name: name,
//           subtitle: subtitle,
//           showGlobe: showGlobe,
//           enabled: enabled,
//         ),
//         topRadius: 34.r,
//         bottomRadius: 34.r,
//       ),
//     );
//   }
// }
//
// class _UserCardGrouped extends StatelessWidget {
//   const _UserCardGrouped({
//     required this.top,
//     required this.bottom,
//   });
//
//   final _UserRowData top;
//   final _UserRowData bottom;
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(34.r),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0x0A111827),
//               blurRadius: 22.r,
//               offset: Offset(0, 10.h),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             _UserRow(
//               data: top,
//               topRadius: 34.r,
//               bottomRadius: 0,
//             ),
//             Divider(height: 1.h, thickness: 1.h, color: UsersScreen._divider),
//             _UserRow(
//               data: bottom,
//               topRadius: 0,
//               bottomRadius: 34.r,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _UserRowData {
//   const _UserRowData({
//     required this.name,
//     required this.subtitle,
//     required this.showGlobe,
//     required this.enabled,
//     this.isSelected = false,
//   });
//
//   final String name;
//   final String subtitle;
//   final bool showGlobe;
//   final bool enabled;
//   final bool isSelected;
// }
//
// class _UserRow extends StatelessWidget {
//   const _UserRow({
//     required this.data,
//     required this.topRadius,
//     required this.bottomRadius,
//   });
//
//   final _UserRowData data;
//   final double topRadius;
//   final double bottomRadius;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//       color: data.isSelected ? UsersScreen._selectedRow: Colors. white,
//       padding: EdgeInsets.only(left: 15.w, right: 18.w, top: 11.h, bottom: 8.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 data.name,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w400,
//                   color: UsersScreen._textDark,
//                 ),
//               ),
//               if (data.showGlobe) ...[
//                 SizedBox(width: 10.w),
//
//                 Image.asset("assets/seting.png", height: 13.h, width: 13.w,fit: BoxFit.contain,)  ,
//
//
//                 SizedBox(width: 8.w),
//                 Image.asset("assets/images/glog.png", height: 15.h, width: 15.w,fit: BoxFit.contain,color: UsersScreen._globeCyan,)  ,
//
//                 SizedBox(width: 90.w),
//                 Container(
//                   height: 26.h,
//                   width: 78.w,
//                   // padding: EdgeInsets.symmetric(horizontal: 18.w),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: data.enabled ? UsersScreen._enabledBlue : UsersScreen._chipDisabledBg,
//                     borderRadius: BorderRadius.circular(26.r),
//                   ),
//                   child: Text(
//                     data.enabled? 'Active' : 'UnActive',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                       color: data.enabled ? Colors.white : UsersScreen._textGrey,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 14.w),
//                 Icon(
//                   CupertinoIcons.ellipsis,
//                   size: 22.sp,
//                   color: UsersScreen._textGrey,
//                 ),
//
//               ],
//             ],
//           ),
//           // SizedBox(height: 8.h),
//           Text(
//             data.subtitle,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w400,
//               color: UsersScreen._textGrey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ActionIcon extends StatelessWidget {
//   const _ActionIcon(this.icon);
//
//   final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Icon(icon, size: 26.sp, color: UsersScreen._textGrey);
//   }
// }
//
// class _FabPlus extends StatelessWidget {
//   const _FabPlus();
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(999.r),
//         onTap: () {},
//         child: Container(
//           width: 66.w,
//           height: 66.w,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0x10111827),
//                 blurRadius: 22.r,
//                 offset: Offset(0, 10.h),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Icon(
//               CupertinoIcons.plus,
//               size: 34.sp,
//               color: UsersScreen._textDark,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widget/global_back_button.dart';

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
                icons: const [
                  _InlineIcon(CupertinoIcons.gear, color: _textDark),
                  _InlineIcon(CupertinoIcons.globe, color: _globeCyan),

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
                icons: const [
                  _InlineIcon(CupertinoIcons.person, color: _textDark),
                  _InlineIcon(CupertinoIcons.globe, color: _globeCyan),
                ],
              ),
              bottom: _UserRowData(
                name: 'Aican Support',
                subtitle: 'demo@aican.com',
                isActive: false,
                isSelected: true,
                icons:  [
                  _InlineIcon( CupertinoIcons.add,color: _textDark),
                  _InlineIcon(CupertinoIcons.nosign, color: _textDark),
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
            _UserRow(data: bottom, topRadius: 0, bottomRadius: 34.r),
          ],
        ),
      ),
    );
  }
}

class _InlineIcon {
  const _InlineIcon(this.icon,  {required this.color});
  final IconData icon;
  final Color color;
  // final String?image;
}

class _UserRowData {
  const _UserRowData({
    required this.name,
    required this.subtitle,
    required this.icons,
    required this.isActive,
    this.isSelected = false,
  });

  final String name;
  final String subtitle;
  final List<_InlineIcon> icons;
  final bool isActive;
  final bool isSelected;
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.data,
    required this.topRadius,
    required this.bottomRadius,
  });

  final _UserRowData data;
  final double topRadius;
  final double bottomRadius;

  @override
  Widget build(BuildContext context) {
    final bg = data.isSelected ? UsersScreen._selectedRow : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius),
          topRight: Radius.circular(topRadius),
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
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
                        data.name,
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
                    ...data.icons.map(
                          (e) => Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Icon(e.icon, size: 20.sp, color: e.color),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  data.subtitle,
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

          // Right side (ALWAYS visible — fixes your issue)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusChip(isActive: data.isActive),
                SizedBox(width: 18.w),
                Icon(CupertinoIcons.ellipsis, size: 22.sp, color: UsersScreen._textGrey),
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
      height: 26.h,
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
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
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
        onTap: () {},
        child: Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x10111827),
                blurRadius: 22.r,
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