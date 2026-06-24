import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/utils/ui_tap_haptic.dart';
import 'package:workpleis/features/device_details/device_dashboard_sync.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/devices/screen/devices_screen.dart';
import 'package:workpleis/features/nav_bar/screen/custom_bottom_nav_bar.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/settings/screen/settings_screen.dart';

import '../../../core/widget/global_back_button.dart';

/// Closed 360° ring for thermostat, LED dimmer, and ventilation.
const double _fullRingStart = math.pi / 2 + (52 * math.pi / 180) / 2;
const double _fullRingSweep = 2 * math.pi;

/// Snap ring value to nearest 1 % step.
double _snapRingPercentOneStep(double value) =>
    (value.clamp(0.0, 1.0) * 100).round() / 100.0;

/// LED dimmer / ventilation: grey inactive arc + gradient progress on a closed ring.
/// Inactive segment uses butt caps so the progress start can get a clean solid cap
/// (avoids the soft gradient cut where the full grey track used to sit underneath).
void _paintGradientFullRing(
  Canvas canvas,
  Size size, {
  required double percent,
  required double strokeWidth,
  required List<Color> gradientColors,
  List<double>? gradientStops,
  Color trackColor = kDeviceOffGreyFill,
}) {
  final Offset center = Offset(size.width / 2, size.height / 2);
  final double midRadius = size.shortestSide / 2 - strokeWidth / 2 - 2;
  final Rect arcRect = Rect.fromCircle(center: center, radius: midRadius);
  const double startAngle = _fullRingStart;

  final double clamped = percent.clamp(0.0, 1.0);
  final double sweepAngle = clamped >= 0.999
      ? _fullRingSweep
      : _fullRingSweep * clamped;

  if (clamped <= 0.001) {
    final Paint emptyTrack = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, startAngle, _fullRingSweep, false, emptyTrack);
    return;
  }

  // Close the sweep so 360° rings do not show a hard color seam.
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
    canvas.drawArc(arcRect, startAngle, _fullRingSweep, false, shaderPaint);
    return;
  }

  final double inactiveSweep = _fullRingSweep - sweepAngle;

  // When almost full, skip the tiny grey gap that caused a visible seam.
  if (inactiveSweep <= 0.015) {
    shaderPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, startAngle, _fullRingSweep, false, shaderPaint);
    return;
  }

  final Paint inactivePaint = Paint()
    ..color = trackColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.butt;

  canvas.drawArc(
    arcRect,
    startAngle + sweepAngle,
    inactiveSweep,
    false,
    inactivePaint,
  );

  shaderPaint.strokeCap = StrokeCap.butt;
  canvas.drawArc(arcRect, startAngle, sweepAngle, false, shaderPaint);

  final Color startColor = gradientColors.first;
  final Offset arcStart = Offset(
    center.dx + midRadius * math.cos(startAngle),
    center.dy + midRadius * math.sin(startAngle),
  );
  canvas.drawCircle(
    arcStart,
    strokeWidth / 2,
    Paint()
      ..color = startColor
      ..isAntiAlias = true,
  );
}

/// Maps a pan position on a full ring to [0, 1] with 1 % steps.
double _fullRingPercentFromLocal(Offset local, Size size, double prevPercent) {
  final Offset c = Offset(size.width / 2, size.height / 2);
  final Offset d = local - c;
  final double angle = math.atan2(d.dy, d.dx);
  double t = (angle - _fullRingStart) / _fullRingSweep;
  if (t < 0) {
    t += 1;
  }
  double next = _snapRingPercentOneStep(t);

  final double prev = prevPercent.clamp(0.0, 1.0);
  if (prev > 0.85 && next < 0.15) {
    next = 1.0;
  }
  if (prev < 0.15 && next > 0.85) {
    next = 0.0;
  }
  return _snapRingPercentOneStep(next);
}

/// Flat circular press halo (matches blind angle slider overlay, no shadow).
const Color _controlPressHaloColor = Color(0x220088FE);

/// Hollow selector ring (RGBW wheel / tunable-white disk).
Widget _hollowRingSelectorThumb({
  required bool pressed,
  required double diameter,
  required double strokeWidth,
  Color idleStrokeColor = const Color(0xFF6488EA),
  required Color pressGlowColor,
  double pressHaloPadding = 14,
}) {
  final double outer = diameter + pressHaloPadding * 2;
  return SizedBox(
    width: outer,
    height: outer,
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (pressed)
          Container(
            width: outer,
            height: outer,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _controlPressHaloColor,
            ),
          ),
        Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: pressed ? pressGlowColor : idleStrokeColor,
              width: strokeWidth,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Ring / dial thumb with flat press halo only (no drop shadow).
Widget _ringControlThumb({
  required Widget thumb,
  required bool pressed,
  required double thumbDiameter,
  Color? haloColor,
  double haloPadding = 14,
}) {
  final Color halo = haloColor ?? _controlPressHaloColor;
  final double outer = thumbDiameter + haloPadding * 2;
  return SizedBox(
    width: outer,
    height: outer,
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (pressed)
          Container(
            width: outer,
            height: outer,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: halo,
            ),
          ),
        SizedBox(
          width: thumbDiameter,
          height: thumbDiameter,
          child: thumb,
        ),
      ],
    ),
  );
}

/// Controls which primary region appears below the hero (stats stay the same).
enum
DeviceDetailsControlMode {
  /// Hero + stats + Off/On row + instruction (Motion Sensor omits Off/On).
  standard,

  /// Light scene: main title + "Values" + All On / Night / All Off (no power row, no tune row).
  lightSceneValues,

  /// RGBW fixture: hue/saturation wheel + intensity slider (no Off/On tune row).
  rgbwPicker,

  /// LED dimmer: circular gradient ring + centered % (no Off/On tune row).
  ledDimmer,
 

  /// Tunable white: temperature disk + intensity slider (no Off/On tune row).
  tunableWhite,

  /// Heating & Cooling: device image hero + dropdown chevron + Heating/Cooling
  /// pill toggle (no Off/On tune row).
  heatingCooling,

  /// Fan: device image hero + Off / Speed 1 / Speed 2 / Speed 3 selector row
  /// (no Off/On tune row).
  fanLevel,

  /// Ventilation: cyan→blue gradient ring + centered % + fan icon (no Off/On row).
  ventilation,

  /// Blind/shutter: venetian-slat visualisation + level % + angle % + slider.
  blindControl,

  /// Awning/roller-blind: image clipped by level % + up/down handle (no slats, no angle).
  awningControl,

  /// Thermostat set-point: open ring (grey track + blue→pink progress by %),
  /// draggable thumb, "Set Point XX.X°" in centre, current temp & humidity below.
  thermostatRing,

  /// Presence: Comfort / Auto / Eco / Dynamic / Individual circular modes.
  presenceModes,

  /// Multi-value switch: 12-position grid (3×4) with On Light / Irrigation / Alarm labels.
  multiValueSwitch,
}

/// Carried on [GoRouterState.extra] so [DeviceDetailsControlMode] cannot be lost
/// while navigating (query-only payloads were unreliable in this app shell).
class DeviceDetailsRouteArgs {
  const DeviceDetailsRouteArgs({
    required this.deviceTitle,
    required this.imageAssetPath,
    this.controlButtonCount = 3,
    this.controlMode = DeviceDetailsControlMode.standard,
  });

  final String deviceTitle;
  final String imageAssetPath;
  final int controlButtonCount;
  final DeviceDetailsControlMode controlMode;
}

/// Full-screen device UI (formerly Light Dining Room). Only [deviceTitle],
/// [imageAssetPath], and [controlButtonCount] vary per device; the rest of the
/// layout is shared.
class DeviceDetailsScreen extends StatefulWidget {
  const DeviceDetailsScreen({
    super.key,
    required this.deviceTitle,
    required this.imageAssetPath,
    this.controlButtonCount = 3,
    this.controlMode = DeviceDetailsControlMode.standard,
  });

  final String deviceTitle;
  final String imageAssetPath;

  /// Kept for route/navigation compatibility; tune buttons are no longer shown.
  final int controlButtonCount;

  /// Switches between standard hero + Off/On vs light-scene "Values", RGBW picker, or LED dimmer ring.
  final DeviceDetailsControlMode controlMode;

  static const String routeName = '/device-details';

  /// Builds a location string for [GoRouter] with query parameters.
  static String routeUri({
    required String title,
    required String imageAssetPath,
    int controlButtonCount = 3,
    DeviceDetailsControlMode controlMode = DeviceDetailsControlMode.standard,
  }) {
    final n = controlButtonCount.clamp(1, 8);
    final Map<String, String> query = <String, String>{
      'title': title,
      'image': imageAssetPath,
      'buttons': '$n',
    };
    if (controlMode == DeviceDetailsControlMode.lightSceneValues) {
      query['mode'] = 'lightSceneValues';
    } else if (controlMode == DeviceDetailsControlMode.rgbwPicker) {
      query['mode'] = 'rgbw';
    } else if (controlMode == DeviceDetailsControlMode.ledDimmer) {
      query['mode'] = 'ledDimmer';
    } else if (controlMode == DeviceDetailsControlMode.tunableWhite) {
      query['mode'] = 'tunableWhite';
    } else if (controlMode == DeviceDetailsControlMode.heatingCooling) {
      query['mode'] = 'heatingCooling';
    } else if (controlMode == DeviceDetailsControlMode.fanLevel) {
      query['mode'] = 'fanLevel';
    } else if (controlMode == DeviceDetailsControlMode.ventilation) {
      query['mode'] = 'ventilation';
    } else if (controlMode == DeviceDetailsControlMode.blindControl) {
      query['mode'] = 'blindControl';
    } else if (controlMode == DeviceDetailsControlMode.awningControl) {
      query['mode'] = 'awningControl';
    } else if (controlMode == DeviceDetailsControlMode.thermostatRing) {
      query['mode'] = 'thermostatRing';
    } else if (controlMode == DeviceDetailsControlMode.presenceModes) {
      query['mode'] = 'presenceModes';
    } else if (controlMode == DeviceDetailsControlMode.multiValueSwitch) {
      query['mode'] = 'multiValueSwitch';
    }
    return Uri(path: routeName, queryParameters: query).toString();
  }

  /// Prefer this over raw [routeUri] + [context.push] so [controlMode] is always applied.
  static void go(
    BuildContext context, {
    required String deviceTitle,
    required String imageAssetPath,
    int controlButtonCount = 3,
    DeviceDetailsControlMode controlMode = DeviceDetailsControlMode.standard,
  }) {
    final int n = controlButtonCount.clamp(1, 8);
    context.push(
      routeUri(
        title: deviceTitle,
        imageAssetPath: imageAssetPath,
        controlButtonCount: n,
        controlMode: controlMode,
      ),
      extra: DeviceDetailsRouteArgs(
        deviceTitle: deviceTitle,
        imageAssetPath: imageAssetPath,
        controlButtonCount: n,
        controlMode: controlMode,
      ),
    );
  }

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

enum _DeviceTab { tools, automation, chart, overview, activity }

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isOn = true;

  late final TabController _tabController;

  static const List<_DeviceTab> _deviceTabsOrder = <_DeviceTab>[
    _DeviceTab.tools,
    _DeviceTab.automation,
    _DeviceTab.chart,
    _DeviceTab.overview,
    _DeviceTab.activity,
  ];

  _DeviceTab _tabFromIndex(int i) =>
      _deviceTabsOrder[i.clamp(0, _deviceTabsOrder.length - 1)];
  String _label = 'Lighting';
  String _manualMode = 'A';

  /// Selected scene for [DeviceDetailsControlMode.lightSceneValues]: 0 All On, 1 Night, 2 All Off.
  int _selectedSceneIndex = 0;

  /// RGBW wheel: hue degrees [0,360), saturation [0,1], intensity [0,1] for brightness slider.
  double _rgbwHue = 88;
  double _rgbwSaturation = 0.52;
  double _rgbwIntensity = 0.7;

  /// While true, page scroll is disabled so wheel drags are not stolen by [SingleChildScrollView].
  bool _rgbwWheelDragging = false;

  /// While true, page scroll is disabled on tunable-white temperature disk drags.
  bool _tunableWhiteDiskDragging = false;

  bool _ledDimmerRingDragging = false;
  bool _ventilationRingDragging = false;
  bool _thermostatRingDragging = false;
  bool _tunableWhiteSliderDragging = false;
  bool _rgbwSliderDragging = false;

  /// LED dimmer ring: 0 = min, 1 = 100%.
  double _ledDimmerPercent = 0.0;

  /// Tunable white: temperature position (0 warm → 1 cool) and intensity (0..1).
  double _tunableWhiteTempT = 0.62; // ~5850K feel
  double _tunableWhiteIntensity = 0.70;

  /// Tunable white: last tap point on the disk, normalized 0..1.
  /// Used so the on-disk pointer (white ring + "Daylight" label) sits exactly
  /// where the user clicked. Defaults to the disk center.
  double _tunableWhiteDotDx = 0.5;
  double _tunableWhiteDotDy = 0.5;

  /// Heating & Cooling: which pill is selected. 'heating' or 'cooling'.
  String _heatingCoolingMode = 'heating';

  /// Fan level selection: 0 = Off, 1 = Speed 1, 2 = Speed 2, 3 = Speed 3.
  /// Defaults to Speed 1 to match the design screenshot's initial state.
  int _selectedFanLevel = 1;

  /// Ventilation ring: 0 = left end of the open arc, 1 = right end (bottom stays empty).
  double _ventilationPercent = 0.0;

