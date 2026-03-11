import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Add Protocol bottom sheet — opened from Integrations screen FAB.
/// Design: title "Add protocol", close (X), grid 5 + 3 protocol options.

/// -------------------- Image Size Registry (popup protocol icons ~40–50dp) --------------------
@immutable
class AddProtocolImgSize {
  final double w;
  final double h;
  const AddProtocolImgSize(this.w, this.h);
  const AddProtocolImgSize.square(double s) : w = s, h = s;
}

class AddProtocolImageRegistry {
  AddProtocolImageRegistry._();
  static const AddProtocolImgSize fallback = AddProtocolImgSize.square(44);

  static final Map<String, AddProtocolImgSize> byAsset = {
    'assets/tcp-ip.png': const AddProtocolImgSize.square(44),
    'assets/image 145.png': const AddProtocolImgSize(44, 44),
    'assets/TCP.png': const AddProtocolImgSize.square(44),
    'assets/RS485.png': const AddProtocolImgSize(44, 44),
    'assets/images/UDP.png': const AddProtocolImgSize.square(44),
    'assets/image 66.png': const AddProtocolImgSize.square(44),

    

    'assets/zigport.png': const AddProtocolImgSize.square(33),
    'assets/images/BACnet.png': const AddProtocolImgSize.square(33),
    'assets/images/KNX.png': const AddProtocolImgSize.square(33),


  };

  static AddProtocolImgSize of(String asset) {
    return byAsset[asset] ?? fallback;
  }
}

class _ProtocolIcon extends StatelessWidget {
  const _ProtocolIcon({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    final s = AddProtocolImageRegistry.of(asset);
    return Image.asset(
      asset,
      width: s.w.w,
      height: s.h.h,
      fit: BoxFit.contain,
    );
  }
}

/// -------------------- Add Protocol Bottom Sheet --------------------
class AddProtocolBottomSheet extends StatelessWidget {
  const AddProtocolBottomSheet({super.key});

  static const Color _textDark = Color(0xFF111827);

  // Row 1: 5 items
  static const List<_ProtocolChoice> _row1 = [
    _ProtocolChoice('TCP/IP', 'assets/tcp-ip.png'),
    _ProtocolChoice('Modbus RTU', 'assets/image 145.png'),
    _ProtocolChoice('Modbus TCP', 'assets/TCP.png'),
    _ProtocolChoice('RS485', 'assets/RS485.png'),
    _ProtocolChoice('UDP', 'assets/images/UDP.png'),
  ];
  // Row 2: 3 items
  static const List<_ProtocolChoice> _row2 = <_ProtocolChoice>[
    _ProtocolChoice('Zigbee', 'assets/zigport.png'),
    _ProtocolChoice('BACnet', 'assets/images/BACnet.png'),
    
    _ProtocolChoice('KNX', 'assets/images/KNX.png'),
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
            padding: EdgeInsets.fromLTRB(0.w, 13.w, 8.w, 60.h),
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
                // Header: "Add protocol" centered, close (X) on far right
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Add protocol',
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
                // Row 1: 5 protocol options (TCP/IP, Modbus RTU, Modbus TCP, RS485, UDP)
                Row(
                  
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _row1.map((c) => _ProtocolTile(choice: c)).toList(),
                ),
                SizedBox(height: 10.h),

                Divider(height: 1.h, thickness: 1.h, color: Color(0xFFE1E1E1)),
                SizedBox(height: 10.h),
                // Row 2: 3 items in first 3 columns (same grid as row 1 — Zigbee under TCP/IP, BACnet under Modbus RTU, KNX under Modbus TCP)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProtocolTile(choice: _row2[0]),
                    _ProtocolTile(choice: _row2[1]),
                    _ProtocolTile(choice: _row2[2]),
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

class _ProtocolChoice {
  final String label;
  final String asset;
  const _ProtocolChoice(this.label, this.asset);
}

class _ProtocolTile extends StatelessWidget {
  const _ProtocolTile({required this.choice});
  final _ProtocolChoice choice;

  static const Color _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProtocolIcon(asset: choice.asset),
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