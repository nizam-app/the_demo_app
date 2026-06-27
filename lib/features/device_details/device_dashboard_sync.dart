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
    this.tunableWhiteDotDx = 0.5,
    this.tunableWhiteDotDy = 0.5,
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
  final double tunableWhiteDotDx;
  final double tunableWhiteDotDy;
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
    double? tunableWhiteDotDx,
    double? tunableWhiteDotDy,
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
      tunableWhiteDotDx: tunableWhiteDotDx ?? this.tunableWhiteDotDx,
      tunableWhiteDotDy: tunableWhiteDotDy ?? this.tunableWhiteDotDy,
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

  String get presenceLabel {
    if (!isOn) return 'Off';
    return presenceLabels[
        presenceModeIndex.clamp(0, presenceLabels.length - 1)];
  }

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

  String get multiValueSwitchCaption {
    if (!isOn) return 'Off';
    return multiValueSwitchRowLabels[
        multiValueSwitchIndex % multiValueSwitchRowLabels.length];
  }

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

/// Bubble Gray — inner circle fill on dashboard ring / switch tiles (active/on).
const Color _dashboardBubbleGray = Color(0xFFF3F4F6);

/// Off-state palette — shared with device details hero tiles (Presence off, etc.).
const Color kDeviceOffGreyFill = Color(0xFFC7CCD8);
const Color kDeviceOffGreyBorder = Color(0xFFC7CCD8);
const Color kDeviceSoftGreyOutline = Color(0xFFE1E1E1);
/// Icon / check tint on off-grey surfaces (darker than [kDeviceOffGreyFill] for contrast).
const Color kDeviceOffGreyIcon = Color(0xFF6B7280);

/// Artwork tint matching fan_level_off.png on dashboard (Fan Level 3 off).
const Color kDashboardFanOffIconColor = kDeviceOffGreyFill;

bool _dashboardIsOffPercent(double value) => value.clamp(0.0, 1.0) <= 0.001;

/// Standard Lighting dashboard icon size (matches [DashboardRgbwIcon] wheel).
double get kDashboardLightingIconSide => 52.w;

/// Fits any dashboard lighting icon into the standard RGB-sized slot.
Widget dashboardLightingIconFrame(Widget child) {
  return SizedBox(
    width: kDashboardLightingIconSide,
    height: kDashboardLightingIconSide,
    child: child,
  );
}

/// Unified dashboard off icon — grey fill, border, optional inner artwork.
Widget _dashboardMutedCircleIcon({
  Widget? child,
  double padding = 10,
}) {
  final double side = kDashboardLightingIconSide;
  return Container(
    width: side,
    height: side,
    decoration: BoxDecoration(
      color: kDeviceOffGreyFill,
      shape: BoxShape.circle,
      border: Border.all(color: kDeviceOffGreyBorder),
    ),
    padding: child == null ? null : EdgeInsets.all(padding.w),
    alignment: Alignment.center,
    child: child,
  );
}

/// Grey placeholder when a dashboard tile is 0% / Off.
class DashboardOffGreyIcon extends StatelessWidget {
  const DashboardOffGreyIcon({super.key, this.circular = false});

  final bool circular;

  @override
  Widget build(BuildContext context) {
    if (circular) {
      return _dashboardMutedCircleIcon();
    }
    final double side = kDashboardLightingIconSide;
    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: kDeviceOffGreyFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: kDeviceOffGreyBorder),
      ),
    );
  }
}

const double _dashRingStart = math.pi / 2 + (52 * math.pi / 180) / 2;
const double _dashRingSweep = 2 * math.pi;

/// Progress ring stroke on dashboard LED / ventilation / thermostat cards.
const double _dashProgressRingStroke = 4;
const double _dashProgressRingInnerInset = 10;

TextStyle _dashboardRingInnerTextStyle({double fontSize = 12}) {
  return TextStyle(
    fontFamily: 'Inter',
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF111827),
    height: 1.0,
  );
}

Widget _dashboardRingInnerLabel(String text, {double fontSize = 12}) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: _dashboardRingInnerTextStyle(fontSize: fontSize),
    ),
  );
}

