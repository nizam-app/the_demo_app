// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../core/widget/global_back_button.dart';
//
// /// Resize only these values; card layout (padding, container sizes) stays the same.
// class _InterfacesResize {
//   _InterfacesResize._();
//   // Card: images
//   static const double cardLogo = 26;
//   static const double cardStatusBadge = 22;
//   static const double cardStatusBadgeIcon = 16;
//   static const double cardMoreIcon = 22;
//   // Card: text
//   static const double cardTitleSp = 16;
//   static const double cardSubtitleSp = 14;
//   static const double cardDevicePillSp = 14;
//   // Screen
//   static const double screenTitleSp = 22;
//   static const double manageTitleSp = 20;
//   // Top bar
//   static const double topBarBackIcon = 16;
//   // Bottom nav
//   static const double bottomNavIcon = 26;
//   static const double bottomNavLabelSp = 9;
//   static const double bottomNavNotificationSp = 10;
//   // FAB
//   static const double fabIcon = 24;
// }
//
// class InterfacesScreen extends StatefulWidget {
//   const InterfacesScreen({super.key});
//   static const routeName = "/Interfaces";
//
//   @override
//   State<InterfacesScreen> createState() => _InterfacesScreenState();
// }
//
// class _InterfacesScreenState extends State<InterfacesScreen> {
//   // Colors (matched to screenshot)
//   static const Color _bg = Color(0xFFF3F4F6);
//   static const Color _card = Colors.white;
//   static const Color _textDark = Color(0xFF111827);
//   static const Color _textGrey = Color(0xFF6B7280);
//   static const Color _pillGrey = Color(0xFFF1F3F6);
//   static const Color _blue = Color(0xFF0A84FF);
//   static const Color _magenta = Color(0xFFFF00A8);
//
//   int _selectedIndex = 2;// Dashboard selected in screenshot (center)
//
//   final List<_InterfaceItem> _items = const [
//     _InterfaceItem(
//       title: 'Aican Bus',
//       subtitle: 'Port 1  •  Port 2',
//       deviceCountText: '46 Devices',
//       logoAsset: 'assets/image 66.png',
//       status: _InterfaceStatus.ok,
//       pillStyle: _PillStyle.grey,
//     ),
//     _InterfaceItem(
//       title: 'ModBus RTU',
//       subtitle: 'Port 3',
//       deviceCountText: '11 Devices',
//       logoAsset: 'assets/image 145.png',
//       status: _InterfaceStatus.warn,
//       pillStyle: _PillStyle.magenta,
//     ),
//     _InterfaceItem(
//       title: 'ZigBee',
//       subtitle: 'Port 4',
//       deviceCountText: '12 Devices',
//       logoAsset: 'assets/zigport.png',
//       status: _InterfaceStatus.ok,
//       pillStyle: _PillStyle.grey,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       floatingActionButton: const _FabPlus(),
//
//       bottomNavigationBar: _BottomNav(
//         selectedIndex: _selectedIndex,
//         notificationCount: 12,
//         onTap: (i) => setState(() => _selectedIndex = i),
//       ),
//
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const _TopBar(),
//               SizedBox(height: 23.h),
//               Text(
//                 'Manage interfaces',
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: _InterfacesResize.manageTitleSp.sp,
//                   fontWeight: FontWeight.w600,
//                   color: _textDark,
//                 ),
//               ),
//
//               SizedBox(height: 15.h),
//
//               Expanded(
//                 child: ListView.separated(
//                   padding: EdgeInsets.only(bottom: 90.h),
//                   itemCount: _items.length,
//                   separatorBuilder: (_, __) => SizedBox(height: 14.h),
//                   itemBuilder: (_, index) => _InterfaceCard(
//                     item: _items[index],
//                     bg: _card,
//                     textDark: _textDark,
//                     textGrey: _textGrey,
//                     pillGrey: _pillGrey,
//                     blue: _blue,
//                     magenta: _magenta,
//                     onMore: () {},
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
// /// -------------------- Card --------------------
//
// class _InterfaceCard extends StatelessWidget {
//   const _InterfaceCard({
//     required this.item,
//     required this.bg,
//     required this.textDark,
//     required this.textGrey,
//     required this.pillGrey,
//     required this.blue,
//     required this.magenta,
//     required this.onMore,
//   });
//
//   final _InterfaceItem item;
//   final Color bg;
//   final Color textDark;
//   final Color textGrey;
//   final Color pillGrey;
//   final Color blue;
//   final Color magenta;
//   final VoidCallback onMore;
//
//   @override
//   Widget build(BuildContext context) {
//     final pillBg = item.pillStyle == _PillStyle.magenta ? magenta : pillGrey;
//     final pillTextColor = item.pillStyle == _PillStyle.magenta ? Colors.white : textDark;
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(26.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10.r,
//             offset: Offset(0, 10.h),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           // Left logo container
//           Container(
//             width: 43.w,
//             height: 43.h,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF3F4F6),
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Center(
//               child: AppAssetIcon(
//                 item.logoAsset,
//                 size: _InterfacesResize.cardLogo,
//               ),
//             ),
//           ),
//
//           SizedBox(width: 14.w),
//
//           // Title + subtitle
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Flexible(
//                       child: Text(
//                         item.title,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: _InterfacesResize.cardTitleSp.sp,
//                           fontWeight: FontWeight.w400,
//                           color: textDark,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     _StatusBadge(status: item.status),
//                   ],
//                 ),
//                 SizedBox(height: 6.h),
//                 Text(
//                   item.subtitle,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: _InterfacesResize.cardSubtitleSp.sp,
//                     fontWeight: FontWeight.w500,
//                     color: textGrey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(width: 12.w),
//
//           // Devices pill
//           Container(
//             height: 30.h,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: pillBg,
//               borderRadius: BorderRadius.circular(26.r),
//             ),
//             child: Text(
//               item.deviceCountText,
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: _InterfacesResize.cardDevicePillSp.sp,
//                 fontWeight: FontWeight.w500,
//                 color: pillTextColor,
//               ),
//             ),
//           ),
//
//           SizedBox(width: 10.w),
//
//           // More (...)
//           InkWell(
//             onTap: onMore,
//             borderRadius: BorderRadius.circular(10.r),
//             child: Padding(
//               padding: EdgeInsets.all(8.r),
//               child: Icon(
//                 Icons.more_horiz_rounded,
//                 size: _InterfacesResize.cardMoreIcon.sp,
//                 color: const Color(0xFF6B7280),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _StatusBadge extends StatelessWidget {
//   const _StatusBadge({required this.status});
//   final _InterfaceStatus status;
//
//   static const Color _blue = Color(0xFF0A84FF);
//   static const Color _magenta = Color(0xFFFF00A8);
//
//   @override
//   Widget build(BuildContext context) {
//     if (status == _InterfaceStatus.ok) {
//       return Container(
//         width: _InterfacesResize.cardStatusBadge.w,
//         height: _InterfacesResize.cardStatusBadge.w,
//         decoration: const BoxDecoration(
//           color: _blue,
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Icon(
//             Icons.check_rounded,
//             size: _InterfacesResize.cardStatusBadgeIcon.sp,
//             color: Colors.white,
//           ),
//         ),
//       );
//     }
//
//     // warning triangle
//     return Icon(
//       Icons.warning_rounded,
//       size: _InterfacesResize.cardStatusBadge.sp,
//       color: _magenta,
//     );
//   }
// }
//
// /// -------------------- Bottom Nav --------------------
//
// class _BottomNav extends StatelessWidget {
//   const _BottomNav({
//     required this.selectedIndex,
//     required this.onTap,
//     required this.notificationCount,
//   });
//
//   final int selectedIndex;
//   final void Function(int) onTap;
//   final int notificationCount;
//
//   @override
//   Widget build(BuildContext context) {
//     const selected = Color(0xFF111827);
//     const unselected = Color(0xFF111827);
//
//     final items = <_NavItem>[
//       const _NavItem(label: "Devices", icon: "assets/Group 28.png"),
//       const _NavItem(label: "Analytics", icon: "assets/bar 5.png"),
//       const _NavItem(label: "Dashboard", icon: "assets/Mask group copy 6.png"),
//       //const _NavItem(label: "Voice", icon: "assets/image 98.png"),
//       const _NavItem(label: "Notifications", icon: "assets/Group 43.png"),
//       const _NavItem(label: "Automations", icon: "assets/Mask group (8).png"),
//     ];
//
//     return Container(
//       height: 72.h,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.74),
//         border: const Border(
//           top: BorderSide(color: Color(0xFFE1E1E1), width: 1),
//         ),
//       ),
//       child: LayoutBuilder(
//         builder: (context, c) {
//           final w = c.maxWidth / items.length;
//           return Stack(
//             children: [
//               Positioned(
//                 top: 0,
//                 left: w * selectedIndex + (w - 46.w) / 2,
//                 child: Container(
//                   width: 46.w,
//                   height: 3.h,
//                   decoration: BoxDecoration(
//                     color: selected,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(2.r),
//                       bottomRight: Radius.circular(2.r),
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: List.generate(items.length, (i) {
//                   final isSel = i == selectedIndex;
//                   final color = isSel ? selected : unselected;
//                   final item = items[i];
//
//                   return Expanded(
//                     child: InkWell(
//                       onTap: () => onTap(i),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               Image.asset(
//                                 item.icon,
//                                 width: _InterfacesResize.bottomNavIcon.sp,
//                                 height: _InterfacesResize.bottomNavIcon.sp,
//                                 color: color,
//                               ),
//                               if (item.label == "Notifications" &&
//                                   notificationCount > 0)
//                                 Positioned(
//                                   right: -10.w,
//                                   top: -6.h,
//                                   child: Container(
//                                     width: 19.w,
//                                     height: 15.h,
//                                     alignment: Alignment.center,
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 2.w,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFFE019A),
//                                       borderRadius: BorderRadius.circular(18.r),
//                                     ),
//                                     child: Text(
//                                       notificationCount.toString(),
//                                       style: TextStyle(
//                                         fontSize: _InterfacesResize.bottomNavNotificationSp.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           SizedBox(height: 6.h),
//                           Text(
//                             item.label,
//                             style: TextStyle(
//                               fontSize: _InterfacesResize.bottomNavLabelSp.sp,
//                               fontWeight: FontWeight.w700,
//                               color: color,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _NavItem {
//   final String label;
//   final String icon;
//   const _NavItem({required this.label, required this.icon});
// }
//
//
//
// class _FabPlus extends StatelessWidget {
//   const _FabPlus();
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(26.r),
//         onTap: () {},
//
//         child: Container(
//           width: 46.w,
//           height: 46.w,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0x10111827),
//                 blurRadius: 26.r,
//                 offset: Offset(0, 10.h),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Icon(
//               CupertinoIcons.add,
//               size: _InterfacesResize.fabIcon.sp,
//               color: Color(0xFF111827),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// -------------------- Reusable UI Bits --------------------
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
//           child: Image.asset(
//             'assets/aro.png',
//             width: _InterfacesResize.topBarBackIcon.w,
//             height: _InterfacesResize.topBarBackIcon.h,
//           ),
//           onTap: (){
//             Navigator.maybePop(context);
//           },
//           color: const Color(0xFFFFFFFF),
//         ),
//         Expanded(
//           child: Center(
//             child: Text(
//               'Interfaces',
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: _InterfacesResize.screenTitleSp.sp,
//                 fontWeight: FontWeight.w600,
//                 color: _textDark,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 44.w), // keeps title visually centered
//       ],
//     );
//   }
// }
//
//
//
//
// class AppAssetIcon extends StatelessWidget {
//   const AppAssetIcon(
//       this.path, {
//         super.key,
//         required this.size,
//         this.color,
//       });
//
//   final String path;
//   final double size;
//   final Color? color;
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       path,
//       width: size.w,
//       height: size.w,
//       fit: BoxFit.contain,
//       color: color,
//       colorBlendMode: color == null ? null : BlendMode.srcIn,
//     );
//   }
// }
//
// /// -------------------- Models --------------------
//
// enum _InterfaceStatus { ok, warn }
// enum _PillStyle { grey, magenta }
//
// class _InterfaceItem {
//   const _InterfaceItem({
//     required this.title,
//     required this.subtitle,
//     required this.deviceCountText,
//     required this.logoAsset,
//     required this.status,
//     required this.pillStyle,
//   });
//
//   final String title;
//   final String subtitle;
//   final String deviceCountText;
//   final String logoAsset;
//   final _InterfaceStatus status;
//   final _PillStyle pillStyle;
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/select_interface.dart';

/// -------------------- Image Size Registry (ALL sizes here) --------------------
@immutable
class ImgSize {
  final double w;
  final double h;
  const ImgSize(this.w, this.h);
  const ImgSize.square(double s) : w = s, h = s;
}

class ImageSizeRegistry {
  ImageSizeRegistry._();

  static const ImgSize fallback = ImgSize.square(24);

  /// ✅ Put every asset size here (each can be different)
  /// If an asset is not listed, fallback is used.
  static final Map<String, ImgSize> byAsset = {
    // Top bar
    'assets/aro.png': const ImgSize.square(16),

    // Interface logos
    'assets/image 66.png': const ImgSize.square(26),
    'assets/image 145.png': const ImgSize.square(39),
    'assets/zigport.png': const ImgSize.square(29),

    // Common icons
    'assets/icons/plus.png': const ImgSize.square(26),

    // Bottom nav icons
    'assets/Group 28.png': const ImgSize.square(24), // Devices
    'assets/bar 5.png': const ImgSize.square(26), // Analytics
    'assets/Mask group copy 6.png': const ImgSize.square(26), // Dashboard
    'assets/Group 43.png': const ImgSize.square(24), // Notifications
    'assets/Mask group (8).png': const ImgSize.square(24), // Automations
  };

  static ImgSize of(String asset, {ImgSize? fallbackSize}) {
    return byAsset[asset] ?? (fallbackSize ?? fallback);
  }
}

class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon(
      this.asset, {
        super.key,
        this.size,
        this.color,
        this.fit = BoxFit.contain,
      });

  final String asset;
  final ImgSize? size;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final s = size ?? ImageSizeRegistry.of(asset);
    return Image.asset(
      asset,
      width: s.w.w,
      height: s.h.h,
      fit: fit,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );
  }
}

/// -------------------- Interfaces Screen --------------------
class InterfacesScreen extends StatefulWidget {
  const InterfacesScreen({super.key});
  static const routeName = "/InterfacesScreen";

  @override
  State<InterfacesScreen> createState() => _InterfacesScreenState();
}

class _InterfacesScreenState extends State<InterfacesScreen> {
  // Colors (same style)
  static const Color _bg = Color(0xFFF3F4F6);
  static const Color _card = Colors.white;
  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _pillGrey = Color(0xFFF1F3F6);
  static const Color _blue = Color(0xFF0A84FF);
  static const Color _magenta = Color(0xFFFF00A8);

  int _selectedIndex = 2;

  late final List<_InterfaceStatus> _itemStatuses = [
    for (final e in _items) e.status,
  ];

  Future<void> showSelectInterfaceBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) => const SelectInterfaceBottomSheet(),
    );
  }


  final List<_InterfaceItem> _items = const [
    _InterfaceItem(
      title: 'Aican Bus',
      subtitle: 'Port 1  •  Port 2',
      devices: '46 Devices',
      logoAsset: 'assets/image 66.png',
      status: _InterfaceStatus.ok,
      pillStyle: _PillStyle.grey,
    ),
    _InterfaceItem(
      title: 'ModBus RTU',
      subtitle: 'Port 3',
      devices: '11 Devices',
      logoAsset: 'assets/image 145.png',
      status: _InterfaceStatus.warn,
      pillStyle: _PillStyle.magenta,
    ),
    _InterfaceItem(
      title: 'ZigBee',
      subtitle: 'Port 4',
      devices: '12 Devices',
      logoAsset: 'assets/zigport.png',
      status: _InterfaceStatus.ok,
      pillStyle: _PillStyle.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      floatingActionButton: _FabPlus(
        onTap: ()=>showSelectInterfaceBottomSheet(context),
      ),

      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        notificationCount: 12,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(onBack: () => Navigator.maybePop(context)),
              SizedBox(height: 23.h),
              Text(
                'Manage interfaces',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 92.h),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (_, i) => _InterfaceCard(
                    item: _items[i],
                    status: _itemStatuses[i],
                    onStatusTap: () {
                      setState(() {
                        _itemStatuses[i] = _itemStatuses[i] == _InterfaceStatus.ok
                            ? _InterfaceStatus.warn
                            : _InterfaceStatus.ok;
                      });
                    },
                    onMore: () {},
                    bg: _card,
                    textDark: _textDark,
                    textGrey: _textGrey,
                    pillGrey: _pillGrey,
                    blue: _blue,
                    magenta: _magenta,
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

/// -------------------- Top Bar --------------------
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;
  static const Color _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(26.r),
          onTap: onBack,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppAssetIcon(
                'assets/aro.png',
                color: _textDark,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Interfaces',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
        ),
        //SizedBox(width: 44.w),
      ],
    );
  }
}

