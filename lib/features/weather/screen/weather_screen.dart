import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:workpleis/core/widget/global_back_button.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';

final _weatherScreenProvider = Provider<_WeatherScreenData>((ref) {
  return const _WeatherScreenData(
    location: 'Jerusalem',
    temperature: '24',
    condition: 'Sunny',
    highLow: 'L:24.6°   H:24.6°',
    summary:
        'Sunny conditions will continue for the rest of the day. Wind guest are up to 41 km/h.',
    currentInfo: [
      _CurrentInfo(label: '', value: 'Now'),
      _CurrentInfo(label: '', value: '19'),
      _CurrentInfo(label: '', value: '19:45'),
      _CurrentInfo(label: '', value: '20'),
      _CurrentInfo(label: '', value: '21'),
    ],
    forecast: [
      // _ForecastDay(day: 'Saturday', low: 24, high: 36),
      _ForecastDay(day: 'Sunday', low: 24, high: 36),
      _ForecastDay(day: 'Monday', low: 24, high: 36),
      _ForecastDay(day: 'Tuesday', low: 24, high: 36),
      _ForecastDay(day: 'Wednesday', low: 24, high: 36),
      _ForecastDay(day: 'Thursday', low: 24, high: 36),
      _ForecastDay(day: 'Friday', low: 24, high: 36),
    ],
    metrics: [
      _MetricData(
        title: 'Temperature',
        primary: '24°',
        secondary: 'Similar to the actual  temperature.',
        iconType: _MetricIconType.temperature,
      ),
      _MetricData(
        title: 'UV index',
        primary: '1',
        primary2: 'Low',
        secondary: 'Low for the rest of the day',
        accent: Color(0xFF15DFFE),
        iconType: _MetricIconType.uv,
      ),
      _MetricData(
        title: 'Sunset',
        primary: '19:48',
        secondary: 'Sunrise: 5:35',
        accent: Color(0xFFFFE241),
        iconType: _MetricIconType.sunset,
      ),
      _MetricData(
        title: 'Precipitation',
        primary: '0 mm',
        secondary: 'Today\'s amount 2.6mm',
        accent: Color(0xFF38A4FE),
        iconType: _MetricIconType.precipitation,
      ),
      _MetricData(
        title: 'Wind Map',
        primary: 'Wind',
        secondary: '21 km/h',
        primary2: 'Today H',
        primary3: 'Direction',
        secondery2: "41 km/h",
        secondery3: '306°',
        accent: Color(0xFF000000),
        iconType: _MetricIconType.wind,
      ),
      _MetricData(
        title: 'Pressure',
        primary: 'Low',
        secondary: 'High',
        accent: Color(0xFF15DFFE),
        iconType: _MetricIconType.pressure,
      ),
      _MetricData(
        title: 'Humidity',
        primary: '47%',
        secondary: 'Today\'s average humidity 51%',
        accent: Color(0xFF15DFFE),
        iconType: _MetricIconType.humidity,
      ),
      _MetricData(
        title: 'Air quality',
        primary: '28',
        secondary: 'Maximum air quality',
        accent: Color(0xFFFF6BB1),
        iconType: _MetricIconType.air,
      ),
    ],
    latitude: '48.208579°',
    longitude: '16.374124°',
  );
});

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key, this.showBottomNav = true});

  static const String routeName = '/weather';

  final bool showBottomNav;

  static const Color _skyTop = Color(0xFF75B5FF);
  static const Color _skyBottom = Color(0xFF38A4FE);
  static const Color _panelSoft = Color(0xFF002172);
  static const Color _textPrimary = Color(0xFF002172);
  static const Color _textSecondary = Color(0xFFFFFFFF);
  static const Color _textMuted = Color(0xFFA7CAFE);

  void _onNavItemTapped(BuildContext context, int index) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(_weatherScreenProvider);

    return Scaffold(
      backgroundColor: _skyBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_skyTop, _skyBottom],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(23.w, 6.h, 14.w, 0),
                child: SizedBox(
                  height: 32.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlobalCircleIconBtn(
                          color: const Color(0xFF205BB5),
                          child: Image.asset(
                            'assets/aro.png',
                            width: 16.w,
                            height: 16.h,
                            color: Colors.white,
                          ),
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/menu');
                            }
                          },
                        ),
                      ),
                      Text(
                        'Weather',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF002172),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 172.w,
                              height: 132.h,
                              child: const _WeatherHeroIllustration(),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      weather.location,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                        color: _textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          weather.temperature,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 60.sp,
                                            fontWeight: FontWeight.w300,
                                            color: _textPrimary,
                                            height: 0.95,
                                          ),
                                        ),
                                        // SizedBox(width: 2.w,),
                                        Text(
                                          '°',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 50.sp,
                                            fontWeight: FontWeight.w400,
                                            color: _textPrimary,
                                            height: 0.80,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),

                                    Transform.translate(
                                      offset: Offset(0.w, -10.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            weather.condition,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: _textPrimary,
                                            ),
                                          ),
                                          //SizedBox(height: 10.h),
                                          Text(
                                            weather.highLow,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: _textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _WeatherSummaryCard(
                        summary: weather.summary,
                        items: weather.currentInfo,
                      ),
                      SizedBox(height: 12.h),
                      _OutlookCard(forecast: weather.forecast),
                      SizedBox(height: 12.h),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth - 10.w) / 2;
                          return Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: weather.metrics
                                .map(
                                  (metric) => SizedBox(
                                    width: itemWidth,
                                    child: _MetricCard(metric: metric),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      _LocationMapCard(
                        latitude: weather.latitude,
                        longitude: weather.longitude,
                      ),
                      SizedBox(height: showBottomNav ? 10.h : 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? BottomNavBarWidget(
              selectedIndex: -1,
              onItemTapped: (index) => _onNavItemTapped(context, index),
            )
          : null,
    );
  }
}

