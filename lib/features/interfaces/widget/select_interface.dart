import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ✅ Open popup

/// -------------------- Image Size Registry (edit sizes per asset) --------------------
// @immutable
// class ImgSize {
//    final double w;
//   final double h;
//   //const ImgSize(this.w, this.h);
//   const ImgSize( this.w, this.h);
//   const ImgSize.square(double s) :   w = s, h = s;
// }
//
// class ImageSizeRegistry {
//   ImageSizeRegistry._();
//
//   static const ImgSize fallback = ImgSize.square(44);
//
//   /// ✅ Put every asset size here (each can be different)
//   static final Map<String, ImgSize> byAsset = {
//     'assets/icons/close.png': const ImgSize.square(18),
//
//     // Select interface icons
//     'assets/image 66.png': const ImgSize( 40, 40),
//     'assets/image 145.png': const ImgSize(44, 44),
//     //'assets/TCP.png': const ImgSize(44, 44),
//     'assets/RTU2.png': const ImgSize(56,56),
//     'assets/RS485.png': const ImgSize(44, 44),
//     'assets/ip_camera.png': const ImgSize(33, 33),
//     'assets/zigport.png': const ImgSize(33, 33),
//     'assets/wifi-single.png': const ImgSize(33, 33),
//
//
//     // 'assets/image 66.png': const ImgSize( 26),
//     // //'assets/image 145.png': const ImgSize(26,),
//     // 'assets/RTU2.png': const ImgSize(26,),
//     //
//     // 'assets/TCP.png': const ImgSize(26,),
//     // 'assets/RS485.png': const ImgSize(26, ),
//     // 'assets/ip_camera.png': const ImgSize(26,),
//     // 'assets/zigport.png': const ImgSize(26, ),
//     // 'assets/wifi-single.png': const ImgSize(26,),
//     //
//
//
//   };
//
//
//
//
//   static ImgSize of(String asset, {ImgSize? fallbackSize}) {
//     return byAsset[asset] ?? (fallbackSize ?? fallback);
//   }
// }
//
//
//
// class AppAssetIcon extends StatelessWidget {
//   const AppAssetIcon(
//       this.asset, {
//         super.key,
//         this.size,
//         this.color,
//         this.fit = BoxFit.contain,
//       });
//
//   final String asset;
//   final ImgSize? size;
//   final Color? color;
//   final BoxFit fit;
//
//   @override
//   Widget build(BuildContext context) {
//     final s = size ?? ImageSizeRegistry.of(asset);
//     return Image.asset(
//       asset,
//       width: s.w.w,
//       height: s.h.h,
//       fit: fit,
//       color: color,
//       colorBlendMode: color == null ? null : BlendMode.srcIn,
//     );
//   }
// }

@immutable
class ImgSize {
  final double w;
  final double h;
  const ImgSize(this.w, this.h);
  const ImgSize.square(double s) : w = s, h = s;
}

// class ImageSizeRegistry {
//   ImageSizeRegistry._();
//
//   static const ImgSize fallback = ImgSize.square(44);
//
// static final Map<String, ImgSize> byAsset = {
//      'assets/icons/close.png': const ImgSize.square(18),
//   //
//     // ✅ Select interface icons (আপনার asset নাম অনুযায়ী)
//     'assets/image 66.png': const ImgSize(26, 26),     // BUS
//     'assets/RTU2.png': const ImgSize(52, 52),         // Modbus RTU
//     'assets/image 145.png': const ImgSize(56, 56),    // Modbus TCP (আপনি যেটা ব্যবহার করেন)
//     'assets/RS485.png': const ImgSize(56, 56),        // RS485
//     'assets/wifi-single.png': const ImgSize(44, 44),  // Wireless
//     'assets/zigport.png': const ImgSize(33, 33),      // Zigbee
//     'assets/ip_camera.png': const ImgSize(33, 33),    // IP Camera
//   };
//
//   static ImgSize of(String asset, {ImgSize? fallbackSize}) {
//     final key = asset.trim(); // ✅ FIX-1: trim key
//     return byAsset[key] ?? (fallbackSize ?? fallback);
//   }
// }

class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon(
      this.asset, {
        super.key,
        this.size,
        this.color,
        this.fit = BoxFit.contain,
        this.forceSize = true,
      });

  final String asset;
  final ImgSize? size;
  final Color? color;
  final BoxFit fit;

  /// ✅ FIX-2: force exact box size (so your registry size applies)
  final bool forceSize;

  @override
  Widget build(BuildContext context) {
   // final s = size ?? ImageSizeRegistry.of(asset);

    // ✅ FIX-3: icons scale by width to match design (consistent)
    //final widthPx = s.w.w;
   // final heightPx = s.h.w;

    final img = Image.asset(
      asset.trim(),
      fit: fit,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );

    if (!forceSize) {
      return img;
    }

    return SizedBox(
      //width: widthPx,
//height: heightPx,
      child: FittedBox(
        fit: fit, // contain like design
        child: SizedBox(
          //width: s.w,
         // height: s.h,
          child: img,
        ),
      ),
    );
  }
}


/// -------------------- Bottom Sheet UI --------------------
class SelectInterfaceBottomSheet extends StatelessWidget {
  const SelectInterfaceBottomSheet({super.key});

  static const Color _textDark = Color(0xFF111827);
  static const Color _line = Color(0xFFE5E7EB);
  static const Color _chipBg = Color(0xFFF3F4F6);

  static const List<_InterfaceChoice> _topRow = [
    _InterfaceChoice('BUS', 'assets/image 66.png',),
     _InterfaceChoice('Modbus RTU', 'assets/image 145.png'),
    // _InterfaceChoice('Modbus RTU', 'assets/RTU2.png'),

    _InterfaceChoice('Modbus TCP', 'assets/TCP.png'),
    _InterfaceChoice('RS485', 'assets/RS485.png'),
    _InterfaceChoice('Wireless', 'assets/wifi-single.png'),
  ];
  static const List<_InterfaceChoice> _bottomRow = [
    _InterfaceChoice('Zigbee', 'assets/zigport.png'),
    _InterfaceChoice('IP Camera', 'assets/ip_camera.png'),
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0.w, 13.h, 8.w, 60.h),
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Select interface',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
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
                              color: _textDark,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.h),
                // First row: 5 icons (BUS, Modbus RTU, Modbus TCP, RS485, Wireless)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _topRow.map((it) => _ChoiceTile(choice: it)).toList(),
                ),
                SizedBox(height: 10.h),
                // Divider: thin light gray line
                Divider(height: 1.h, thickness: 1.h, color: _line),
                SizedBox(height: 10.h),
                // Second row: 2 items in first 2 columns (same grid as row 1 — Zigbee under BUS, IP Camera under Modbus RTU)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChoiceTile(choice: _bottomRow[0]),
                    _ChoiceTile(choice: _bottomRow[1]),
                    const Expanded(child: SizedBox.shrink()),
                    const Expanded(child: SizedBox.shrink()),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InterfaceChoice {
  final String label;
  final String asset;
  const _InterfaceChoice(this.label, this.asset);
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.choice});
  final _InterfaceChoice choice;

  static const Color _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // All popup icons use the exact same visual box size
          SizedBox(
            width: double.infinity,
            height: 30.h,

            child: AppAssetIcon(
              choice.asset,

            ),
          ),
          SizedBox(height: 10.h),
          Text(
            choice.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }
}