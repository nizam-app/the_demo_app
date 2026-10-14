import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/utils/ui_tap_haptic.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/core/widget/liquid_glass.dart';
import 'package:workpleis/core/widget/pressable_circle_surface.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';

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

  /// Bottom nav: Settings (4) is selected when this screen is opened from Settings.
  int _selectedNavIndex = 4;
  double _headerScrollOffset = 0;

  void _onNavItemTapped(int index) {
    const routes = [
      '/devices',
      '/analytics',
      '/home',
      '/notifications',
      '/settings',
    ];
    if (index < routes.length) {
      context.go(routes[index]);
    }
  }

  late final List<_InterfaceStatus> _itemStatuses = [
    for (final e in _items) e.status,
  ];

  Future<void> showSelectInterfaceBottomSheet(BuildContext context) {
    return showLiquidGlassModalBottomSheet(
      context: context,
      isDismissible: true,
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
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final headerChrome = 56.h;
    final scrollTopPadding = topInset + headerChrome + 10.h;
    final scrollBottomPad = 92.h + bottomInset + 10.h;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: GlassBottomNavScaffold(
        backgroundColor: _bg,
        selectedIndex: _selectedNavIndex,
        onItemTapped: _onNavItemTapped,
        floatingActionButton: _FabPlus(
          onTap: () => showSelectInterfaceBottomSheet(context),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(color: _bg),
                ),
              ),
              Positioned.fill(
                child: listenInnerScreenScroll(
                  onScrollOffset: (px) => updateInnerScreenHeaderScrollOffset(
                    current: _headerScrollOffset,
                    next: px,
                    apply: () => setState(() => _headerScrollOffset = px),
                  ),
                  child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    scrollTopPadding,
                    20.w,
                    scrollBottomPad,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      for (int i = 0; i < _items.length; i++) ...[
                        if (i > 0) SizedBox(height: 14.h),
                        _InterfaceCard(
                          item: _items[i],
                          status: _itemStatuses[i],
                          onStatusTap: () {
                            uiTapHaptic();
                            setState(() {
                              _itemStatuses[i] =
                                  _itemStatuses[i] == _InterfaceStatus.ok
                                  ? _InterfaceStatus.warn
                                  : _InterfaceStatus.ok;
                            });
                          },
                          onTap: () {
                            uiTapHaptic();
                            setState(() {
                              _itemStatuses[i] =
                                  _itemStatuses[i] == _InterfaceStatus.ok
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
                      ],
                      SizedBox(height:400.h),  
                    ],
                  ),
                ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LiquidGlassInnerScreenHeader(
                  backgroundColor: _bg,
                  scrollOffset: _headerScrollOffset,
                  padding: EdgeInsets.fromLTRB(
                    15.w,
                    topInset + 10.h,
                    15.w,
                    8.h,
                  ),
                  child: SizedBox(
                    height: 32.h,
                    child: _TopBar(
                      onBack: () => Navigator.maybePop(context),
                    ),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GlobalCircleIconBtn(
          onTap: onBack,
          child: AppAssetIcon('assets/aro.png', color: _textDark),
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
        SizedBox(width: 32.w),
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
    required this.onTap,
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
  final VoidCallback onTap;
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
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
              child: Center(child: AppAssetIcon(item.logoAsset)),
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
                      SizedBox(width: 6.w),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onStatusTap,
                          borderRadius: BorderRadius.circular(26.r),
                          //behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: _StatusBadge(status: status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 6.h),
                  Text(
                    item.subtitle,
                    //overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 6.w),

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

            SizedBox(width: 4.w),

            InkWell(
              onTap: onMore,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 22.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
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
      return Image.asset(
        "assets/zigbee_done.png",
        height: 13,
        width: 13,
        fit: BoxFit.cover,
      );
    }
    return Icon(Icons.warning_rounded, size: 18.sp, color: _magenta);
  }
}

/// -------------------- FAB --------------------
class _FabPlus extends StatelessWidget {
  const _FabPlus({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableCircleSurface(
      side: 46.w,
      useLiquidGlass: true,
      onTap: onTap,
      child: Icon(
        CupertinoIcons.plus,
        size: 30.sp,
        color: const Color(0xFF111827),
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