void _paintDashGradientRing(
  Canvas canvas,
  Size size, {
  required double percent,
  required double strokeWidth,
  required List<Color> gradientColors,
  List<double>? gradientStops,
  Color trackColor = kDeviceOffGreyFill,
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
      ..color = trackColor
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
    ..color = trackColor
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
      strokeWidth: _dashProgressRingStroke,
      gradientColors: const <Color>[Color(0xFF00D1FF), Color(0xFF00E52A)],
      gradientStops: const <double>[0.0, 0.8],
      trackColor: const Color(0xFFC7CCD7),
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
      strokeWidth: _dashProgressRingStroke,
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
    final double clamped = percent.clamp(0.0, 1.0);
    final int pct = (clamped * 100).round();
    final double side = kDashboardLightingIconSide;
    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(side),
            painter: ringStyle == DashboardRingStyle.ventilation
                ? _DashVentilationRingPainter(percent: clamped)
                : _DashLedRingPainter(percent: clamped),
          ),
          Container(
            width: side - _dashProgressRingInnerInset,
            height: side - _dashProgressRingInnerInset,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _dashboardBubbleGray,
            ),
            alignment: Alignment.center,
            child: _dashboardRingInnerLabel('$pct%'),
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
    const double strokeWidth = _dashProgressRingStroke;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double midRadius = size.shortestSide / 2 - strokeWidth / 2 - 1;
    final Rect arcRect = Rect.fromCircle(center: center, radius: midRadius);

    final Paint trackPaint = Paint()
      ..color = kDeviceOffGreyFill
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

/// Ventilation dashboard ring (same layout as LED [DashboardRingProgressIcon]).
class DashboardVentilationIcon extends StatelessWidget {
  const DashboardVentilationIcon({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return DashboardRingProgressIcon(
      percent: percent,
      ringStyle: DashboardRingStyle.ventilation,
    );
  }
}

/// Living room thermostat ring (same layout as LED [DashboardRingProgressIcon]).
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
    final double side = kDashboardLightingIconSide;

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(side),
            painter: _DashThermostatRingPainter(percent: percent),
          ),
          Container(
            width: side - _dashProgressRingInnerInset,
            height: side - _dashProgressRingInnerInset,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _dashboardBubbleGray,
            ),
            alignment: Alignment.center,
            child: _dashboardRingInnerLabel(
              '$tempInt.$tempFrac°',
              fontSize: 11,
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

/// Tunable white color-temperature disk (matches details hero + grey selector ring).
class DashboardTunableWhiteIcon extends StatelessWidget {
  const DashboardTunableWhiteIcon({
    super.key,
    required this.dotDx,
    required this.dotDy,
    this.intensity = 1.0,
  });

  final double dotDx;
  final double dotDy;
  final double intensity;

  static const List<Color> _diskColors = <Color>[
    Color(0xFFFEE481),
    Color(0xFFFFFFFF),
    Color(0xFF93E1E3),
  ];

  static const List<double> _diskStopsOuter = <double>[0.0, 0.55, 1.0];
  static const List<double> _diskStopsInner = <double>[0.0, 0.48, 1.0];

  @override
  Widget build(BuildContext context) {
    if (_dashboardIsOffPercent(intensity)) {
      final double side = kDashboardLightingIconSide;
      return Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          color: kDeviceOffGreyFill,
          shape: BoxShape.circle,
          border: Border.all(color: kDeviceSoftGreyOutline),
        ),
      );
    }

    final double side = kDashboardLightingIconSide;
    const double heroDisk = 280;
    final double scale = side / heroDisk;
    final double dialBorderWidth = 6 * scale;
    final double ringSize = 40 * scale;
    final double ringBorder = 2 * scale;
    final double x = dotDx.clamp(0.0, 1.0) * side;
    final double y = dotDy.clamp(0.0, 1.0) * side;

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: side,
            height: side,
            padding: EdgeInsets.all(dialBorderWidth),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _diskColors,
                stops: _diskStopsOuter,
              ),
            ),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _diskColors,
                        stops: _diskStopsInner,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.06),
                        ],
                        stops: const <double>[0.65, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: x - ringSize / 2,
            top: y - ringSize / 2,
            child: Container(
              width: ringSize,
              height: ringSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: kDeviceOffGreyBorder,
                  width: ringBorder,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
    if (_dashboardIsOffPercent(intensity)) {
      final double side = kDashboardLightingIconSide;
      return Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          color: kDeviceOffGreyFill,
          shape: BoxShape.circle,
          border: Border.all(color: kDeviceSoftGreyOutline),
        ),
      );
    }

    final double side = kDashboardLightingIconSide;
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
    final double side = kDashboardLightingIconSide;
    final int clamped = sceneIndex.clamp(0, 2);
    final String asset = DeviceControlSnapshot.lightSceneHeroAssetForIndex(
      clamped,
      onAssetPath: onAssetPath,
    );

    if (clamped == 2) {
      return Image.asset(
        asset,
        width: side,
        height: side,
        fit: BoxFit.contain,
        color: const Color(0xFFC7CCD7),
        colorBlendMode: BlendMode.srcIn,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/light-scenc_off.png',
          width: side,
          height: side,
          fit: BoxFit.contain,
          color: const Color(0xFFC7CCD7),
          colorBlendMode: BlendMode.srcIn,
        ),
      );
    }

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
      width: kDashboardLightingIconSide,
      height: kDashboardLightingIconSide,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/heating_cooling.png',
        width: kDashboardLightingIconSide,
        height: kDashboardLightingIconSide,
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
    final double side = kDashboardLightingIconSide;
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
    this.isOn = true,
  });

  final int modeIndex;
  final bool isOn;

  static const LinearGradient _selectedRingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF15DFFE), Color(0xFFAFFF54)],
  );

  @override
  Widget build(BuildContext context) {
    const double detailsCircle = 86;
    final double side = kDashboardLightingIconSide;
    final double scale = side / detailsCircle;
    final double ringInset = 3.8 * scale;
    final double innerInset = 10 * scale;
    final String asset = DeviceControlSnapshot.presenceModeAssetPaths[
        modeIndex.clamp(0, DeviceControlSnapshot.presenceModeAssetPaths.length - 1)];

    final Widget baseImage = Image.asset(
      asset,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
    final Widget modeImage = isOn
        ? baseImage
        : ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color(0xFFC7CAD6),
              BlendMode.srcIn,
            ),
            child: baseImage,
          );

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isOn ? _selectedRingGradient : null,
        border: isOn
            ? null
            : Border.all(
                color: kDeviceOffGreyFill,
                width: 1.5 * scale,
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isOn ? 0.10 : 0.05),
            blurRadius: isOn ? 10 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: isOn ? EdgeInsets.all(ringInset) : EdgeInsets.zero,
      child: ClipOval(
        clipBehavior: Clip.antiAlias,
        child: ColoredBox(
          color: _dashboardBubbleGray,
          child: Padding(
            padding: EdgeInsets.all(innerInset),
            child: modeImage,
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
    this.isOn = true,
  });

  final int selectedIndex;
  final bool isOn;

  static const LinearGradient selectedBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF00E5FF), Color(0xFF00FF80)],
  );
  static const Color selectedFillColor = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    final int displayed = selectedIndex + 1;
    const Color textColor = Color(0xFF111827);
    final Color checkColor =
        isOn ? const Color(0xFF22C55E) : kDeviceOffGreyIcon;
    final double side = kDashboardLightingIconSide;
    final double tileW = side * 46 / 52;
    final double tileH = side * 26 / 52;

    final Widget tile = DecoratedBox(
      decoration: BoxDecoration(
        color: selectedFillColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: SizedBox(
        height: tileH,
        width: tileW,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Text(
                '$displayed',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
            Positioned(
              top: 3.5.h,
              right: 2.5.w,
              child: Icon(
                Icons.check_circle,
                size: 16.sp,
                color: checkColor,
              ),
            ),
          ],
        ),
      ),
    );

    return SizedBox(
      width: side,
      height: side,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: isOn ? selectedBorderGradient : null,
            border: isOn
                ? null
                : Border.all(
                    color: const Color(0xFFE1E1E1),
                    width: 1.5,
                  ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isOn ? 0.08 : 0.05),
                blurRadius: isOn ? 10 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(2.5.w),
          child: tile,
        ),
      ),
    );
  }
}

