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
    'assets/images/BACnet.png': const AddProtocolImgSize.square(28),
    'assets/images/KNX.png': const AddProtocolImgSize.square(30),


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

  static const Color _textDark = Color(0xFF333333);
  static const Color _chipBg = Color(0xFFF0F0F0);

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
            padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 57.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 26.r,
                  offset: Offset(0, -6.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: "Add protocol" centered, close (X) on far right
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Text(
                        'Add protocol',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Material(
                        color: _chipBg,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          customBorder: const CircleBorder(),
                          child: SizedBox(
                            width: 32.w,
                            height: 32.h,
                            child: Icon(
                              Icons.close_rounded,
                              size: 22.sp,
                              color: _textDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                // Row 1: 5 protocol options (TCP/IP, Modbus RTU, Modbus TCP, RS485, UDP)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _row1.map((c) => _ProtocolTile(choice: c)).toList(),
                ),
                SizedBox(height: 22.h),

                Divider(height: 1.h, thickness: 1.h, color: Color(0xFFE1E1E1)),
                SizedBox(height: 22.h),
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