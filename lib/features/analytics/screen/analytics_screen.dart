import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/categories/screen/categories_screen.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';

// —— Riverpod (Analytics screen only) ——
enum _AnalyticsPeriod { week, day }

final _analyticsPeriodProvider = StateProvider<_AnalyticsPeriod>(
  (ref) => _AnalyticsPeriod.day,
);

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
                          onTap: () => context.push(CategoriesScreen.routeName),
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
                              Image.asset(
                                "assets/images/back_arro.png",
                                height: 11.h,
                                width: 11.w,
                                fit: BoxFit.cover,
                                color: _AnalyticsColors.linkBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _DeviceUsageCard(
                      selectedIndex: selectedDevice,
                      onSelect: (i) =>
                          ref
                                  .read(
                                    _analyticsSelectedDeviceIndexProvider
                                        .notifier,
                                  )
                                  .state =
                              i,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavBarWidget(selectedIndex: 1, onItemTapped: _onNavItemTapped)
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
    return SizedBox(
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
              color: selected ? const Color(0xFFF3F4F6) : Colors.white,
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
    0.93, // S
    0.71, // M
    0.52, // T
    0.87, // W
    0.98, // T
    0.71, // F
    0.99, // S
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: _AnalyticsColors.cardBg,
        borderRadius: BorderRadius.circular(30.r),
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
              height: 1.2,
            ),
          ),
          SizedBox(height: 18.h),

          /// Top chart
         /// Top chart - same box/table style like image 1
SizedBox(
  height: 150.h,
  width: 400.w,
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Stack(
            children: [
              CustomPaint(
                size: Size(double.infinity, 150.h),
                painter: _WeeklyBarsPainter(
                  normalizedHeights: _weekHeights,
                  gridColor: const Color(0xFFE5E7EB),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 150.h,
                ),
              ),

              /// labels inside bottom row of the same chart box
              Positioned(
                left: 0,
                right: 0,
                bottom: 8.h,
                child: Row(
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                      .map(
                        (d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 0.2.w),
      SizedBox(
        width: 35.w,
        child: Padding(
          padding: EdgeInsets.only(top: 0.h, bottom: 35.h),
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
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ],
  ),
),

SizedBox(height: 18.h),

SizedBox(
  height: 135.h,
  width: 400.w,
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 2.w, right: 2.w),
          child: Stack(
            children: [
              CustomPaint(
                painter: _DailyStackPainter(
                  gridColor: const Color(0xFFE5E7EB),
                  barWidth: 11.w,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 184.h,
                ),
              ),

              /// x-axis labels inside same chart box
              Positioned(
                left: 0,
                right: 0,
                bottom: 8.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '00:00',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '6:00',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '12:00',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '18:00',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 0.2.w),
      SizedBox(
        width: 35.w,
        child: Padding(
          padding: EdgeInsets.only(top: 2.h, bottom: 38.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ['100%', '75%', '50%', '25%', '0']
                .map(
                  (t) => Text(
                    t,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ],
  ),
),

// SizedBox(height: 12.h),
// const Divider(height: 1, color: Color(0xFFF1F3F5)),
// SizedBox(height: 12.h),
// const Divider(height: 1, color: Color(0xFFF1F3F5)),  
          
          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _LegendColumn(
                    label: 'On',
                    value: '5h 58m',
                    labelColor: const Color(0xFF0088FE),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: _LegendColumn(
                    label: 'Off',
                    value: '1h 29m',
                    labelColor: const Color(0xFF111827),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _LegendColumn(
                    label: 'Auto',
                    value: '8h 50m',
                    labelColor: const Color(0xFF00C8FF),
                    textAlign: TextAlign.right,
                  ),
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
    this.textAlign = TextAlign.left,
  });

  final String label;
  final String value;
  final Color labelColor;
  final TextAlign textAlign;

  CrossAxisAlignment _crossAxis() {
    switch (textAlign) {
      case TextAlign.right:
      case TextAlign.end:
        return CrossAxisAlignment.end;
      case TextAlign.center:
        return CrossAxisAlignment.center;
      default:
        return CrossAxisAlignment.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: _crossAxis(),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17.sp,
            fontWeight: FontWeight.w400,
            color: labelColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.sp,
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

    const int barCount = 7;

    // bottom row for weekday labels
    final double labelRowHeight = 34;
    final double chartHeight = size.height - labelRowHeight;

    final double columnWidth = size.width / barCount;
    final double barWidth = columnWidth * 0.48;

    // outer vertical lines (full height including label row)
    for (int i = 0; i <= barCount; i++) {
      final x = columnWidth * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        grid,
      );
    }

    // horizontal lines for chart area only
    for (int i = 0; i <= 4; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        grid,
      );
    }

    // separator line between chart and weekday row
    canvas.drawLine(
      Offset(0, chartHeight),
      Offset(size.width, chartHeight),
      grid,
    );

    for (int i = 0; i < barCount; i++) {
      final double value = normalizedHeights[i].clamp(0.0, 1.0);
      final double barHeight = chartHeight * value;

      final double left = (i * columnWidth) + ((columnWidth - barWidth) / 2);
      final double top = chartHeight - barHeight;

      final rect = Rect.fromLTWH(left, top, barWidth, barHeight);
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(5),
        topRight: const Radius.circular(5),
        bottomRight: Radius.zero,
        bottomLeft: Radius.zero,
      );

      final paint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
              Color(0xFF0088FE),
            Color(0xFF00D1FF),
          
          ],
        ).createShader(rect);

      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyBarsPainter oldDelegate) {
    return oldDelegate.normalizedHeights != normalizedHeights ||
        oldDelegate.gridColor != gridColor;
  }
}
class _DailyStackPainter extends CustomPainter {
  _DailyStackPainter({
    required this.gridColor,
    required this.barWidth,
  });

  final Color gridColor;
  final double barWidth;

  static const Color onColor = Color(0xFF1E90FF);
  static const Color autoColor = Color(0xFF14C8F7);
  static const Color offColor = Color(0xFF111827);

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    const double labelRowHeight = 34;
    final double chartHeight = size.height - labelRowHeight;
    const double radius = 2.5;

    // vertical lines full height including label row
    for (int i = 0; i <= 4; i++) {
      final x = size.width * (i / 4);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        grid,
      );
    }

    // horizontal lines only for chart area
    for (int i = 0; i <= 4; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        grid,
      );
    }

    // separator between chart and x-axis label row
    canvas.drawLine(
      Offset(0, chartHeight),
      Offset(size.width, chartHeight),
      grid,
    );

    final bars = <_StackBarDraw>[
      _StackBarDraw(xFactor: 0.18,  on: 0.40, auto: 0.00, off: 0.10),
      _StackBarDraw(xFactor: 0.29, on: 0.40, auto: 0.00, off: 0.10),
      _StackBarDraw(xFactor: 0.335,  on: 0.40, auto: 0.13, off: 0.22),
      _StackBarDraw(xFactor: 0.38, on: 0.26, auto: 0.20, off: 0.17),
      _StackBarDraw(xFactor: 0.425,  on: 0.32, auto: 0.18, off: 0.24),
      _StackBarDraw(xFactor: 0.47, on: 0.35, auto: 0.13, off: 0.14),
    ];

    for (final bar in bars) {
      final double x = (size.width * bar.xFactor) - (barWidth / 2);

      final double onH = chartHeight * bar.on;
      final double autoH = chartHeight * bar.auto;
      final double offH = chartHeight * bar.off;

      double bottom = chartHeight;

      if (bar.on > 0) {
        bottom -= onH;
        canvas.drawRect(
          Rect.fromLTWH(x, bottom, barWidth, onH),
          Paint()..color = onColor,
        );
      }

      if (bar.auto > 0) {
        bottom -= autoH;
        canvas.drawRect(
          Rect.fromLTWH(x, bottom, barWidth, autoH),
          Paint()..color = autoColor,
        );
      }

      if (bar.off > 0) {
        bottom -= offH;
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(x, bottom, barWidth, offH),
            topLeft: const Radius.circular(radius),
            topRight: const Radius.circular(radius),
          ),
          Paint()..color = offColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DailyStackPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor ||
        oldDelegate.barWidth != barWidth;
  }
}


class _StackBarDraw {
  const _StackBarDraw({
    required this.xFactor,
    required this.on,
    required this.auto,
    required this.off,
  });

  final double xFactor;
  final double on;
  final double auto;
  final double off;
}

class _StackBar {
  const _StackBar({
    required this.xFactor,
    required this.on,
    required this.auto,
    required this.off,
  });

  final double xFactor;
  final double on;
  final double auto;
  final double off;
}

class _DeviceUsageCard extends StatelessWidget {
  const _DeviceUsageCard({required this.selectedIndex, required this.onSelect});

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
            color: Colors.black.withOpacity(0.04),
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
                          Image.asset(
                            row.image,
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
                                    backgroundColor: const Color(0xFFE1E1E1),
                                    valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF3B82F6),
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
                          Image.asset(
                            "assets/images/back_arro.png",
                            height: 11.h,
                            width: 11.w,
                            fit: BoxFit.cover,
                            color: const Color(0xFF6B7280),
                          ),
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
