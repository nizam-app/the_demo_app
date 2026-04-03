import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
      _ForecastDay(day: 'Saturday', low: 24, high: 36),
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
        secondary: 'Similar to the actual temperature.',
        iconType: _MetricIconType.temperature,
      ),
      _MetricData(
        title: 'UV index',
        primary: '1',
        secondary: 'Low for the first part of the day',
        accent: Color(0xFF15DFFE),
        iconType: _MetricIconType.uv,
      ),
      _MetricData(
        title: 'Sunset',
        primary: '19:48',
        secondary: 'Sunrise 5:55',
        accent: Color(0xFFFFE241),
        iconType: _MetricIconType.sunset,
      ),
      _MetricData(
        title: 'Precipitation',
        primary: '0 mm',
        secondary: 'Today\'s amount 2.4 mm',
        accent: Color(0xFF38A4FE),
        iconType: _MetricIconType.precipitation,
      ),
      _MetricData(
        title: 'Wind Map',
        primary: 'Wind',
        secondary: 'Today H  41 km/h\nDirection  335°',
        accent: Color(0xFFA7CAFE),
        iconType: _MetricIconType.wind,
      ),
      _MetricData(
        title: 'Pressure',
        primary: '1007',
        secondary: 'Light',
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
    latitude: '45° 26\' 43.34" N',
    longitude: '75° 44\' 44.14" W',
  );
});

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key, this.showBottomNav = true});

  static const String routeName = '/weather';

  final bool showBottomNav;

  static const Color _skyTop = Color(0xFF75B5FF);
  static const Color _skyBottom = Color(0xFF38A4FE);
  static const Color _panelSoft = Color(0xFF274998);
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
                  height: 40.h,
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                     SizedBox(height: 10.h,),
                                   
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
        borderRadius: BorderRadius.circular(26.r),
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
          Divider(height: 1.h, color: Colors.white,),
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
                        color:Colors.white,
                          letterSpacing: 0.2
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

class _OutlookCard extends StatelessWidget {
  const _OutlookCard({required this.forecast});

  final List<_ForecastDay> forecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: WeatherScreen._textPrimary,
        borderRadius: BorderRadius.circular(26.r),
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
          Divider(height: 1.h, color: Colors.white,),  
          SizedBox(height: 8.h), 
          
          ...List.generate(forecast.length, (index) {
            final day = forecast[index];
            return Column(
              children: [
                _ForecastRow(day: day, iconIndex: index),
                if (index != forecast.length - 1)
                  Divider(
                    height: 15.h,
                    //thickness: 1,
                    color: Colors.white,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.day, required this.iconIndex});

  final _ForecastDay day;
  final int iconIndex;

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
       // SizedBox(width: 10.w),
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
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.72,
                child: Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFEDB6A), Color(0xFFFF7A45)],
                    ),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.62, 0),
                child: Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9CE4FF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: metric.iconType == _MetricIconType.pressure ? 154.h : 132.h,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: WeatherScreen._panelSoft,
        borderRadius: BorderRadius.circular(24.r),
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: metric.iconType == _MetricIconType.pressure ? 8.h : 12.h,
          ),
          if (metric.iconType == _MetricIconType.pressure)
            Expanded(
              child: Center(
                child: _PressureGauge(
                  value: metric.primary,
                  label: metric.secondary,
                ),
              ),
            )
          else if (metric.iconType == _MetricIconType.wind)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.primary,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    metric.secondary,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: WeatherScreen._textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            )
          else ...[
              Text(
                metric.primary,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 31.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const Spacer(),
              Text(
                metric.secondary,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
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
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: WeatherScreen._textPrimary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 17.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Geo location map',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            height: 176.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7FB),
              borderRadius: BorderRadius.circular(18.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: const _StaticMapPainterWidget(),
          ),
          SizedBox(height: 10.h),
          _LatLngRow(label: 'Latitude', value: latitude),
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
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: WeatherScreen._textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
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

  @override
  Widget build(BuildContext context) {
    if (metric.iconType == _MetricIconType.temperature) {
      return const _ThermometerGlyph();
    }

    if (metric.iconType == _MetricIconType.uv) {
      return const Icon(Icons.sunny, color: Color(0xFFFFE241), size: 18);
    }

    if (metric.iconType == _MetricIconType.sunset) {
      return const Icon(Icons.wb_twilight, color: Color(0xFFFFE241), size: 18);
    }

    if (metric.iconType == _MetricIconType.precipitation) {
      return const Icon(Icons.grain, color: Color(0xFF7DD3FC), size: 18);
    }

    if (metric.iconType == _MetricIconType.wind) {
      return const Icon(Icons.air, color: Color(0xFFA7CAFE), size: 18);
    }

    if (metric.iconType == _MetricIconType.pressure) {
      return const Icon(Icons.speed, color: Color(0xFFA7CAFE), size: 18);
    }

    if (metric.iconType == _MetricIconType.humidity) {
      return const Icon(
        Icons.water_drop_outlined,
        color: Color(0xFF7DD3FC),
        size: 18,
      );
    }

    return const Icon(Icons.blur_on, color: Color(0xFFFF7AB5), size: 18);
  }
}

class _ThermometerGlyph extends StatelessWidget {
  const _ThermometerGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.w,
      height: 18.h,
      child: CustomPaint(painter: _ThermometerPainter()),
    );
  }
}

