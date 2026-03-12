import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// -------------------- Image Size Registry (edit sizes per asset) --------------------

@immutable
class ImgSize {
  final double w;
  final double h;
  const ImgSize(this.w, this.h);
  const ImgSize.square(double s) : w = s, h = s;
}

class ImageSizeRegistry {
  ImageSizeRegistry._();
  static const ImgSize fallback = ImgSize.square(44);

  /// Set width and height separately per asset (e.g. 40.w x 44.h).
  static final Map<String, ImgSize> byAsset = {
    //'assets/imagelogo.png': const ImgSize(52, 52),
    'assets/imageslogo1.png': const ImgSize(44, 44),
    'assets/image 145.png': const ImgSize(44, 44),
    'assets/images41.png': const ImgSize(44, 44),
    'assets/images42.png': const ImgSize(44, 44),
    'assets/imiageswf45.png': const ImgSize(44, 44),
   // 'assets/wifi-single.png': const ImgSize(33, 33),
    'assets/zigport.png': const ImgSize(33, 33),
    'assets/ip_camera.png': const ImgSize(33, 33),
  };

  static ImgSize of(String asset) => byAsset[asset] ?? fallback;
}

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
  final bool forceSize;

  @override
  Widget build(BuildContext context) {
    final s = size ?? ImageSizeRegistry.of(asset);
    final img = Image.asset(
      asset.trim(),
      width: s.w.w,
      height: s.h.h,
      fit: fit,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
    );

    if (!forceSize) return img;

    return SizedBox(
      width: s.w.w,
      height: s.h.h,
      child: Center(
        child: img,
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
    _InterfaceChoice('BUS', 'assets/imageslogo1.png',),
     _InterfaceChoice('Modbus RTU', 'assets/image 145.png'),
    // _InterfaceChoice('Modbus RTU', 'assets/RTU2.png'),

    _InterfaceChoice('Modbus TCP', 'assets/images41.png'),
    _InterfaceChoice('RS485', 'assets/images42.png'),
    _InterfaceChoice('Wireless', 'assets/imiageswf45.png'),
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
          // Icon: registry defines width & height per asset; same row height for alignment
          Center(
            child: AppAssetIcon(choice.asset),
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