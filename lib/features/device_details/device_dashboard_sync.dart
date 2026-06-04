import 'dart:math' as math;

import 'package:flutter/material.dart';

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

  String get presenceLabel => presenceLabels[
      presenceModeIndex.clamp(0, presenceLabels.length - 1)];

  String get fanStatusLabel {
    if (fanLevel <= 0) return 'Off';
    return 'Speed $fanLevel';
  }

  String get heatingCoolingStatusLabel {
    if (!isOn) return 'Off';
    return heatingCoolingMode == 'cooling' ? 'Cooling' : 'Heating';
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

/// RGBW color preview (matches wheel selection on details screen).
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

  @override
  Widget build(BuildContext context) {
    final Color fill = HSVColor.fromAHSV(
      1.0,
      hue.clamp(0.0, 359.99),
      saturation.clamp(0.0, 1.0),
      intensity.clamp(0.0, 1.0),
    ).toColor();
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        gradient: const SweepGradient(
          colors: <Color>[
            Color(0xFFBEEEDD),
            Color(0xFFF8F3A8),
            Color(0xFFF8C8A0),
            Color(0xFFF6AFC8),
            Color(0xFFD2B6F1),
            Color(0xFF9FBEF2),
            Color(0xFF9EDFE9),
            Color(0xFFBEEEDD),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fill,
            border: Border.all(color: Colors.white, width: 3),
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

  static const LinearGradient _selectedBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF00E5FF), Color(0xFF00FF80)],
  );

  @override
  Widget build(BuildContext context) {
    final int displayed = selectedIndex + 1;
    const double side = 52;

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        gradient: _selectedBorderGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Text(
                '$displayed',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Positioned(
              top: 4,
              right: 2,
              child: Icon(
                Icons.check_circle,
                size: 22,
                color: Color(0xFF22C55E),
              ),
            ),
          ],
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