class _PressureGauge extends StatelessWidget {
  const _PressureGauge({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 88.w,
          height: 58.h,
          child: CustomPaint(painter: _GaugePainter()),
        ),
        Transform.translate(
          offset: Offset(0, -6.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, -5.h),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: WeatherScreen._textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StaticMapPainterWidget extends StatelessWidget {
  const _StaticMapPainterWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _MapPainter())),
        Positioned(
          left: 18.w,
          top: 24.h,
          child: Text(
            'Jerusalem',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF002172),
            ),
          ),
        ),
        Positioned(
          right: 44.w,
          bottom: 38.h,
          child: Column(
            children: [
              Container(
                width: 14.w,
                height: 14.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 3.w,
                height: 18.h,
                color: const Color(0xFFEF4444),
              ),
            ],
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
          child: Image.asset("assets/coludy_icon.png", height: 136.h, width: 176.w,fit: BoxFit.cover,),
        ),
     
        Positioned(
          left: 90.w,
          top: 40.h,
            child: Image.asset("assets/sun_icon.png", height: 126.h, width: 130.w,fit: BoxFit.contain,),
        ),
        
      ],
    );
  }
}

class _CloudLayer extends StatelessWidget {
  const _CloudLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 6.w,
          top: 16.h,
          child: Container(
            width: 42.w,
            height: 42.w,
            decoration: const BoxDecoration(
              color: Color(0xFFD9E9FF),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 28.w,
          top: 4.h,
          child: Container(
            width: 52.w,
            height: 52.w,
            decoration: const BoxDecoration(
              color: Color(0xFFD9E9FF),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 60.w,
          top: 16.h,
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(
              color: Color(0xFFD9E9FF),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 12.w,
          top: 26.h,
          child: Container(
            width: 90.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: const Color(0xFFD9E9FF),
              borderRadius: BorderRadius.circular(18.r),
            ),
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
    this.accent = const Color(0xFFA7CAFE),
  });

  final String title;
  final String primary;
  final String secondary;
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

class _ThermometerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = const Color(0xFFA7CAFE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    final fillPaint = Paint()..color = const Color(0xFF7DD3FC);

    final stemRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.42,
        size.height * 0.12,
        size.width * 0.16,
        size.height * 0.56,
      ),
      Radius.circular(6.r),
    );
    canvas.drawRRect(stemRect, stemPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.445,
          size.height * 0.36,
          size.width * 0.11,
          size.height * 0.29,
        ),
        Radius.circular(6.r),
      ),
      fillPaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.8),
      size.width * 0.2,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = math.min(size.width / 2, size.height) - 4;

    final trackPaint = Paint()
      ..color = const Color(0xFF95BFFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7;
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0088FE), Color(0xFF15DFFE)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      trackPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * 0.72,
      false,
      progressPaint,
    );

    final angle = math.pi * 1.72;
    final needleStart = Offset(
      center.dx + math.cos(angle) * 10,
      center.dy + math.sin(angle) * 10,
    );
    final needleEnd = Offset(
      center.dx + math.cos(angle) * (radius - 8),
      center.dy + math.sin(angle) * (radius - 8),
    );

    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(needleStart, needleEnd, needlePaint);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF3F4F6);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final roadPaint = Paint()
      ..color = const Color(0xFFD9DCE4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final mainRoadPaint = Paint()
      ..color = const Color(0xFFF5C977)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final waterPaint = Paint()..color = const Color(0xFFCDE7FF);
    final parkPaint = Paint()..color = const Color(0xFFDDF4D7);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.62,
          size.height * 0.08,
          size.width * 0.22,
          size.height * 0.18,
        ),
        const Radius.circular(24),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.58,
          size.width * 0.28,
          size.height * 0.2,
        ),
        const Radius.circular(24),
      ),
      waterPaint,
    );

    final path1 = Path()
      ..moveTo(0, size.height * 0.36)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.22,
        size.width * 0.42,
        size.height * 0.35,
      )
      ..quadraticBezierTo(
        size.width * 0.68,
        size.height * 0.5,
        size.width,
        size.height * 0.32,
      );
    canvas.drawPath(path1, mainRoadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.16, 0)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.24,
        size.width * 0.3,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.72,
        size.width * 0.54,
        size.height,
      );
    canvas.drawPath(path2, roadPaint);

    final path3 = Path()
      ..moveTo(size.width * 0.48, 0)
      ..quadraticBezierTo(
        size.width * 0.56,
        size.height * 0.26,
        size.width * 0.66,
        size.height * 0.44,
      )
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.66,
        size.width * 0.92,
        size.height,
      );
    canvas.drawPath(path3, roadPaint);

    final routePaint = Paint()
      ..color = const Color(0xFF4F8FFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final route = Path()
      ..moveTo(size.width * 0.18, size.height * 0.74)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.62,
        size.width * 0.42,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.57,
        size.height * 0.46,
        size.width * 0.68,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.52,
        size.width * 0.86,
        size.height * 0.7,
      );
    canvas.drawPath(route, routePaint);

    final markerPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.7),
      6,
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFF2A6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}