/// Awning level preview (blue gradient fill from top — matches details hero).
class DashboardAwningLevelIcon extends StatelessWidget {
  const DashboardAwningLevelIcon({
    super.key,
    required this.level,
    this.softInterior = false,
  });

  /// 0 = empty (0%), 1 = full (100%).
  final double level;
  final bool softInterior;

  static const LinearGradient _awningGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF38A4FE), Color(0xFF15DFFE)],
  );

  @override
  Widget build(BuildContext context) {
    final double p = level.clamp(0.0, 1.0);
    final double side = kDashboardLightingIconSide;
    final double radius = 12.r;
    final Color interiorColor =
        softInterior ? _dashboardBubbleGray : kDeviceOffGreyFill;

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: interiorColor),
              if (!_dashboardIsOffPercent(p))
                Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    heightFactor: p,
                    widthFactor: 1,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(gradient: _awningGradient),
                    ),
                  ),
                ),
            ],
          ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: kDeviceOffGreyBorder,
                  width: softInterior ? 2.w : 1.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Venetian slats preview (matches details [_BlindSlatsPainter]).
class DashboardBlindSlatsPainter extends CustomPainter {
  const DashboardBlindSlatsPainter({
    required this.level,
    required this.angle,
    this.cornerRadius = 0,
  });

  final double level;
  final double angle;
  final double cornerRadius;