  /// Blind level: 0 = fully open (up), 1 = fully down. Displayed as 0–100%.
  double _blindLevel = 1.0;

  /// Blind slat angle: 0 = flat (fully open), 1 = fully closed. Displayed as 0–100%.
  double _blindAngle = 0.7;

  /// Thermostat set-point ring: 0 = 19 °C, 1 = 35 °C.
  /// Thumb starts at the arc origin (lower-left, ~8 o'clock) = 19 °C.
  double _thermostatSetPercent = 0.0;

  /// Presence screen: selected circular mode (0 Comfort … 4 Individual).
  int _selectedPresenceModeIndex = 0;
  int? _presenceOffModeIndex;

  /// Multi-value switch grid: selected tile index 0 … 11 (displayed as 1 … 12).
  int _selectedMultiValueSwitchIndex = 0;

  bool _suppressDashboardSync = false;

  static const List<String> _sceneLabels = <String>[
    'All On',
    'Night',
    'All Off',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _deviceTabsOrder.length,
      vsync: this,
    );
    _tabController.addListener(() => setState(() {}));
    _loadDashboardSnapshot(
      DeviceDashboardSync.instance.snapshotFor(widget.deviceTitle),
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (!_suppressDashboardSync) {
      _publishDashboardSnapshot();
    }
  }

  void _publishDashboardSnapshot() {
    DeviceDashboardSync.instance.update(
      widget.deviceTitle,
      _buildDashboardSnapshot(),
    );
  }

  DeviceControlSnapshot _buildDashboardSnapshot() {
    final DeviceControlSnapshot prev =
        DeviceDashboardSync.instance.snapshotFor(widget.deviceTitle);

    int blindDown = prev.blindDownPercent;
    int blindUp = prev.blindUpPercent;
    if (widget.controlMode == DeviceDetailsControlMode.awningControl) {
      blindDown = ((1 - _blindLevel) * 100).round();
      blindUp = (_blindLevel * 100).round();
    } else if (widget.controlMode == DeviceDetailsControlMode.blindControl) {
      blindDown = (_blindLevel * 100).round();
      blindUp = (_blindAngle * 100).round();
    }

    double dimmer = prev.dimmerPercent;
    if (widget.controlMode == DeviceDetailsControlMode.ledDimmer) {
      dimmer = _ledDimmerPercent;
    } else if (widget.controlMode == DeviceDetailsControlMode.standard) {
      dimmer = _isOn ? prev.dimmerPercent : 0.0;
    } else if (widget.controlMode == DeviceDetailsControlMode.tunableWhite) {
      dimmer = _tunableWhiteIntensity;
    } else if (widget.controlMode == DeviceDetailsControlMode.rgbwPicker) {
      dimmer = _rgbwIntensity;
    }

    final double thermostatC = widget.controlMode ==
            DeviceDetailsControlMode.thermostatRing
        ? 19.0 + _thermostatSetPercent.clamp(0.0, 1.0) * 16.0
        : prev.thermostatCelsius;

    return DeviceControlSnapshot(
      isOn: _resolveDashboardIsOn(),
      dimmerPercent: dimmer,
      thermostatCelsius: thermostatC,
      blindDownPercent: blindDown,
      blindUpPercent: blindUp,
      ledDimmerPercent: _ledDimmerPercent,
      ventilationPercent: _ventilationPercent,
      rgbwHue: _rgbwHue,
      rgbwSaturation: _rgbwSaturation,
      rgbwIntensity: _rgbwIntensity,
      sceneIndex: _selectedSceneIndex,
      fanLevel: _selectedFanLevel,
      heatingCoolingMode: _heatingCoolingMode,
      tunableWhiteIntensity: _tunableWhiteIntensity,
      tunableWhiteDotDx: _tunableWhiteDotDx,
      tunableWhiteDotDy: _tunableWhiteDotDy,
      presenceModeIndex: _selectedPresenceModeIndex,
      thermostatRingPercent: _thermostatSetPercent,
      multiValueSwitchIndex: _selectedMultiValueSwitchIndex,
    );
  }

  bool _resolveDashboardIsOn() {
    switch (widget.controlMode) {
      case DeviceDetailsControlMode.fanLevel:
        return _selectedFanLevel > 0;
      case DeviceDetailsControlMode.lightSceneValues:
        return _selectedSceneIndex != 2;
      case DeviceDetailsControlMode.heatingCooling:
        return _isOn;
      case DeviceDetailsControlMode.standard:
        return _isOn;
      case DeviceDetailsControlMode.presenceModes:
        return _isOn;
      case DeviceDetailsControlMode.multiValueSwitch:
        return _isOn;
      default:
        return true;
    }
  }

  void _loadDashboardSnapshot(DeviceControlSnapshot snap) {
    _isOn = snap.isOn;
    _ledDimmerPercent = snap.ledDimmerPercent;
    _ventilationPercent = snap.ventilationPercent;
    _rgbwHue = snap.rgbwHue;
    _rgbwSaturation = snap.rgbwSaturation;
    _rgbwIntensity = snap.rgbwIntensity;
    _selectedSceneIndex = snap.sceneIndex;
    _selectedFanLevel = snap.fanLevel;
    _heatingCoolingMode = snap.heatingCoolingMode;
    _tunableWhiteIntensity = snap.tunableWhiteIntensity;
    _tunableWhiteDotDx = snap.tunableWhiteDotDx;
    _tunableWhiteDotDy = snap.tunableWhiteDotDy;
    _selectedPresenceModeIndex = snap.presenceModeIndex;
    _presenceOffModeIndex =
        widget.controlMode == DeviceDetailsControlMode.presenceModes &&
                !snap.isOn
            ? snap.presenceModeIndex
            : null;
    _thermostatSetPercent = snap.thermostatRingPercent;
    _selectedMultiValueSwitchIndex = snap.multiValueSwitchIndex;

    if (widget.controlMode == DeviceDetailsControlMode.awningControl) {
      _blindLevel = snap.blindUpPercent / 100.0;
    } else if (widget.controlMode == DeviceDetailsControlMode.blindControl) {
      _blindLevel = snap.blindDownPercent / 100.0;
      _blindAngle = snap.blindUpPercent / 100.0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Whether the main hero image should use the grey off-state artwork.
  bool get _showOffHeroImage {
    switch (widget.controlMode) {
      case DeviceDetailsControlMode.heatingCooling:
        return !_isOn;
      case DeviceDetailsControlMode.fanLevel:
        return _selectedFanLevel == 0;
      case DeviceDetailsControlMode.lightSceneValues:
        return _selectedSceneIndex == 2;
      case DeviceDetailsControlMode.standard:
        return !_isOn;
      default:
        return false;
    }
  }

  String? get _offHeroImageAssetPath {
    switch (widget.controlMode) {
      case DeviceDetailsControlMode.heatingCooling:
        return 'assets/images/heating&cooling_off.png';
      case DeviceDetailsControlMode.fanLevel:
        return 'assets/images/fan_level_off.png';
      case DeviceDetailsControlMode.lightSceneValues:
        return 'assets/images/light-scenc_off.png';
      case DeviceDetailsControlMode.standard:
        final String path = widget.imageAssetPath.toLowerCase();
        final String title = widget.deviceTitle.toLowerCase();
        if (path.contains('irrigation') || title.contains('irrigation')) {
          return 'assets/images/irrigation_of.png';
        }
        if (path.contains('bathroom') ||
            title.contains('bathroom') ||
            path.contains('mask group (6)')) {
          return 'assets/images/bathroom_off.png';
        }
        if (title.contains('motion sensor')) {
          return 'assets/images/motion_sensor_off.png';
        }
        return 'assets/images/light_of.png';
      default:
        return null;
    }
  }

  String get _heroImageAssetPath {
    if (widget.deviceTitle == 'Motion Sensor' && !_isOn) {
      return 'assets/images/motion_sensor_off.png';
    }
    if (widget.controlMode == DeviceDetailsControlMode.lightSceneValues) {
      switch (_selectedSceneIndex.clamp(0, 2)) {
        case 2:
          return 'assets/images/light-scenc_off.png';
        case 1:
          return 'assets/gray_image.png';
        case 0:
        default:
          return widget.imageAssetPath;
      }
    }
    if (!_showOffHeroImage) return widget.imageAssetPath;
    return _offHeroImageAssetPath ?? widget.imageAssetPath;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      initialIndex: 2,
      backgroundColor: const Color(0xFFF3F4F6),
      //backgroundColor: Colors.black,
      children: [
        const RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        const RepaintBoundary(child: AnalyticsScreen(showBottomNav: false)),
        RepaintBoundary(child: _buildBody(context)),
        const RepaintBoundary(child: NotificationsScreen(showBottomNav: false)),
        const RepaintBoundary(child: SettingsScreen()),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final bool isLightSceneValues =
        widget.controlMode == DeviceDetailsControlMode.lightSceneValues;
    final bool presenceModes =
        widget.controlMode == DeviceDetailsControlMode.presenceModes;
    final bool multiValueSwitch =
        widget.controlMode == DeviceDetailsControlMode.multiValueSwitch;
    final bool scrollNeedsMinHeight = presenceModes || multiValueSwitch;

    /// These demo devices use a fixed (non-scroll) body; other modes unchanged.
    final String titleLc = widget.deviceTitle.toLowerCase();
    final bool disableBodyScroll =
        widget.controlMode == DeviceDetailsControlMode.ventilation ||
        (widget.controlMode == DeviceDetailsControlMode.thermostatRing &&
            titleLc == 'living room') ||
        (widget.controlMode == DeviceDetailsControlMode.ledDimmer &&
            widget.deviceTitle == 'LED Dimmer living room') ||
        (widget.controlMode == DeviceDetailsControlMode.rgbwPicker &&
            _rgbwWheelDragging) ||
        (widget.controlMode == DeviceDetailsControlMode.tunableWhite &&
            (_tunableWhiteDiskDragging || _tunableWhiteSliderDragging)) ||
        (widget.controlMode == DeviceDetailsControlMode.rgbwPicker &&
            _rgbwSliderDragging) ||
        (widget.controlMode == DeviceDetailsControlMode.ledDimmer &&
            _ledDimmerRingDragging) ||
        (widget.controlMode == DeviceDetailsControlMode.ventilation &&
            _ventilationRingDragging) ||
        (widget.controlMode == DeviceDetailsControlMode.thermostatRing &&
            _thermostatRingDragging);

    final ScrollPhysics scrollPhysics = disableBodyScroll
        ? const NeverScrollableScrollPhysics()
        : scrollNeedsMinHeight
        ? const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics())
        : const AlwaysScrollableScrollPhysics();

    final Widget scrollColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_heroStartsWithTopDeviceImage()) ...[
          _buildHeroWithImageHeader(context, _buildHero()),
        ] else ...[
          _buildTopHeader(context),
          _buildSwcBelowHeader(),
          _buildHero(),
        ],
        SizedBox(
          height: widget.controlMode == DeviceDetailsControlMode.rgbwPicker ||
                  widget.controlMode == DeviceDetailsControlMode.tunableWhite ||
                  widget.controlMode == DeviceDetailsControlMode.blindControl ||
                  widget.controlMode == DeviceDetailsControlMode.awningControl
              ? 6.h
              : isLightSceneValues
              ? 8.h
              : 10.h,
        ),
        if (widget.controlMode ==
            DeviceDetailsControlMode.lightSceneValues) ...[
          _buildSceneValuesSection(),
        ] else if (widget.controlMode != DeviceDetailsControlMode.rgbwPicker &&
            widget.controlMode != DeviceDetailsControlMode.ledDimmer &&
            widget.controlMode != DeviceDetailsControlMode.tunableWhite &&
            widget.controlMode != DeviceDetailsControlMode.heatingCooling &&
            widget.controlMode != DeviceDetailsControlMode.fanLevel &&
            widget.controlMode != DeviceDetailsControlMode.ventilation &&
            widget.controlMode != DeviceDetailsControlMode.blindControl &&
            widget.controlMode != DeviceDetailsControlMode.awningControl &&
            widget.controlMode != DeviceDetailsControlMode.thermostatRing &&
            widget.controlMode != DeviceDetailsControlMode.presenceModes &&
            widget.controlMode !=
                DeviceDetailsControlMode.multiValueSwitch) ...[
          if (widget.deviceTitle == 'Motion Sensor') ...[
            SizedBox(height: 8.h),
            Text(
              'Motion Cleared',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 8.h),
          ],
          if (widget.deviceTitle != 'Motion Sensor') ...[
            _buildOnOffRow(),
            SizedBox(height: 14.h),
          ],
          _buildStandardDeviceCommentSection(),
        ],
        _buildTabsWithContent(),
        SizedBox(height: 80.h),
      ],
    );