/// -------------------- Interface Card --------------------
class _InterfaceCard extends StatelessWidget {
  const _InterfaceCard({
    required this.item,
    required this.status,
    required this.onStatusTap,
    required this.onMore,
    required this.bg,
    required this.textDark,
    required this.textGrey,
    required this.pillGrey,
    required this.blue,
    required this.magenta,
  });

  final _InterfaceItem item;
  final _InterfaceStatus status;
  final VoidCallback onStatusTap;
  final VoidCallback onMore;

  final Color bg;
  final Color textDark;
  final Color textGrey;
  final Color pillGrey;
  final Color blue;
  final Color magenta;

  static const Color _inactivePillRed = Color(0xFFFE019A);

  @override
  Widget build(BuildContext context) {
    final isActive = status == _InterfaceStatus.ok;
    final pillBg = isActive ? pillGrey : _inactivePillRed;
    final pillTextColor = isActive ? textDark : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo wrapper
          Container(
            width: 43.w,
            height: 43.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: AppAssetIcon(item.logoAsset),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: textDark,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onStatusTap,
                        borderRadius: BorderRadius.circular(26.r),
                        //behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.all(6.w),
                          child: _StatusBadge(status: status),
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 6.h),
                Text(
                  item.subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Devices pill
          Container(
            height: 30.h,
            width: 96.w,
           // padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Text(
              item.devices,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: pillTextColor,
              ),
            ),
          ),