  static const int _slatCount = 11;
  static const Color _slatColor = Color(0xFF38A4FE);
  static const Color _slatShadow = Color(0xFF2196F3);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect clipRrect = RRect.fromRectAndRadius(
      bounds,
      Radius.circular(
        cornerRadius.clamp(0.0, math.min(size.width, size.height) / 2),
      ),
    );

    canvas.drawRRect(clipRrect, Paint()..color = kDeviceOffGreyFill);

    canvas.save();
    canvas.clipRRect(clipRrect);

    final double cx = size.width / 2;
    final double usableW = size.width;
    final double bandH = size.height / _slatCount;
    const double gap = 0.5;
    final double maxSlatInBand = math.max(2.0, bandH - gap);
    final double a = angle.clamp(0.0, 1.0);
    // Thicker slats at low angle; full band height when open — avoids side/vertical gaps.
    final double slatH = maxSlatInBand * (0.72 + 0.28 * a);
    final double topW = usableW;
    final double taperT = (0.94 + 0.06 * a).clamp(0.94, 1.0);
    final double botW = topW * taperT;
    final int visible = (_slatCount * level.clamp(0.0, 1.0)).round().clamp(
      0,
      _slatCount,
    );

    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint edgeTop = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.40)
      ..strokeCap = StrokeCap.round;

    final Paint edgeBot = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = _slatShadow.withValues(alpha: 0.46)
      ..strokeCap = StrokeCap.round;

    final Paint divider = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = Colors.white.withValues(alpha: 0.28);

    for (int i = 0; i < visible; i++) {
      final double bandTop = i * bandH;
      final double top = bandTop + (bandH - slatH) / 2;
      final double bot = top + slatH;

      final Path slat = Path()
        ..moveTo(cx - topW / 2, top)
        ..lineTo(cx + topW / 2, top)
        ..lineTo(cx + botW / 2, bot)
        ..lineTo(cx - botW / 2, bot)
        ..close();

      fill.color = _slatColor;
      canvas.drawPath(slat, fill);

      canvas.drawLine(
        Offset(cx - topW / 2, top),
        Offset(cx + topW / 2, top),
        edgeTop,
      );

      canvas.drawLine(
        Offset(cx - botW / 2, bot),
        Offset(cx + botW / 2, bot),
        edgeBot,
      );

      if (i < visible - 1) {
        canvas.drawLine(
          Offset(cx - botW / 2, bot + gap / 2),
          Offset(cx + botW / 2, bot + gap / 2),
          divider,
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DashboardBlindSlatsPainter old) =>
      old.level != level ||
      old.angle != angle ||
      old.cornerRadius != cornerRadius;
}

/// Blind Living Room slat stack (level + angle — matches details hero).
class DashboardBlindSlatsIcon extends StatelessWidget {
  const DashboardBlindSlatsIcon({
    super.key,
    required this.level,
    required this.angle,
  });

  final double level;
  final double angle;

  @override
  Widget build(BuildContext context) {
    final double side = kDashboardLightingIconSide;
    final double pad = 3.w;
    final double outerR = 12.r;
    final double innerR = math.max(0.0, outerR - pad);

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: kDeviceOffGreyFill,
        borderRadius: BorderRadius.circular(outerR),
        border: Border.all(color: kDeviceOffGreyBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(outerR),
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerR),
            child: CustomPaint(
              painter: DashboardBlindSlatsPainter(
                level: level.clamp(0.0, 1.0),
                angle: angle.clamp(0.0, 1.0),
                cornerRadius: innerR,
              ),
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}