    return SafeArea(
      top: true,
      bottom: false,
      left: true,
      right: true,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, viewportConstraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 12.h),
                  physics: scrollPhysics,
                  child: scrollNeedsMinHeight
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: scrollColumn,
                        )
                      : scrollColumn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Hero layouts that lead with a centered device image ([standard], scene, fan, HVAC).
  bool _heroStartsWithTopDeviceImage() {
    return widget.controlMode == DeviceDetailsControlMode.standard ||
        widget.controlMode == DeviceDetailsControlMode.lightSceneValues ||
        widget.controlMode == DeviceDetailsControlMode.fanLevel ||
        widget.controlMode == DeviceDetailsControlMode.heatingCooling;
  }

  Widget _buildTopHeader(BuildContext context) {
    return _buildDefaultTopHeader(context);
  }

  Widget _buildDeviceDetailsBackButton(BuildContext context) {
    return GlobalCircleIconBtn(
      color: const Color(0xFFFFFFFF),
      child: Image.asset('assets/aro.png', width: 16.w, height: 16.h),
      onTap: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go('/setting-device');
        }
      },
    );
  }

  /// Back chevron over the hero so the device image starts at the top (no empty header row).
  Widget _buildHeroWithImageHeader(BuildContext context, Widget hero) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        hero,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildDeviceDetailsBackButton(context),
            ),
          ),
        ),
      ],
    );
  }

  /// Device title + edit icon inline after the last line of text.
  Widget _buildTitleEditRow() {
    const Color textPrimary = Color(0xFF111827);
    final double iconW = 13.w;
    final double gap = 8.w;
    final TextStyle titleStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 23.sp,
      fontWeight: FontWeight.w700,
      color: textPrimary,
      height: 1.25,
    );

    return Center(
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          style: titleStyle,
          children: [
            TextSpan(text: widget.deviceTitle),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: gap),
                child: Image.asset(
                  'assets/Group 63.png',
                  height: 13.h,
                  width: iconW,
                  fit: BoxFit.contain,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Model / device id — under title in hero for [standard] / [lightSceneValues] / [fanLevel] / [heatingCooling], else under top header.
  Widget _buildSwcBelowHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 2.h, 14.w, 4.h),
      child: Text(
        'SWC 1326 39',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildDefaultTopHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 2.h, 14.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDeviceDetailsBackButton(context),
          Expanded(child: _buildTitleEditRow()),
        ],
      ),
    );
  }

  Widget _buildHero() {
    if (widget.controlMode == DeviceDetailsControlMode.rgbwPicker) {
      return _buildRgbwHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.ledDimmer) {
      return _buildLedDimmerHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.tunableWhite) {
      return _buildTunableWhiteHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.heatingCooling) {
      return _buildHeatingCoolingHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.fanLevel) {
      return _buildFanLevelHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.ventilation) {
      return _buildVentilationHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.blindControl) {
      return _buildBlindControlHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.awningControl) {
      return _buildAwningControlHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.thermostatRing) {
      return _buildThermostatRingHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.presenceModes) {
      return _buildPresenceModesHeroContent();
    }
    if (widget.controlMode == DeviceDetailsControlMode.multiValueSwitch) {
      return _buildMultiValueSwitchHeroContent();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.asset(
            _heroImageAssetPath,
            key: widget.controlMode == DeviceDetailsControlMode.lightSceneValues
                ? ValueKey<int>(_selectedSceneIndex)
                : null,
            height: 88.h,
            width: 88.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/Mask group (5).png',
              height: 88.h,
              width: 88.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (widget.controlMode == DeviceDetailsControlMode.standard ||
            widget.controlMode ==
                DeviceDetailsControlMode.lightSceneValues) ...[
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: _buildTitleEditRow(),
          ),
          _buildSwcBelowHeader(),
        ],
        SizedBox(height: 4.h),
        _buildHeroIdentityStats(
          onTimeTop: widget.deviceTitle == 'Motion Sensor' ? '12:45' : '12:57',
        ),
      ],
    );
  }

  /// Hero for [DeviceDetailsControlMode.presenceModes]: five selectable modes.
  Widget _buildPresenceModesHeroContent() {
    const Color textPrimary = Color(0xFF111827);
    final double circleDm = 86.w;
    final double ringInset = 3.8.w;

    Widget presenceModeTile({
      required int index,
      required String label,
      required Widget iconChild,
    }) {
      final bool sel = _selectedPresenceModeIndex == index;
      final bool showRing = sel && _isOn;
      final bool showOffGrey = _presenceOffModeIndex == index && !_isOn;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          uiTapHaptic();
          setState(() {
            _selectedPresenceModeIndex = index;
            _presenceOffModeIndex = null;
            _isOn = true;
          });
        },
        onLongPress: () {
          uiTapHaptic();
          setState(() {
            _selectedPresenceModeIndex = index;
            _presenceOffModeIndex = index;
            _isOn = false;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: circleDm,
              height: circleDm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: showRing
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFc7cad6), Color(0xFFAFFF54)],
                      )
                    : null,
                border: showRing
                    ? null
                    : Border.all(
                        color: showOffGrey
                            ? kDeviceOffGreyFill
                            : const Color(0xFFE1E1E1),
                        width: 1.5,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(showRing ? 0.10 : 0.05),
                    blurRadius: showRing ? 10 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: showRing ? EdgeInsets.all(ringInset) : EdgeInsets.zero,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: ColoredBox(
                  color: showOffGrey
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFFFFFFFF),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double inset = 10.w;
                      final double rawSide = math.min(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      final double side =
                          math.max(0.0, rawSide - inset * 2);
                      final Widget icon = showOffGrey
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFC7CAD6),
                                BlendMode.srcIn,
                              ),
                              child: iconChild,
                            )
                          : iconChild;
                      return Padding(
                        padding: EdgeInsets.all(inset),
                        child: Center(
                          child: SizedBox(
                            width: side,
                            height: side,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              child: icon,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: showOffGrey ? kDeviceOffGreyIcon : textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildHeroIdentityStats(),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  presenceModeTile(
                    index: 0,
                    label: 'Comfort',
                    iconChild: Image.asset(
                      widget.imageAssetPath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/comfort.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                  presenceModeTile(
                    index: 1,
                    label: 'Auto',
                    iconChild: Image.asset(
                      'assets/images/auto.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  presenceModeTile(
                    index: 2,
                    label: 'Eco',
                    iconChild: Image.asset(
                      'assets/images/Eco.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  presenceModeTile(
                    index: 3,
                    label: 'Dynamic',
                    iconChild: Image.asset(
                      'assets/images/dynamic.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  SizedBox(width: 44.w),
                  presenceModeTile(
                    index: 4,
                    label: 'Individual',
                    iconChild: Image.asset(
                      'assets/images/Individual.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  /// Hero for [DeviceDetailsControlMode.multiValueSwitch]: 3×4 value grid.
  Widget _buildMultiValueSwitchHeroContent() {
    const Color textPrimary = Color(0xFF111827);
    const Color labelMuted = Color(0xFF9CA3AF);
    const List<String> rowLabels = <String>[
      'On Light',
      'On Irrigation',
      'On Alarm',
    ];
    const LinearGradient selectedBorderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color(0xFF00E5FF), Color(0xFF00FF80)],
    );
    const Color selectedFillColor = Color(0xFFE1E1E1);

    Widget valueTile(int index) {
      final int displayed = index + 1;
      final bool sel = _selectedMultiValueSwitchIndex == index;
      final bool showSelected = sel && _isOn;
      final bool showOffGrey = sel && !_isOn;
      final Color checkColor =
          showOffGrey ? kDeviceOffGreyIcon : const Color(0xFF22C55E);
      final String caption = rowLabels[index % 3];
      final double radiusOuter = 26.r;
      final double radiusInner = sel
          ? (radiusOuter - 3.w).clamp(12.r, radiusOuter)
          : radiusOuter;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          uiTapHaptic();
          setState(() {
            _selectedMultiValueSwitchIndex = index;
            _isOn = true;
          });
        },
        onLongPress: () {
          if (!sel) return;
          uiTapHaptic();
          setState(() => _isOn = false);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                gradient: showSelected ? selectedBorderGradient : null,
                borderRadius: BorderRadius.circular(26.r),
                border: showSelected
                    ? null
                    : Border.all(
                        color: sel
                            ? const Color(0xFFE1E1E1)
                            : const Color(0xFFFFFFFF),
                        width: sel ? 1.5 : 1,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      showSelected ? 0.08 : (sel ? 0.05 : 0.04),
                    ),
                    blurRadius: showSelected ? 10 : 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: sel ? EdgeInsets.all(3.w) : EdgeInsets.zero,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: sel ? selectedFillColor : Colors.white,
                  borderRadius: BorderRadius.circular(radiusInner),
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
                            color: textPrimary,
                          ),
                        ),
                      ),
                      if (sel)
                        Positioned(
                          top: 8.h,
                          right: 5.w,
                          child: Icon(
                            Icons.check_circle,
                            size: 30.sp,
                            color: checkColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              caption,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: showOffGrey ? kDeviceOffGreyIcon : textPrimary,
                height: 1.15,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeroIdentityStats(),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: List<Widget>.generate(4, (int row) {
              return Padding(
                padding: EdgeInsets.only(bottom: row < 3 ? 12.h : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List<Widget>.generate(3, (int col) {
                    final int idx = row * 3 + col;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        child: valueTile(idx),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLedDimmerHeroContent() {
    final double ringSize = 290.w;
    final double stroke = 12.r;

    return Column(
      children: [
        _buildHeroIdentityStats(),
        // SizedBox(height: 22.h),
        // Text(
        //   'LED Dimmer',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontFamily: 'Inter',
        //     fontSize: 20.sp,
        //     fontWeight: FontWeight.w600,
        //     color: const Color(0xFF111827),
        //   ),
        // ),
        SizedBox(height: 8.h),
        Center(
          child: SizedBox(
            width: ringSize,
            height: ringSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final Size sz = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) {
                    uiTapHaptic();
                    setState(() => _ledDimmerRingDragging = true);
                    _ledDimmerUpdateFromLocal(d.localPosition, sz);
                  },
                  onPanUpdate: (d) =>
                      _ledDimmerUpdateFromLocal(d.localPosition, sz),
                  onPanEnd: (_) =>
                      setState(() => _ledDimmerRingDragging = false),
                  onPanCancel: () =>
                      setState(() => _ledDimmerRingDragging = false),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      IgnorePointer(
                        child: CustomPaint(
                          size: sz,
                          painter: _LedDimmerRingPainter(
                            percent: _ledDimmerPercent.clamp(0.0, 1.0),
                            strokeWidth: stroke,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: Text(
                          '${(_ledDimmerPercent * 100).round()}%',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 52.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final Offset c = Offset(sz.width / 2, sz.height / 2);
                          final double radius =
                              sz.shortestSide / 2 - stroke / 2 - 2;
                          final double p = _ledDimmerPercent.clamp(0.0, 1.0);
                          final double ang =
                              _fullRingStart + (_fullRingSweep * p);
                          final Offset thumb =
                              c + Offset(math.cos(ang), math.sin(ang)) * radius;
                          final double thumbSize = 38.r;
                          final double haloPad = 8.r;
                          final double outerSize = thumbSize + haloPad * 2;
                          return Positioned(
                            left: thumb.dx - outerSize / 2,
                            top: thumb.dy - outerSize / 2,
                            child: IgnorePointer(
                              child: _ringControlThumb(
                                pressed: _ledDimmerRingDragging,
                                thumbDiameter: thumbSize,
                                haloPadding: haloPad,
                                thumb: Container(
                                  width: thumbSize,
                                  height: thumbSize,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E52A),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 5,
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _ledDimmerUpdateFromLocal(Offset local, Size size) {
    setState(
      () => _ledDimmerPercent = _fullRingPercentFromLocal(
        local,
        size,
        _ledDimmerPercent,
      ),
    );
  }

  int _ventilationDisplayPercent(double p) {
    return (p.clamp(0.0, 1.0) * 100).round().clamp(0, 100);
  }

  void _ventilationUpdateFromLocal(Offset local, Size size) {
    setState(
      () => _ventilationPercent = _fullRingPercentFromLocal(
        local,
        size,
        _ventilationPercent,
      ),
    );
  }

  /// Three-column stats row (On time / 7 Days / Cycles).
  Widget _buildHeroStatsRow({String onTimeTop = '12:57'}) {
    return Padding(
      padding: EdgeInsets.only(left: 80.w, right: 90.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBlock(top: onTimeTop, bottom: 'On time'),
          _StatBlock(top: '5h 58m', bottom: '7 Days'),
          _StatBlock(top: '1257', bottom: 'Cycles'),
        ],
      ),
    );
  }

  /// Spacer + stats only — for [standard] / [lightSceneValues] / [fanLevel] / [heatingCooling] the title and SWC sit above this in [_buildHero] (or default hero); else title is in [_buildTopHeader] and SWC may precede the hero.
  Widget _buildHeroIdentityStats({String onTimeTop = '12:57'}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.h),
        _buildHeroStatsRow(onTimeTop: onTimeTop),
      ],
    );
  }

  /// Hero for [DeviceDetailsControlMode.ventilation]: cyan→blue ring, large %
  /// + fan asset in the center, single blue thumb (larger than LED dimmer).
  Widget _buildVentilationHeroContent() {
    final double ringSize = 290.w;
    final double stroke = 12.r;
    final double thumbSize = 44.r;
    const Color thumbBlue = Color(0xFF38A4FE);

    final int shownPct = _ventilationDisplayPercent(_ventilationPercent);

    return Column(
      children: [
        _buildHeroIdentityStats(),
        SizedBox(height: 8.h),
        Center(
          child: SizedBox(
            width: ringSize,
            height: ringSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final Size sz = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) {
                    uiTapHaptic();
                    setState(() => _ventilationRingDragging = true);
                    _ventilationUpdateFromLocal(d.localPosition, sz);
                  },
                  onPanUpdate: (d) =>
                      _ventilationUpdateFromLocal(d.localPosition, sz),
                  onPanEnd: (_) =>
                      setState(() => _ventilationRingDragging = false),
                  onPanCancel: () =>
                      setState(() => _ventilationRingDragging = false),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      CustomPaint(
                        size: sz,
                        painter: _VentilationRingPainter(
                          percent: _ventilationPercent.clamp(0.0, 1.0),
                          strokeWidth: stroke,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$shownPct%',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 52.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                              height: 1.05,
                            ),
                          ),
                          SizedBox(height: 6.h),

                          Image.asset(
                             'assets/images/fan 2.png',
                            height: 84.h,
                            width: 84.w,
                            fit: BoxFit.contain, 
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          final Offset c = Offset(sz.width / 2, sz.height / 2);
                          final double radius =
                              sz.shortestSide / 2 - stroke / 2 - 2;
                          final double p = _ventilationPercent.clamp(0.0, 1.0);
                          final double ang =
                              _fullRingStart + (_fullRingSweep * p);
                          final Offset thumb =
                              c + Offset(math.cos(ang), math.sin(ang)) * radius;
                          final double haloPad = 8.r;
                          final double thumbSize =38.r;
                         final double outerSize = thumbSize + haloPad * 2;
                          return Positioned(
                            left: thumb.dx - outerSize / 2,
                            top: thumb.dy - outerSize / 2,
                            child: IgnorePointer(
                              child: _ringControlThumb(
                                pressed: _ventilationRingDragging,
                                thumbDiameter: thumbSize,
                                haloPadding: haloPad,
                                thumb: Container(
                                  width: thumbSize,
                                  height: thumbSize,
                                  decoration: BoxDecoration(
                                    color: thumbBlue,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTunableWhiteHeroContent() {
    final double diskSize = 280.w;
    final double thumbSize = 30.r;

    // Approximate warm↔cool kelvin range for the UI.
    const int warmK = 2700;
    const int coolK = 7500;
    final double t = _tunableWhiteTempT.clamp(0.0, 1.0);
    final int kelvin = (warmK + (coolK - warmK) * t).round();

    final double dialBorderWidth = 6.w;
    final Color textPrimary = const Color(0xFF111827);
    final Color textSecondary = const Color(0xFF6B7280);
    final Color accent = const Color(0xFF00D1FF);

    return Column(
      children: [
        // SizedBox(height: 10.h),
        // Text(
        //   'Tunable white light',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontFamily: 'Inter',
        //     fontSize: 22.sp,
        //     fontWeight: FontWeight.w700,
        //     color: textPrimary,
        //   ),
        // ),
        _buildHeroIdentityStats(),
        SizedBox(height: 8.h),
        Center(
          child: SizedBox(
            width: diskSize,
            height: diskSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final Size sz = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (PointerDownEvent e) {
                    uiTapHaptic();
                    setState(() => _tunableWhiteDiskDragging = true);
                    _tunableWhiteUpdateFromLocal(e.localPosition, sz);
                  },
                  onPointerMove: (PointerMoveEvent e) {
                    if (_tunableWhiteDiskDragging) {
                      _tunableWhiteUpdateFromLocal(e.localPosition, sz);
                    }
                  },
                  onPointerUp: (_) =>
                      setState(() => _tunableWhiteDiskDragging = false),
                  onPointerCancel: (_) =>
                      setState(() => _tunableWhiteDiskDragging = false),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IgnorePointer(
                        child: Container(
                          width: sz.width,
                          height: sz.height,
                          padding: EdgeInsets.all(dialBorderWidth),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xFFFEE481),
                                Color(0xFFFFFFFF),
                                Color(0xFF93E1E3),
                              ],
                              stops: <double>[0.0, 0.55, 1.0],
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
                                      colors: <Color>[
                                        Color(0xFFFEE481),
                                        Color(0xFFFFFFFF),
                                        Color(0xFF93E1E3),
                                      ],
                                      stops: <double>[0.0, 0.48, 1.0],
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
                      ),
                      // Selector + "Daylight" label at the user's tap point.
                      Builder(
                        builder: (context) {
                          final double x = _tunableWhiteDotDx * sz.width;
                          final double y = _tunableWhiteDotDy * sz.height;
                          final double ringSize = 40.r;
                          final double labelGap = 8.h;
                          final double labelHeight = 16.h;
                          // Anchor ring center on (x, y); label sits below with Figma gap.
                          return Positioned(
                            left: x - ringSize / 2,
                            top: y - ringSize / 2,
                            child: IgnorePointer(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: ringSize,
                                    height: ringSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: kDeviceOffGreyBorder,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: labelGap),
                                  SizedBox(
                                    height: labelHeight,
                                    child: Text(
                                      'Daylight',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Temperature',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${kelvin}K',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            height: 1.0,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.sp,
                    height: 1.2,
                    color: textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Intensity:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: '${(_tunableWhiteIntensity * 100).round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              Padding(
                padding:  EdgeInsets.only(left: 20.w, right: 20.w),
                child: Row(
                  children: [
                    Image.asset("assets/images/a2b985126ef03e050674ff1db5daca52af4c4e57.png", height: 20.h, width: 20.h,fit: BoxFit.cover,),
                    //SizedBox(width: 10.w),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 10.h,
                          trackShape: const _TunableWhiteIntensityGradientTrackShape(),
                          activeTrackColor: accent,
                          inactiveTrackColor: const Color(0xFFE5E7EB),
                          thumbColor: accent,
                          overlayColor: _controlPressHaloColor,
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 22.r,
                          ),
                          thumbShape: _TunableWhiteThumbShape(
                            radius: thumbSize / 2,
                            fillColor: accent,
                            dragging: _tunableWhiteSliderDragging,
                          ),
                        ),
                        child: Slider(
                          value: _tunableWhiteIntensity.clamp(0.0, 1.0),
                          min: 0,
                          max: 1,
                          onChangeStart: (_) {
                            uiTapHaptic();
                            setState(() => _tunableWhiteSliderDragging = true);
                          },
                          onChangeEnd: (_) => setState(
                            () => _tunableWhiteSliderDragging = false,
                          ),
                          onChanged: (v) => setState(
                            () => _tunableWhiteIntensity = v.clamp(0.0, 1.0),
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(width: 10.w),
                    Image.asset("assets/images/a2b985126ef03e050674ff1db5daca52af4c4e57.png", height: 40.h, width: 40.h,fit: BoxFit.cover,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _tunableWhiteUpdateFromLocal(Offset local, Size size) {
    // Map vertical drag within the disk to temperature t in [0,1].
    final double y = local.dy.clamp(0.0, size.height);
    final double tValue = ((y / size.height) - 0.18) / 0.64;

    // Clamp the visual pointer to the circular disk so it can't sit outside
    // the visible dial (corners of the SizedBox are outside the circle).
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double maxR = size.shortestSide / 2 - 32.r; // keep ring inside dial
    Offset d = local - Offset(cx, cy);
    if (d.distance > maxR && maxR > 0) {
      d = d / d.distance * maxR;
    }
    final Offset clamped = Offset(cx, cy) + d;

    setState(() {
      _tunableWhiteTempT = tValue.clamp(0.0, 1.0);
      _tunableWhiteDotDx = size.width <= 0
          ? 0.5
          : (clamped.dx / size.width).clamp(0.0, 1.0);
      _tunableWhiteDotDy = size.height <= 0
          ? 0.5
          : (clamped.dy / size.height).clamp(0.0, 1.0);
    });
  }

  Widget _buildRgbwHeroContent() {
    final Color preview = HSVColor.fromAHSV(
      1.0,
      _rgbwHue.clamp(0.0, 359.99),
      _rgbwSaturation.clamp(0.0, 1.0),
      _rgbwIntensity.clamp(0.0, 1.0),
    ).toColor();
    final String hex = preview.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();

    final double wheelSize = 310.w;

    return Column(
      children: [
        _buildHeroIdentityStats(),
        SizedBox(height: 6.h),
        Center(
          child: SizedBox(
            width: wheelSize,
            height: wheelSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final Size layoutSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (PointerDownEvent e) {
                    uiTapHaptic();
                    setState(() => _rgbwWheelDragging = true);
                    _rgbwUpdateFromLocal(e.localPosition, layoutSize);
                  },
                  onPointerMove: (PointerMoveEvent e) {
                    if (_rgbwWheelDragging) {
                      _rgbwUpdateFromLocal(e.localPosition, layoutSize);
                    }
                  },
                  onPointerUp: (_) =>
                      setState(() => _rgbwWheelDragging = false),
                  onPointerCancel: (_) =>
                      setState(() => _rgbwWheelDragging = false),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      IgnorePointer(
                        child: Container(
                          width: layoutSize.width,
                          height: layoutSize.height,
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              transform: const GradientRotation(-math.pi / 2),
                              colors: <Color>[
                                Color(0xFFBEEEDD), // top-left mint
                                Color(0xFFF8F3A8), // top yellow
                                Color(0xFFF8C8A0), // right-top orange
                                Color(0xFFF6AFC8), // right-bottom pink
                                Color(0xFFD2B6F1), // bottom purple
                                Color(0xFF9FBEF2), // bottom-left blue
                                Color(0xFF9EDFE9), // left cyan
                                Color(0xFFBEEEDD), // close loop
                              ],
                              stops: <double>[
                                0.00,
                                0.16,
                                0.30,
                                0.48,
                                0.64,
                                0.79,
                                0.92,
                                1.00,
                              ],
                            ),
                          ),
                          child: ClipOval(
                            child: CustomPaint(
                              size: layoutSize,
                              painter: _RgbHueWheelPainter(),
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final Offset c = Offset(
                            layoutSize.width / 2,
                            layoutSize.height / 2,
                          );
                          final double maxR = _rgbwWheelMaxRadius(layoutSize);
                          final double r =
                              maxR * _rgbwSaturation.clamp(0.0, 1.0);
                          final double rad = _rgbwHue * math.pi / 180;
                          final Offset thumb =
                              c + Offset(math.cos(rad) * r, -math.sin(rad) * r);
                          final double thumbD = 38.r;
                          final double haloPad = 8.r;
                          final double outerD = thumbD + haloPad * 2;
                          return Positioned(
                            left: thumb.dx - outerD / 2,
                            top: thumb.dy - outerD / 2,
                            child: IgnorePointer(
                              child: _hollowRingSelectorThumb(
                                pressed: _rgbwWheelDragging,
                                diameter: thumbD,
                                strokeWidth: 5,
                                pressHaloPadding: haloPad,
                                idleStrokeColor: Colors.white,
                                pressGlowColor: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          hex,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.sp,
                    height: 1.2,
                    // color: Color(0xFF111827)  ,
                    // fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Intensity: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: '${(_rgbwIntensity * 100).round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding:  EdgeInsets.only(right: 20.w, left: 20.w),
                child: Row(
                  children: [
                    Image.asset("assets/images/a2b985126ef03e050674ff1db5daca52af4c4e57.png", height: 20.h, width: 20.h,fit: BoxFit.cover,),

                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 10.h,
                          trackShape: const _RgbwIntensityGradientTrackShape(),
                          thumbShape: _RgbwMagentaThumbShape(
                            enabledOuterRadius: 18.r,
                            enabledInnerRadius: 14.r,
                            dragging: _rgbwSliderDragging,
                          ),
                          overlayColor: _controlPressHaloColor,
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 22.r,
                          ),
                          activeTrackColor: const Color(0xFFE91EAC),
                          inactiveTrackColor: const Color(0xFFFFFFFF),
                          disabledActiveTrackColor: const Color(0xFFE91EAC),
                          disabledInactiveTrackColor: const Color(0xFFFFFFFF),
                          thumbColor: const Color(0xFFE91EAC),
                          disabledThumbColor: const Color(0xFFE91EAC),
                        ),
                        child: Slider(
                          value: _rgbwIntensity.clamp(0.0, 1.0),
                          min: 0,
                          max: 1,
                          activeColor: const Color(0xFFE91EAC),
                          inactiveColor: const Color(0xFFFFFFFF),
                          onChangeStart: (_) {
                            uiTapHaptic();
                            setState(() => _rgbwSliderDragging = true);
                          },
                          onChangeEnd: (_) =>
                              setState(() => _rgbwSliderDragging = false),
                          onChanged: (v) =>
                              setState(() => _rgbwIntensity = v.clamp(0.0, 1.0)),
                        ),
                      ),
                    ),

                    Image.asset("assets/images/a2b985126ef03e050674ff1db5daca52af4c4e57.png", height: 40.h, width: 40.h,fit: BoxFit.cover,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _rgbwWheelMaxRadius(Size size) => size.shortestSide / 2 - 10.r;

  void _rgbwUpdateFromLocal(Offset local, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final Offset d = local - c;
    final double maxR = _rgbwWheelMaxRadius(size);
    final double dist = d.distance.clamp(0.0, maxR);
    double hueDeg = math.atan2(-d.dy, d.dx) * 180 / math.pi;
    if (hueDeg < 0) {
      hueDeg += 360;
    }
    setState(() {
      _rgbwHue = hueDeg;
      _rgbwSaturation = maxR <= 0 ? 0 : dist / maxR;
    });
  }

  Widget _buildHeatingCoolingHeroContent() {
    const Color pillBg = Colors.white;
    const Color pillBorder = Color(0xFFE5E7EB);
    const Color offSelectedBg = kDeviceOffGreyFill;

    // Pills only show selected while device is on; Off clears both visually.
    final bool isHeating = _isOn && _heatingCoolingMode == 'heating';
    final bool isCooling = _isOn && _heatingCoolingMode == 'cooling';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.asset(
            _heroImageAssetPath,
            height: 110.h + 10,
            width: 110.w + 10,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/heating_cooling.png',
              height: 110.h + 10,
              width: 110.w + 10,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: _buildTitleEditRow(),
        ),
        _buildSwcBelowHeader(),
        SizedBox(height: 4.h),
        _buildHeroIdentityStats(
          onTimeTop: widget.deviceTitle == 'Motion Sensor' ? '12:45' : '12:57',
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    uiTapHaptic();
                    setState(() => _isOn = false);
                  },
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: !_isOn ? offSelectedBg : pillBg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/off_logo.png',
                      height: 13.h,
                      width: 13.w,
                      fit: BoxFit.cover,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                _heatingCoolingPill(
                  label: 'Heating',
                  selected: isHeating,
                  onTap: () => setState(() {
                    _isOn = true;
                    _heatingCoolingMode = 'heating';
                  }),
                  accentBg: Color(0xFFFE019A),
                  inactiveBg: pillBg,
                  border: pillBorder,
                  leading: Image.asset(
                    'assets/Heating.png',
                    height: 22.h,
                    width: 22.w,
                    fit: BoxFit.cover,
                    color: isHeating ? Colors.white : Colors.black,
                    colorBlendMode: BlendMode.srcIn,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/hvac.png',
                      height: 22.h,
                      width: 22.w,
                      fit: BoxFit.cover,
                      color: isHeating ? Colors.white : Colors.black,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                _heatingCoolingPill(
                  label: 'Cooling',
                  selected: isCooling,
                  onTap: () => setState(() {
                    _isOn = true;
                    _heatingCoolingMode = 'cooling';
                  }),
                  accentBg: Color(0xFF0088FE),
                  inactiveBg: pillBg,
                  border: pillBorder,
                  leading: Image.asset(
                    'assets/colling.png',
                    height: 22.h,
                    width: 22.w,
                    fit: BoxFit.cover,
                    color: isCooling ? Colors.white : Colors.black,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Center(
        child: Padding(
        padding: EdgeInsets.only(left:  85.w, right: 0),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: SizedBox(
        height: 15.h,
        width: 15.w,
        child: Image.asset(
        'assets/images/message_icon.png',
        fit: BoxFit.contain,
        ),
        ),
        ),
        //SizedBox(width: 6.w),
        Expanded(
        child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
        'Here we will write instruction how to \n'
    'control and more information about that\n'
    'device',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    height: 1.45,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B7280),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
      ],
    );
  }

  Widget _heatingCoolingPill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color accentBg,
    required Color inactiveBg,
    required Color border,
    required Widget leading,
  }) {
    final Color foreground = selected ? Colors.white : Colors.black;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        uiTapHaptic();
        onTap();
      },
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: selected ? accentBg : inactiveBg,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
            color: selected ? Colors.transparent : border,
            width: 1,
          ),
          boxShadow: selected
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThermostatRingHeroContent() {
    final double ringSize = 300.w;
    final double stroke = 15.r;

    // Temperature: 19 °C at 0 % → 35 °C at 100 %.
    final double setTemp = 19.0 + _thermostatSetPercent.clamp(0.0, 1.0) * 16.0;
    final int tempInt = setTemp.floor();
    final int tempFrac = ((setTemp - tempInt) * 10).round();

    return Column(
      children: [
        _buildHeroIdentityStats(),
        SizedBox(height: 8.h),

        // ── Thermostat ring ──────────────────────────────────────────────────
        Center(
          child: SizedBox(
            width: ringSize,
            height: ringSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final Size sz = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) {
                    uiTapHaptic();
                    setState(() => _thermostatRingDragging = true);
                    _thermostatUpdateFromLocal(d.localPosition, sz);
                  },
                  onPanUpdate: (d) =>
                      _thermostatUpdateFromLocal(d.localPosition, sz),
                  onPanEnd: (_) =>
                      setState(() => _thermostatRingDragging = false),
                  onPanCancel: () =>
                      setState(() => _thermostatRingDragging = false),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Grey full track + rainbow progress on closed 360° ring.
                      IgnorePointer(
                        child: CustomPaint(
                          size: sz,
                          painter: _ThermostatRingPainter(
                            strokeWidth: stroke,
                            percent: _thermostatSetPercent.clamp(0.0, 1.0),
                          ),
                        ),
                      ),

                      // Centre: set point + dotted divider + current temp / humidity
                      IgnorePointer(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Set Point',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$tempInt',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 52.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF111827),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '.$tempFrac°',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF111827),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 6.h),
                              CustomPaint(
                                size: Size(132.w, 4),
                                painter: const _ThermostatDottedDividerPainter(
                                  color: Color(0xFFD1D5DB),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/low-temperature 1.png',
                                    height: 19.h,
                                    width: 8.w,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '24.6°C',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Image.asset(
                                    'assets/hot-prsend.png',
                                    height: 20.h,
                                    width: 20.w,
                                    fit: BoxFit.cover,
                                  ),

                                  SizedBox(width: 4.w),
                                  Text(
                                    '21%',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16.sp,
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

                      // Draggable thumb
                      Builder(
                        builder: (context) {
                          final Offset c = Offset(sz.width / 2, sz.height / 2);
                          final double radius =
                              sz.shortestSide / 2 - stroke / 2 - 2;
                          final double p =
                              _thermostatSetPercent.clamp(0.0, 1.0);
                          final double ang =
                              _fullRingStart + (_fullRingSweep * p);
                          final Offset thumb =
                              c + Offset(math.cos(ang), math.sin(ang)) * radius;
                          final double thumbSize = 38.r;
                          final double haloPad = 8.r;
                          final double outerSize = thumbSize + haloPad * 2;
                          return Positioned(
                            left: thumb.dx - outerSize / 2,
                            top: thumb.dy - outerSize / 2,
                            child: IgnorePointer(
                              child: _ringControlThumb(
                                pressed: _thermostatRingDragging,
                                thumbDiameter: thumbSize,
                                haloPadding: haloPad,
                                thumb: Container(
                                  width: thumbSize,
                                  height: thumbSize,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF007C),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Updates [_thermostatSetPercent] from a pan on the closed ring (0 = 19 °C, 1 = 35 °C).
  void _thermostatUpdateFromLocal(Offset local, Size size) {
    setState(
      () => _thermostatSetPercent = _fullRingPercentFromLocal(
        local,
        size,
        _thermostatSetPercent,
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildFanLevelHeroContent() {
    final List<({String label, int value})> options =
        <({String label, int value})>[
          (label: 'Off', value: 0),
          (label: 'Speed 1', value: 1),
          (label: 'Speed 2', value: 2),
          (label: 'Speed 3', value: 3),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.asset(
            _heroImageAssetPath,
            height: 140.h,
            width: 140.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/fan.png',
              height: 140.h,
              width: 140.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: _buildTitleEditRow(),
        ),
        _buildSwcBelowHeader(),
        SizedBox(height: 4.h),
        _buildHeroIdentityStats(
          onTimeTop: widget.deviceTitle == 'Motion Sensor' ? '12:45' : '12:57',
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(options.length, (int i) {
              final opt = options[i];
              final bool sel = _selectedFanLevel == opt.value;
              final option = _SceneValueOption(
                label: opt.label,
                selected: sel,
                child: _fanLevelOptionIcon(opt.value),
                onTap: () => setState(() => _selectedFanLevel = opt.value),
                selectedBackgroundOverride: opt.value == 0
                    ? (sel ? kDeviceOffGreyFill : null)
                    : (sel ? Colors.white : null),
                selectedBorderOverride: opt.value == 0
                    ? (sel ? kDeviceOffGreyFill : null)
                    : (sel ? const Color(0xFF38A4FE) : null),
                selectedBorderWidth: opt.value != 0 && sel ? 2.0 : 1.0,
              );
              if (i == 0) return option;
              return Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: option,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _fanLevelOptionIcon(int level) {
    const Color iconColor = Color(0xFF111827);

    if (level == 0) {
      return Image.asset(
        'assets/off_logo.png',
        height: 13.h,
        width: 13.w,
        fit: BoxFit.cover,
        color: Colors.black,
      );
    }

    return SizedBox(
      width: 28.w,
      height: 28.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          //assets/images/Fun_level3.png
          Image.asset("assets/images/speet1.png", height: 32.h, width: 32.w, fit: BoxFit.cover,),
          Positioned(
            right: -1,
            bottom: -1,
            child: Text(
              '$level',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                color: iconColor,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnOffRow() {
    const Color offSelectedBg = kDeviceOffGreyFill;
    const Color onSelectedBg = Color(0xFF0088FE);
    const Color inactiveBg = Colors.white;
    const Color inactiveBorder = Color(0xFFE5E7EB);
    const Color inactiveFg = Color(0xFF6B7280);

    return Padding(
      padding: EdgeInsets.only(left: 130.w, right: 130.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                uiTapHaptic();
                setState(() => _isOn = false);
              },
              child: Container(
                height: 39.h,
                width: 78.w,
                decoration: BoxDecoration(
                  color: !_isOn ? offSelectedBg : inactiveBg,
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(
                    color: !_isOn ? offSelectedBg : inactiveBg,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/off_logo.png',
                        height: 13.h,
                        width: 13.w,
                        fit: BoxFit.cover,
                        color: !_isOn ? Colors.black : Colors.black,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Off',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: !_isOn ? Colors.black : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                uiTapHaptic();
                setState(() => _isOn = true);
              },
              child: Container(
                height: 39.h,
                width: 78.w,
                decoration: BoxDecoration(
                  color: _isOn ? onSelectedBg : inactiveBg,
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(
                    color: _isOn ? onSelectedBg : inactiveBg,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new_rounded,
                        size: 18.sp,
                        color: _isOn ? Colors.white : Colors.black,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'On',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _isOn ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Comment under Off/On (standard). Motion Sensor uses alternate copy + layout only.
  Widget _buildStandardDeviceCommentSection() {
    const Color noteColor = Color(0xFF6B7280);

    if (widget.deviceTitle == 'Motion Sensor') {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: SizedBox(
                  height: 15.h,
                  width: 15.w,
                  child: Image.asset(
                    'assets/images/message_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Text(
                  'Here we will write instruction how to \n'
                  'control and more information about that\n'
                  'device',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                    color: noteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: SizedBox(
                height: 15.h,
                width: 15.w,
                child: Image.asset(
                  'assets/images/message_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Text(
                'Don\'t ON this device while you sleeping\n'
                'Here we will write comments to user\n'
                'how to use and control that device with\n'
                'all information that needed!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                  color: noteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSceneValuesSection() {
    final String headline = _sceneLabels[_selectedSceneIndex.clamp(0, 2)];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            headline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Values',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(3, (int i) {
              final option = _SceneValueOption(
                label: _sceneLabels[i],
                selected: _selectedSceneIndex == i,
                child: _sceneValueIcon(i),
                onTap: () => setState(() => _selectedSceneIndex = i),
                selectedBackgroundOverride: i == 2 ? Colors.white : null,
                selectedBorderOverride:
                    i == 2 ? const Color(0xFFE5E7EB) : null,
              );
              if (i == 0) return option;
              return Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: option,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _sceneValueIcon(int sceneSlot) {
    const String onAsset = 'assets/light_image.png';
    const String nightAsset = 'assets/gray_image.png';
    const String offAsset = 'assets/images/light-scenc_off.png';

    switch (sceneSlot) {
      case 0:
        return Image.asset(
          onAsset,
          width: 28.w,
          height: 28.w,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(
            widget.imageAssetPath,
            width: 28.w,
            height: 28.w,
            fit: BoxFit.contain,
          ),
        );
      case 1:
        return Image.asset(
          nightAsset,
          width: 28.w,
          height: 28.w,
          fit: BoxFit.contain,
        );
      case 2:
      default:
        return Image.asset(
          offAsset,
          width: 28.w,
          height: 28.w,
          fit: BoxFit.contain,
        );
    }
  }

  // ─── Blind Control ────────────────────────────────────────────────────────

  Widget _buildBlindControlHeroContent() {
    final int levelPct = (_blindLevel * 100).round();
    final int anglePct = (_blindAngle * 100).round();

    final TextStyle labelStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF111827),
    );

    final TextStyle valueStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF111827),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeroIdentityStats(),

        SizedBox(height: 8.h),

        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Level ', style: labelStyle),
              TextSpan(text: '$levelPct%', style: valueStyle),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        Padding(
          padding: EdgeInsets.only(left: 85.w, right:85.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double w = constraints.maxWidth;
              final double slatsBoxH = w * 1.0;

              final double cardPadding = 12.h;
              final double handleSize = 38.r;
              final double handlePeek = 18.h;

              final double innerH = slatsBoxH - (cardPadding * 2);
              final double innerCornerR = math.max(0.0, 26.r - cardPadding);

              // Button position will now follow blind level
              final double handleTop =
                  (cardPadding + (innerH * _blindLevel) - (handleSize / 2))
                      .clamp(cardPadding, slatsBoxH - (handleSize / 2));

              void updateBlindLevelByDrag(DragUpdateDetails d) {
                setState(() {
                  _blindLevel = (_blindLevel + d.delta.dy / (innerH * 1.2))
                      .clamp(0.0, 1.0);
                });
              }

              return SizedBox(
                width: w,
                height: slatsBoxH + handlePeek,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // Main blind card
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: slatsBoxH,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.r),
                          border: Border.all(
                            color: const Color(0xFFFFFFFF),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 12.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26.r),
                          child: Padding(
                            padding: EdgeInsets.all(cardPadding),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onVerticalDragStart: (_) => uiTapHaptic(),
                              onVerticalDragUpdate: updateBlindLevelByDrag,
                              child: Stack(
                                clipBehavior: Clip.hardEdge,
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        innerCornerR,
                                      ),
                                      child: CustomPaint(
                                        painter: _BlindSlatsPainter(
                                          level: _blindLevel,
                                          angle: _blindAngle,
                                          cornerRadius: innerCornerR,
                                        ),
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Moving handle button
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      top: handleTop,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onVerticalDragStart: (_) => uiTapHaptic(),
                          onVerticalDragUpdate: updateBlindLevelByDrag,
                          child: SizedBox(
                            width: handleSize,
                            height: handleSize,
                            child: _BlindHandle(
                              onUp: () => setState(() {
                                _blindLevel = (_blindLevel - 0.05).clamp(
                                  0.0,
                                  1.0,
                                );
                              }),
                              onDown: () => setState(() {
                                _blindLevel = (_blindLevel + 0.05).clamp(
                                  0.0,
                                  1.0,
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        SizedBox(height: 12.h),

        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Angle: ', style: labelStyle),
              TextSpan(text: '$anglePct%', style: valueStyle),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 47.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 19.w,
                height: 14.h,
                child: Image.asset(
                  'assets/images/light-Menu.png',
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
              ),

              SizedBox(width: 5.w),

              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 10.h,
                    trackShape: const _BlindAngleGradientTrackShape(),
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: const Color(0xFFEFFFFF),
                    thumbColor: Colors.transparent,
                    thumbShape: const _BlindAngleSliderThumbShape(
                      innerRadius: 10,
                      borderWidth: 5,
                      borderColor: Colors.white,
                    ),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 22.r),
                    overlayColor: const Color(0x220088FE),
                  ),
                  child: Slider(
                    value: _blindAngle.clamp(0.0, 1.0),
                    onChangeStart: (_) => uiTapHaptic(),
                    onChanged: (v) => setState(() => _blindAngle = v),
                  ),
                ),
              ),

              SizedBox(width: 5.w),

              SizedBox(
                width: 17.w,
                height: 30.h,
                child: Image.asset(
                  'assets/images/light-line-menu.png',
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildBlindControlHeroContent() {
  //   final int levelPct = (_blindLevel * 100).round();
  //   final int anglePct = (_blindAngle * 100).round();
  //
  //   final TextStyle labelStyle = TextStyle(
  //     fontFamily: 'Inter',
  //     fontSize: 16.sp,
  //     fontWeight: FontWeight.w400,
  //     color: const Color(0xFF111827),
  //   );
  //   final TextStyle valueStyle = TextStyle(
  //     fontFamily: 'Inter',
  //     fontSize: 16.sp,
  //     fontWeight: FontWeight.w700,
  //     color: const Color(0xFF111827),
  //   );
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       _buildHeroIdentityStats(),
  //       SizedBox(height: 12.h),
  //
  //       Text.rich(
  //         TextSpan(children: [
  //           TextSpan(text: 'Level ', style: labelStyle),
  //           TextSpan(text: '$levelPct%', style: valueStyle),
  //         ]),
  //       ),
  //       SizedBox(height: 10.h),
  //
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 40.w),
  //         child: LayoutBuilder(
  //           builder: (context, constraints) {
  //             final double w = constraints.maxWidth;
  //             final double slatsBoxH = w * 0.72;
  //             /// Lets the handle overlap the bottom slat + card rim like the design.
  //             final double handlePeek = 18.h;
  //
  //             return SizedBox(
  //               width: w,
  //               height: slatsBoxH + handlePeek,
  //               child: Stack(
  //                 clipBehavior: Clip.none,
  //                 alignment: Alignment.topCenter,
  //                 children: [
  //                   Positioned(
  //                     top: 0,
  //                     left: 0,
  //                     right: 0,
  //                     height: slatsBoxH,
  //                     child: DecoratedBox(
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(26.r),
  //                         border: Border.all(
  //                           color: const Color(0xFFFFFFFF),
  //                           width: 1,
  //                         ),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.black.withValues(alpha: 0.02),
  //                             blurRadius: 12.r,
  //                             offset: Offset(0, 3.h),
  //                           ),
  //                         ],
  //                       ),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(12.r),
  //                         child: Padding(
  //                           padding: EdgeInsets.all(10.h),
  //                           child: GestureDetector(
  //                             behavior: HitTestBehavior.opaque,
  //                             onVerticalDragUpdate: (d) => setState(() {
  //                               _blindLevel = (_blindLevel +
  //                                       d.delta.dy / (slatsBoxH * 1.2))
  //                                   .clamp(0.0, 1.0);
  //                             }),
  //                             child: Stack(
  //                               clipBehavior: Clip.hardEdge,
  //                               alignment: Alignment.center,
  //                               children: [
  //                                 Positioned.fill(
  //                                   child: CustomPaint(
  //                                     painter: _BlindSlatsPainter(
  //                                       level: _blindLevel,
  //                                       angle: _blindAngle,
  //                                     ),
  //                                     child: const SizedBox.expand(),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     left: 0,
  //                     right: 0,
  //                     bottom: 0,
  //                     child: Center(
  //                       child: _BlindHandle(
  //                         onUp: () => setState(() {
  //                           _blindLevel =
  //                               (_blindLevel - 0.05).clamp(0.0, 1.0);
  //                         }),
  //                         onDown: () => setState(() {
  //                           _blindLevel =
  //                               (_blindLevel + 0.05).clamp(0.0, 1.0);
  //                         }),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //       SizedBox(height: 12.h),
  //
  //       Text.rich(
  //         TextSpan(children: [
  //           TextSpan(text: 'Angle: ', style: labelStyle),
  //           TextSpan(text: '$anglePct%', style: valueStyle),
  //         ]),
  //       ),
  //       //SizedBox(height: 14.h),
  //
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16.w),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             SizedBox(
  //               width: 28.w,
  //               height: 26.h,
  //               child: Image.asset(
  //                 'assets/images/light-Menu.png',
  //                 fit: BoxFit.contain,
  //                 excludeFromSemantics: true,
  //               ),
  //             ),
  //             SizedBox(width: 5.w),
  //             Expanded(
  //               child: SliderTheme(
  //                 data: SliderThemeData(
  //                   trackHeight: 4.h,
  //                   activeTrackColor: const Color(0xFF0088FE),
  //                   inactiveTrackColor: const Color(0xFFE5E7EB),
  //                   thumbColor: const Color(0xFF0088FE),
  //                   thumbShape: const _BlindAngleSliderThumbShape(
  //                     innerRadius: 10,
  //                     borderWidth: 4,
  //                     fillColor: Color(0xFF0088FE),
  //                     borderColor: Colors.white,
  //                   ),
  //                   overlayShape:
  //                       RoundSliderOverlayShape(overlayRadius: 22.r),
  //                   overlayColor: const Color(0x220088FE),
  //                 ),
  //                 child: Slider(
  //                   value: _blindAngle.clamp(0.0, 1.0),
  //                   onChanged: (v) => setState(() => _blindAngle = v),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 5.w),
  //             SizedBox(
  //               width: 28.w,
  //               height: 26.h,
  //               child: Image.asset(
  //                 'assets/images/light-line-menu.png',
  //                 fit: BoxFit.contain,
  //                 excludeFromSemantics: true,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildAwningControlHeroContent() {
    final int levelPct = (_blindLevel * 100).round();

    final TextStyle labelStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF111827),
    );

    final TextStyle valueStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF111827),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeroIdentityStats(),
        SizedBox(height: 8.h),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Level ', style: labelStyle),
              TextSpan(text: '$levelPct%', style: valueStyle),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 83.w, right: 83.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double w = constraints.maxWidth;
              final double cardH = w * 1.0;
              final double cardPadding = 8.h;
              final double handleSize = 40.r;
              final double handlePeek = 18.h;
              final double innerH = cardH - (cardPadding * 2);
              final double fillH = (innerH * _blindLevel).clamp(0.0, innerH);
              final double innerCornerR = math.max(0.0, 26.r - cardPadding);
              final bool fillReachesBottom = fillH >= innerH - 0.5;

              final double handleTop =
                  (cardPadding + (innerH * _blindLevel) - (handleSize / 2))
                      .clamp(cardPadding, cardH - (handleSize / 2));

              void updateAwningLevelByDrag(DragUpdateDetails d) {
                setState(() {
                  _blindLevel = (_blindLevel + d.delta.dy / (innerH * 1.2))
                      .clamp(0.0, 1.0);
                });
              }

              Widget awningFill(double height) {
                return SizedBox(
                  height: height,
                  width: double.infinity,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xFF38A4FE),
                          Color(0xFF15DFFE),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                width: w,
                height: cardH + handlePeek,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: cardH,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.r),
                          border: Border.all(
                            color: const Color(0xFFFFFFFF),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 12.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26.r),
                          child: Padding(
                            padding: EdgeInsets.all(cardPadding),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onVerticalDragStart: (_) => uiTapHaptic(),
                              onVerticalDragUpdate: updateAwningLevelByDrag,
                              child: Stack(
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  const Positioned.fill(
                                    child: ColoredBox(color: Colors.white),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    height: fillH,
                                    child: ClipRRect(
                                      borderRadius: fillReachesBottom
                                          ? BorderRadius.circular(innerCornerR)
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(
                                                innerCornerR,
                                              ),
                                              topRight: Radius.circular(
                                                innerCornerR,
                                              ),
                                            ),
                                      child: awningFill(fillH),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      top: handleTop,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onVerticalDragStart: (_) => uiTapHaptic(),
                          onVerticalDragUpdate: updateAwningLevelByDrag,
                          child: SizedBox(
                            width: handleSize,
                            height: handleSize,
                            child: _BlindHandle(
                              onUp: () => setState(() {
                                _blindLevel = (_blindLevel - 0.05).clamp(
                                  0.0,
                                  1.0,
                                );
                              }),
                              onDown: () => setState(() {
                                _blindLevel = (_blindLevel + 0.05).clamp(
                                  0.0,
                                  1.0,
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Tab labels on the page background; underline sits on the white card below.
  Widget _buildTabsWithContent() {
    final double stripH = 55.h;
    final double lineH = 3.h;
    final double labelTopPad = 10.h;
    final double indicatorTopPad = stripH - labelTopPad - lineH;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: stripH,
            child: TabBar(
              controller: _tabController,
              padding: EdgeInsets.zero,
              dividerHeight: 10,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.fill,
              labelPadding: EdgeInsets.only(top: labelTopPad),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.only(top: indicatorTopPad),
              labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                height: 1.0,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                height: 1.0,
                fontWeight: FontWeight.w500,
              ),
              labelColor: const Color(0xFF111827),
              unselectedLabelColor: const Color(0xFF111827),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: lineH,
                  color: const Color(0xFF111827),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
              ),
              tabs: const [
                Tab(text: 'Tools'),
                Tab(text: 'Automation'),
                Tab(text: 'Chart'),
                Tab(text: 'Overview'),
                Tab(text: 'Activity'),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildTabContent(embeddedInTabsSheet: true),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({bool embeddedInTabsSheet = false}) {
    switch (_tabFromIndex(_tabController.index)) {
      case _DeviceTab.tools:
        return _buildManageDeviceCard(embeddedInTabsSheet: embeddedInTabsSheet);
      case _DeviceTab.automation:
        return _automationCard(embeddedInTabsSheet: embeddedInTabsSheet);
      case _DeviceTab.chart:
        return _chartCard(embeddedInTabsSheet: embeddedInTabsSheet);
      case _DeviceTab.overview:
        return deviceOverviewCard(embeddedInTabsSheet: embeddedInTabsSheet);
      case _DeviceTab.activity:
        return _activityCard(embeddedInTabsSheet: embeddedInTabsSheet);
    }
  }

  Widget _wrapTabsPanelCard({
    required bool embeddedInTabsSheet,
    required Widget child,
  }) {
    if (embeddedInTabsSheet) {
      return child;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildManageDeviceCard({bool embeddedInTabsSheet = false}) {
    return _wrapTabsPanelCard(
      embeddedInTabsSheet: embeddedInTabsSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 52.h,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Manage your device',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
          _manageRowLabels(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
          _manageRowAlerts(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
          _manageRowSafeValue(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
          _manageRowManualOverride(),
        ],
      ),
    );
  }


  Widget _manageRowLabels() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/labels_icon.png",
            height: 23.h,
            width: 23.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Labels',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _ChipPill(
                text: 'Bathroom',
                bg: const Color(0xFFFE019A),
                textColor: Colors.white,
                border: Colors.transparent,
              ),

              SizedBox(width: 10.w),
              _ChipPill(
                text: _label,
                bg: Colors.white,
                textColor: const Color(0xFF0088FE),
                border: const Color(0xFF0088FE),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _manageRowAlerts() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/alerts_icon.png",
            height: 23.h,
            width: 23.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Alerts',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              '12',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Icon(
            Icons.chevron_right_rounded,
            size: 22.sp,
            color: const Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }

  Widget _manageRowSafeValue() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/sate_icon.png",
            height: 21.h,
            width: 21.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Safe Value',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Text(
            'On',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(width: 6.w),
          Icon(
            Icons.chevron_right_rounded,
            size: 22.sp,
            color: const Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }

  Widget _manageRowManualOverride() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: Row(
        children: [
          Image.asset(
            "assets/manual_icon.png",
            height: 23.h,
            width: 23.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            'Manual Override',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Container(
            height: 36.h,
            width: 69.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ModeButton(
                  label: 'A',
                  active: _manualMode == 'A',
                  onTap: () => setState(() => _manualMode = 'A'),
                ),
                //SizedBox(width: 10.w),
                _ModeButton(
                  label: 'M',
                  active: _manualMode == 'M',
                  onTap: () => setState(() => _manualMode = 'M'),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Icon(
            Icons.chevron_right_rounded,
            size: 22.sp,
            color: const Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }

  Widget _automationCard({bool embeddedInTabsSheet = false}) {
    return _wrapTabsPanelCard(
      embeddedInTabsSheet: embeddedInTabsSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 55.h,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Text(
                'Organize automation',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
          _miniAutomationRow(
            title: 'Set actions based on value of',
            subtitle: 'Multi-Value Switch',
            image: "assets/set_actions_icon.png",
            imageheight: 40.h,
            imagewidth: 40.w,
          ),
          Padding(
            padding: EdgeInsets.only(right: 14.w, left: 48.w),
            child: const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE1E1E1),
            ),
          ),
          _miniAutomationRow(
            title: 'Temperature hysteresis controller (2)',
            subtitle: 'Multi-Value Switch',
            image: "assets/temperature_icon.png",
            imageheight: 34.h,
            imagewidth: 34.w,
          ),

          Padding(
            padding: EdgeInsets.only(right: 14.w, left: 48.w),
            child: const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE1E1E1),
            ),
          ),

          _addAutomationRow(  
            title: 'Add automation',
            image: "assets/images/add+.png",
            imageheight: 20.h,
            imagewidth: 20.w,
          ),
        ],
      ),
    );
  }

  Widget _chartCard({bool embeddedInTabsSheet = false}) {
    return _wrapTabsPanelCard(
      embeddedInTabsSheet: embeddedInTabsSheet,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 55.h,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Text(
                'Live chart',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          Divider(height: 1.h, thickness: 1, color: const Color(0xFFE1E1E1)),
          Padding(
            padding: EdgeInsets.only(top: 15.h, right: 12.w, bottom: 14.h),
            child: SizedBox(
              height: 150.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFCDE5FF), Color(0xFFFFFFFF)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(14.r),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: const _SimpleChartPainter(),
                              child: const SizedBox.expand(),
                            ),
                          ),
                          Positioned(
                            top: 15.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088FF),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Light ON',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12.h,
                            left: 10.w,
                            right: 10.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _TimeAxis('12:00'),
                                _TimeAxis('14:00'),
                                _TimeAxis('16:00'),
                                _TimeAxis('18:00'),
                                _TimeAxis('20:00'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 58.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'On',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        Text(
                          'Off',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
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
    );
  }

  Widget _activityCard({bool embeddedInTabsSheet = false}) {
    return _wrapTabsPanelCard(
      embeddedInTabsSheet: embeddedInTabsSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 55.h,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Text(
                'History log',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE1E1E1)),
          _activityRow(
            leading: const Icon(
              Icons.person_rounded,
              size: 17,
              color: Color(0xFF0088FE),
            ),
            time: '18.12.25',
            clock: '18:26',
            name: 'User name 1',
            statusText: 'On',
            //statusColor: const Color(0xFF111827),
          ),
          Padding(
            padding: EdgeInsets.only(left: 58.w),
            child: const Divider(height: 1, color: Color(0xFFE1E1E1)),
          ),
          _activityRow(
            leading: const Icon(
              Icons.person_rounded,
              size: 17,
              color: Color(0xFF0088FE),
            ),
            time: '18.12.25',
            clock: '17:55',
            name: 'User name 2',
            statusText: 'Off',
            //statusColor: const Color(0xFF),
          ),
          Padding(
            padding: EdgeInsets.only(left: 58.w),
            child: const Divider(height: 1, color: Color(0xFFE1E1E1)),
          ),
          _activityRow(
            leading: const Text(
              'M',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF),
                fontSize: 16,
              ),
            ),
            time: '18.12.25',
            clock: '16:13',
            name: 'User name 3',
            statusText: '78%',
            // statusColor: const Color(0xFFEC4899),
            statusIsPercent: true,
            avatarBgColor: const Color(0xFFFE019A),
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget _miniAutomationRow({
    required String title,
    required String subtitle,
    required String image,
    Color? iconColor,
    required double imageheight,
    required double imagewidth,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: imageheight,
            width: imagewidth,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Image.asset(
            "assets/back_arro.png",
            height: 13.h,
            width: 13.w,
            fit: BoxFit.cover,
            color: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _addAutomationRow({
    required String title,
    required String image,
    Color? iconColor,
    required double imageheight,
    required double imagewidth,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 39.h,
          width: 39.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.r),
              color: Color(0xFFF3F4F6)
            ),
            child: Center(
              child: Image.asset(
                image,
                height: imageheight,
                width: imagewidth,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                  ),
                ),

              ],
            ),
          ),
          // SizedBox(width: 8.w),
          // Image.asset(
          //   "assets/back_arro.png",
          //   height: 13.h,
          //   width: 13.w,
          //   fit: BoxFit.cover,
          //   color: const Color(0xFF6B7280),
          // ),
        ],
      ),
    );
  }

  Widget _activityRow({
    required Widget leading,
    required String time,
    required String clock,
    required String name,
    required String statusText,
    //required Color statusColor,
    bool statusIsPercent = false,
    Color? avatarBgColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            height: 33.h,
            width: 33.w,
            child: CircleAvatar(
              radius: 33.r,
              backgroundColor: avatarBgColor ?? const Color(0xFFF3F4F6),
              child: leading,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: time,
                        style: TextStyle(color: const Color(0xFF6B7280)),
                      ),
                      const TextSpan(text: '   '),
                      TextSpan(
                        text: clock,
                        style: TextStyle(color: const Color(0xFF6B7280)),
                      ),
                      const TextSpan(text: '   '),
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          //SizedBox(width: 10.w),
          Text(
            statusText,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cyan → blue linear gradient on the active segment of the blind angle slider.
class _BlindAngleGradientTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const _BlindAngleGradientTrackShape();

  static const List<Color> _gradientColors = <Color>[
    Color(0xFF15DFFE),
    Color(0xFF38A4FE),
  ];

  @override
  bool get isRounded => true;

  static Paint _gradientPaint(Rect bounds, {required bool ltrActive}) {
    return Paint()
      ..shader = LinearGradient(
        begin: ltrActive ? Alignment.centerLeft : Alignment.centerRight,
        end: ltrActive ? Alignment.centerRight : Alignment.centerLeft,
        colors: _gradientColors,
      ).createShader(bounds);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final double trackHeight = sliderTheme.trackHeight!;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    const double additionalActiveTrackHeight = 0;
    final Radius activeTrackRadius = Radius.circular(
      (trackRect.height + additionalActiveTrackHeight) / 2,
    );
    final bool isLTR = textDirection == TextDirection.ltr;
    final bool isRTL = textDirection == TextDirection.rtl;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? const Color(0xFFE5E7EB);

    final bool leadingSegmentGradient = isLTR;
    final bool trailingSegmentGradient = isRTL;

    final bool drawInactiveTrack =
        thumbCenter.dx < (trackRect.right - (trackHeight / 2));
    if (drawInactiveTrack) {
      final RRect trailing = RRect.fromLTRBR(
        thumbCenter.dx - (trackHeight / 2),
        isRTL
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        isRTL
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? trackRadius : activeTrackRadius,
      );
      context.canvas.drawRRect(
        trailing,
        trailingSegmentGradient
            ? _gradientPaint(trailing.outerRect, ltrActive: false)
            : inactivePaint,
      );
    }
    final bool drawActiveTrack =
        thumbCenter.dx > (trackRect.left + (trackHeight / 2));
    if (drawActiveTrack) {
      final RRect leading = RRect.fromLTRBR(
        trackRect.left,
        isLTR
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx + (trackHeight / 2),
        isLTR
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? activeTrackRadius : trackRadius,
      );
      context.canvas.drawRRect(
        leading,
        leadingSegmentGradient
            ? _gradientPaint(leading.outerRect, ltrActive: true)
            : inactivePaint,
      );
    }
  }
}

/// Slider thumb: white ring + solid accent fill.
class _BlindAngleSliderThumbShape extends SliderComponentShape {
  const _BlindAngleSliderThumbShape({
    required this.innerRadius,
    required this.borderWidth,
    required this.borderColor,
  });

  final double innerRadius;
  final double borderWidth;
  final Color borderColor;

  static const Color _thumbFill = Color(0xFF38A4FE);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(innerRadius + borderWidth);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final double outerR = innerRadius + borderWidth;
    canvas.drawCircle(center, outerR, Paint()..color = borderColor);
    canvas.drawCircle(center, innerRadius, Paint()..color = _thumbFill);
  }
}

class _BlindSlatsPainter extends CustomPainter {
  const _BlindSlatsPainter({
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
      Radius.circular(cornerRadius.clamp(0.0, math.min(size.width, size.height) / 2)),
    );

    canvas.drawRRect(clipRrect, Paint()..color = Colors.white);

    canvas.save();
    canvas.clipRRect(clipRrect);

    final double horizontalInset = size.width * 0.015;
    final double cx = size.width / 2;
    final double usableW = size.width - (horizontalInset * 2);

    final double bandH = size.height / _slatCount;

    // gap কমানো হয়েছে
    final double gap = 0.8;

    final double maxSlatInBand = math.max(2.0, bandH - gap);

    // height বাড়ানো হয়েছে
    final double slatH = maxSlatInBand * angle.clamp(0.14, 1.25);

    // width slightly wider
    final double topW = usableW * 1.02;

    // Trapezoid when angle is low; blend to nearly rectangular at 100% so sides
    // stay almost flat instead of stepped zig-zag edges.
    final double a = angle.clamp(0.0, 1.0);
    final double baseTaper = 0.74 + 0.16 * a;
    final double flatBlend = a * a;
    final double taperT =
        (baseTaper * (1 - flatBlend) + 1.0 * flatBlend).clamp(0.66, 1.0);

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

      // top highlight
      canvas.drawLine(
        Offset(cx - topW / 2, top),
        Offset(cx + topW / 2, top),
        edgeTop,
      );

      // bottom shadow
      canvas.drawLine(
        Offset(cx - botW / 2, bot),
        Offset(cx + botW / 2, bot),
        edgeBot,
      );

      // separator
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
  bool shouldRepaint(_BlindSlatsPainter oldDelegate) {
    return oldDelegate.level != level ||
        oldDelegate.angle != angle ||
        oldDelegate.cornerRadius != cornerRadius;
  }
}

// Drag-handle widget drawn on top of the slats.
class _BlindHandle extends StatelessWidget {
  const _BlindHandle({this.onUp, this.onDown});

  final VoidCallback? onUp;
  final VoidCallback? onDown;

  @override
  Widget build(BuildContext context) {
    final double triW = 15.w;
    final double triH = 13.h;
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.14),
        //     blurRadius: 8.r,
        //     offset: Offset(0, 2.h),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onUp == null
                ? null
                : () {
                    uiTapHaptic();
                    onUp!();
                  },
            child: SizedBox(
              width: triW,
              height: triH,
              child: Image.asset("assets/Polygon_on.png"),
            ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDown == null
                ? null
                : () {
                    uiTapHaptic();
                    onDown!();
                  },
            child: SizedBox(
              width: triW,
              height: triH,
              child: Image.asset("assets/off_logo.png"),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeAxis extends StatelessWidget {
  const _TimeAxis(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      ),
    );
  }
}

class _SimpleChartPainter extends CustomPainter {
  const _SimpleChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const Color blue = Color(0xFF0088FF);

    final double y = size.height * 0.03;
    final double startX = size.width * 0.01;
    final double endX = size.width * 0.98;

    final Paint linePaint = Paint()
      ..color = blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(startX, y), Offset(endX, y), linePaint);

    canvas.drawCircle(
      Offset(endX, y),
      4.5,
      Paint()
        ..color = blue
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────

Widget deviceOverviewCard({bool embeddedInTabsSheet = false}) {
  const overviewTitle = Color(0xFF111827);
  const overviewValueGreen = Color(0xFF5AB56B);
  const overviewLabel = Color(0xFF6B7280);

  final Widget body = Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
        SizedBox(
          height: 55.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              top: 14.h,
              bottom: 14.h,
              right: 14.w,
            ),
            child: Text(
              'Device overview',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: overviewTitle,
              ),
            ),
          ),
        ),
        Divider(color: const Color(0xFFE1E1E1), height: 1, thickness: 1),
        Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 14.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _deviceOverviewGridCell(
                    'Savings',
                    '₪ 268.7',
                    valueColor: overviewValueGreen,
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                    shekelSymbolUsesTitleColor: true,
                  ),
                  _deviceOverviewGridCell(
                    'Peak',
                    '1.3 kWh',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Usage',
                    '13.8%',
                    valueColor: overviewValueGreen,
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _deviceOverviewGridCell(
                    'Energy',
                    '0.52 kWh',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Avr cost',
                    '₪ 139.8',
                    valueColor: overviewValueGreen,
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                    shekelSymbolUsesTitleColor: true,
                  ),
                  _deviceOverviewGridCell(
                    'Runtime',
                    '5h 58m',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _deviceOverviewGridCell(
                    'Last action',
                    '26% 12:45',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Status',
                    '78%',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                  _deviceOverviewGridCell(
                    'Next action',
                    'Off 13:26',
                    labelColor: overviewLabel,
                    titleColor: overviewTitle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
  );

  if (embeddedInTabsSheet) {
    return body;
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: body,
  );
}

Widget _deviceOverviewGridCell(
  String label,
  String value, {
  Color? valueColor,
  required Color labelColor,
  required Color titleColor,
  bool shekelSymbolUsesTitleColor = false,
}) {
  final Color resolvedValueColor = valueColor ?? titleColor;
  final TextStyle valueStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  final String trimmedValue = value.trimLeft();
  final bool splitShekel =
      shekelSymbolUsesTitleColor &&
      trimmedValue.startsWith('₪') &&
      trimmedValue.length > 1;

  late final Widget valueChild;
  if (splitShekel) {
    final String afterShekel = trimmedValue.substring(1).trimLeft();
    valueChild = Text.rich(
      TextSpan(
        style: valueStyle,
        children: [
          TextSpan(
            text: '₪',
            style: valueStyle.copyWith(color: titleColor),
          ),
          if (afterShekel.isNotEmpty)
            TextSpan(
              text: ' $afterShekel',
              style: valueStyle.copyWith(color: resolvedValueColor),
            ),
        ],
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  } else {
    valueChild = Text(
      value,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: valueStyle.copyWith(color: resolvedValueColor),
    );
  }

  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 1,
            color: labelColor,
          ),
        ),
        SizedBox(height: 4.h),
        valueChild,
      ],
    ),
  );
}

class _SceneValueOption extends StatelessWidget {
  const _SceneValueOption({
    required this.label,
    required this.selected,
    required this.child,
    required this.onTap,
    this.selectedBackgroundOverride,
    this.selectedBorderOverride,
    this.selectedBorderWidth = 1.0,
  });

  final String label;
  final bool selected;
  final Widget child;
  final VoidCallback onTap;
  /// When non-null and [selected], replaces default grey selected fill.
  final Color? selectedBackgroundOverride;
  /// When non-null and [selected], replaces default selected border color.
  final Color? selectedBorderOverride;
  /// Border width when [selected] (default matches prior 1.0).
  final double selectedBorderWidth;

  @override
  Widget build(BuildContext context) {
    final Color fillColor = selected
        ? (selectedBackgroundOverride ?? const Color(0xFFE5E7EB))
        : Colors.white;
    final Color borderColor = selected
        ? (selectedBorderOverride ?? const Color(0xFFD1D5DB))
        : const Color(0xFFE5E7EB);
    final double borderW = selected ? selectedBorderWidth : 1.0;

    return GestureDetector(
      onTap: () {
        uiTapHaptic();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 84.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: fillColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: borderW,
                ),
                boxShadow: selected
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: child,
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pale cyan → accent active track (tunable white intensity).
class _TunableWhiteIntensityGradientTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const _TunableWhiteIntensityGradientTrackShape();

  static const List<Color> _gradientColors = <Color>[
    Color(0xFFBFF6FF),
    Color(0xFF00D1FF),
  ];

  @override
  bool get isRounded => true;

  static Paint _gradientPaint(Rect bounds, {required bool ltrActive}) {
    return Paint()
      ..shader = LinearGradient(
        begin: ltrActive ? Alignment.centerLeft : Alignment.centerRight,
        end: ltrActive ? Alignment.centerRight : Alignment.centerLeft,
        colors: _gradientColors,
      ).createShader(bounds);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final double trackHeight = sliderTheme.trackHeight!;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    const double additionalActiveTrackHeight = 0;
    final Radius activeTrackRadius = Radius.circular(
      (trackRect.height + additionalActiveTrackHeight) / 2,
    );
    final bool isLTR = textDirection == TextDirection.ltr;
    final bool isRTL = textDirection == TextDirection.rtl;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? const Color(0xFFE5E7EB);

    final bool leadingSegmentGradient = isLTR;
    final bool trailingSegmentGradient = isRTL;

    final bool drawInactiveTrack =
        thumbCenter.dx < (trackRect.right - (trackHeight / 2));
    if (drawInactiveTrack) {
      final RRect trailing = RRect.fromLTRBR(
        thumbCenter.dx - (trackHeight / 2),
        isRTL
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        isRTL
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? trackRadius : activeTrackRadius,
      );
      context.canvas.drawRRect(
        trailing,
        trailingSegmentGradient
            ? _gradientPaint(trailing.outerRect, ltrActive: false)
            : inactivePaint,
      );
    }
    final bool drawActiveTrack =
        thumbCenter.dx > (trackRect.left + (trackHeight / 2));
    if (drawActiveTrack) {
      final RRect leading = RRect.fromLTRBR(
        trackRect.left,
        isLTR
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx + (trackHeight / 2),
        isLTR
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? activeTrackRadius : trackRadius,
      );
      context.canvas.drawRRect(
        leading,
        leadingSegmentGradient
            ? _gradientPaint(leading.outerRect, ltrActive: true)
            : inactivePaint,
      );
    }
  }
}

/// Light pink → magenta active track; white inactive (matches RGBW intensity spec).
class _RgbwIntensityGradientTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const _RgbwIntensityGradientTrackShape();

  static const List<Color> _gradientColors = <Color>[
    Color(0xFFFFD6EC),
    Color(0xFFE91EAC),
  ];

  @override
  bool get isRounded => true;

  static Paint _gradientPaint(Rect bounds, {required bool ltrActive}) {
    return Paint()
      ..shader = LinearGradient(
        begin: ltrActive ? Alignment.centerLeft : Alignment.centerRight,
        end: ltrActive ? Alignment.centerRight : Alignment.centerLeft,
        colors: _gradientColors,
      ).createShader(bounds);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final double trackHeight = sliderTheme.trackHeight!;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    const double additionalActiveTrackHeight = 0;
    final Radius activeTrackRadius = Radius.circular(
      (trackRect.height + additionalActiveTrackHeight) / 2,
    );
    final bool isLTR = textDirection == TextDirection.ltr;
    final bool isRTL = textDirection == TextDirection.rtl;

    final Paint inactivePaint = Paint()..color = const Color(0xFFFFFFFF);

    // Same segment map as [RoundedRectSliderTrackShape]: leading segment uses
    // "left" paint, trailing uses "right" paint. Active (gradient) follows the
    // slider start edge (LTR = left, RTL = right).
    final bool leadingSegmentGradient = isLTR;
    final bool trailingSegmentGradient = isRTL;

    final bool drawInactiveTrack =
        thumbCenter.dx < (trackRect.right - (trackHeight / 2));
    if (drawInactiveTrack) {
      final RRect trailing = RRect.fromLTRBR(
        thumbCenter.dx - (trackHeight / 2),
        isRTL
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        isRTL
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? trackRadius : activeTrackRadius,
      );
      context.canvas.drawRRect(
        trailing,
        trailingSegmentGradient
            ? _gradientPaint(trailing.outerRect, ltrActive: false)
            : inactivePaint,
      );
    }
    final bool drawActiveTrack =
        thumbCenter.dx > (trackRect.left + (trackHeight / 2));
    if (drawActiveTrack) {
      final RRect leading = RRect.fromLTRBR(
        trackRect.left,
        isLTR
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx + (trackHeight / 2),
        isLTR
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        isLTR ? activeTrackRadius : trackRadius,
      );
      context.canvas.drawRRect(
        leading,
        leadingSegmentGradient
            ? _gradientPaint(leading.outerRect, ltrActive: true)
            : inactivePaint,
      );
    }
  }
}

/// Magenta fill with white outer ring (RGBW intensity thumb).
class _RgbwMagentaThumbShape extends SliderComponentShape {
  _RgbwMagentaThumbShape({
    required this.enabledOuterRadius,
    required this.enabledInnerRadius,
    this.dragging = false,
    this.disabledOuterRadius,
    this.disabledInnerRadius,
  });

  final double enabledOuterRadius;
  final double enabledInnerRadius;
  final bool dragging;
  final double? disabledOuterRadius;
  final double? disabledInnerRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    final double r = isEnabled
        ? enabledOuterRadius
        : (disabledOuterRadius ?? enabledOuterRadius);
    return Size.fromRadius(r);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final double outer = Tween<double>(
      begin: disabledOuterRadius ?? enabledOuterRadius,
      end: enabledOuterRadius,
    ).evaluate(enableAnimation);
    final double inner = Tween<double>(
      begin: disabledInnerRadius ?? enabledInnerRadius,
      end: enabledInnerRadius,
    ).evaluate(enableAnimation);
    final Canvas canvas = context.canvas;
    canvas.drawCircle(center, outer, Paint()..color = Colors.white);
    canvas.drawCircle(center, inner, Paint()..color = const Color(0xFFE91EAC));
  }
}

/// Filled thumb (tunable white intensity).
class _TunableWhiteThumbShape extends SliderComponentShape {
  const _TunableWhiteThumbShape({
    required this.radius,
    required this.fillColor,
    this.dragging = false,
  });

  final double radius;
  final Color fillColor;
  final bool dragging;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,

    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // No Canvas.drawShadow: it can render a cross-shaped artifact on circular
    // thumb paths on some Skia builds. Keep a clean fill + ring only.
    canvas.drawCircle(center, radius, Paint()..color = fillColor);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.w
        ..color = Colors.white.withOpacity(0.95),
    );
  }
}

/// Cyan→green gradient on the open ring (same geometry as ventilation; colours unchanged).

class _LedDimmerRingPainter extends CustomPainter {
  _LedDimmerRingPainter({required this.percent, required this.strokeWidth});

  final double percent;
  final double strokeWidth;

  static const List<Color> _gradientColors = <Color>[
    Color(0xFF00D1FF), 
    Color(0xFF00E52A), 
    
  ];
  static const List<double> _gradientStops = <double>[
    0.0,
    0.80,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _paintGradientFullRing(
      canvas,
      size,
      percent: percent,
      strokeWidth: strokeWidth,
      gradientColors: _gradientColors,
      gradientStops: _gradientStops,
    );
  }

  @override
  bool shouldRepaint(covariant _LedDimmerRingPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Thin dotted divider shown inside the thermostat ring below set-point °.
class _ThermostatDottedDividerPainter extends CustomPainter {
  const _ThermostatDottedDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const double dotRadius = 1.1;
   final double cy = size.height / 2;
    double x = dotRadius + 0.5;
    while (x < size.width - dotRadius) {
      canvas.drawCircle(Offset(x, cy), dotRadius, dotPaint);
      x += dotRadius * 2 + 4;
    }
  }

  @override
  bool shouldRepaint(covariant _ThermostatDottedDividerPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Grey full ring + blue→purple→pink progress on a closed 360° path.
/// [percent] is [_thermostatSetPercent] (0 = 19 °C, 1 = 35 °C).
class _ThermostatRingPainter extends CustomPainter {
  const _ThermostatRingPainter({
    required this.strokeWidth,
    required this.percent,
  });

  final double strokeWidth;
  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double midRadius = size.shortestSide / 2 - strokeWidth / 2 - 2;
    final Rect arcRect = Rect.fromCircle(center: center, radius: midRadius);

    const double startAngle = _fullRingStart;

    final Paint trackPaint = Paint()
      ..color = kDeviceOffGreyFill
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, 0, _fullRingSweep, false, trackPaint);

    final double clamped = percent.clamp(0.0, 1.0);
    if (clamped <= 0.001) {
      return;
    }

    final double sweepAngle = clamped >= 0.999
        ? _fullRingSweep
        : _fullRingSweep * clamped;

    const SweepGradient gradient = SweepGradient(
      colors: <Color>[
        Color(0xFF4A9EFF), // blue  (cold — arc origin / left side)
        Color(0xFF9B5DE5), // purple
        Color(0xFFFF007C), // pink/magenta (hot — approaching arc origin)
        Color(0xFFFF007C), // hold pink
        Color(0xFF4A9EFF), // return to blue (seamless wrap)
      ],
      stops: <double>[0.0, 0.35, 0.62, 0.88, 1.0],
      transform: GradientRotation(startAngle),
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(arcRect);

    canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ThermostatRingPainter old) =>
      old.strokeWidth != strokeWidth || old.percent != percent;
}

/// Full grey ring + cyan→blue progress on a closed 360° path.
class _VentilationRingPainter extends CustomPainter {
  _VentilationRingPainter({required this.percent, required this.strokeWidth});

  final double percent;
  final double strokeWidth;

  static const List<Color> _gradientColors = <Color>[
    Color(0xFF15DFFE),
    Color(0xFF38A4FE), 
    
  ];
  static const List<double> _gradientStops = <double>[
    0.0,
    0.80,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _paintGradientFullRing(
      canvas,
      size,
      percent: percent,
      strokeWidth: strokeWidth,
      gradientColors: _gradientColors,
      gradientStops: _gradientStops,
    );
  }

  @override
  bool shouldRepaint(covariant _VentilationRingPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Hue spectrum disk + radial fade toward white (RGBW picker).
class _RgbHueWheelPainter extends CustomPainter {
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

    // White center → transparent edge: saturation increases toward the rim.
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

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.top, required this.bottom});

  final String top;
  final String bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          top,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          bottom,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _ChipPill extends StatelessWidget {
  const _ChipPill({
    required this.text,
    required this.bg,
    required this.border,
    required this.textColor,
  });

  final String text;
  final Color bg;
  final Color border;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: border, width: 1.2.w),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        uiTapHaptic();
        onTap();
      },
      child: Container(
        width: 30.w,
        height: 30.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFCBD5E1) : Colors.transparent,
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: active ? const Color(0xFF111827) : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
