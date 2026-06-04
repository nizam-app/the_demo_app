import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared device control values between [DeviceDetailsScreen] and [HomeScreen].
class DeviceControlSnapshot {
  const DeviceControlSnapshot({
    this.isOn = true,
    this.dimmerPercent = 0.72,
    this.thermostatCelsius = 24.6,
    this.blindDownPercent = 0,
    this.blindUpPercent = 72,
    this.ledDimmerPercent = 0.0,
    this.ventilationPercent = 0.0,
    this.rgbwHue = 88,
    this.rgbwSaturation = 0.52,
    this.rgbwIntensity = 0.7,
    this.sceneIndex = 0,
    this.fanLevel = 1,
    this.heatingCoolingMode = 'heating',
    this.tunableWhiteIntensity = 0.7,
    this.presenceModeIndex = 0,
    this.thermostatRingPercent = 0.0,
    this.multiValueSwitchIndex = 0,
  });

  final bool isOn;
  final double dimmerPercent;
  final double thermostatCelsius;
  final int blindDownPercent;
  final int blindUpPercent;
  final double ledDimmerPercent;
  final double ventilationPercent;
  final double rgbwHue;
  final double rgbwSaturation;
  final double rgbwIntensity;
  final int sceneIndex;
  final int fanLevel;
  final String heatingCoolingMode;
  final double tunableWhiteIntensity;
  final int presenceModeIndex;
  final double thermostatRingPercent;
  final int multiValueSwitchIndex;

  static const List<String> sceneLabels = <String>[
    'All On',
    'Night',
    'All Off',
  ];

  static const List<String> presenceLabels = <String>[
    'Comfort',
    'Auto',
    'Eco',
    'Dynamic',
    'Individual',
  ];

  DeviceControlSnapshot copyWith({
    bool? isOn,
    double? dimmerPercent,
    double? thermostatCelsius,
    int? blindDownPercent,
    int? blindUpPercent,
    double? ledDimmerPercent,
    double? ventilationPercent,
    double? rgbwHue,
    double? rgbwSaturation,
    double? rgbwIntensity,
    int? sceneIndex,
    int? fanLevel,
    String? heatingCoolingMode,
    double? tunableWhiteIntensity,
    int? presenceModeIndex,
    double? thermostatRingPercent,
    int? multiValueSwitchIndex,
  }) {
    return DeviceControlSnapshot(
      isOn: isOn ?? this.isOn,
      dimmerPercent: dimmerPercent ?? this.dimmerPercent,
      thermostatCelsius: thermostatCelsius ?? this.thermostatCelsius,
      blindDownPercent: blindDownPercent ?? this.blindDownPercent,
      blindUpPercent: blindUpPercent ?? this.blindUpPercent,
      ledDimmerPercent: ledDimmerPercent ?? this.ledDimmerPercent,
      ventilationPercent: ventilationPercent ?? this.ventilationPercent,
      rgbwHue: rgbwHue ?? this.rgbwHue,
      rgbwSaturation: rgbwSaturation ?? this.rgbwSaturation,
      rgbwIntensity: rgbwIntensity ?? this.rgbwIntensity,
      sceneIndex: sceneIndex ?? this.sceneIndex,
      fanLevel: fanLevel ?? this.fanLevel,
      heatingCoolingMode: heatingCoolingMode ?? this.heatingCoolingMode,
      tunableWhiteIntensity: tunableWhiteIntensity ?? this.tunableWhiteIntensity,
      presenceModeIndex: presenceModeIndex ?? this.presenceModeIndex,
      thermostatRingPercent: thermostatRingPercent ?? this.thermostatRingPercent,
      multiValueSwitchIndex:
          multiValueSwitchIndex ?? this.multiValueSwitchIndex,
    );
  }

  String get sceneLabel =>
      sceneLabels[sceneIndex.clamp(0, sceneLabels.length - 1)];

  /// Hero artwork for light scene (matches [DeviceDetailsScreen] `_heroImageAssetPath`).
  String lightSceneHeroAssetPath({
    String onAssetPath =
        'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
  }) =>
      lightSceneHeroAssetForIndex(sceneIndex, onAssetPath: onAssetPath);

  static String lightSceneHeroAssetForIndex(
    int index, {
    String onAssetPath =
        'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
  }) {
    switch (index.clamp(0, 2)) {
      case 2:
        return 'assets/images/light-scenc_off.png';
      case 1:
        return 'assets/gray_image.png';
      case 0:
      default:
        return onAssetPath;
    }
  }

  String get presenceLabel => presenceLabels[
      presenceModeIndex.clamp(0, presenceLabels.length - 1)];