          SizedBox(width: 10.w),

          InkWell(
            onTap: onMore,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Icon(
                Icons.more_horiz_rounded,
                size: 22.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final _InterfaceStatus status;

  static const Color _blue = Color(0xFF0A84FF);
  static const Color _magenta = Color(0xFFFF00A8);

  @override
  Widget build(BuildContext context) {
    if (status == _InterfaceStatus.ok) {
      return Container(
        width: 16.w,
        height: 16.h,
        decoration: const BoxDecoration(
          color: _blue,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            size: 13.sp,
            color: Colors.white,
          ),
        ),
      );
    }
    return Icon(Icons.warning_rounded, size: 22.sp, color: _magenta);
  }
}

/// -------------------- Bottom Nav --------------------
class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.notificationCount,
  });

  final int selectedIndex;
  final void Function(int) onTap;
  final int notificationCount;

  static const Color _selected = Color(0xFF111827);
  static const Color _unselected = Color(0xFF111827);
  static const Color _danger = Color(0xFFFE019A);

  @override
  Widget build(BuildContext context) {
    final items = const <_NavItem>[
      _NavItem('Devices', 'assets/Group 28.png'),
      _NavItem('Analytics', 'assets/bar 5.png'),
      _NavItem('Dashboard', 'assets/Mask group copy 6.png'),
      _NavItem('Notifications', 'assets/Group 43.png'),
      _NavItem('Settings', 'assets/seting.png'),
    ];

    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.74),
        border: const Border(top: BorderSide(color: Color(0xFFE1E1E1), width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / items.length;
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: w * selectedIndex + (w - 46.w) / 2,
                child: Container(
                  width: 46.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: _selected,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2.r),
                      bottomRight: Radius.circular(2.r),
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(items.length, (i) {
                  final item = items[i];
                  final isSel = i == selectedIndex;
                  final color = isSel ? _selected : _unselected;

                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AppAssetIcon(item.icon, color: color),
                              if (item.label == 'Notifications' && notificationCount > 0)
                                Positioned(
                                  right: -10.w,
                                  top: -6.h,
                                  child: Container(
                                    width: 19.w,
                                    height: 15.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _danger,
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: Text(
                                      '$notificationCount',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  const _NavItem(this.label, this.icon);
}

/// -------------------- FAB --------------------
class _FabPlus extends StatelessWidget {
  const _FabPlus({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: onTap,
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
              CupertinoIcons.plus,
              size: 28.sp,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }
}

/// -------------------- Models --------------------
enum _InterfaceStatus { ok, warn }
enum _PillStyle { grey, magenta }

class _InterfaceItem {
  final String title;
  final String subtitle;
  final String devices;
  final String logoAsset;
  final _InterfaceStatus status;
  final _PillStyle pillStyle;

  const _InterfaceItem({
    required this.title,
    required this.subtitle,
    required this.devices,
    required this.logoAsset,
    required this.status,
    required this.pillStyle,
  });
}