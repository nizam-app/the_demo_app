import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/categories/screen/categories_screen.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';

// —— Riverpod (Analytics screen only) ——
enum _AnalyticsPeriod { week, day }

final _analyticsPeriodProvider =
    StateProvider<_AnalyticsPeriod>((ref) => _AnalyticsPeriod.day);

final _analyticsSelectedDeviceIndexProvider = StateProvider<int>((ref) => 1);

abstract final class _AnalyticsColors {
  static const Color pageBg = Color(0xFFF3F4F6);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color title = Color(0xFF111827);
  static const Color subtitle = Color(0xFF6B7280);
  static const Color linkBlue = Color(0xFF0088FF);
  static const Color selectedRowBg = Color(0xFFEAF1FF);
  static const Color gridLine = Color(0xFFE5E7EB);
}

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key, this.showBottomNav = true});

  static const String routeName = '/analytics';
  final bool showBottomNav;

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  void _onNavItemTapped(int index) {
    final routes = [
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

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(_analyticsPeriodProvider);
    final selectedDevice = ref.watch(_analyticsSelectedDeviceIndexProvider);

    return Scaffold(
      backgroundColor: _AnalyticsColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 6.h, 14.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GlobalCircleIconBtn(
                      color: _AnalyticsColors.cardBg,
                      child: Image.asset(
                        'assets/aro.png',
                        width: 16.w,
                        height: 16.h,
                      ),
                      onTap: () {
                        if (!widget.showBottomNav) {
                          final shell = CustomBottomNavBar.of(context);
                          if (shell != null) {
                            shell.setSelectedIndex(2);
                            return;
                          }
                        }
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 17.h),
                  Center(
                    child: _PeriodSegmentedControl(
                      selected: period,
                      onChanged: (p) =>
                          ref.read(_analyticsPeriodProvider.notifier).state = p,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: _AnalyticsColors.title,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Today, 24 June',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: _AnalyticsColors.subtitle,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _ActivityCard(period: period),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Text(
                          'Device usage',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: _AnalyticsColors.title,
                          ),
                        ),
                        const Spacer(),
                        
                            GestureDetector(
                              onTap: () =>
                                  context.push(CategoriesScreen.routeName),
                              child: Row(
                                children: [
                                  Text(
                                    'Categories ',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: _AnalyticsColors.linkBlue,
                                    ),
                                  ),
                                  Image.asset("assets/images/back_arro.png", height: 11.h, width: 11.w, fit: BoxFit.cover, color: _AnalyticsColors.linkBlue,)
                                ],
                              ),
                            //  Image.asset("name")
                              
                              
                            ),
                        
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _DeviceUsageCard(
                      selectedIndex: selectedDevice,
                      onSelect: (i) => ref
                          .read(_analyticsSelectedDeviceIndexProvider.notifier)
                          .state = i,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavBarWidget(
              selectedIndex: 1,
              onItemTapped: _onNavItemTapped,
            )
          : null,
    );
  }
}

class _PeriodSegmentedControl extends StatelessWidget {
  const _PeriodSegmentedControl({
    required this.selected,
    required this.onChanged,
  });

  final _AnalyticsPeriod selected;
  final ValueChanged<_AnalyticsPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 274.w,
      height: 40.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentChip(
            label: 'Week',
            selected: selected == _AnalyticsPeriod.week,
            onTap: () => onChanged(_AnalyticsPeriod.week),
          ),
          _SegmentChip(
            label: 'Day',
            selected: selected == _AnalyticsPeriod.day,
            onTap: () => onChanged(_AnalyticsPeriod.day),
          ),
        ],
      ),
    );
  }
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
        width: 132.w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFF3F4F6)
                  : Colors.white,
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? const Color(0xFF111827)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.period});

  final _AnalyticsPeriod period;

  static const List<double> _weekHeights = [
    0.42,
    0.58,
    0.72,
    0.48,
    0.65,
    0.88,
    0.52,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: _AnalyticsColors.cardBg,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period == _AnalyticsPeriod.day
                ? 'Light living room 18h 46m'
                : 'Light living room 5d 12h',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF111827),
              height: 1.25,
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 132.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: _WeeklyBarsPainter(
                      normalizedHeights: _weekHeights,
                      gridColor: _AnalyticsColors.gridLine,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 32.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: ['24h', '18h', '12h', '6h', '0']
                        .map(
                          (t) => Text(
                            t,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: _AnalyticsColors.subtitle,
                              //color: Color(0xFF6B7280)
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: _AnalyticsColors.subtitle,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 22.h),
          SizedBox(
            height: 110.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: _DailyStackPainter(
                      slotData: const [
                        (0.28, 0.22, 0.18),
                        (0.35, 0.30, 0.20),
                        (0.40, 0.25, 0.22),
                        (0.22, 0.18, 0.15),
                      ],
                      gridColor: _AnalyticsColors.gridLine,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 32.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: ['100%', '75%', '50%', '25%', '0']
                        .map(
                          (t) => Text(
                            t,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: _AnalyticsColors.subtitle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '00:00',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: _AnalyticsColors.subtitle,
                ),
              ),
              Text(
                '6:00',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: _AnalyticsColors.subtitle,
                ),
              ),
              Text(
                '12:00',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: _AnalyticsColors.subtitle,
                ),
              ),
              Text(
                '18:00',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: _AnalyticsColors.subtitle,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          SizedBox(height: 10.h),
          Row(
            children: const [
              Expanded(
                child: _LegendColumn(
                  label: 'On',
                  value: '5h 58m',
                  labelColor: Color(0xFF0088FE),
                ),
              ),
              Expanded(
                child: _LegendColumn(
                  label: 'Off',
                  value: '1h 29m',
                  labelColor: Color(0xFF111827),
                ),
              ),
              Expanded(
                child: _LegendColumn(
                  label: 'Auto',
                  value: '8h 50m',
                  labelColor: Color(0xFF00D1FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendColumn extends StatelessWidget {
  const _LegendColumn({
    required this.label,
    required this.value,
    required this.labelColor,
  });                                

  final String label;
  final String value;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: labelColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _WeeklyBarsPainter extends CustomPainter {
  _WeeklyBarsPainter({
    required this.normalizedHeights,
    required this.gridColor,
  });

  final List<double> normalizedHeights;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    const barCount = 7;
    final gap = 5.0;
    final barW = (size.width - gap * (barCount + 1)) / barCount;

    // Lined grid behind bars: horizontal (0,6h,12h,18h,24h) + vertical per day column.
    for (var i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), grid);
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, size.height),
      grid,
    );
    for (var k = 0; k < barCount - 1; k++) {
      final x = gap + k * (barW + gap) + barW + gap / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    for (var i = 0; i < barCount; i++) {
      final nh = normalizedHeights[i].clamp(0.0, 1.0);
      final h = size.height * nh;
      final left = gap + i * (barW + gap);
      final top = size.height - h;
      final r = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, top, barW, h),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      final shader = ui.Gradient.linear(
        Offset(left, top),
        Offset(left, size.height),
        const [Color(0xFF90CAF9), Color(0xFF1565C0)],
      );
      canvas.drawRRect(r, Paint()..shader = shader);
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyBarsPainter oldDelegate) =>
      oldDelegate.normalizedHeights != normalizedHeights ||
      oldDelegate.gridColor != gridColor;
}

class _DailyStackPainter extends CustomPainter {
  _DailyStackPainter({
    required this.slotData,
    required this.gridColor,
  });

  final List<(double, double, double)> slotData;
  final Color gridColor;

  static const _light = Color(0xFF90CAF9);
  static const _mid = Color(0xFF1976D2);
  static const _dark = Color(0xFF0D47A1);

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    final n = slotData.length;
    final gap = 8.0;
    final colW = (size.width - gap * (n + 1)) / n;

    // Lined grid behind stacks: horizontal (0–100%) + vertical between time slots.
    for (var i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), grid);
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, size.height),
      grid,
    );
    for (var k = 0; k < n - 1; k++) {
      final x = gap + k * (colW + gap) + colW + gap / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    for (var i = 0; i < n; i++) {
      final left = gap + i * (colW + gap);
      final (a, b, c) = slotData[i];
      final total = (a + b + c).clamp(0.001, 10.0);
      final track = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, 0, colW, size.height),
        topLeft: const Radius.circular(5),
        topRight: const Radius.circular(5),
        bottomLeft: const Radius.circular(5),
        bottomRight: const Radius.circular(5),
      );

      final h1 = size.height * (a / total);
      final h2 = size.height * (b / total);
      final h3 = size.height * (c / total);

      canvas.save();
      canvas.clipRRect(track);
      canvas.drawRect(
        Rect.fromLTWH(left, 0, colW, size.height),
        Paint()..color = const Color(0xFFF3F4F6),
      );
      var yBottom = size.height;
      yBottom -= h1;
      canvas.drawRect(
        Rect.fromLTWH(left, yBottom, colW, h1),
        Paint()..color = _light,
      );
      yBottom -= h2;
      canvas.drawRect(
        Rect.fromLTWH(left, yBottom, colW, h2),
        Paint()..color = _mid,
      );
      yBottom -= h3;
      canvas.drawRect(
        Rect.fromLTWH(left, yBottom, colW, h3),
        Paint()..color = _dark,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DailyStackPainter oldDelegate) =>
      oldDelegate.slotData != slotData || oldDelegate.gridColor != gridColor;
}

class _DeviceUsageCard extends StatelessWidget {
  const _DeviceUsageCard({
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static final List<_DeviceUsageRowData> _rows = [
    _DeviceUsageRowData(
      name: 'Bathroom light',
      value: '8h 44m',
      progress: 0.90,
      image: "assets/Mask group (5).png",
      
    ),
    _DeviceUsageRowData(
      name: 'Push button',
      value: '28times',
      progress: 0.70,
      image: "assets/Mask group (13).png",
      
    ),
    _DeviceUsageRowData(
      name: 'Vent 3 speed',
      value: '1h 44m',
      progress: 0.60,
      image: "assets/images/fan.png",

    ),
    _DeviceUsageRowData(
      name: 'Air condition',
      value: '2h 05m',
      progress: 0.50,
      image: "assets/images/6376d7bf4226592678854fa38ee9afdd47741881.png",
    
    ),
    _DeviceUsageRowData(
      name: 'Irrigation',
      value: '2h 05m',
      progress: 0.55,
      image: "assets/images/irrigation.png",
      
    ),
    _DeviceUsageRowData(
      name: 'Volt meter',
      value: '47.5kW',
      progress: 0.82,
      image: "assets/images/brightness_sensor.png",
      
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AnalyticsColors.cardBg,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: Column(
          children: List.generate(_rows.length, (index) {
            final row = _rows[index];
            final isLast = index == _rows.length - 1;
            return Column(
              children: [
                Material(
                  color: selectedIndex == index
                      ? _AnalyticsColors.selectedRowBg
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelect(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          Image.asset(row.image,
                            height: 26.h,
                            width: 26.w,
                            fit: BoxFit.contain,
                            ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  row.name,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(26),
                                  child: LinearProgressIndicator(
                                    value: row.progress,
                                    minHeight: 5.h,
                                  //  backgroundColor: const Color(0xFFE1E1E1),
                                    valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFFE1E1E1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            row.value,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Image.asset("assets/images/back_arro.png",
                            height: 11.h,
                            width: 11.w,
                            fit: BoxFit.cover,
                            color: Color(0xFF6B7280),)
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16.w + 40.w + 12.w,
                    color: const Color(0xFFE1E1E1),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _DeviceUsageRowData {
  const _DeviceUsageRowData({
    required this.name,
    required this.value,
    required this.progress,
    required this.image,

  });

  final String name;
  final String value;
  final double progress;
  final String image;
  
}