  static const List<String> presenceModeAssetPaths = <String>[
    'assets/images/comfort.png',
    'assets/images/auto.png',
    'assets/images/Eco.png',
    'assets/images/dynamic.png',
    'assets/images/Individual.png',
  ];

  String get presenceModeAssetPath => presenceModeAssetPaths[
      presenceModeIndex.clamp(0, presenceModeAssetPaths.length - 1)];

  String get fanStatusLabel {
    if (fanLevel <= 0) return 'Off';
    return 'Speed $fanLevel';
  }

  String get heatingCoolingStatusLabel {
    if (!isOn) return 'Off';
    return heatingCoolingMode == 'cooling' ? 'Cooling' : 'Heating';
  }

  static const List<String> multiValueSwitchRowLabels = <String>[
    'On Light',
    'On Irrigation',
    'On Alarm',
  ];

  String get multiValueSwitchCaption => multiValueSwitchRowLabels[
      multiValueSwitchIndex % multiValueSwitchRowLabels.length];

  double get thermostatRingCelsius =>
      19.0 + thermostatRingPercent.clamp(0.0, 1.0) * 16.0;
}

/// Normalized device title → latest control snapshot.
class DeviceDashboardSync extends ChangeNotifier {
  DeviceDashboardSync._();

  static final DeviceDashboardSync instance = DeviceDashboardSync._();

  final Map<String, DeviceControlSnapshot> _snapshots = <String, DeviceControlSnapshot>{};

  static String keyFor(String deviceTitle) =>
      deviceTitle.trim().toLowerCase();

  DeviceControlSnapshot snapshotFor(String deviceTitle) {
    return _snapshots[keyFor(deviceTitle)] ?? const DeviceControlSnapshot();
  }

  void update(String deviceTitle, DeviceControlSnapshot snapshot) {
    _snapshots[keyFor(deviceTitle)] = snapshot;
    notifyListeners();
  }
}

// —— Mini ring icons for dashboard cards (match details-screen rings) ——

const double _dashRingStart = math.pi / 2 + (52 * math.pi / 180) / 2;
const double _dashRingSweep = 2 * math.pi;

void _paintDashGradientRing(
  Canvas canvas,
  Size size, {
  required double percent,
  required double strokeWidth,
  required List<Color> gradientColors,
  List<double>? gradientStops,
}) {
  final Offset center = Offset(size.width / 2, size.height / 2);
  final double midRadius = size.shortestSide / 2 - strokeWidth / 2 - 1;
  final Rect arcRect = Rect.fromCircle(center: center, radius: midRadius);
  const double startAngle = _dashRingStart;
  final double clamped = percent.clamp(0.0, 1.0);
  final double sweepAngle = clamped >= 0.999
      ? _dashRingSweep
      : _dashRingSweep * clamped;

  if (clamped <= 0.001) {
    final Paint emptyTrack = Paint()
      ..color = const Color(0xFFE1E1E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, startAngle, _dashRingSweep, false, emptyTrack);
    return;
  }

  final List<Color> ringColors = <Color>[
    ...gradientColors,
    gradientColors.first,
  ];
  final List<double> stops = gradientStops != null
      ? <double>[...gradientStops, 1.0]
      : List<double>.generate(
          ringColors.length,
          (int i) => i / (ringColors.length - 1),
        );

  final SweepGradient gradient = SweepGradient(
    colors: ringColors,
    stops: stops,
    transform: GradientRotation(startAngle),
    tileMode: TileMode.clamp,
  );

  final Paint shaderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..shader = gradient.createShader(arcRect);

  if (clamped >= 0.999) {
    shaderPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, startAngle, _dashRingSweep, false, shaderPaint);
    return;
  }

  final Paint trackPaint = Paint()
    ..color = const Color(0xFFE1E1E1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.butt;
  canvas.drawArc(arcRect, startAngle, _dashRingSweep, false, trackPaint);

  shaderPaint.strokeCap = StrokeCap.round;
  canvas.drawArc(arcRect, startAngle, sweepAngle, false, shaderPaint);
}

class _DashLedRingPainter extends CustomPainter {
  _DashLedRingPainter({required this.percent});

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    _paintDashGradientRing(
      canvas,
      size,
      percent: percent,
      strokeWidth: 4,
      gradientColors: const <Color>[Color(0xFF00D1FF), Color(0xFF00E52A)],
      gradientStops: const <double>[0.0, 0.8],
    );
  }

  @override
  bool shouldRepaint(covariant _DashLedRingPainter old) =>
      old.percent != percent;
}

