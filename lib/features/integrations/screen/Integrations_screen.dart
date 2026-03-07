import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/add_protocol.dart';

class IntegrationsScreen extends StatefulWidget {
  const IntegrationsScreen({super.key});
  static const routeName = "/Integrations";

  @override
  State<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

/// -------------------- Image Size Registry (edit per asset) --------------------
@immutable
class ImgSize {
  final double w;
  final double h;
  const ImgSize(this.w, this.h);
  const ImgSize.square(double s) : w = s, h = s;
}

class ImageSizeRegistry {
  ImageSizeRegistry._();

  static const ImgSize fallback = ImgSize.square(26);

  /// ✅ Put every asset size here (each can be different)
  static final Map<String, ImgSize> byAsset = {
    // Top
    'assets/aro.png': const ImgSize.square(16),

    // Center illustration
    'assets/integrations_img.png': const ImgSize(91, 91),

    // Bottom nav icons (use your assets)
    'assets/Group 28.png': const ImgSize.square(24), // Devices
    'assets/bar 5.png': const ImgSize.square(26), // Analytics
    'assets/Mask group copy 6.png': const ImgSize.square(26), // Dashboard
    'assets/Group 43.png': const ImgSize.square(24), // Notifications
    'assets/Mask group (8).png': const ImgSize.square(24), // Settings/Automations (use yours)

    // FAB icon
    'assets/icons/plus.png': const ImgSize.square(24),

    // Active integration card icons
    'assets/tcp-ip.png': const ImgSize(52, 52),
    'assets/RS485.png': const ImgSize(39, 39),
    'assets/active_devices.png': const ImgSize.square(15),
    'assets/images/Group 55.png': const ImgSize.square(15),
    
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

class _IntegrationsScreenState extends State<IntegrationsScreen> {
  // Colors
  static const Color _bg = Color(0xFFF3F4F6);
  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _danger = Color(0xFFFE019A);

  int _selectedIndex = 3; // Notifications selected in screenshot

  late final List<IntegrationState> _cardStates = [
    IntegrationState.enabled,
    IntegrationState.disabled,
  ];


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      floatingActionButton: _RoundFab(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddProtocolBottomSheet(),
          );
        },
        child: Icon(Icons.add, size: 28.sp, color: _textDark),
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
              SizedBox(height: 60.h),

              // Center Illustration
              Center(
                child: AppAssetIcon(
                  'assets/integrations_img.png',
                  
                  // If you don't have this, replace with your own asset.
                ),
              ),

              SizedBox(height: 60.h),

              Text(
                'Your control unit can provide information about devices in this\nhub (90 K2) to other control unit or central building management\nsystem to expose control and status display.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w300,
                  color: _textGrey,
                  height: 1.35,
                ),
              ),

              SizedBox(height: 26.h),

              Text(
                'Active integrations',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
                   SizedBox(height: 12.h),
              // Empty space (like screenshot)
              ActiveIntegrationCard(
                item: const ActiveIntegrationItem(
                  title: 'TCP/IP',
                  subLeft: '10000',
                  subRight: '12 Devices',
                  logoAsset: 'assets/tcp-ip.png',
                  statusIconAsset: 'assets/active_devices.png',
                  state: IntegrationState.enabled,
                ),
                currentState: _cardStates[0],
                onStateTap: () {
                  setState(() {
                    _cardStates[0] = _cardStates[0] == IntegrationState.enabled
                        ? IntegrationState.disabled
                        : IntegrationState.enabled;
                  });
                },
              ),
              SizedBox(height: 10.h),
              ActiveIntegrationCard(
                item: const ActiveIntegrationItem(
                  title: 'RS485',
                  subLeft: 'Port 3',
                  subRight: '10 Devices',
                  logoAsset: 'assets/RS485.png',
                  statusIconAsset: 'assets/images/Group 55.png',
                  state: IntegrationState.disabled,
                ),
                currentState: _cardStates[1],
                onStateTap: () {
                  setState(() {
                    _cardStates[1] = _cardStates[1] == IntegrationState.enabled
                        ? IntegrationState.disabled
                        : IntegrationState.enabled;
                  });
                },
              )
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
              'Integrations',
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

/// -------------------- FAB --------------------
class _RoundFab extends StatelessWidget {
  const _RoundFab({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26.r),
        child: Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 26.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
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
  static const Color _badge = Color(0xFFFE019A);

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
                                      color: _badge,
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

enum IntegrationState { enabled, disabled }

class ActiveIntegrationItem {
  final String title; // TCP/IP, RS485
  final String subLeft; // 10000 or Port 3
  final String subRight; // 12 Devices
  final String logoAsset; // tcpip icon, rs485 icon
  final String statusIconAsset; // link / ban
  final IntegrationState state;
  final String? badgeText; // "42 ▸ 17" (optional small badge)

  const ActiveIntegrationItem({
    required this.title,
    required this.subLeft,
    required this.subRight,
    required this.logoAsset,
    required this.statusIconAsset,
    required this.state,
    this.badgeText,
  });
}

/// ---------------- Card Widget ----------------
class ActiveIntegrationCard extends StatelessWidget {
  const ActiveIntegrationCard({
    super.key,
    required this.item,
    required this.currentState,
    this.onStateTap,
    this.onTap,
  });

  final ActiveIntegrationItem item;
  final IntegrationState currentState;
  final VoidCallback? onStateTap;
  final VoidCallback? onTap;

  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _blue = Color(0xFF0088FE);
  static const Color _disabledBg = Color(0xFFF1F3F6);

  @override
  Widget build(BuildContext context) {
    final isEnabled = currentState == IntegrationState.enabled;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Row(
          children: [
            // left icon box
            Center(
              child: AppAssetIcon(item.logoAsset),
            ),

            SizedBox(width: 14.w),

            // title + sub
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title row
                  Row(
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: _textDark,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      AppAssetIcon(
                        item.statusIconAsset,
                       
                        // screenshot icon is grey
                       // color: _textGrey,
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // subtitle + optional badge
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.w,
                    children: [
                      Text(
                        '${item.subLeft}  •  ${item.subRight}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: _textGrey,
                        ),
                      ),
                      if (item.badgeText != null) _MiniBadge(text: item.badgeText!),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Right pill + arrow
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onStateTap,
                  borderRadius: BorderRadius.circular(26.r),
                  child: _StatusPill(enabled: isEnabled),
                ),
                SizedBox(width: 14.w),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 26.sp,
                  color: _textGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// small blue badge like "42 ▸ 17"
class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A84FF),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.enabled});
  final bool enabled;

  static const Color _blue = Color(0xFF0088FE);
  static const Color _disabledBg = Color(0xFFF1F3F6);
  static const Color _textDark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 78.w,
      //padding: EdgeInsets.symmetric(horizontal: 18.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? _blue : _disabledBg,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Text(
        enabled ? 'Enabled' : 'Disabled',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: enabled ? Colors.white : _textDark,
        ),
      ),
    );
  }
}