class _WeatherSummaryCard extends StatelessWidget {
  const _WeatherSummaryCard({required this.summary, required this.items});

  final String summary;
  final List<_CurrentInfo> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 10.h),
      decoration: BoxDecoration(
        color: WeatherScreen._textPrimary,
        //color: Color(0xFF0088FE),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: WeatherScreen._textSecondary,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: Colors.white),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items
                .asMap()
                .entries
                .map(
                  (entry) => SizedBox(
                    width: 68.w,
                    child: Column(
                      crossAxisAlignment: entry.value.label.isEmpty
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   item.label.isEmpty ? ' ' : item.label,
                        //   style: TextStyle(
                        //     fontFamily: 'Inter',
                        //     fontSize: 16.sp,
                        //     fontWeight: FontWeight.w500,
                        //     color: Colors.white,
                        //     letterSpacing: 0.2,
                        //   ),
                        // ),
                        SizedBox(height: 3.h),
                        Text(
                          entry.value.value,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _MiniSunCloudIcon(index: entry.key),
                        SizedBox(height: 6.h),
                        Text(
                          '22°',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _OutlookCard extends StatefulWidget {
  const _OutlookCard({required this.forecast});

  final List<_ForecastDay> forecast;

  @override
  State<_OutlookCard> createState() => _OutlookCardState();
}

class _OutlookCardState extends State<_OutlookCard> {
  /// 0.0–1.0 fill along the bar; one value per forecast row (drag / tap to change).
  late List<double> _progress;

  @override
  void initState() {
    super.initState();
    _progress = List<double>.filled(widget.forecast.length, 0.72);
  }

  @override
  void didUpdateWidget(covariant _OutlookCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.forecast.length != widget.forecast.length) {
      _progress = List<double>.filled(widget.forecast.length, 0.72);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: WeatherScreen._textPrimary,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(width: 1.w, color: Colors.white),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '7-DAY OUTLOOK',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(height: 1.h, color: Colors.white),
          SizedBox(height: 8.h),
          ...List.generate(widget.forecast.length, (index) {
            final day = widget.forecast[index];
            return Column(
              children: [
                _ForecastRow(
                  day: day,
                  iconIndex: index,
                  progress: _progress[index],
                  onProgressChanged: (v) {
                    setState(() {
                      _progress[index] = v.clamp(0.0, 1.0);
                    });
                  },
                ),
                if (index != widget.forecast.length - 1)
                  Divider(height: 15.h, color: Colors.white),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({
    required this.day,
    required this.iconIndex,
    required this.progress,
    required this.onProgressChanged,
  });

  final _ForecastDay day;
  final int iconIndex;
  final double progress;
  final ValueChanged<double> onProgressChanged;

  static const _gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00), Color(0xFFFF4D6D)],
    stops: [0.0, 0.52, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 95.w,
          child: Text(
            day.day,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        MiniSunCloudIcon(index: iconIndex),
        SizedBox(width: 10.w),
        Text(
          '${day.low}°',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackW = constraints.maxWidth;
              final barH = 4.h;
              final thumbD = 7.w;
              final hitH = math.max(28.h, thumbD);

              void applyDx(double dx) {
                if (trackW <= 0) return;
                onProgressChanged((dx / trackW).clamp(0.0, 1.0));
              }

              final fillW = (progress * trackW).clamp(0.0, trackW).toDouble();
              final thumbLeft = (progress * trackW - thumbD / 2)
                  .clamp(0.0, math.max(0.0, trackW - thumbD))
                  .toDouble();

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => applyDx(d.localPosition.dx),
                onHorizontalDragStart: (d) => applyDx(d.localPosition.dx),
                onHorizontalDragUpdate: (d) => applyDx(d.localPosition.dx),
                child: SizedBox(
                  height: hitH.toDouble(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: trackW,
                          height: barH,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: fillW,
                          height: barH,
                          decoration: BoxDecoration(
                            gradient: _gradient,
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                        ),
                      ),
                      Positioned(
                        left: thumbLeft,
                        top: ((hitH - thumbD) / 2).toDouble(),
                        child: Container(
                          width: thumbD,
                          height: thumbD,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '${day.high}°',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

  double get _cardHeight {
    switch (metric.iconType) {
      case _MetricIconType.pressure:
      
        return 182.h;
      case _MetricIconType.wind:
        // Taller than default: header + large primary + 2-line secondary needs room.
        return 182.h;
      default:
    //case _MetricIconType.uv:
        return 173.h;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      padding: EdgeInsets.fromLTRB(19.w, 15.h, 15.w, 14.h),
      decoration: BoxDecoration(
        color: WeatherScreen._panelSoft,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(width: 1.h, color:Colors.white),  
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MetricLeadingIcon(metric: metric),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  metric.title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: (metric.iconType == _MetricIconType.pressure ||
                    metric.iconType == _MetricIconType.uv)
                ? 8.h
                : 12.h,
          ),

          if (metric.iconType == _MetricIconType.pressure)
            Expanded(
              child: _PressureGauge(
                value: metric.primary,
                label: metric.secondary,
              ),
            )
          else if (metric.iconType == _MetricIconType.uv)
            Expanded(
              child: _UvIndexCard(
                value: metric.primary,
                statusLabel: metric.primary2 ?? '',
                description: metric.secondary,
                accentColor: metric.accent,
              ),
            )
          else if (metric.iconType == _MetricIconType.wind)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        metric.primary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        metric.secondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Divider(height: 1.h, color: Colors.white,),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        metric.primary2!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        metric.secondery2!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Divider(height: 1.h, color: Colors.white,),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        metric.primary3!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        metric.secondery3!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else ...[
              SizedBox(height: 12.h,),
              Text(
              metric.primary,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.0,
              ),
            ),
               SizedBox(height: 12.h,),
            Text(
              metric.secondary,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: WeatherScreen._textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LocationMapCard extends StatelessWidget {
  const _LocationMapCard({required this.latitude, required this.longitude});

  final String latitude;
  final String longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(19.w, 15.h, 15.w, 12.h),
      decoration: BoxDecoration(
        color: WeatherScreen._textPrimary,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(width: 1.w, color: Colors.white)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/location_icon.png",
                height: 25.h,
                width: 25.w,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 6.w),
              Text(
                'Geo location map',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            height: 281.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7FB),
              borderRadius: BorderRadius.circular(26.r),
            ),
            clipBehavior: Clip.antiAlias,

            child: Image.asset(
              "assets/images/google-map.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 281.h,
            ),
            //child: const _StaticMapPainterWidget(),
          ),
          SizedBox(height: 10.h),
          _LatLngRow(label: 'Latitude', value: latitude),
          SizedBox(height: 6.h),
          Divider(height: 1.h, color: Colors.white,),
          SizedBox(height: 6.h),
          _LatLngRow(label: 'Longitude', value: longitude),
        ],
      ),
    );
  }
}

class _LatLngRow extends StatelessWidget {
  const _LatLngRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _MetricLeadingIcon extends StatelessWidget {
  const _MetricLeadingIcon({required this.metric});

  final _MetricData metric;

  static const double _kIcon = 25;

  /// Fixed box + [BoxFit.contain] so wind/pressure (and other) assets are not cropped.
  Widget _asset(String path) {
    return SizedBox(
      width: _kIcon.w,
      height: _kIcon.h,
      child: Center(
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (metric.iconType == _MetricIconType.temperature) {
      return _asset('assets/images/temperature.png');
    }

    if (metric.iconType == _MetricIconType.uv) {
      return _asset('assets/images/uv_index.png');
    }

    if (metric.iconType == _MetricIconType.sunset) {
      return _asset('assets/images/sunset_icon.png');
    }

    if (metric.iconType == _MetricIconType.precipitation) {
      return _asset('assets/images/uv_index.png');
    }

    if (metric.iconType == _MetricIconType.wind) {
      return _asset('assets/images/wind_map.png');
    }

    if (metric.iconType == _MetricIconType.pressure) {
      return _asset('assets/images/pressure_icon.png');
    }

    if (metric.iconType == _MetricIconType.humidity) {
      return _asset('assets/images/humidity_icon.png');
    }

    return _asset('assets/images/air_icon.png');
  }
}

class _PressureGauge extends StatelessWidget {
  const _PressureGauge({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
     
      children: [
        Center(child: Image.asset("assets/images/presure_bigicon.png",
          height: 88.h,
         // width: 170.w,
          fit: BoxFit.cover,)),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              //"Low" ,
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
             //SizedBox(width: 10.w,),
            Text(
            //  "High",
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// UV index body: large value, accent status, gradient scale bar, footer text.
class _UvIndexCard extends StatelessWidget {
  const _UvIndexCard({
    required this.value,
    required this.statusLabel,
    required this.description,
    required this.accentColor,
  });

  final String value;
  final String statusLabel;
  final String description;
  final Color accentColor;

  static const _barGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFAB300),
      Color(0xFFFE019A),
      Color(0xFF00E52A),
      Color(0xFF315051),
    ],
    stops: [0.09, 0.40, 0.60, 0.90],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.05,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          statusLabel,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: accentColor,
            height: 1,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: _barGradient,
          ),
        ),
        SizedBox(height: 6.h),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherHeroIllustration extends StatelessWidget {
  const _WeatherHeroIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: 0.h,
          child: Image.asset(
            "assets/coludy_icon.png",
            height: 136.h,
            width: 176.w,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          left: 90.w,
          top: 40.h,
          child: Image.asset(
            "assets/sun_icon.png",
            height: 126.h,
            width: 130.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _MiniSunCloudIcon extends StatelessWidget {
  const _MiniSunCloudIcon({this.index = 0});

  final int index;

  @override
  Widget build(BuildContext context) {
    final specs = <({String asset, double width, double height})>[
      (asset: 'assets/sun_icon.png', width: 25.w, height: 25.h),
      (asset: 'assets/sun_icon.png', width: 25.w, height: 25.h),
      (asset: 'assets/sun-arrorbar.png', width: 25.w, height: 25.h),
      (asset: 'assets/moon_icon.png', width: 25.w, height: 25.h),
      (asset: 'assets/moon_icon.png', width: 25.w, height: 25.h),
    ];
    final spec = specs[index % specs.length];

    return SizedBox(
      width: 25.w,
      height: 25.h,
      child: Center(
        child: Image.asset(
          spec.asset,
          width: spec.width,
          height: spec.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class MiniSunCloudIcon extends StatelessWidget {
  const MiniSunCloudIcon({this.index = 0});

  final int index;

  @override
  Widget build(BuildContext context) {
    final specs = <({String asset, double width, double height})>[
      (asset: 'assets/sun_icon.png', width: 25.w, height: 25.h),
    ];
    final spec = specs[index % specs.length];

    return SizedBox(
      width: 25.w,
      height: 25.h,
      child: Center(
        child: Image.asset(
          spec.asset,
          width: spec.width,
          height: spec.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _WeatherScreenData {
  const _WeatherScreenData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.highLow,
    required this.summary,
    required this.currentInfo,
    required this.forecast,
    required this.metrics,
    required this.latitude,
    required this.longitude,
  });

  final String location;
  final String temperature;
  final String condition;
  final String highLow;
  final String summary;
  final List<_CurrentInfo> currentInfo;
  final List<_ForecastDay> forecast;
  final List<_MetricData> metrics;
  final String latitude;
  final String longitude;
}

class _CurrentInfo {
  const _CurrentInfo({required this.label, required this.value});

  final String label;
  final String value;
}

class _ForecastDay {
  const _ForecastDay({
    required this.day,
    required this.low,
    required this.high,
  });

  final String day;
  final int low;
  final int high;
}

class _MetricData {
  const _MetricData({    
    required this.title,
    required this.primary,
    required this.secondary,
    required this.iconType,
    this.secondery2,
    this.primary2,
    this.primary3,
    this.secondery3,
    this.accent = const Color(0xFFA7CAFE),
  });

  final String title;
  final String primary;
  final String? primary2;
  final String? primary3;
  final String secondary;
  final String? secondery2;
  final String? secondery3;
  final _MetricIconType iconType;
  final Color accent;
}

enum _MetricIconType {
  temperature,
  uv,
  sunset,
  precipitation,
  wind,
  pressure,
  humidity,
  air,
}