class _DashVentilationRingPainter extends CustomPainter {
  _DashVentilationRingPainter({required this.percent});

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    _paintDashGradientRing(
      canvas,
      size,
      percent: percent,
      strokeWidth: 4,
      gradientColors: const <Color>[Color(0xFF3F92F6), Color(0xFF24D7FF)],
      gradientStops: const <double>[0.0, 0.42],
    );
  }

  @override
  bool shouldRepaint(covariant _DashVentilationRingPainter old) =>
      old.percent != percent;
}

/// LED / ventilation progress ring for dashboard lighting cards.
class DashboardRingProgressIcon extends StatelessWidget {
  const DashboardRingProgressIcon({
    super.key,
    required this.percent,
    required this.ringStyle,
  });

  final double percent;
  final DashboardRingStyle ringStyle;

  @override
  Widget build(BuildContext context) {
    final int pct = (percent.clamp(0.0, 1.0) * 100).round();
    final double side = 52;
    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(side),
            painter: ringStyle == DashboardRingStyle.ventilation
                ? _DashVentilationRingPainter(percent: percent)
                : _DashLedRingPainter(percent: percent),
          ),
          Container(
            width: side - 10,
            height: side - 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Text(
              '$pct%',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum DashboardRingStyle { led, ventilation }

/// Rainbow thermostat ring (matches details Living Room hero).
class _DashThermostatRingPainter extends CustomPainter {
  const _DashThermostatRingPainter({required this.percent});

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 4;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double midRadius = size.shortestSide / 2 - strokeWidth / 2 - 1;
    final Rect arcRect = Rect.fromCircle(center: center, radius: midRadius);

    final Paint trackPaint = Paint()
      ..color = const Color(0xFFE1E1E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, 0, _dashRingSweep, false, trackPaint);

    final double clamped = percent.clamp(0.0, 1.0);
    if (clamped <= 0.001) {
      return;
    }

    final double sweepAngle =
        clamped >= 0.999 ? _dashRingSweep : _dashRingSweep * clamped;

    const SweepGradient gradient = SweepGradient(
      colors: <Color>[
        Color(0xFF4A9EFF),
        Color(0xFF9B5DE5),
        Color(0xFFFF007C),
        Color(0xFFFF007C),
        Color(0xFF4A9EFF),
      ],
      stops: <double>[0.0, 0.35, 0.62, 0.88, 1.0],
      transform: GradientRotation(_dashRingStart),
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(arcRect);

    canvas.drawArc(arcRect, _dashRingStart, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _DashThermostatRingPainter old) =>
      old.percent != percent;
}

Offset _dashRingThumbCenter(Size size, double percent, double strokeWidth) {
  final Offset center = Offset(size.width / 2, size.height / 2);
  final double radius = size.shortestSide / 2 - strokeWidth / 2 - 2;
  final double ang = _dashRingStart + _dashRingSweep * percent.clamp(0.0, 1.0);
  return center + Offset(math.cos(ang), math.sin(ang)) * radius;
}

/// Dotted divider inside dashboard thermostat ring (matches details hero).
class _DashThermostatDottedDividerPainter extends CustomPainter {
  const _DashThermostatDottedDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const double dotRadius = 0.8;
    final double cy = size.height / 2;
    double x = dotRadius + 0.5;
    while (x < size.width - dotRadius) {
      canvas.drawCircle(Offset(x, cy), dotRadius, dotPaint);
      x += dotRadius * 2 + 2.5;
    }
  }

  @override
  bool shouldRepaint(covariant _DashThermostatDottedDividerPainter old) =>
      old.color != color;
}

/// Ventilation ring with % + fan (matches details hero centre).
class DashboardVentilationIcon extends StatelessWidget {
  const DashboardVentilationIcon({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final int pct = (percent.clamp(0.0, 1.0) * 100).round();
    final double side = 52.w;
    const double stroke = 4;
    final Size size = Size(side, side);
    final Offset thumb = _dashRingThumbCenter(size, percent, stroke);
    const double thumbD = 7;

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: size,
            painter: _DashVentilationRingPainter(percent: percent),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$pct%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                    height: 1.05,
                  ),
                ),
                Image.asset(
                  'assets/images/fan 2.png',
                  height: 11.w,
                  width: 11.w,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Positioned(
            left: thumb.dx - thumbD / 2,
            top: thumb.dy - thumbD / 2,
            child: Container(
              width: thumbD,
              height: thumbD,
              decoration: BoxDecoration(
                color: const Color(0xFF38A4FE),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Thermostat ring with set-point text (matches details Living Room hero).
class DashboardThermostatRingIcon extends StatelessWidget {
  const DashboardThermostatRingIcon({
    super.key,
    required this.percent,
    this.currentTempCelsius = 24.6,
    this.humidityPercent = 21,
  });

  final double percent;
  final double currentTempCelsius;
  final int humidityPercent;

  @override
  Widget build(BuildContext context) {
    final double setTemp = 19.0 + percent.clamp(0.0, 1.0) * 16.0;
    final int tempInt = setTemp.floor();
    final int tempFrac = ((setTemp - tempInt) * 10).round();
    final double side = 52.w;
    const double stroke = 4;
    final Size size = Size(side, side);
    final Offset thumb = _dashRingThumbCenter(size, percent, stroke);
    const double thumbD = 7;

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: size,
            painter: _DashThermostatRingPainter(percent: percent),
          ),
          SizedBox(
            width: side - 10,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Set Point',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 4.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$tempInt',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        TextSpan(
                          text: '.$tempFrac°',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomPaint(
                    size: Size(22.w, 1.5),
                    painter: const _DashThermostatDottedDividerPainter(
                      color: Color(0xFFD1D5DB),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/low-temperature 1.png',
                        height: 4.5.h,
                        width: 2.5.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 0.5.w),
                      Text(
                        '${currentTempCelsius.toStringAsFixed(1)}°',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 3.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Image.asset(
                        'assets/hot-prsend.png',
                        height: 4.5.h,
                        width: 4.5.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 0.5.w),
                      Text(
                        '$humidityPercent%',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 3.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: thumb.dx - thumbD / 2,
            top: thumb.dy - thumbD / 2,
            child: Container(
              width: thumbD,
              height: thumbD,
              decoration: BoxDecoration(
                color: const Color(0xFFFF007C),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hue spectrum disk + radial fade (same painter as details RGBW wheel).
class _DashRgbHueWheelPainter extends CustomPainter {
  static final List<Color> _hueColors = List<Color>.generate(
    361,
    (int i) => HSVColor.fromAHSV(1, i.toDouble(), 1, 1).toColor(),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.shortestSide / 2;
    final Rect bounds = Rect.fromCircle(center: center, radius: radius);

    final Paint sweep = Paint()
      ..shader = SweepGradient(
        colors: <Color>[..._hueColors.sublist(0, 360), _hueColors[0]],
        stops: <double>[
          ...List<double>.generate(360, (int i) => i / 360),
          1.0,
        ],
        tileMode: TileMode.clamp,
      ).createShader(bounds);
    canvas.drawCircle(center, radius, sweep);

    final Paint radial = Paint()
      ..shader = const RadialGradient(
        colors: <Color>[Colors.white, Color(0x00FFFFFF)],
        stops: <double>[0, 1],
      ).createShader(bounds);
    canvas.drawCircle(center, radius, radial);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// RGBW color wheel preview (matches details hero wheel + hollow selector).
class DashboardRgbwIcon extends StatelessWidget {
  const DashboardRgbwIcon({
    super.key,
    required this.hue,
    required this.saturation,
    required this.intensity,
  });

  final double hue;
  final double saturation;
  final double intensity;

  static const List<Color> _rimColors = <Color>[
    Color(0xFFBEEEDD),
    Color(0xFFF8F3A8),
    Color(0xFFF8C8A0),
    Color(0xFFF6AFC8),
    Color(0xFFD2B6F1),
    Color(0xFF9FBEF2),
    Color(0xFF9EDFE9),
    Color(0xFFBEEEDD),
  ];

  static const List<double> _rimStops = <double>[
    0.00,
    0.16,
    0.30,
    0.48,
    0.64,
    0.79,
    0.92,
    1.00,
  ];

  @override
  Widget build(BuildContext context) {
    final double side = 52.w;
    final Size layoutSize = Size(side, side);
    final Offset center = Offset(side / 2, side / 2);
    final double maxR = layoutSize.shortestSide / 2 - (10 * side / 310);
    final double thumbR = maxR * saturation.clamp(0.0, 1.0);
    final double rad = hue.clamp(0.0, 359.99) * math.pi / 180;
    final Offset thumbPos =
        center + Offset(math.cos(rad) * thumbR, -math.sin(rad) * thumbR);
    final double thumbD = 38 * side / 310;
    final double strokeW = 5 * side / 310;

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: side,
            height: side,
            padding: EdgeInsets.all(6 * side / 310),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                transform: GradientRotation(-math.pi / 2),
                colors: _rimColors,
                stops: _rimStops,
              ),
            ),
            child: ClipOval(
              child: CustomPaint(
                painter: _DashRgbHueWheelPainter(),
              ),
            ),
          ),
          Positioned(
            left: thumbPos.dx - thumbD / 2,
            top: thumbPos.dy - thumbD / 2,
            child: Container(
              width: thumbD,
              height: thumbD,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: strokeW),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Light scene hero image (All On / Night / All Off from details screen).
class DashboardLightSceneIcon extends StatelessWidget {
  const DashboardLightSceneIcon({
    super.key,
    required this.sceneIndex,
    this.onAssetPath =
        'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
  });

  final int sceneIndex;
  final String onAssetPath;

  @override
  Widget build(BuildContext context) {
    final double side = 52.w;
    final int clamped = sceneIndex.clamp(0, 2);
    final String asset = DeviceControlSnapshot.lightSceneHeroAssetForIndex(
      clamped,
      onAssetPath: onAssetPath,
    );

    return Image.asset(
      asset,
      width: side,
      height: side,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        if (clamped == 0) {
          return Image.asset(
            'assets/light_image.png',
            width: side,
            height: side,
            fit: BoxFit.contain,
          );
        }
        return Image.asset(
          onAssetPath,
          width: side,
          height: side,
          fit: BoxFit.contain,
        );
      },
    );
  }
}

/// Heating & cooling hero image (on vs off artwork from details screen).
class DashboardHeatingCoolingIcon extends StatelessWidget {
  const DashboardHeatingCoolingIcon({
    super.key,
    required this.isOn,
  });

  final bool isOn;

  @override
  Widget build(BuildContext context) {
    final String asset = isOn
        ? 'assets/images/heating_cooling.png'
        : 'assets/images/heating&cooling_off.png';
    return Image.asset(
      asset,
      width: 52.w,
      height: 52.w,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/heating_cooling.png',
        width: 52.w,
        height: 52.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Fan hero image on dashboard (off artwork vs on artwork from details screen).
class DashboardFanLevelIcon extends StatelessWidget {
  const DashboardFanLevelIcon({
    super.key,
    required this.level,
    this.onAssetPath = 'assets/images/Fun_level3.png',
  });

  final int level;
  final String onAssetPath;

  @override
  Widget build(BuildContext context) {
    final double side = 52.w;
    final int clamped = level.clamp(0, 3);

    if (clamped == 0) {
      return Image.asset(
        'assets/images/fan_level_off.png',
        width: side,
        height: side,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/fan.png',
          width: side,
          height: side,
          fit: BoxFit.contain,
        ),
      );
    }

    return Image.asset(
      onAssetPath,
      width: side,
      height: side,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/fan.png',
        width: side,
        height: side,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Selected presence mode circle (matches details hero mode tile).
class DashboardPresenceModeIcon extends StatelessWidget {
  const DashboardPresenceModeIcon({
    super.key,
    required this.modeIndex,
  });

  final int modeIndex;

  static const LinearGradient _selectedRingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF15DFFE), Color(0xFFAFFF54)],
  );

  @override
  Widget build(BuildContext context) {
    const double detailsCircle = 86;
    final double side = 52.w;
    final double scale = side / detailsCircle;
    final double ringInset = 3.8 * scale;
    final double innerInset = 10 * scale;
    final String asset = DeviceControlSnapshot.presenceModeAssetPaths[
        modeIndex.clamp(0, DeviceControlSnapshot.presenceModeAssetPaths.length - 1)];

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _selectedRingGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(ringInset),
      child: ClipOval(
        clipBehavior: Clip.antiAlias,
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(innerInset),
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
    );
  }
}

/// Selected value tile for multi-value switch (matches details hero tile).
class DashboardMultiValueSwitchIcon extends StatelessWidget {
  const DashboardMultiValueSwitchIcon({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  static const LinearGradient selectedBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF00E5FF), Color(0xFF00FF80)],
  );

  @override
  Widget build(BuildContext context) {
    final int displayed = selectedIndex + 1;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: selectedBorderGradient,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(3.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: SizedBox(
          height: 48.h,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  '$displayed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 5.w,
                child: Icon(
                  Icons.check_circle,
                  size: 30.sp,
                  color: const Color(0xFF22C55E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Awning / blind level preview (blue fill from bottom).
class DashboardBlindLevelIcon extends StatelessWidget {
  const DashboardBlindLevelIcon({super.key, required this.level});

  /// 0 = open, 1 = fully closed/down.
  final double level;

  @override
  Widget build(BuildContext context) {
    final double p = level.clamp(0.0, 1.0);
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.white),
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: p,
              widthFactor: 1,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFF38A4FE), Color(0xFF2196F3)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
