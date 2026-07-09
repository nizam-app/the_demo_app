import 'dart:async';
import 'dart:io' show File;
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/core/utils/ui_tap_haptic.dart';
import 'package:workpleis/features/device_details/device_dashboard_sync.dart';
import 'package:workpleis/features/device_details/screen/device_details_screen.dart';

import '../../devices/screen/devices_screen.dart';
import '../../menu/screen/menu_screen.dart';
import '../../nav_bar/screen/custom_bottom_nav_bar.dart';
import '../../notifications/screen/notifications_screen.dart';
import '../../profile/screen/profile_screen.dart';
import '../../settings/screen/settings_screen.dart';
import '../widget/Add_section.dart';
import '../widget/add_dashboard_device_sheet.dart';
import '../widget/editAddSectionSheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  static void showEditAddSectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const EditAddSectionSheet(),
      ),
    );
  }

  static void showAddSectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const AddSectionSheet(),
      ),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _DashboardEditSection { light, lighting }

/// Scrollable dashboard blocks below the category pills (reorderable via Edit sheet).
enum _DashboardBlock { light, lighting, favorites, shading, chart }

class _AddedDashboardSection {
  _AddedDashboardSection({
    required this.id,
    required this.title,
    required List<String> deviceOrder,
    required this.horizontalScrolling,
    required String widgetSize,
    this.headerBackgroundPath,
  }) : deviceOrder = List<String>.from(deviceOrder),
       widgetSize = widgetSize;

  final int id;
  String title;
  List<String> deviceOrder;
  bool horizontalScrolling;
  String widgetSize;
  String? headerBackgroundPath;
}

class _HomeScreenState extends State<HomeScreen> {
  /// Dashboard category pills (0 Light … 3 Security).
  int _homeCategoryIndex = 0;
  int _brightnessPct = 50;

  double _bedroomDimmer = 0.72;
  double _bathroomThermostat = 24.6;
  int _awningDown = 0;
  int _awningUp = 72;

  /// Blind Living Room: left stat = level, right stat = angle (sync blindDown/blindUp).
  int _blindRoomLevel = 0;
  int _blindRoomAngle = 72;
  Timer? _blindMoveTimer;
  final List<int> _shadeDown = [100, 100, 100];
  final List<int> _shadeUp = [50, 50, 50];

  /// Shading list rows: manual (M) vs auto (A), matches prior static modes.
  final List<bool> _shadeManual = [true, false, true];
  double _favThermostatM = 24.6;
  double _favThermostatA = 24.6;

  /// A/M mode badges (tap to toggle auto vs manual) — dashboard + lighting.
  bool _bedroomManual = false;
  bool _bathroomManual = true;
  bool _awningManual = true;
  bool _blindManual = true;
  bool _irrigationManual = false;
  bool _motionSensorManual = false;
  bool _lightSceneManual = false;
  bool _rgbwManual = false;
  bool _lightingLedBadge1Manual = false;
  bool _heatingCoolingManual = false;
  bool _tunableWhiteManual = false;
  bool _ventilationManual = true;
  bool _fanLevelManual = false;
  bool _presenceManual = false;
  bool _livingRoomManual = true;
  bool _multiValueSwitchManual = false;
  bool _favThermoMManual = true;
  bool _favThermoAManual = false;

  /// 0 = neither circle "marked"; 1 = minus/down; 2 = plus/up (gray when marked).
  int _bathroomThermoMark = 0;
  int _awningMark = 0;
  int _blindRoomMark = 0;
  final List<int> _shadeStepMark = [0, 0, 0];
  int _favThermoMMark = 0;
  int _favThermoAMark = 0;

  bool _irrigationOn = true;
  bool _motionSensorOn = true;

  /// Dashboard section layouts: S=Shading, M=Favorites, L=Lighting, XL=Light.
  String _lightWidgetSize = 'XL';
  String _lightingWidgetSize = 'L';
  final Map<String, int> _lightingStepMark = <String, int>{};

  static const List<String> _kDefaultLightDeviceOrder = <String>[
    'light_dining',
    'bathroom_heat',
    'awning',
    'irrigation',
    'blind_living',
    'motion',
  ];

  static const List<String> _kDefaultLightingDeviceOrder = <String>[
    'light_scene',
    'rgbw',
    'led_dimmer',
    'heating_cooling',
    'tunable_white',
    'ventilation',
    'fan_level_3',
    'presence',
    'living_room',
    'multi_value_switch',
  ];

  static const List<String> _kAllDashboardDeviceOrder = <String>[
    ..._kDefaultLightDeviceOrder,
    ..._kDefaultLightingDeviceOrder,
  ];

  static const int _kDefaultDashboardSectionId = 1;

  List<String> _lightDeviceOrder = List<String>.from(_kDefaultLightDeviceOrder);
  List<String> _lightingDeviceOrder = List<String>.from(
    _kDefaultLightingDeviceOrder,
  );
  final List<String> _lightRemovedDevices = <String>[];
  final List<String> _lightingRemovedDevices = <String>[];

  String _lightSectionTitle = 'Light';
  String? _lightSectionHeaderImagePath;
  String? _lightingSectionHeaderImagePath;
  bool _lightHorizontalScroll = false;
  bool _lightingHorizontalScroll = false;
  _DashboardEditSection? _editingSection;
  int? _editingAddedSectionId;
  String? _selectedAddedDeviceId;
  int _nextAddedSectionId = 2;
  final List<_AddedDashboardSection> _addedSections =
      <_AddedDashboardSection>[
        _AddedDashboardSection(
          id: _kDefaultDashboardSectionId,
          title: 'Lighting',
          deviceOrder: _kAllDashboardDeviceOrder,
          horizontalScrolling: false,
          widgetSize: 'L',
        ),
      ];
  String? _selectedEditDeviceId;
  bool _showSectionEditButtons = false;
  bool _isAddDashboardSectionSheetOpen = false;
  String? _dashboardDraggingDeviceId;
  List<Object> _dashboardSectionOrder = <Object>[
    _kDefaultDashboardSectionId,
    _DashboardBlock.chart,
  ];
  final GlobalKey<CustomBottomNavBarState> _shellNavKey =
      GlobalKey<CustomBottomNavBarState>();

  late final VoidCallback _dashboardSyncListener;
  bool _suppressDashboardSyncPull = false;

  @override
  void initState() {
    super.initState();
    _pullFromDashboardSync();
    _dashboardSyncListener = () {
      if (mounted) _pullFromDashboardSync();
    };
    DeviceDashboardSync.instance.addListener(_dashboardSyncListener);
  }

  void _setShellBottomBarVisible(bool visible) {
    _shellNavKey.currentState?.setBottomBarVisible(visible);
  }

  @override
  void dispose() {
    _setShellBottomBarVisible(true);
    DeviceDashboardSync.instance.removeListener(_dashboardSyncListener);
    super.dispose();
  }

  void _pullFromDashboardSync() {
    if (_suppressDashboardSyncPull) return;
    final DeviceDashboardSync sync = DeviceDashboardSync.instance;
    setState(() {
      final DeviceControlSnapshot light = sync.snapshotFor(
        'Light dinning room',
      );
      _bedroomDimmer = light.isOn ? light.dimmerPercent.clamp(0.0, 1.0) : 0.0;

      final DeviceControlSnapshot bath = sync.snapshotFor(
        'Bathroom heating thermostat',
      );
      _bathroomThermostat = bath.thermostatCelsius;
      _irrigationOn = sync.snapshotFor('Irrigation entry').isOn;
      _motionSensorOn = sync.snapshotFor('Motion Sensor').isOn;

      final DeviceControlSnapshot awning = sync.snapshotFor(
        'Awning garden 123',
      );
      _awningDown = awning.blindDownPercent;
      _awningUp = awning.blindUpPercent;

      final DeviceControlSnapshot blind = sync.snapshotFor('Blind Living Room');
      _blindRoomLevel = blind.blindDownPercent;
      _blindRoomAngle = blind.blindUpPercent;
    });
  }
  //just update

  void _pushDashboardFor(String deviceTitle) {
    final DeviceControlSnapshot prev = DeviceDashboardSync.instance.snapshotFor(
      deviceTitle,
    );
    DeviceControlSnapshot next = prev;

    switch (DeviceDashboardSync.keyFor(deviceTitle)) {
      case 'light dinning room':
        next = prev.copyWith(
          dimmerPercent: _bedroomDimmer.clamp(0.0, 1.0),
          isOn: _bedroomDimmer > 0.001,
        );
        break;
      case 'bathroom heating thermostat':
        next = prev.copyWith(thermostatCelsius: _bathroomThermostat);
        break;
      case 'irrigation entry':
        next = prev.copyWith(isOn: _irrigationOn);
        break;
      case 'motion sensor':
        next = prev.copyWith(isOn: _motionSensorOn);
        break;
      case 'awning garden 123':
        next = prev.copyWith(
          blindDownPercent: 100 - _awningUp,
          blindUpPercent: _awningUp,
        );
        break;
      case 'blind living room':
        next = prev.copyWith(
          blindDownPercent: _blindRoomLevel,
          blindUpPercent: _blindRoomAngle,
        );
        break;
      default:
        return;
    }
    _suppressDashboardSyncPull = true;
    DeviceDashboardSync.instance.update(deviceTitle, next);
    _suppressDashboardSyncPull = false;
  }

  DeviceControlSnapshot _snap(String title) =>
      DeviceDashboardSync.instance.snapshotFor(title);

  bool _usesLargeWidgetRows(String size) => size == 'S';

  int _gridColumnsForWidgetSize(String size) {
    switch (size) {
      case 'M':
        return 3;
      case 'L':
        return 2;
      case 'XL':
      default:
        return 2;
    }
  }

  int _lightGridColumnsForWidgetSize(String size) {
    switch (size) {
      case 'S':
        return 1;
      case 'M':
        return 3;
      case 'L':
        return 2;
      case 'XL':
      default:
        return 2;
    }
  }

  double _lightCardHeightForWidgetSize(String size) {
    switch (size) {
      case 'XL':
        return 220.h;
      case 'M':
        return 150.h;
      case 'L':
        return 185.h;
      case 'S':
      default:
        return 150.h;
    }
  }

  double _lightHorizontalItemWidth(String size) {
    switch (size) {
      case 'XL':
        return 280.w;
      case 'M':
        return 120.w;
      case 'L':
        return 210.w;
      case 'S':
      default:
        return 320.w;
    }
  }

  double _lightingLargeRowHeightForWidgetSize(String size) => 90.h;

  bool get _lightingUsesLargeWidgets =>
      _usesLargeWidgetRows(_lightingWidgetSize);
  // S → full-width rows; M → three columns; L → two columns; XL → two large columns.

  double get _lightCardHeight =>
      _lightCardHeightForWidgetSize(_lightWidgetSize);

  void _patchSnap(
    String deviceTitle,
    DeviceControlSnapshot Function(DeviceControlSnapshot prev) patch,
  ) {
    DeviceDashboardSync.instance.update(
      deviceTitle,
      patch(DeviceDashboardSync.instance.snapshotFor(deviceTitle)),
    );
  }

  List<String> _deviceOrderFor(_DashboardEditSection section) =>
      section == _DashboardEditSection.light
      ? _lightDeviceOrder
      : _lightingDeviceOrder;

  List<String> _removedDevicesFor(_DashboardEditSection section) =>
      section == _DashboardEditSection.light
      ? _lightRemovedDevices
      : _lightingRemovedDevices;

  void _setDeviceOrderFor(_DashboardEditSection section, List<String> next) {
    if (section == _DashboardEditSection.light) {
      _lightDeviceOrder = List<String>.from(next);
    } else {
      _lightingDeviceOrder = List<String>.from(next);
    }
  }

  String _sectionRenameLabel(_DashboardEditSection section) =>
      section == _DashboardEditSection.light ? _lightSectionTitle : 'Lighting';

  String? _sectionHeaderImagePath(_DashboardEditSection section) =>
      section == _DashboardEditSection.light
      ? _lightSectionHeaderImagePath
      : _lightingSectionHeaderImagePath;

  void _setSectionHeaderImagePath(_DashboardEditSection section, String path) {
    if (section == _DashboardEditSection.light) {
      _lightSectionHeaderImagePath = path;
    } else {
      _lightingSectionHeaderImagePath = path;
    }
  }

  Future<void> _pickSectionHeaderImage(_DashboardEditSection section) async {
    final String? path = await _pickDashboardHeaderImagePath();
    if (!mounted || path == null) return;
    setState(() => _setSectionHeaderImagePath(section, path));
  }

  Future<String?> _pickDashboardHeaderImagePath() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_library_outlined),
                        title: Text(
                          'Choose from gallery',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                          ),
                        ),
                        onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.photo_camera_outlined),
                        title: Text(
                          'Take a photo',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                          ),
                        ),
                        onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (source == null || !mounted) return null;

    final XFile? file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (file == null || !mounted) return null;
    return file.path;
  }

  Future<String?> _promptDashboardSectionName(String currentName) async {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => _DashboardSectionNameDialog(initialName: currentName),
    );
  }

  Future<List<String>?> _pickDevicesForNewSection(
    List<String> current, {
    Set<String> disabledDeviceIds = const <String>{},
  }) async {
    final List<String>? picked = await showAddDashboardDeviceSheet(
      context,
      devices: _dashboardDeviceCatalog(),
      disabledDeviceIds: disabledDeviceIds,
      initialSelectedDeviceIds: current,
    );
    if (picked == null) return null;
    return picked;
  }

  void _showAddDashboardSectionSheet() {
    if (_isAddDashboardSectionSheetOpen ||
        _editingSection != null ||
        _editingAddedSectionId != null) {
      return;
    }

    _setShellBottomBarVisible(false);
    setState(() => _isAddDashboardSectionSheetOpen = true);
  }

  void _closeAddDashboardSectionSheet() {
    if (!mounted) return;
    _setShellBottomBarVisible(true);
    setState(() => _isAddDashboardSectionSheetOpen = false);
  }

  Widget _buildAddDashboardSectionOverlay() {
    if (!_isAddDashboardSectionSheetOpen) return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: AddSectionSheet(
                onClose: _closeAddDashboardSectionSheet,
                onNameRequested: _promptDashboardSectionName,
                onDevicesRequested: _pickDevicesForNewSection,
                onHeaderBackgroundRequested: _pickDashboardHeaderImagePath,
                onAdd: (AddSectionConfiguration configuration) {
                  setState(() {
                    final int sectionId = _nextAddedSectionId++;
                    _addedSections.add(
                      _AddedDashboardSection(
                        id: sectionId,
                        title: configuration.name,
                        deviceOrder: configuration.deviceIds,
                        horizontalScrolling: configuration.horizontalScrolling,
                        widgetSize: configuration.widgetSize,
                        headerBackgroundPath:
                            configuration.headerBackgroundPath,
                      ),
                    );
                    final int chartIndex = _dashboardSectionOrder.indexOf(
                      _DashboardBlock.chart,
                    );
                    _dashboardSectionOrder.insert(
                      chartIndex >= 0
                          ? chartIndex
                          : _dashboardSectionOrder.length,
                      sectionId,
                    );
                  });
                  _closeAddDashboardSectionSheet();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _DashboardBlock _blockForEditSection(_DashboardEditSection section) =>
      section == _DashboardEditSection.light
      ? _DashboardBlock.light
      : _DashboardBlock.lighting;

  bool _canMoveDashboardSection(_DashboardEditSection section, int delta) {
    final _DashboardBlock block = _blockForEditSection(section);
    final int index = _dashboardSectionOrder.indexOf(block);
    final int target = index + delta;
    return index >= 0 && target >= 0 && target < _dashboardSectionOrder.length;
  }

  void _moveDashboardSection(_DashboardEditSection section, int delta) {
    if (!_canMoveDashboardSection(section, delta)) return;
    final _DashboardBlock block = _blockForEditSection(section);
    final List<Object> order = List<Object>.from(_dashboardSectionOrder);
    final int index = order.indexOf(block);
    final int target = index + delta;
    order.removeAt(index);
    order.insert(target, block);
    setState(() => _dashboardSectionOrder = order);
  }

  void _removeDashboardSection(_DashboardEditSection section) {
    final _DashboardBlock block = _blockForEditSection(section);
    setState(() {
      _dashboardSectionOrder = _dashboardSectionOrder
          .where((Object item) => item != block)
          .toList(growable: false);
      _editingSection = null;
      _selectedEditDeviceId = null;
    });
    _setShellBottomBarVisible(true);
  }

  void _removeDeviceById(
    _DashboardEditSection section,
    String deviceId, {
    VoidCallback? onEmpty,
  }) {
    final List<String> order = List<String>.from(_deviceOrderFor(section));
    final int index = order.indexOf(deviceId);
    if (index < 0) return;
    order.removeAt(index);
    _removedDevicesFor(section).add(deviceId);
    setState(() {
      _setDeviceOrderFor(section, order);
      if (order.isEmpty) {
        _selectedEditDeviceId = null;
        onEmpty?.call();
      } else if (_selectedEditDeviceId == deviceId) {
        _selectedEditDeviceId = order[math.min(index, order.length - 1)];
      }
    });
  }

  void _removeSelectedDevice(
    _DashboardEditSection section,
    VoidCallback? onEmpty,
  ) {
    final String? id = _selectedEditDeviceId;
    if (id == null) return;
    _removeDeviceById(section, id, onEmpty: onEmpty);
  }

  DashboardAddDeviceOption _dashboardAddDeviceOption(String deviceId) {
    switch (deviceId) {
      case 'light_dining':
        final DeviceControlSnapshot light = _snap('Light dinning room');
        return DashboardAddDeviceOption(
          id: 'light_dining',
          title: 'Light dinning room',
          imagePath: light.isOn
              ? 'assets/Mask group (5).png'
              : 'assets/images/light_of.png',
        );
      case 'bathroom_heat':
        final DeviceControlSnapshot bathroom = _snap(
          'Bathroom heating thermostat',
        );
        return DashboardAddDeviceOption(
          id: 'bathroom_heat',
          title: 'Bathroom heating thermostat',
          imagePath: bathroom.isOn
              ? 'assets/Mask group (6).png'
              : 'assets/images/bathroom_off.png',
        );
      case 'awning':
        return DashboardAddDeviceOption(
          id: 'awning',
          title: 'Awning garden 123',
          imagePath: 'assets/Rectangle 823.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardAwningLevelIcon(level: 1.0),
          ),
        );
      case 'irrigation':
        return DashboardAddDeviceOption(
          id: 'irrigation',
          title: 'Irrigation entry',
          imagePath: _irrigationOn
              ? 'assets/Mask group (7).png'
              : 'assets/images/irrigation_of.png',
        );
      case 'blind_living':
        return DashboardAddDeviceOption(
          id: 'blind_living',
          title: 'Blind Living Room',
          imagePath: 'assets/Rectangle 823.png',
          iconWidget: dashboardLightingIconFrame(
            _HomeBlindSlatsIcon(level: 1.0, angle: 1.0),
          ),
        );
      case 'motion':
        return const DashboardAddDeviceOption(
          id: 'motion',
          title: 'Motion Sensor',
          imagePath: 'assets/images/update_sensor.png',
        );
      case 'light_scene':
        final DeviceControlSnapshot scene = _snap('Light Scene');
        return DashboardAddDeviceOption(
          id: 'light_scene',
          title: 'Light Scene',
          imagePath:
              'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardLightSceneIcon(sceneIndex: scene.sceneIndex),
          ),
        );
      case 'rgbw':
        final DeviceControlSnapshot rgbw = _snap('RGBW room abc');
        return DashboardAddDeviceOption(
          id: 'rgbw',
          title: 'RGBW room abc',
          imagePath:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardRgbwIcon(
              hue: rgbw.rgbwHue,
              saturation: rgbw.rgbwSaturation,
              intensity: rgbw.rgbwIntensity,
            ),
          ),
        );
      case 'led_dimmer':
        return DashboardAddDeviceOption(
          id: 'led_dimmer',
          title: 'LED Dimmer living room',
          imagePath:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardRingProgressIcon(
              percent: 1.0,
              ringStyle: DashboardRingStyle.led,
              labelFontSize: 10,
            ),
          ),
        );
      case 'heating_cooling':
        final DeviceControlSnapshot hvac = _snap('Heating & Cooling');
        return DashboardAddDeviceOption(
          id: 'heating_cooling',
          title: 'Heating & Cooling',
          imagePath: 'assets/images/heating_cooling.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardHeatingCoolingIcon(isOn: hvac.isOn),
          ),
        );
      case 'tunable_white':
        final DeviceControlSnapshot tunable = _snap('Tunable white light');
        return DashboardAddDeviceOption(
          id: 'tunable_white',
          title: 'Tunable white light',
          imagePath: 'assets/white_light.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardTunableWhiteIcon(
              dotDx: tunable.tunableWhiteDotDx,
              dotDy: tunable.tunableWhiteDotDy,
              intensity: tunable.tunableWhiteIntensity,
            ),
          ),
        );
      case 'ventilation':
        return DashboardAddDeviceOption(
          id: 'ventilation',
          title: 'Ventilation',
          imagePath: 'assets/images/ventilations.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardVentilationIcon(percent: 1.0, labelFontSize: 10),
          ),
        );
      case 'fan_level_3':
        final DeviceControlSnapshot fan = _snap('Fan Level 3');
        return DashboardAddDeviceOption(
          id: 'fan_level_3',
          title: 'Fan Level 3',
          imagePath: 'assets/images/Fun_level3.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardFanLevelIcon(level: fan.fanLevel),
          ),
        );
      case 'presence':
        final DeviceControlSnapshot presence = _snap('Presence');
        return DashboardAddDeviceOption(
          id: 'presence',
          title: 'Presence',
          imagePath: 'assets/images/comfort.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardPresenceModeIcon(
              modeIndex: presence.presenceModeIndex,
              isOn: presence.isOn,
            ),
          ),
        );
      case 'living_room':
        return DashboardAddDeviceOption(
          id: 'living_room',
          title: 'Living room',
          imagePath:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardThermostatRingIcon(percent: 1.0, labelFontSize: 10),
          ),
        );
      case 'multi_value_switch':
        final DeviceControlSnapshot multi = _snap('Multi-Value Switch');
        return DashboardAddDeviceOption(
          id: 'multi_value_switch',
          title: 'Multi-Value Switch',
          imagePath:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          iconWidget: dashboardLightingIconFrame(
            DashboardMultiValueSwitchIcon(
              selectedIndex: multi.multiValueSwitchIndex,
              isOn: multi.isOn,
            ),
          ),
        );
      default:
        return DashboardAddDeviceOption(
          id: deviceId,
          title: deviceId,
          imagePath: 'assets/images/sensor.png',
        );
    }
  }

  List<DashboardAddDeviceOption> _dashboardDeviceCatalog() {
    return <DashboardAddDeviceOption>[
      for (final String id in _kAllDashboardDeviceOrder)
        _dashboardAddDeviceOption(id),
    ];
  }

  Set<String> _disabledDeviceIdsForAddPicker(_DashboardEditSection section) {
    final Set<String> disabled = <String>{};
    final Set<String> sectionPool =
        (section == _DashboardEditSection.light
                ? _kDefaultLightDeviceOrder
                : _kDefaultLightingDeviceOrder)
            .toSet();
    for (final String id in _kAllDashboardDeviceOrder) {
      if (!sectionPool.contains(id)) disabled.add(id);
    }
    return disabled;
  }

  Future<void> _openAddDashboardDevicePicker(
    _DashboardEditSection section,
  ) async {
    final List<DashboardAddDeviceOption> catalog = _dashboardDeviceCatalog();
    final Set<String> disabled = _disabledDeviceIdsForAddPicker(section);
    final List<String> currentOrder = List<String>.from(
      _deviceOrderFor(section),
    );
    disabled.removeAll(currentOrder);

    final List<String>? picked = await showAddDashboardDeviceSheet(
      context,
      devices: catalog,
      disabledDeviceIds: disabled,
      initialSelectedDeviceIds: currentOrder,
    );
    if (!mounted || picked == null) return;

    setState(() {
      final List<String> removed = _removedDevicesFor(section);
      for (final String id in currentOrder) {
        if (!picked.contains(id)) removed.add(id);
      }
      for (final String id in picked) {
        removed.remove(id);
      }
      _setDeviceOrderFor(section, picked);
      _selectedEditDeviceId = picked.isEmpty ? null : picked.last;
    });
  }

  Future<void> _renameDashboardSection(_DashboardEditSection section) async {
    final String? next = await _promptDashboardSectionName(
      _sectionRenameLabel(section),
    );
    if (!mounted || next == null || next.isEmpty) return;
    setState(() {
      if (section == _DashboardEditSection.light) {
        _lightSectionTitle = next;
      }
    });
  }

  void _closeDashboardSectionEdit() {
    if (!mounted) return;
    _setShellBottomBarVisible(true);
    setState(() {
      _editingSection = null;
      _editingAddedSectionId = null;
      _selectedEditDeviceId = null;
      _selectedAddedDeviceId = null;
    });
  }

  void _toggleDashboardEditMode() {
    if (_isAddDashboardSectionSheetOpen) return;
    setState(() {
      _showSectionEditButtons = !_showSectionEditButtons;
      if (!_showSectionEditButtons) {
        _editingSection = null;
        _editingAddedSectionId = null;
        _selectedEditDeviceId = null;
        _selectedAddedDeviceId = null;
        _dashboardDraggingDeviceId = null;
        _setShellBottomBarVisible(true);
      }
    });
  }

  void _reorderDeviceInSection(
    _DashboardEditSection section,
    String draggedId,
    String targetId,
  ) {
    if (draggedId == targetId) return;
    final List<String> order = List<String>.from(_deviceOrderFor(section));
    final int fromIndex = order.indexOf(draggedId);
    final int toIndex = order.indexOf(targetId);
    if (fromIndex < 0 || toIndex < 0) return;
    order.removeAt(fromIndex);
    order.insert(toIndex, draggedId);
    setState(() {
      _setDeviceOrderFor(section, order);
      _selectedEditDeviceId = draggedId;
    });
  }

  double _dashboardDragFeedbackWidth(_DashboardEditSection section) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    if (section == _DashboardEditSection.light) {
      if (_lightWidgetSize == 'S') return screenWidth - 32.w;
      if (_lightHorizontalScroll) {
        return _lightHorizontalItemWidth(_lightWidgetSize);
      }
      final int cols = _lightGridColumnsForWidgetSize(_lightWidgetSize);
      return (screenWidth - 32.w - (cols - 1) * 12.w) / cols;
    }
    if (_lightingUsesLargeWidgets) return screenWidth - 32.w;
    if (_lightingHorizontalScroll) {
      return _lightHorizontalItemWidth(_lightingWidgetSize);
    }
    final int cols = _gridColumnsForWidgetSize(_lightingWidgetSize);
    return (screenWidth - 32.w - (cols - 1) * 12.w) / cols;
  }

  double _dashboardDragFeedbackHeight(_DashboardEditSection section) {
    if (section == _DashboardEditSection.light) {
      if (_lightWidgetSize == 'S') return 90.h;
      return _lightCardHeight;
    }
    if (_lightingUsesLargeWidgets) {
      return _lightingLargeRowHeightForWidgetSize(_lightingWidgetSize);
    }
    return _lightCardHeightForWidgetSize(_lightingWidgetSize);
  }

  void _openDashboardSectionEdit(
    BuildContext context,
    _DashboardEditSection section,
  ) {
    if (_isAddDashboardSectionSheetOpen || _editingAddedSectionId != null) {
      return;
    }
    _setShellBottomBarVisible(false);
    final List<String> order = _deviceOrderFor(section);
    setState(() {
      _editingSection = section;
      _selectedEditDeviceId ??= order.isNotEmpty ? order.first : null;
      if (_selectedEditDeviceId != null &&
          !order.contains(_selectedEditDeviceId)) {
        _selectedEditDeviceId = order.isNotEmpty ? order.first : null;
      }
    });
  }

  Widget _buildDashboardEditOverlay() {
    final _DashboardEditSection? section = _editingSection;
    if (section == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0.h,
            child: SafeArea(
              top: false,
              child: EditAddSectionSheet(
                onClose: _closeDashboardSectionEdit,
                sectionRenameLabel: _sectionRenameLabel(section),
                onRenameTap: () => _renameDashboardSection(section),
                onAddDeviceTap: () => _openAddDashboardDevicePicker(section),
                onHeaderBackgroundTap: () => _pickSectionHeaderImage(section),
                headerBackgroundImagePath: _sectionHeaderImagePath(section),
                onMoveUp: () => _moveDashboardSection(section, -1),
                onMoveDown: () => _moveDashboardSection(section, 1),
                canMoveUp: _canMoveDashboardSection(section, -1),
                canMoveDown: _canMoveDashboardSection(section, 1),
                onRemove: () => _removeDashboardSection(section),
                initialHorizontalScroll: section == _DashboardEditSection.light
                    ? _lightHorizontalScroll
                    : _lightingHorizontalScroll,
                onHorizontalScrollChanged: (v) => setState(() {
                  if (section == _DashboardEditSection.light) {
                    _lightHorizontalScroll = v;
                  } else {
                    _lightingHorizontalScroll = v;
                  }
                }),
                showWidgetSize: true,
                initialSize: section == _DashboardEditSection.light
                    ? _lightWidgetSize
                    : _lightingWidgetSize,
                onSizeChanged: (v) => setState(() {
                  if (section == _DashboardEditSection.light) {
                    _lightWidgetSize = v;
                  } else {
                    _lightingWidgetSize = v;
                  }
                  final List<String> order = _deviceOrderFor(section);
                  _selectedEditDeviceId = order.isEmpty ? null : order.first;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLightSectionEdit(BuildContext context) =>
      _openDashboardSectionEdit(context, _DashboardEditSection.light);

  void _showLightingSectionEdit(BuildContext context) =>
      _openDashboardSectionEdit(context, _DashboardEditSection.lighting);

  _AddedDashboardSection? _addedSectionById(int? id) {
    if (id == null) return null;
    for (final _AddedDashboardSection section in _addedSections) {
      if (section.id == id) return section;
    }
    return null;
  }

  void _openAddedSectionEdit(_AddedDashboardSection section) {
    if (_isAddDashboardSectionSheetOpen || _editingSection != null) {
      return;
    }
    _setShellBottomBarVisible(false);
    setState(() {
      _editingSection = null;
      _editingAddedSectionId = section.id;
      _selectedAddedDeviceId = section.deviceOrder.isEmpty
          ? null
          : section.deviceOrder.first;
    });
  }

  Future<void> _renameAddedSection(_AddedDashboardSection section) async {
    final String? next = await _promptDashboardSectionName(section.title);
    if (!mounted || next == null || next.isEmpty) return;
    setState(() => section.title = next);
  }

  Future<void> _addDevicesToAddedSection(_AddedDashboardSection section) async {
    final List<String>? next = await _pickDevicesForNewSection(
      section.deviceOrder,
    );
    if (!mounted || next == null) return;
    setState(() {
      section.deviceOrder = List<String>.from(next);
      _selectedAddedDeviceId = next.isEmpty ? null : next.last;
    });
  }

  Future<void> _pickAddedSectionHeader(_AddedDashboardSection section) async {
    final String? path = await _pickDashboardHeaderImagePath();
    if (!mounted || path == null) return;
    setState(() => section.headerBackgroundPath = path);
  }

  bool _canMoveAddedSection(_AddedDashboardSection section, int delta) {
    final int index = _dashboardSectionOrder.indexOf(section.id);
    if (index < 0) return false;
    final int target = index + delta;
    if (target < 0) return false;
    final int chartIndex = _dashboardSectionOrder.indexOf(
      _DashboardBlock.chart,
    );
    if (chartIndex >= 0 && target >= chartIndex) return false;
    return target < _dashboardSectionOrder.length;
  }

  void _moveAddedSection(_AddedDashboardSection section, int delta) {
    if (!_canMoveAddedSection(section, delta)) return;
    final List<Object> order = List<Object>.from(_dashboardSectionOrder);
    final int index = order.indexOf(section.id);
    final int target = index + delta;
    final Object moved = order.removeAt(index);
    order.insert(target, moved);
    setState(() {
      _dashboardSectionOrder = order;
      _editingAddedSectionId = section.id;
    });
  }

  void _removeAddedSection(_AddedDashboardSection section) {
    setState(() {
      _addedSections.remove(section);
      _dashboardSectionOrder = _dashboardSectionOrder
          .where((Object item) => item != section.id)
          .toList(growable: false);
      _editingAddedSectionId = null;
      _selectedAddedDeviceId = null;
    });
    _setShellBottomBarVisible(true);
  }

  Widget _buildAddedSectionEditOverlay() {
    final _AddedDashboardSection? section = _addedSectionById(
      _editingAddedSectionId,
    );
    if (section == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: EditAddSectionSheet(
                onClose: _closeDashboardSectionEdit,
                sectionRenameLabel: section.title,
                onRenameTap: () => _renameAddedSection(section),
                onAddDeviceTap: () => _addDevicesToAddedSection(section),
                addDeviceCountLabel: section.deviceOrder.isEmpty
                    ? null
                    : '${section.deviceOrder.length}',
                onHeaderBackgroundTap: () => _pickAddedSectionHeader(section),
                headerBackgroundImagePath: section.headerBackgroundPath,
                onMoveUp: () => _moveAddedSection(section, -1),
                onMoveDown: () => _moveAddedSection(section, 1),
                canMoveUp: _canMoveAddedSection(section, -1),
                canMoveDown: _canMoveAddedSection(section, 1),
                onRemove: () => _removeAddedSection(section),
                initialHorizontalScroll: section.horizontalScrolling,
                onHorizontalScrollChanged: (value) =>
                    setState(() => section.horizontalScrolling = value),
                initialSize: section.widgetSize,
                onSizeChanged: (value) => setState(() {
                  section.widgetSize = value;
                  _selectedAddedDeviceId = section.deviceOrder.isEmpty
                      ? null
                      : section.deviceOrder.first;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeAddedDevice(_AddedDashboardSection section, String deviceId) {
    setState(() {
      section.deviceOrder = section.deviceOrder
          .where((id) => id != deviceId)
          .toList();
      if (_selectedAddedDeviceId == deviceId) {
        _selectedAddedDeviceId = section.deviceOrder.isEmpty
            ? null
            : section.deviceOrder.first;
      }
    });
  }

  void _reorderAddedDevice(
    _AddedDashboardSection section,
    String draggedId,
    String targetId,
  ) {
    if (draggedId == targetId) return;
    final List<String> order = List<String>.from(section.deviceOrder);
    final int from = order.indexOf(draggedId);
    final int to = order.indexOf(targetId);
    if (from < 0 || to < 0) return;
    order.removeAt(from);
    order.insert(to, draggedId);
    setState(() {
      section.deviceOrder = order;
      _selectedAddedDeviceId = draggedId;
    });
  }

  Widget _wrapAddedDeviceCell(
    _AddedDashboardSection section,
    String deviceId,
    Widget child,
  ) {
    Widget result = child;
    if (_editingAddedSectionId == section.id) {
      final bool selected = _selectedAddedDeviceId == deviceId;
      result = Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedAddedDeviceId = deviceId),
            child: child,
          ),
          if (selected)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.r),
                    border: Border.all(
                      color: const Color(0xFF00E5FF),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: -6.h,
            right: -6.w,
            child: GestureDetector(
              onTap: () => _removeAddedDevice(section, deviceId),
              child: Image.asset(
                'assets/images/cross.png',
                width: 26.w,
                height: 26.h,
              ),
            ),
          ),
        ],
      );
    }

    final bool isEditingThisAddedSection = _editingAddedSectionId == section.id;
    final bool shouldAnimateEdit =
        _showSectionEditButtons || isEditingThisAddedSection;
    if (!shouldAnimateEdit) return result;
    return _DashboardShakeWrapper(
      shaking: _dashboardDraggingDeviceId != deviceId,
      child: _DashboardDraggableReorderSlot(
        deviceId: deviceId,
        feedbackWidth: _addedSectionItemWidth(section),
        feedbackHeight: _addedSectionItemHeight(section, deviceId),
        onDragStarted: () =>
            setState(() => _dashboardDraggingDeviceId = deviceId),
        onDragEnded: () => setState(() => _dashboardDraggingDeviceId = null),
        onReorder: (draggedId) =>
            _reorderAddedDevice(section, draggedId, deviceId),
        child: result,
      ),
    );
  }

  double _addedSectionItemWidth(_AddedDashboardSection section) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    if (section.widgetSize == 'S') return screenWidth - 32.w;
    if (section.horizontalScrolling) {
      return _lightHorizontalItemWidth(section.widgetSize);
    }
    final int columns = _lightGridColumnsForWidgetSize(section.widgetSize);
    return (screenWidth - 32.w - (columns - 1) * 12.w) / columns;
  }

  double _addedSectionItemHeight(
    _AddedDashboardSection section,
    String deviceId,
  ) {
    if (section.widgetSize == 'S') {
      return _lightingLargeRowHeightForWidgetSize(section.widgetSize);
    }
    if (_isLightingDevice(deviceId)) {
      if (section.widgetSize == 'S') {
        return _lightingLargeRowHeightForWidgetSize(section.widgetSize);
      }
      return _lightCardHeightForWidgetSize(section.widgetSize);
    }
    return _lightCardHeightForWidgetSize(section.widgetSize);
  }

  bool _isLightingDevice(String deviceId) =>
      _kDefaultLightingDeviceOrder.contains(deviceId);

  Widget _buildAddedDevice(_AddedDashboardSection section, String deviceId) {
    final String size = section.widgetSize;
    final double cardHeight = _lightCardHeightForWidgetSize(size);

    if (size == 'S') {
      return _isLightingDevice(deviceId)
          ? _buildLightingLargeRowById(deviceId)
          : _buildLightLargeRowById(deviceId);
    }

    if (_isLightingDevice(deviceId)) {
      return _buildLightingSmallCardById(
        deviceId,
        uniformControlSlot: true,
        cardHeightOverride: cardHeight,
        compactOverride: size == 'M',
      );
    }
    return _buildLightDeviceCard(
      deviceId,
      widgetSize: size,
      uniformControls: true,
    );
  }

  Widget _buildAddedSectionDevices(_AddedDashboardSection section) {
    final List<String> ids = section.deviceOrder;
    if (ids.isEmpty) {
      return SizedBox(
        height: 72.h,
        child: Center(
          child: Text(
            'No devices',
            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF6B7280)),
          ),
        ),
      );
    }

    if (section.widgetSize == 'S') {
      return Column(
        children: [
          for (int i = 0; i < ids.length; i++) ...[
            if (i > 0) SizedBox(height: 12.h),
            _wrapAddedDeviceCell(
              section,
              ids[i],
              _buildAddedDevice(section, ids[i]),
            ),
          ],
        ],
      );
    }

    if (section.horizontalScrolling) {
      return SizedBox(
        height: _lightCardHeightForWidgetSize(section.widgetSize),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          itemCount: ids.length,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (_, index) {
            final String id = ids[index];
            return SizedBox(
              width: _lightHorizontalItemWidth(section.widgetSize),
              child: _wrapAddedDeviceCell(
                section,
                id,
                _buildAddedDevice(section, id),
              ),
            );
          },
        ),
      );
    }

    final int columns = _lightGridColumnsForWidgetSize(section.widgetSize);
    return Column(
      children: [
        for (int i = 0; i < ids.length; i += columns) ...[
          if (i > 0) SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int col = 0; col < columns; col++) ...[
                if (col > 0) SizedBox(width: 12.w),
                Expanded(
                  child: i + col < ids.length
                      ? _wrapAddedDeviceCell(
                          section,
                          ids[i + col],
                          _buildAddedDevice(section, ids[i + col]),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  List<Widget> _buildAddedSectionWidgets(_AddedDashboardSection section) {
    return <Widget>[
      _SectionTitle(
        section.title,
        showEditButton: _showSectionEditButtons,
        onEditTap: () => _openAddedSectionEdit(section),
        headerBackgroundImagePath: section.headerBackgroundPath,
      ),
      SizedBox(height: 12.h),
      _buildAddedSectionDevices(section),
    ];
  }

  List<Widget> _buildOrderedDashboardBlocks(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (final Object entry in _dashboardSectionOrder) {
      final List<Widget> entryWidgets;
      if (entry is _DashboardBlock) {
        entryWidgets = _widgetsForDashboardBlock(context, entry);
      } else if (entry is int) {
        final _AddedDashboardSection? section = _addedSectionById(entry);
        if (section == null) continue;
        entryWidgets = _buildAddedSectionWidgets(section);
      } else {
        continue;
      }
      if (children.isNotEmpty) {
        children.add(SizedBox(height: 18.h));
      }
      children.addAll(entryWidgets);
    }
    children.add(SizedBox(height: 70.h));
    return children;
  }

  List<Widget> _widgetsForDashboardBlock(
    BuildContext context,
    _DashboardBlock block,
  ) {
    switch (block) {
      case _DashboardBlock.light:
        return <Widget>[
          _SectionTitle(
            _lightSectionTitle,
            showEditButton: _showSectionEditButtons,
            onEditTap: () => _showLightSectionEdit(context),
            headerBackgroundImagePath: _lightSectionHeaderImagePath,
          ),
          SizedBox(height: 12.h),
          _buildLightSectionDevices(),
        ];
      case _DashboardBlock.lighting:
        return <Widget>[
          _SectionTitle(
            'Lighting',
            showEditButton: _showSectionEditButtons,
            onEditTap: () => _showLightingSectionEdit(context),
            headerBackgroundImagePath: _lightingSectionHeaderImagePath,
          ),
          SizedBox(height: 12.h),
          _buildLightingSectionCards(),
        ];
      case _DashboardBlock.favorites:
        return <Widget>[_buildFavoritesSection()];
      case _DashboardBlock.shading:
        return <Widget>[_buildShadingSection()];
      case _DashboardBlock.chart:
        return <Widget>[
          const _SectionTitle('Chart Section'),
          SizedBox(height: 12.h),
          _ChartCard(),
        ];
    }
  }

  Widget _wrapDashboardDeviceCell({
    required _DashboardEditSection section,
    required String deviceId,
    required Widget child,
  }) {
    final Widget editSafeChild = _showSectionEditButtons
        ? AbsorbPointer(child: child)
        : child;
    Widget cell = _wrapDashboardEditTarget(
      section: section,
      deviceId: deviceId,
      child: editSafeChild,
    );
    if (!_showSectionEditButtons) return cell;

    return _DashboardShakeWrapper(
      shaking: _dashboardDraggingDeviceId != deviceId,
      child: _DashboardDraggableReorderSlot(
        deviceId: deviceId,
        feedbackWidth: _dashboardDragFeedbackWidth(section),
        feedbackHeight: _dashboardDragFeedbackHeight(section),
        onDragStarted: () =>
            setState(() => _dashboardDraggingDeviceId = deviceId),
        onDragEnded: () => setState(() => _dashboardDraggingDeviceId = null),
        onReorder: (String draggedId) =>
            _reorderDeviceInSection(section, draggedId, deviceId),
        child: cell,
      ),
    );
  }

  Widget _wrapDashboardEditTarget({
    required _DashboardEditSection section,
    required String deviceId,
    required Widget child,
  }) {
    if (_editingSection != section) return child;
    final bool selected = _selectedEditDeviceId == deviceId;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedEditDeviceId = deviceId),
          behavior: HitTestBehavior.opaque,
          child: child,
        ),
        if (selected)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                ),
              ),
            ),
          ),
        Positioned(
          top: -6.h,
          right: -6.w,
          child: GestureDetector(
            onTap: () => _removeDeviceById(
              section,
              deviceId,
              onEmpty: _closeDashboardSectionEdit,
            ),
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              'assets/images/cross.png',
              width: 26.w,
              height: 26.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  /// Blind Living Room: short ↓ close angle +10, short ↑ open angle −10;
  /// long ↓ level 100%, long ↑ level 0%.
  void _blindLivingRoomAdjustAngle(int delta) {
    setState(() {
      _blindRoomAngle = (_blindRoomAngle + delta).clamp(0, 100);
    });
    _pushDashboardFor('Blind Living Room');
  }

  void _blindLivingRoomSetLevel(int percent) {
    setState(() {
      _blindRoomLevel = percent.clamp(0, 100);
    });
    _pushDashboardFor('Blind Living Room');
  }

  void _startBlindLevelChange(bool down) {
    _blindMoveTimer?.cancel();
    _blindMoveTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      setState(() {
        if (down) {
          _blindRoomLevel = (_blindRoomLevel + 5).clamp(0, 100);
        } else {
          _blindRoomLevel = (_blindRoomLevel - 5).clamp(0, 100);
        }
      });
      _pushDashboardFor('Blind Living Room');
      if (_blindRoomLevel >= 100 || _blindRoomLevel <= 0) {
        _stopBlindLevelChange();
      }
    });
  }

  void _stopBlindLevelChange() {
    _blindMoveTimer?.cancel();
    _blindMoveTimer = null;
  }

  /// Awning dashboard: ↓ extends (level↑), ↑ retracts (level↓); long = 100% / 0%.
  void _awningAdjustLevel(int delta) {
    _awningUp = (_awningUp + delta).clamp(0, 100);
    _awningDown = 100 - _awningUp;
    _pushDashboardFor('Awning garden 123');
  }

  void _awningSetLevel(int percent) {
    _awningUp = percent.clamp(0, 100);
    _awningDown = 100 - _awningUp;
    _pushDashboardFor('Awning garden 123');
  }

  void _flashMark({
    required int value,
    required int Function() getCurrent,
    required void Function(int v) set,
    VoidCallback? action,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    setState(() => set(value));
    action?.call();
    if (action != null && mounted) {
      setState(() {});
    }
    Future.delayed(duration, () {
      if (!mounted) return;
      if (getCurrent() == value) {
        setState(() => set(0));
      }
    });
  }

  Widget _buildHomeBody(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final headerChrome = 56.h;
    final scrollTopPadding = topInset + headerChrome + 10.h;
    final double editSheetInset =
        (_editingSection != null || _editingAddedSectionId != null) ? 360.h : 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    scrollTopPadding,
                    16.w,
                    24.h + editSheetInset,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Category pills (Light selected)
                        SizedBox(
                          height: 63.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            // padding: EdgeInsets.symmetric(horizontal: 12.w),
                            children: [
                              _CategoryPill(
                                label: 'Light',
                                isSelected: _homeCategoryIndex == 0,
                                icon: Icons.lightbulb_outline,
                                imagePath: 'assets/Mask group (3).png',
                                onTap: () =>
                                    setState(() => _homeCategoryIndex = 0),
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'Shading',
                                isSelected: _homeCategoryIndex == 1,
                                icon: Icons.blinds_outlined,
                                imagePath: 'assets/Mask group (2).png',
                                onTap: () =>
                                    setState(() => _homeCategoryIndex = 1),
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'HVAC',
                                isSelected: _homeCategoryIndex == 2,
                                icon: Icons.ac_unit_outlined,
                                imagePath: 'assets/Mask group (4).png',
                                onTap: () =>
                                    setState(() => _homeCategoryIndex = 2),
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'Security',
                                isSelected: _homeCategoryIndex == 3,
                                icon: Icons.ac_unit_outlined,
                                imagePath: 'assets/securety.png',
                                onTap: () =>
                                    setState(() => _homeCategoryIndex = 3),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        ..._buildOrderedDashboardBlocks(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFFE5E7EB).withOpacity(0.18),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        15.w,
                        topInset + 10.h,
                        15.w,
                        8.h,
                      ),
                      child: Builder(
                        builder: (ctx) => _Header(
                          onMenuTap: () {
                            ctx.push(MenuScreen.routeName);
                          },
                          onEditTap: _toggleDashboardEditMode,
                          onAddTap: _showAddDashboardSectionSheet,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isAddDashboardSectionSheetOpen)
              _buildAddDashboardSectionOverlay(),
            if (_editingSection != null) _buildDashboardEditOverlay(),
            if (_editingAddedSectionId != null) _buildAddedSectionEditOverlay(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      key: _shellNavKey,
      initialIndex: 2,
      translucentBottomBar: true,
      bottomBarBackgroundOpacity: 0,
      backgroundColor: Colors.white,
      children: [
        // Index 0: Devices
        RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        // Index 1: Analytics (single shell nav: no second bottom bar)
        const RepaintBoundary(child: AnalyticsScreen(showBottomNav: false)),
        // Index 2: Home/Voice
        RepaintBoundary(child: _buildHomeBody(context)),
        // Index 3: Notifications
        RepaintBoundary(child: NotificationsScreen(showBottomNav: true)),
        // Index 4: Settings
        const RepaintBoundary(child: SettingsScreen()),
      ],
    );
  }

  Widget _buildShadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Shading'),
        SizedBox(height: 12.h),
        _buildShadingControl(
          rowIndex: 0,
          deviceName: 'Blind Living Room south window upside right',
        ),
        SizedBox(height: 12.h),
        _buildShadingControl(
          rowIndex: 1,
          deviceName: 'Blind Living Room south window upside right',
        ),
        SizedBox(height: 12.h),
        _buildShadingControl(
          rowIndex: 2,
          deviceName: 'Blind Living Room south window upside right',
        ),
        SizedBox(height: 18.h),
        // _buildTemperatureSetPointCard(),
      ],
    );
  }

  Widget _buildShadingControl({
    required int rowIndex,
    required String deviceName,
  }) {
    final bool manual = _shadeManual[rowIndex];
    final downPercent = _shadeDown[rowIndex];
    final upPercent = _shadeUp[rowIndex];
    return Container(
      height: 90.h, // ✅ slimmer like image
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26.r),
      ),
      padding: EdgeInsets.only(left: 8.w, top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Left icon (smaller & centered)
          Image.asset(
            'assets/Rectangle 823.png',
            width: 70.w,
            height: 75.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14.w),

          // ✅ Middle (2 lines title + indicators)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 16.sp, // ✅ bigger like image
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                    height: 1.08,
                  ),
                  maxLines: 2, // ✅ 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                Row(
                  children: [
                    _ModeBadge(
                      mode: manual ? 'M' : 'A',
                      filled: manual,
                      onTap: () =>
                          setState(() => _shadeManual[rowIndex] = !manual),
                    ),
                    SizedBox(width: 10.w),
                    Image.asset(
                      'assets/Group 32.jpg', // down icon
                      width: 12.w,
                      height: 19.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$downPercent%',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    SizedBox(width: 14.w),

                    Image.asset(
                      'assets/Vector 4.jpg', // up icon
                      width: 10.w,
                      height: 19.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$upPercent%',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h, right: 10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CircleBtn(
                    size: 35,
                    marked: _shadeStepMark[rowIndex] == 1,
                    onTap: () => _flashMark(
                      value: 1,
                      getCurrent: () => _shadeStepMark[rowIndex],
                      set: (v) => _shadeStepMark[rowIndex] = v,
                      action: () => _shadeDown[rowIndex] =
                          (_shadeDown[rowIndex] - 5).clamp(0, 100),
                    ),
                    child: Image.asset(
                      'assets/Mask group (17).png',
                      width: 13.w,
                      height: 13.h,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(width: 17.w),
                  _CircleBtn(
                    size: 35,
                    marked: _shadeStepMark[rowIndex] == 2,
                    onTap: () => _flashMark(
                      value: 2,
                      getCurrent: () => _shadeStepMark[rowIndex],
                      set: (v) => _shadeStepMark[rowIndex] = v,
                      action: () => _shadeUp[rowIndex] =
                          (_shadeUp[rowIndex] + 5).clamp(0, 100),
                    ),
                    child: Transform.rotate(
                      angle: math.pi,
                      child: Image.asset(
                        'assets/Mask group (17).png',
                        width: 13.w,
                        height: 13.h,
                        color: const Color(0xFF6B7280),
                      ),
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

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Favorites'),
        SizedBox(height: 12.h),

        // Row 1
        Row(
          children: [
            Expanded(child: _buildCameraCard()), // ✅ equal
            SizedBox(width: 12.w),
            Expanded(
              child: _buildThermostatCard(
                mode: _favThermoMManual ? 'M' : 'A',
                filled: _favThermoMManual,
                value: _favThermostatM,
                minusMarked: _favThermoMMark == 1,
                plusMarked: _favThermoMMark == 2,
                onModeTap: () =>
                    setState(() => _favThermoMManual = !_favThermoMManual),
                onMinus: () => _flashMark(
                  value: 1,
                  getCurrent: () => _favThermoMMark,
                  set: (v) => _favThermoMMark = v,
                  action: () => _favThermostatM = (_favThermostatM - 0.5).clamp(
                    10.0,
                    35.0,
                  ),
                ),
                onPlus: () => _flashMark(
                  value: 2,
                  getCurrent: () => _favThermoMMark,
                  set: (v) => _favThermoMMark = v,
                  action: () => _favThermostatM = (_favThermostatM + 0.5).clamp(
                    10.0,
                    35.0,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Row 2
        Row(
          children: [
            Expanded(child: _buildCameraCard()),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildThermostatCard(
                mode: _favThermoAManual ? 'M' : 'A',
                filled: _favThermoAManual,
                value: _favThermostatA,
                minusMarked: _favThermoAMark == 1,
                plusMarked: _favThermoAMark == 2,
                onModeTap: () =>
                    setState(() => _favThermoAManual = !_favThermoAManual),
                onMinus: () => _flashMark(
                  value: 1,
                  getCurrent: () => _favThermoAMark,
                  set: (v) => _favThermoAMark = v,
                  action: () => _favThermostatA = (_favThermostatA - 0.5).clamp(
                    10.0,
                    35.0,
                  ),
                ),
                onPlus: () => _flashMark(
                  value: 2,
                  getCurrent: () => _favThermoAMark,
                  set: (v) => _favThermoAMark = v,
                  action: () => _favThermostatA = (_favThermostatA + 0.5).clamp(
                    10.0,
                    35.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCameraCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: SizedBox(
        height: 144.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/328a2c5e933681916f5ce64c1952942a7ea4e97e.png',
              fit: BoxFit.cover,
            ),

            // Blue overlay with 40% opacity
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0175F0).withOpacity(0.4),
                borderRadius: BorderRadius.circular(26.r),
              ),
            ),

            Positioned(
              left: 16.w,
              top: 18.h,
              child: Text(
                'Front Door\nCamera',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.05,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThermostatCard({
    required String mode,
    required bool filled,
    required double value,
    bool minusMarked = false,
    bool plusMarked = false,
    VoidCallback? onModeTap,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Stack(
      children: [
        Container(
          height: 144.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(26.r),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/IMG_0274 1.png',
                width: 34.w,
                height: 34.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8.h),
              Text(
                'Bedroom Thermostat parents room',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF111827),
                  height: 1.12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  _CircleBtn(
                    marked: minusMarked,
                    onTap: onMinus,
                    size: 35,
                    child: Icon(
                      Icons.remove,
                      size: 20.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${value.toStringAsFixed(1)}°c',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                  _CircleBtn(
                    marked: plusMarked,
                    onTap: onPlus,
                    size: 35,
                    child: Icon(
                      Icons.add,
                      size: 20.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(mode: mode, filled: filled, onTap: onModeTap),
        ),
      ],
    );
  }

  Widget _buildLightSectionDevices() {
    final List<String> ids = _deviceOrderFor(_DashboardEditSection.light);
    if (ids.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_lightWidgetSize == 'S') {
      return Column(
        children: [
          for (int i = 0; i < ids.length; i++) ...[
            if (i > 0) SizedBox(height: 12.h),
            _wrapDashboardDeviceCell(
              section: _DashboardEditSection.light,
              deviceId: ids[i],
              child: _buildLightLargeRowById(ids[i]),
            ),
          ],
        ],
      );
    }

    if (_lightHorizontalScroll) {
      return SizedBox(
        height: _lightCardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: ids.length,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final String id = ids[index];
            return SizedBox(
              width: _lightHorizontalItemWidth(_lightWidgetSize),
              child: _wrapDashboardDeviceCell(
                section: _DashboardEditSection.light,
                deviceId: id,
                child: _buildLightDeviceCard(id),
              ),
            );
          },
        ),
      );
    }

    final int columns = _lightGridColumnsForWidgetSize(_lightWidgetSize);
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < ids.length; i += columns) {
      if (i > 0) rows.add(SizedBox(height: 12.h));
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int col = 0; col < columns; col++) ...[
              if (col > 0) SizedBox(width: 12.w),
              Expanded(
                child: i + col < ids.length
                    ? _wrapDashboardDeviceCell(
                        section: _DashboardEditSection.light,
                        deviceId: ids[i + col],
                        child: _buildLightDeviceCard(ids[i + col]),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildLightLargeRowById(String deviceId) {
    final bool editing =
        _editingSection == _DashboardEditSection.light ||
        _showSectionEditButtons;
    VoidCallback? detailsTap(VoidCallback action) => editing ? null : action;

    switch (deviceId) {
      case 'light_dining':
        final DeviceControlSnapshot light = _snap('Light dinning room');
        return _buildLightingLargeRow(
          icon: Image.asset(
            light.isOn
                ? 'assets/Mask group (5).png'
                : 'assets/images/light_of.png',
            fit: BoxFit.contain,
          ),
          deviceName: 'Light dinning room',
          statusText: '${(_bedroomDimmer * 100).round()}%',
          mode: _bedroomManual ? 'M' : 'A',
          modeFilled: _bedroomManual,
          onModeTap: editing
              ? null
              : () => setState(() => _bedroomManual = !_bedroomManual),
          controls: _buildLightingSwitchControl(
            value: _bedroomDimmer > 0.001,
            onChanged: (v) {
              setState(() {
                _bedroomDimmer = v ? 1.0 : 0.0;
              });
              _pushDashboardFor('Light dinning room');
            },
          ),
          onNavigate: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Light dinning room',
              imageAssetPath: 'assets/Mask group (5).png',
              controlButtonCount: 1,
            ),
          ),
        );
      case 'bathroom_heat':
        final DeviceControlSnapshot bathroom = _snap(
          'Bathroom heating thermostat',
        );
        return _buildLightingLargeRow(
          icon: Image.asset(
            bathroom.isOn
                ? 'assets/Mask group (6).png'
                : 'assets/images/bathroom_off.png',
            fit: BoxFit.contain,
          ),
          deviceName: 'Bathroom heating thermostat',
          statusText: '${_bathroomThermostat.toStringAsFixed(1)}° c',
          mode: _bathroomManual ? 'M' : 'A',
          modeFilled: _bathroomManual,
          onModeTap: editing
              ? null
              : () => setState(() => _bathroomManual = !_bathroomManual),
          controls: _buildLightingPlusMinusButtons(
            markKey: 'bathroom_heat_s',
            onMinus: () {
              setState(() {
                _bathroomThermostat = (_bathroomThermostat - 0.5).clamp(
                  10.0,
                  35.0,
                );
              });
              _pushDashboardFor('Bathroom heating thermostat');
            },
            onPlus: () {
              setState(() {
                _bathroomThermostat = (_bathroomThermostat + 0.5).clamp(
                  10.0,
                  35.0,
                );
              });
              _pushDashboardFor('Bathroom heating thermostat');
            },
          ),
          onNavigate: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Bathroom heating thermostat',
              imageAssetPath: 'assets/Mask group (6).png',
              controlButtonCount: 3,
            ),
          ),
        );
      case 'awning':
        return _buildLightingLargeRow(
          icon: DashboardAwningLevelIcon(
            level: _awningUp / 100.0,
            softInterior: true,
          ),
          deviceName: 'Awning garden 123',
          statusText: '$_awningUp%',
          mode: _awningManual ? 'M' : 'A',
          modeFilled: _awningManual,
          onModeTap: editing
              ? null
              : () => setState(() => _awningManual = !_awningManual),
          controls: _buildLightingStepButtons(
            markKey: 'awning_s',
            onDown: () => setState(() => _awningAdjustLevel(10)),
            onUp: () => setState(() => _awningAdjustLevel(-10)),
            onDownLong: () => setState(() => _awningSetLevel(100)),
            onUpLong: () => setState(() => _awningSetLevel(0)),
          ),
          onNavigate: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Awning garden 123',
              imageAssetPath: 'assets/Rectangle 823.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.awningControl,
            ),
          ),
        );
      case 'irrigation':
        return _buildLightingLargeRow(
          icon: Image.asset(
            _irrigationOn
                ? 'assets/Mask group (7).png'
                : 'assets/images/irrigation_of.png',
            fit: BoxFit.contain,
          ),
          deviceName: 'Irrigation entry',
          statusText: _irrigationOn ? 'On' : 'Off',
          mode: _irrigationManual ? 'M' : 'A',
          modeFilled: _irrigationManual,
          onModeTap: editing
              ? null
              : () => setState(() => _irrigationManual = !_irrigationManual),
          controls: _buildLightingSwitchControl(
            value: _irrigationOn,
            onChanged: (v) {
              setState(() => _irrigationOn = v);
              _pushDashboardFor('Irrigation entry');
            },
          ),
          onNavigate: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Irrigation entry',
              imageAssetPath: 'assets/Mask group (7).png',
              controlButtonCount: 1,
            ),
          ),
        );
      case 'blind_living':
        return _buildLightingLargeRow(
          icon: _HomeBlindSlatsIcon(
            level: _blindRoomLevel / 100.0,
            angle: _blindRoomAngle / 100.0,
            softInterior: true,
          ),
          deviceName: 'Blind Living Room',
          statusText: '$_blindRoomLevel%  $_blindRoomAngle%',
          mode: _blindManual ? 'M' : 'A',
          modeFilled: _blindManual,
          onModeTap: editing
              ? null
              : () => setState(() => _blindManual = !_blindManual),
          controls: _buildLightingStepButtons(
            markKey: 'blind_living_s',
            onDown: () => setState(() => _blindLivingRoomAdjustAngle(10)),
            onUp: () => setState(() => _blindLivingRoomAdjustAngle(-10)),
            onDownLong: () => setState(() => _blindLivingRoomSetLevel(100)),
            onUpLong: () => setState(() => _blindLivingRoomSetLevel(0)),
          ),
          onNavigate: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Blind Living Room',
              imageAssetPath: 'assets/Rectangle 823.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.blindControl,
            ),
          ),
        );
      case 'motion':
        return _buildLightingLargeRow(
          icon: Image.asset(
            _motionSensorOn
                ? 'assets/images/update_sensor.png'
                : 'assets/images/motion_sensor_off.png',
            fit: BoxFit.contain,
          ),
          deviceName: 'Motion Sensor',
          statusText: _motionSensorOn ? 'On' : 'Off',
          mode: _motionSensorManual ? 'M' : 'A',
          modeFilled: _motionSensorManual,
          onModeTap: editing
              ? null
              : () =>
                    setState(() => _motionSensorManual = !_motionSensorManual),
          controls: _buildLightingSwitchControl(
            value: _motionSensorOn,
            onChanged: (v) {
              setState(() => _motionSensorOn = v);
              _pushDashboardFor('Motion Sensor');
            },
          ),
          onNavigate: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Motion Sensor',
              imageAssetPath: 'assets/images/update_sensor.png',
              controlButtonCount: 1,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLightDeviceCard(
    String deviceId, {
    String? widgetSize,
    bool uniformControls = false,
  }) {
    final String effectiveSize = widgetSize ?? _lightWidgetSize;
    final bool editing =
        _editingSection == _DashboardEditSection.light ||
        _editingAddedSectionId != null ||
        _showSectionEditButtons;
    final bool compact = effectiveSize == 'M';
    final double cardHeight = _lightCardHeightForWidgetSize(effectiveSize);
    final DeviceControlSnapshot diningLight = _snap('Light dinning room');
    final DeviceControlSnapshot bathroomHeat = _snap(
      'Bathroom heating thermostat',
    );

    if (effectiveSize == 'M') {
      Widget lightSmallCard({
        required String deviceName,
        required String status,
        required String iconImage,
        required String mode,
        required bool modeFilled,
        Widget? iconWidget,
        Widget? controls,
        VoidCallback? onTap,
        VoidCallback? onModeTap,
      }) {
        return _buildLightingCard(
          deviceName: deviceName,
          status: status,
          iconImage: iconImage,
          mode: mode,
          modeFilled: modeFilled,
          iconWidget: iconWidget,
          controls: controls,
          onTap: onTap,
          onModeTap: onModeTap,
          compactOverride: compact,
          cardHeightOverride: cardHeight,
          uniformControlSlot: uniformControls,
        );
      }

      switch (deviceId) {
        case 'light_dining':
          return lightSmallCard(
            deviceName: 'Light dinning room',
            status: '${(_bedroomDimmer * 100).round()}%',
            mode: _bedroomManual ? 'M' : 'A',
            modeFilled: _bedroomManual,
            onModeTap: editing
                ? null
                : () => setState(() => _bedroomManual = !_bedroomManual),
            iconImage: diningLight.isOn
                ? 'assets/Mask group (5).png'
                : 'assets/images/light_of.png',
            controls: _buildLightingSwitchControl(
              value: _bedroomDimmer > 0.001,
              onChanged: (v) {
                setState(() => _bedroomDimmer = v ? 1.0 : 0.0);
                _pushDashboardFor('Light dinning room');
              },
            ),
            onTap: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Light dinning room ',
                    imageAssetPath: 'assets/Mask group (5).png',
                    controlButtonCount: 1,
                  ),
          );
        case 'bathroom_heat':
          return lightSmallCard(
            deviceName: 'Bathroom heating thermostat',
            status: '${_bathroomThermostat.toStringAsFixed(1)}° c',
            mode: _bathroomManual ? 'M' : 'A',
            modeFilled: _bathroomManual,
            onModeTap: editing
                ? null
                : () => setState(() => _bathroomManual = !_bathroomManual),
            iconImage: bathroomHeat.isOn
                ? 'assets/Mask group (6).png'
                : 'assets/images/bathroom_off.png',
            controls: _buildLightingPlusMinusButtons(
              markKey: 'bathroom_heat',
              onMinus: () {
                setState(() {
                  _bathroomThermostat = (_bathroomThermostat - 0.5).clamp(
                    10.0,
                    35.0,
                  );
                });
                _pushDashboardFor('Bathroom heating thermostat');
              },
              onPlus: () {
                setState(() {
                  _bathroomThermostat = (_bathroomThermostat + 0.5).clamp(
                    10.0,
                    35.0,
                  );
                });
                _pushDashboardFor('Bathroom heating thermostat');
              },
            ),
            onTap: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Bathroom heating thermostat',
                    imageAssetPath: 'assets/Mask group (6).png',
                    controlButtonCount: 3,
                  ),
          );
        case 'awning':
          return lightSmallCard(
            deviceName: 'Awning garden 123',
            status: '$_awningUp%',
            mode: _awningManual ? 'M' : 'A',
            modeFilled: _awningManual,
            onModeTap: editing
                ? null
                : () => setState(() => _awningManual = !_awningManual),
            iconImage: 'assets/Rectangle 823.png',
            iconWidget: DashboardAwningLevelIcon(
              level: _awningUp / 100.0,
              softInterior: true,
            ),
            controls: _buildLightingStepButtons(
              markKey: 'awning',
              onDown: () => setState(() => _awningAdjustLevel(10)),
              onUp: () => setState(() => _awningAdjustLevel(-10)),
              onDownLong: () => setState(() => _awningSetLevel(100)),
              onUpLong: () => setState(() => _awningSetLevel(0)),
            ),
            onTap: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Awning garden 123',
                    imageAssetPath: 'assets/Rectangle 823.png',
                    controlButtonCount: 1,
                    controlMode: DeviceDetailsControlMode.awningControl,
                  ),
          );
        case 'irrigation':
          return lightSmallCard(
            deviceName: 'Irrigation entry',
            status: _irrigationOn ? 'On' : 'Off',
            mode: _irrigationManual ? 'M' : 'A',
            modeFilled: _irrigationManual,
            onModeTap: editing
                ? null
                : () => setState(() => _irrigationManual = !_irrigationManual),
            iconImage: _irrigationOn
                ? 'assets/Mask group (7).png'
                : 'assets/images/irrigation_of.png',
            controls: _buildLightingSwitchControl(
              value: _irrigationOn,
              onChanged: (v) {
                setState(() => _irrigationOn = v);
                _pushDashboardFor('Irrigation entry');
              },
            ),
            onTap: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Irrigation entry ',
                    imageAssetPath: 'assets/Mask group (7).png',
                    controlButtonCount: 1,
                  ),
          );
        case 'blind_living':
          return lightSmallCard(
            deviceName: 'Blind Living Room',
            status: '$_blindRoomLevel%  $_blindRoomAngle%',
            mode: _blindManual ? 'M' : 'A',
            modeFilled: _blindManual,
            onModeTap: editing
                ? null
                : () => setState(() => _blindManual = !_blindManual),
            iconImage: 'assets/Rectangle 823.png',
            iconWidget: _HomeBlindSlatsIcon(
              level: _blindRoomLevel / 100.0,
              angle: _blindRoomAngle / 100.0,
              softInterior: true,
            ),
            controls: _buildLightingStepButtons(
              markKey: 'blind_living',
              onDown: () => setState(() => _blindLivingRoomAdjustAngle(10)),
              onUp: () => setState(() => _blindLivingRoomAdjustAngle(-10)),
              onDownLong: () => setState(() => _blindLivingRoomSetLevel(100)),
              onUpLong: () => setState(() => _blindLivingRoomSetLevel(0)),
            ),
            onTap: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Blind Living Room',
                    imageAssetPath: 'assets/Rectangle 823.png',
                    controlButtonCount: 1,
                    controlMode: DeviceDetailsControlMode.blindControl,
                  ),
          );
        case 'motion':
          return lightSmallCard(
            deviceName: 'Motion Sensor',
            status: _motionSensorOn ? 'On' : 'Off',
            mode: _motionSensorManual ? 'M' : 'A',
            modeFilled: _motionSensorManual,
            onModeTap: editing
                ? null
                : () => setState(
                    () => _motionSensorManual = !_motionSensorManual,
                  ),
            iconImage: _motionSensorOn
                ? 'assets/images/update_sensor.png'
                : 'assets/images/motion_sensor_off.png',
            controls: _buildLightingSwitchControl(
              value: _motionSensorOn,
              onChanged: (v) {
                setState(() => _motionSensorOn = v);
                _pushDashboardFor('Motion Sensor');
              },
            ),
            onTap: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Motion Sensor',
                    imageAssetPath: 'assets/images/update_sensor.png',
                    controlButtonCount: 1,
                  ),
          );
        default:
          return const SizedBox.shrink();
      }
    }

    switch (deviceId) {
      case 'light_dining':
        return SizedBox(
          height: cardHeight,
          child: _LightDimmerCard(
            title: 'Light dinning room ',
            percent: _bedroomDimmer,
            mode: _bedroomManual ? 'M' : 'A',
            modeFilled: _bedroomManual,
            isOn: diningLight.isOn,
            imagePath: 'assets/Mask group (5).png',
            imagePathOff: 'assets/images/light_of.png',
            compact: compact,
            uniformControls: uniformControls,
            onModeTap: editing
                ? null
                : () => setState(() => _bedroomManual = !_bedroomManual),
            onPercentChanged: editing
                ? null
                : (v) {
                    setState(() => _bedroomDimmer = v.clamp(0.0, 1.0));
                    _pushDashboardFor('Light dinning room');
                  },
            onNavigate: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Light dinning room ',
                    imageAssetPath: 'assets/Mask group (5).png',
                    controlButtonCount: 1,
                  ),
          ),
        );
      case 'bathroom_heat':
        return SizedBox(
          height: cardHeight,
          child: _ThermostatCard(
            title: 'Bathroom heating thermostat',
            value: _bathroomThermostat,
            mode: _bathroomManual ? 'M' : 'A',
            modeFilled: _bathroomManual,
            isOn: bathroomHeat.isOn,
            imagePath: 'assets/Mask group (6).png',
            imagePathOff: 'assets/images/bathroom_off.png',
            compact: compact,
            uniformControls: uniformControls,
            minusMarked: _bathroomThermoMark == 1,
            plusMarked: _bathroomThermoMark == 2,
            onNavigate: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Bathroom heating thermostat',
                    imageAssetPath: 'assets/Mask group (6).png',
                    controlButtonCount: 3,
                  ),
            onModeTap: editing
                ? null
                : () => setState(() => _bathroomManual = !_bathroomManual),
            onMinus: editing
                ? () {}
                : () => _flashMark(
                    value: 1,
                    getCurrent: () => _bathroomThermoMark,
                    set: (v) => _bathroomThermoMark = v,
                    action: () {
                      _bathroomThermostat = (_bathroomThermostat - 0.5).clamp(
                        10.0,
                        35.0,
                      );
                      _pushDashboardFor('Bathroom heating thermostat');
                    },
                  ),
            onPlus: editing
                ? () {}
                : () => _flashMark(
                    value: 2,
                    getCurrent: () => _bathroomThermoMark,
                    set: (v) => _bathroomThermoMark = v,
                    action: () {
                      _bathroomThermostat = (_bathroomThermostat + 0.5).clamp(
                        10.0,
                        35.0,
                      );
                      _pushDashboardFor('Bathroom heating thermostat');
                    },
                  ),
          ),
        );
      case 'awning':
        return SizedBox(
          height: cardHeight,
          child: _BlindCard(
            title: 'Awning garden 123',
            downPercent: _awningDown,
            upPercent: _awningUp,
            levelPercent: _awningUp,
            mode: _awningManual ? 'M' : 'A',
            modeFilled: _awningManual,
            previewLevel: _awningUp / 100.0,
            useAwningPreview: true,
            imagePath: 'assets/Rectangle 823.png',
            compact: compact,
            uniformControls: uniformControls,
            softPreviewInterior: true,
            downMarked: _awningMark == 1,
            upMarked: _awningMark == 2,
            onNavigate: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Awning garden 123',
                    imageAssetPath: 'assets/Rectangle 823.png',
                    controlButtonCount: 1,
                    controlMode: DeviceDetailsControlMode.awningControl,
                  ),
            onModeTap: editing
                ? null
                : () => setState(() => _awningManual = !_awningManual),
            onDown: editing
                ? () {}
                : () => _flashMark(
                    value: 1,
                    getCurrent: () => _awningMark,
                    set: (v) => _awningMark = v,
                    action: () => _awningAdjustLevel(10),
                  ),
            onDownLong: editing
                ? null
                : () => _flashMark(
                    value: 1,
                    getCurrent: () => _awningMark,
                    set: (v) => _awningMark = v,
                    action: () => _awningSetLevel(100),
                  ),
            onUp: editing
                ? () {}
                : () => _flashMark(
                    value: 2,
                    getCurrent: () => _awningMark,
                    set: (v) => _awningMark = v,
                    action: () => _awningAdjustLevel(-10),
                  ),
            onUpLong: editing
                ? null
                : () => _flashMark(
                    value: 2,
                    getCurrent: () => _awningMark,
                    set: (v) => _awningMark = v,
                    action: () => _awningSetLevel(0),
                  ),
          ),
        );
      case 'irrigation':
        return SizedBox(
          height: cardHeight,
          child: _ToggleCard(
            title: 'Irrigation entry ',
            mode: _irrigationManual ? 'M' : 'A',
            modeFilled: _irrigationManual,
            onModeTap: editing
                ? null
                : () => setState(() => _irrigationManual = !_irrigationManual),
            isOn: _irrigationOn,
            imagePath: 'assets/Mask group (7).png',
            imagePathOff: 'assets/images/irrigation_of.png',
            compact: compact,
            uniformControls: uniformControls,
            onIsOnChanged: editing
                ? null
                : (v) {
                    setState(() => _irrigationOn = v);
                    _pushDashboardFor('Irrigation entry');
                  },
            onNavigate: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Irrigation entry ',
                    imageAssetPath: 'assets/Mask group (7).png',
                    controlButtonCount: 1,
                  ),
          ),
        );
      case 'blind_living':
        return SizedBox(
          height: cardHeight,
          child: _BlindCard(
            title: 'Blind Living Room',
            downPercent: _blindRoomLevel,
            upPercent: _blindRoomAngle,
            mode: _blindManual ? 'M' : 'A',
            modeFilled: _blindManual,
            previewLevel: _blindRoomLevel / 100.0,
            blindAngle: _blindRoomAngle / 100.0,
            slatsPreviewOverride: _HomeBlindSlatsIcon(
              level: _blindRoomLevel / 100.0,
              angle: _blindRoomAngle / 100.0,
              softInterior: true,
            ),
            useBlindSlatsPreview: true,
            imagePath: 'assets/Rectangle 823.png',
            compact: compact,
            uniformControls: uniformControls,
            softPreviewInterior: true,
            downMarked: _blindRoomMark == 1,
            upMarked: _blindRoomMark == 2,
            onNavigate: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Blind Living Room',
                    imageAssetPath: 'assets/Rectangle 823.png',
                    controlButtonCount: 1,
                    controlMode: DeviceDetailsControlMode.blindControl,
                  ),
            onModeTap: editing
                ? null
                : () => setState(() => _blindManual = !_blindManual),
            onDown: editing
                ? () {}
                : () => _flashMark(
                    value: 1,
                    getCurrent: () => _blindRoomMark,
                    set: (v) => _blindRoomMark = v,
                    action: () => _blindLivingRoomAdjustAngle(10),
                  ),
            onDownLong: editing ? null : null,
            onDownLongStart: editing
                ? null
                : () => _startBlindLevelChange(true),
            onDownLongEnd: editing ? null : () => _stopBlindLevelChange(),
            onUp: editing
                ? () {}
                : () => _flashMark(
                    value: 2,
                    getCurrent: () => _blindRoomMark,
                    set: (v) => _blindRoomMark = v,
                    action: () => _blindLivingRoomAdjustAngle(-10),
                  ),
            onUpLong: editing ? null : null,
            onUpLongStart: editing ? null : () => _startBlindLevelChange(false),
            onUpLongEnd: editing ? null : () => _stopBlindLevelChange(),
          ),
        );
      case 'motion':
        return SizedBox(
          height: cardHeight,
          child: _ToggleCard(
            title: 'Motion Sensor',
            mode: _motionSensorManual ? 'M' : 'A',
            modeFilled: _motionSensorManual,
            onModeTap: editing
                ? null
                : () => setState(
                    () => _motionSensorManual = !_motionSensorManual,
                  ),
            isOn: _motionSensorOn,
            imagePath: 'assets/images/update_sensor.png',
            imagePathOff: 'assets/images/motion_sensor_off.png',
            compact: compact,
            uniformControls: uniformControls,
            onIsOnChanged: editing
                ? null
                : (v) {
                    setState(() => _motionSensorOn = v);
                    _pushDashboardFor('Motion Sensor');
                  },
            onNavigate: editing
                ? null
                : () => DeviceDetailsScreen.go(
                    context,
                    deviceTitle: 'Motion Sensor',
                    imageAssetPath: 'assets/images/update_sensor.png',
                    controlButtonCount: 1,
                  ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLightingSectionCards() {
    if (_lightingUsesLargeWidgets) {
      return _buildLightingSectionCardsLarge();
    }
    return _buildLightingSectionCardsSmall(
      columns: _gridColumnsForWidgetSize(_lightingWidgetSize),
    );
  }

  Widget _buildLightingSectionCardsSmall({int columns = 3}) {
    final List<String> ids = _deviceOrderFor(_DashboardEditSection.lighting);
    if (ids.isEmpty) return const SizedBox.shrink();

    final String size = _lightingWidgetSize;
    final double cardHeight = _lightCardHeightForWidgetSize(size);

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double gridCardWidth =
        (screenWidth - 32.w - (columns - 1) * 12.w) / columns;

    Widget buildCard(String id) {
      return _buildLightingSmallCardById(
        id,
        uniformControlSlot: true,
        cardHeightOverride: cardHeight,
        compactOverride: size == 'M',
      );
    }

    if (_lightingHorizontalScroll) {
      return SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: ids.length,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final String id = ids[index];
            return SizedBox(
              width: size == 'XL'
                  ? _lightHorizontalItemWidth(size)
                  : gridCardWidth,
              child: _wrapDashboardDeviceCell(
                section: _DashboardEditSection.lighting,
                deviceId: id,
                child: buildCard(id),
              ),
            );
          },
        ),
      );
    }

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < ids.length; i += columns) {
      if (i > 0) rows.add(SizedBox(height: 12.h));
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int col = 0; col < columns; col++) ...[
              if (col > 0) SizedBox(width: 12.w),
              Expanded(
                child: i + col < ids.length
                    ? _wrapDashboardDeviceCell(
                        section: _DashboardEditSection.lighting,
                        deviceId: ids[i + col],
                        child: buildCard(ids[i + col]),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildLightingSmallCardById(
    String deviceId, {
    bool? compactOverride,
    double? cardHeightOverride,
    bool uniformControlSlot = false,
  }) {
    final bool editing =
        _editingSection == _DashboardEditSection.lighting ||
        _editingAddedSectionId != null ||
        _showSectionEditButtons;
    final DeviceControlSnapshot scene = _snap('Light Scene');
    final DeviceControlSnapshot rgbw = _snap('RGBW room abc');
    final DeviceControlSnapshot led = _snap('LED Dimmer living room');
    final DeviceControlSnapshot hvac = _snap('Heating & Cooling');
    final DeviceControlSnapshot tunable = _snap('Tunable white light');
    final DeviceControlSnapshot vent = _snap('Ventilation');
    final DeviceControlSnapshot fan = _snap('Fan Level 3');
    final DeviceControlSnapshot presence = _snap('Presence');
    final DeviceControlSnapshot living = _snap('Living Room');
    final DeviceControlSnapshot multi = _snap('Multi-Value Switch');

    VoidCallback? detailsTap(VoidCallback action) => editing ? null : action;

    switch (deviceId) {
      case 'light_scene':
        return _buildLightingCard(
          deviceName: 'Light Scene',
          status: scene.sceneLabel,
          mode: _lightSceneManual ? 'M' : 'A',
          modeFilled: _lightSceneManual,
          onModeTap: editing
              ? null
              : () => setState(() => _lightSceneManual = !_lightSceneManual),
          iconImage:
              'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
          iconWidget: DashboardLightSceneIcon(sceneIndex: scene.sceneIndex),
          controls: _buildLightingChevronButtons(
            markKey: 'scene',
            onLeft: () => _patchSnap(
              'Light Scene',
              (p) => p.copyWith(sceneIndex: (p.sceneIndex - 1).clamp(0, 2)),
            ),
            onRight: () => _patchSnap(
              'Light Scene',
              (p) => p.copyWith(sceneIndex: (p.sceneIndex + 1).clamp(0, 2)),
            ),
          ),
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Light Scene',
              imageAssetPath:
                  'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
              controlButtonCount: 3,
              controlMode: DeviceDetailsControlMode.lightSceneValues,
            ),
          ),
        );
      case 'rgbw':
        return _buildLightingCard(
          deviceName: 'RGBW room abc',
          status: '${(rgbw.rgbwIntensity * 100).round()}%',
          mode: _rgbwManual ? 'M' : 'A',
          modeFilled: _rgbwManual,
          onModeTap: editing
              ? null
              : () => setState(() => _rgbwManual = !_rgbwManual),
          iconWidget: DashboardRgbwIcon(
            hue: rgbw.rgbwHue,
            saturation: rgbw.rgbwSaturation,
            intensity: rgbw.rgbwIntensity,
          ),
          controls: _buildLightingSliderControl(
            value: rgbw.rgbwIntensity,
            onChanged: (v) => _patchSnap(
              'RGBW room abc',
              (p) => p.copyWith(rgbwIntensity: v),
            ),
          ),
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'RGBW room abc',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 2,
              controlMode: DeviceDetailsControlMode.rgbwPicker,
            ),
          ),
        );
      case 'led_dimmer':
        return _buildLightingCard(
          deviceName: 'LED Dimmer living room',
          status: '${(led.ledDimmerPercent * 100).round()}%',
          mode: _lightingLedBadge1Manual ? 'M' : 'A',
          modeFilled: _lightingLedBadge1Manual,
          onModeTap: editing
              ? null
              : () => setState(
                  () => _lightingLedBadge1Manual = !_lightingLedBadge1Manual,
                ),
          iconWidget: DashboardRingProgressIcon(
            percent: led.ledDimmerPercent,
            ringStyle: DashboardRingStyle.led,
          ),
          controls: _buildLightingSliderControl(
            value: led.ledDimmerPercent,
            onChanged: (v) => _patchSnap(
              'LED Dimmer living room',
              (p) => p.copyWith(ledDimmerPercent: v),
            ),
          ),
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'LED Dimmer living room',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.ledDimmer,
            ),
          ),
        );
      case 'heating_cooling':
        return _buildLightingCard(
          deviceName: 'Heating & Cooling',
          status: hvac.heatingCoolingStatusLabel,
          mode: _heatingCoolingManual ? 'M' : 'A',
          modeFilled: _heatingCoolingManual,
          onModeTap: editing
              ? null
              : () => setState(
                  () => _heatingCoolingManual = !_heatingCoolingManual,
                ),
          iconImage: 'assets/images/heating_cooling.png',
          iconWidget: DashboardHeatingCoolingIcon(isOn: hvac.isOn),
          controls: _buildLightingSwitchControl(
            value: hvac.isOn,
            onChanged: (v) =>
                _patchSnap('Heating & Cooling', (p) => p.copyWith(isOn: v)),
          ),
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Heating & Cooling',
              imageAssetPath: 'assets/images/heating_cooling.png',
              controlButtonCount: 3,
              controlMode: DeviceDetailsControlMode.heatingCooling,
            ),
          ),
        );
      case 'tunable_white':
        return _buildLightingCard(
          deviceName: 'Tunable white light',
          status: '${(tunable.tunableWhiteIntensity * 100).round()}%',
          mode: _tunableWhiteManual ? 'M' : 'A',
          modeFilled: _tunableWhiteManual,
          onModeTap: editing
              ? null
              : () =>
                    setState(() => _tunableWhiteManual = !_tunableWhiteManual),
          iconImage: 'assets/white_light.png',
          iconWidget: DashboardTunableWhiteIcon(
            dotDx: tunable.tunableWhiteDotDx,
            dotDy: tunable.tunableWhiteDotDy,
            intensity: tunable.tunableWhiteIntensity,
          ),
          controls: _buildLightingSliderControl(
            value: tunable.tunableWhiteIntensity,
            onChanged: (v) => _patchSnap(
              'Tunable white light',
              (p) => p.copyWith(tunableWhiteIntensity: v),
            ),
          ),
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Tunable white light',
              imageAssetPath: 'assets/white_light.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.tunableWhite,
            ),
          ),
        );
      case 'ventilation':
        return _buildLightingCard(
          deviceName: 'Ventilation',
          status: '${(vent.ventilationPercent * 100).round()}%',
          mode: _ventilationManual ? 'M' : 'A',
          modeFilled: _ventilationManual,
          onModeTap: editing
              ? null
              : () => setState(() => _ventilationManual = !_ventilationManual),
          iconWidget: DashboardVentilationIcon(
            percent: vent.ventilationPercent,
          ),
          controls: _buildLightingSliderControl(
            value: vent.ventilationPercent,
            onChanged: (v) => _patchSnap(
              'Ventilation',
              (p) => p.copyWith(ventilationPercent: v),
            ),
          ),
          iconImage: 'assets/images/ventilations.png',
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Ventilation',
              imageAssetPath: 'assets/images/ventilations.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.ventilation,
            ),
          ),
        );
      case 'fan_level_3':
        return _buildLightingCard(
          deviceName: 'Fan Level 3',
          status: fan.fanStatusLabel,
          mode: _fanLevelManual ? 'M' : 'A',
          modeFilled: _fanLevelManual,
          onModeTap: editing
              ? null
              : () => setState(() => _fanLevelManual = !_fanLevelManual),
          iconImage: 'assets/images/Fun_level3.png',
          iconWidget: DashboardFanLevelIcon(level: fan.fanLevel),
          controls: _buildLightingPlusMinusButtons(
            markKey: 'fan',
            onMinus: () => _patchSnap(
              'Fan Level 3',
              (p) => p.copyWith(fanLevel: (p.fanLevel - 1).clamp(0, 3)),
            ),
            onPlus: () => _patchSnap(
              'Fan Level 3',
              (p) => p.copyWith(fanLevel: (p.fanLevel + 1).clamp(0, 3)),
            ),
          ),
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Fan Level 3',
              imageAssetPath: 'assets/images/Fun_level3.png',
              controlButtonCount: 3,
              controlMode: DeviceDetailsControlMode.fanLevel,
            ),
          ),
        );
      case 'presence':
        return _buildLightingCard(
          deviceName: 'Presence',
          status: presence.presenceLabel,
          mode: _presenceManual ? 'M' : 'A',
          modeFilled: _presenceManual,
          onModeTap: editing
              ? null
              : () => setState(() => _presenceManual = !_presenceManual),
          iconImage: 'assets/images/comfort.png',
          iconWidget: DashboardPresenceModeIcon(
            modeIndex: presence.presenceModeIndex,
            isOn: presence.isOn,
          ),
          controls: _buildLightingChevronButtons(
            markKey: 'presence',
            onLeft: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(
                isOn: true,
                presenceModeIndex: (p.presenceModeIndex - 1).clamp(0, 4),
              ),
            ),
            onLeftLong: () =>
                _patchSnap('Presence', (p) => p.copyWith(isOn: false)),
            onRight: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(
                isOn: true,
                presenceModeIndex: (p.presenceModeIndex + 1).clamp(0, 4),
              ),
            ),
            onRightLong: () =>
                _patchSnap('Presence', (p) => p.copyWith(isOn: false)),
          ),
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Presence',
              imageAssetPath: 'assets/images/comfort.png',
              controlButtonCount: 2,
              controlMode: DeviceDetailsControlMode.presenceModes,
            ),
          ),
        );
      case 'living_room':
        return _buildLightingCard(
          deviceName: 'Living room',
          status: '${living.thermostatRingCelsius.toStringAsFixed(1)}° c',
          mode: _livingRoomManual ? 'M' : 'A',
          modeFilled: _livingRoomManual,
          onModeTap: editing
              ? null
              : () => setState(() => _livingRoomManual = !_livingRoomManual),
          iconWidget: DashboardThermostatRingIcon(
            percent: living.thermostatRingPercent,
            currentTempCelsius: living.thermostatCelsius,
          ),
          controls: _buildLightingPlusMinusButtons(
            markKey: 'living',
            onMinus: () => _patchSnap(
              'Living Room',
              (p) => p.copyWith(
                thermostatRingPercent: (p.thermostatRingPercent - 0.10).clamp(
                  0.0,
                  1.0,
                ),
              ),
            ),
            onPlus: () => _patchSnap(
              'Living Room',
              (p) => p.copyWith(
                thermostatRingPercent: (p.thermostatRingPercent + 0.10).clamp(
                  0.0,
                  1.0,
                ),
              ),
            ),
          ),
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Living Room',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.thermostatRing,
            ),
          ),
        );
      case 'multi_value_switch':
        return _buildLightingCard(
          deviceName: 'Multi-Value Switch',
          status: multi.multiValueSwitchCaption,
          mode: _multiValueSwitchManual ? 'M' : 'A',
          modeFilled: _multiValueSwitchManual,
          onModeTap: editing
              ? null
              : () => setState(
                  () => _multiValueSwitchManual = !_multiValueSwitchManual,
                ),
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          iconWidget: DashboardMultiValueSwitchIcon(
            selectedIndex: multi.multiValueSwitchIndex,
            isOn: multi.isOn,
          ),
          controls: _buildLightingChevronButtons(
            markKey: 'multi',
            onLeft: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(
                isOn: true,
                multiValueSwitchIndex: (p.multiValueSwitchIndex - 1).clamp(
                  0,
                  2,
                ),
              ),
            ),
            onLeftLong: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(isOn: false),
            ),
            onRight: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(
                isOn: true,
                multiValueSwitchIndex: (p.multiValueSwitchIndex + 1).clamp(
                  0,
                  2,
                ),
              ),
            ),
            onRightLong: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(isOn: false),
            ),
          ),
          compactOverride: compactOverride,
          cardHeightOverride: cardHeightOverride,
          uniformControlSlot: uniformControlSlot,
          onTap: detailsTap(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Multi-Value Switch',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 12,
              controlMode: DeviceDetailsControlMode.multiValueSwitch,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLightingSectionCardsLarge() {
    final List<String> ids = _deviceOrderFor(_DashboardEditSection.lighting);
    if (ids.isEmpty) return const SizedBox.shrink();

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < ids.length; i++) {
      final Widget row = _wrapDashboardDeviceCell(
        section: _DashboardEditSection.lighting,
        deviceId: ids[i],
        child: _buildLightingLargeRowById(ids[i]),
      );
      if (i < ids.length - 1) {
        children.add(
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: row,
          ),
        );
      } else {
        children.add(row);
      }
    }
    return Column(children: children);
  }

  Widget _buildLightingLargeRowById(String deviceId) {
    final bool editing =
        _editingSection == _DashboardEditSection.lighting ||
        _editingAddedSectionId != null ||
        _showSectionEditButtons;
    final DeviceControlSnapshot scene = _snap('Light Scene');
    final DeviceControlSnapshot rgbw = _snap('RGBW room abc');
    final DeviceControlSnapshot led = _snap('LED Dimmer living room');
    final DeviceControlSnapshot hvac = _snap('Heating & Cooling');
    final DeviceControlSnapshot tunable = _snap('Tunable white light');
    final DeviceControlSnapshot vent = _snap('Ventilation');
    final DeviceControlSnapshot fan = _snap('Fan Level 3');
    final DeviceControlSnapshot presence = _snap('Presence');
    final DeviceControlSnapshot living = _snap('Living Room');
    final DeviceControlSnapshot multi = _snap('Multi-Value Switch');

    VoidCallback? detailsNav(VoidCallback action) => editing ? null : action;

    switch (deviceId) {
      case 'light_scene':
        return _buildLightingLargeRow(
          icon: DashboardLightSceneIcon(sceneIndex: scene.sceneIndex),
          deviceName: 'Light Scene',
          statusText: scene.sceneLabel,
          mode: _lightSceneManual ? 'M' : 'A',
          modeFilled: _lightSceneManual,
          onModeTap: editing
              ? null
              : () => setState(() => _lightSceneManual = !_lightSceneManual),
          controls: _buildLightingChevronButtons(
            markKey: 'scene',
            onLeft: () => _patchSnap(
              'Light Scene',
              (p) => p.copyWith(sceneIndex: (p.sceneIndex - 1).clamp(0, 2)),
            ),
            onRight: () => _patchSnap(
              'Light Scene',
              (p) => p.copyWith(sceneIndex: (p.sceneIndex + 1).clamp(0, 2)),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Light Scene',
              imageAssetPath:
                  'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
              controlButtonCount: 3,
              controlMode: DeviceDetailsControlMode.lightSceneValues,
            ),
          ),
        );
      case 'rgbw':
        return _buildLightingLargeRow(
          icon: DashboardRgbwIcon(
            hue: rgbw.rgbwHue,
            saturation: rgbw.rgbwSaturation,
            intensity: rgbw.rgbwIntensity,
          ),
          deviceName: 'RGBW room abc',
          statusText: '${(rgbw.rgbwIntensity * 100).round()}%',
          mode: _rgbwManual ? 'M' : 'A',
          modeFilled: _rgbwManual,
          onModeTap: editing
              ? null
              : () => setState(() => _rgbwManual = !_rgbwManual),
          controls: _buildLightingSliderControl(
            value: rgbw.rgbwIntensity,
            onChanged: (v) => _patchSnap(
              'RGBW room abc',
              (p) => p.copyWith(rgbwIntensity: v),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'RGBW room abc',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 2,
              controlMode: DeviceDetailsControlMode.rgbwPicker,
            ),
          ),
        );
      case 'led_dimmer':
        return _buildLightingLargeRow(
          icon: DashboardRingProgressIcon(
            percent: led.ledDimmerPercent,
            ringStyle: DashboardRingStyle.led,
          ),
          deviceName: 'LED Dimmer living room',
          statusText: '${(led.ledDimmerPercent * 100).round()}%',
          mode: _lightingLedBadge1Manual ? 'M' : 'A',
          modeFilled: _lightingLedBadge1Manual,
          onModeTap: editing
              ? null
              : () => setState(
                  () => _lightingLedBadge1Manual = !_lightingLedBadge1Manual,
                ),
          controls: _buildLightingSliderControl(
            value: led.ledDimmerPercent,
            onChanged: (v) => _patchSnap(
              'LED Dimmer living room',
              (p) => p.copyWith(ledDimmerPercent: v),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'LED Dimmer living room',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.ledDimmer,
            ),
          ),
        );
      case 'heating_cooling':
        return _buildLightingLargeRow(
          icon: DashboardHeatingCoolingIcon(isOn: hvac.isOn),
          deviceName: 'Heating & Cooling',
          statusText: hvac.heatingCoolingStatusLabel,
          mode: _heatingCoolingManual ? 'M' : 'A',
          modeFilled: _heatingCoolingManual,
          onModeTap: editing
              ? null
              : () => setState(
                  () => _heatingCoolingManual = !_heatingCoolingManual,
                ),
          controls: _buildLightingSwitchControl(
            value: hvac.isOn,
            onChanged: (v) =>
                _patchSnap('Heating & Cooling', (p) => p.copyWith(isOn: v)),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Heating & Cooling',
              imageAssetPath: 'assets/images/heating_cooling.png',
              controlButtonCount: 3,
              controlMode: DeviceDetailsControlMode.heatingCooling,
            ),
          ),
        );
      case 'tunable_white':
        return _buildLightingLargeRow(
          icon: DashboardTunableWhiteIcon(
            dotDx: tunable.tunableWhiteDotDx,
            dotDy: tunable.tunableWhiteDotDy,
            intensity: tunable.tunableWhiteIntensity,
          ),
          deviceName: 'Tunable white light',
          statusText: '${(tunable.tunableWhiteIntensity * 100).round()}%',
          mode: _tunableWhiteManual ? 'M' : 'A',
          modeFilled: _tunableWhiteManual,
          onModeTap: editing
              ? null
              : () =>
                    setState(() => _tunableWhiteManual = !_tunableWhiteManual),
          controls: _buildLightingSliderControl(
            value: tunable.tunableWhiteIntensity,
            onChanged: (v) => _patchSnap(
              'Tunable white light',
              (p) => p.copyWith(tunableWhiteIntensity: v),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Tunable white light',
              imageAssetPath: 'assets/white_light.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.tunableWhite,
            ),
          ),
        );
      case 'ventilation':
        return _buildLightingLargeRow(
          icon: DashboardVentilationIcon(percent: vent.ventilationPercent),
          deviceName: 'Ventilation',
          statusText: '${(vent.ventilationPercent * 100).round()}%',
          mode: _ventilationManual ? 'M' : 'A',
          modeFilled: _ventilationManual,
          onModeTap: editing
              ? null
              : () => setState(() => _ventilationManual = !_ventilationManual),
          controls: _buildLightingSliderControl(
            value: vent.ventilationPercent,
            onChanged: (v) => _patchSnap(
              'Ventilation',
              (p) => p.copyWith(ventilationPercent: v),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Ventilation',
              imageAssetPath: 'assets/images/ventilations.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.ventilation,
            ),
          ),
        );
      case 'fan_level_3':
        return _buildLightingLargeRow(
          icon: DashboardFanLevelIcon(level: fan.fanLevel),
          deviceName: 'Fan Level 3',
          statusText: fan.fanStatusLabel,
          mode: _fanLevelManual ? 'M' : 'A',
          modeFilled: _fanLevelManual,
          onModeTap: editing
              ? null
              : () => setState(() => _fanLevelManual = !_fanLevelManual),
          controls: _buildLightingPlusMinusButtons(
            markKey: 'fan',
            onMinus: () => _patchSnap(
              'Fan Level 3',
              (p) => p.copyWith(fanLevel: (p.fanLevel - 1).clamp(0, 3)),
            ),
            onPlus: () => _patchSnap(
              'Fan Level 3',
              (p) => p.copyWith(fanLevel: (p.fanLevel + 1).clamp(0, 3)),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Fan Level 3',
              imageAssetPath: 'assets/images/Fun_level3.png',
              controlButtonCount: 3,
              controlMode: DeviceDetailsControlMode.fanLevel,
            ),
          ),
        );
      case 'presence':
        return _buildLightingLargeRow(
          icon: DashboardPresenceModeIcon(
            modeIndex: presence.presenceModeIndex,
            isOn: presence.isOn,
          ),
          deviceName: 'Presence',
          statusText: presence.presenceLabel,
          mode: _presenceManual ? 'M' : 'A',
          modeFilled: _presenceManual,
          onModeTap: editing
              ? null
              : () => setState(() => _presenceManual = !_presenceManual),
          controls: _buildLightingChevronButtons(
            markKey: 'presence',
            onLeft: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(
                isOn: true,
                presenceModeIndex: (p.presenceModeIndex - 1).clamp(0, 4),
              ),
            ),
            onLeftLong: () =>
                _patchSnap('Presence', (p) => p.copyWith(isOn: false)),
            onRight: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(
                isOn: true,
                presenceModeIndex: (p.presenceModeIndex + 1).clamp(0, 4),
              ),
            ),
            onRightLong: () =>
                _patchSnap('Presence', (p) => p.copyWith(isOn: false)),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Presence',
              imageAssetPath: 'assets/images/comfort.png',
              controlButtonCount: 2,
              controlMode: DeviceDetailsControlMode.presenceModes,
            ),
          ),
        );
      case 'living_room':
        return _buildLightingLargeRow(
          icon: DashboardThermostatRingIcon(
            percent: living.thermostatRingPercent,
            currentTempCelsius: living.thermostatCelsius,
          ),
          deviceName: 'Living room',
          statusText: '${living.thermostatRingCelsius.toStringAsFixed(1)}° c',
          mode: _livingRoomManual ? 'M' : 'A',
          modeFilled: _livingRoomManual,
          onModeTap: editing
              ? null
              : () => setState(() => _livingRoomManual = !_livingRoomManual),
          controls: _buildLightingPlusMinusButtons(
            markKey: 'living',
            onMinus: () => _patchSnap(
              'Living Room',
              (p) => p.copyWith(
                thermostatRingPercent: (p.thermostatRingPercent - 0.10).clamp(
                  0.0,
                  1.0,
                ),
              ),
            ),
            onPlus: () => _patchSnap(
              'Living Room',
              (p) => p.copyWith(
                thermostatRingPercent: (p.thermostatRingPercent + 0.10).clamp(
                  0.0,
                  1.0,
                ),
              ),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Living Room',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 1,
              controlMode: DeviceDetailsControlMode.thermostatRing,
            ),
          ),
        );
      case 'multi_value_switch':
        return _buildLightingLargeRow(
          icon: DashboardMultiValueSwitchIcon(
            selectedIndex: multi.multiValueSwitchIndex,
            isOn: multi.isOn,
          ),
          deviceName: 'Multi-Value Switch',
          statusText: multi.multiValueSwitchCaption,
          mode: _multiValueSwitchManual ? 'M' : 'A',
          modeFilled: _multiValueSwitchManual,
          onModeTap: editing
              ? null
              : () => setState(
                  () => _multiValueSwitchManual = !_multiValueSwitchManual,
                ),
          controls: _buildLightingChevronButtons(
            markKey: 'multi',
            onLeft: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(
                isOn: true,
                multiValueSwitchIndex: (p.multiValueSwitchIndex - 1).clamp(
                  0,
                  2,
                ),
              ),
            ),
            onLeftLong: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(isOn: false),
            ),
            onRight: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(
                isOn: true,
                multiValueSwitchIndex: (p.multiValueSwitchIndex + 1).clamp(
                  0,
                  2,
                ),
              ),
            ),
            onRightLong: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(isOn: false),
            ),
          ),
          onNavigate: detailsNav(
            () => DeviceDetailsScreen.go(
              context,
              deviceTitle: 'Multi-Value Switch',
              imageAssetPath:
                  'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
              controlButtonCount: 12,
              controlMode: DeviceDetailsControlMode.multiValueSwitch,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLightingStepButtons({
    required String markKey,
    required VoidCallback onDown,
    required VoidCallback onUp,
    VoidCallback? onDownLong,
    VoidCallback? onUpLong,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleBtn(
          size: 35,
          marked: (_lightingStepMark[markKey] ?? 0) == 1,
          onTap: () => _flashMark(
            value: 1,
            getCurrent: () => _lightingStepMark[markKey] ?? 0,
            set: (v) => _lightingStepMark[markKey] = v,
            action: onDown,
          ),
          onLongPress: onDownLong == null
              ? null
              : () => _flashMark(
                  value: 1,
                  getCurrent: () => _lightingStepMark[markKey] ?? 0,
                  set: (v) => _lightingStepMark[markKey] = v,
                  action: onDownLong,
                ),
          child: Image.asset(
            'assets/Mask group (17).png',
            width: 13.w,
            height: 13.h,
            fit: BoxFit.contain,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(width: 17.w),
        _CircleBtn(
          size: 35,
          marked: (_lightingStepMark[markKey] ?? 0) == 2,
          onTap: () => _flashMark(
            value: 2,
            getCurrent: () => _lightingStepMark[markKey] ?? 0,
            set: (v) => _lightingStepMark[markKey] = v,
            action: onUp,
          ),
          onLongPress: onUpLong == null
              ? null
              : () => _flashMark(
                  value: 2,
                  getCurrent: () => _lightingStepMark[markKey] ?? 0,
                  set: (v) => _lightingStepMark[markKey] = v,
                  action: onUpLong,
                ),
          child: Transform.rotate(
            angle: math.pi,
            child: Image.asset(
              'assets/Mask group (17).png',
              width: 13.w,
              height: 13.h,
              fit: BoxFit.contain,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLightingPlusMinusButtons({
    required String markKey,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleBtn(
          size: 35,
          marked: (_lightingStepMark[markKey] ?? 0) == 1,
          onTap: () => _flashMark(
            value: 1,
            getCurrent: () => _lightingStepMark[markKey] ?? 0,
            set: (v) => _lightingStepMark[markKey] = v,
            action: onMinus,
          ),
          child: Icon(
            Icons.remove_rounded,
            size: 22.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(width: 17.w),
        _CircleBtn(
          size: 35,
          marked: (_lightingStepMark[markKey] ?? 0) == 2,
          onTap: () => _flashMark(
            value: 2,
            getCurrent: () => _lightingStepMark[markKey] ?? 0,
            set: (v) => _lightingStepMark[markKey] = v,
            action: onPlus,
          ),
          child: Icon(
            Icons.add_rounded,
            size: 22.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildLightingChevronButtons({
    required String markKey,
    required VoidCallback onLeft,
    required VoidCallback onRight,
    VoidCallback? onLeftLong,
    VoidCallback? onRightLong,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleBtn(
          size: 35,
          marked: (_lightingStepMark[markKey] ?? 0) == 1,
          onTap: () => _flashMark(
            value: 1,
            getCurrent: () => _lightingStepMark[markKey] ?? 0,
            set: (v) => _lightingStepMark[markKey] = v,
            action: onLeft,
          ),
          onLongPress: onLeftLong == null
              ? null
              : () => _flashMark(
                  value: 1,
                  getCurrent: () => _lightingStepMark[markKey] ?? 0,
                  set: (v) => _lightingStepMark[markKey] = v,
                  action: onLeftLong,
                ),
          child: Icon(
            Icons.chevron_left_rounded,
            size: 26.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(width: 17.w),
        _CircleBtn(
          size: 35,
          marked: (_lightingStepMark[markKey] ?? 0) == 2,
          onTap: () => _flashMark(
            value: 2,
            getCurrent: () => _lightingStepMark[markKey] ?? 0,
            set: (v) => _lightingStepMark[markKey] = v,
            action: onRight,
          ),
          onLongPress: onRightLong == null
              ? null
              : () => _flashMark(
                  value: 2,
                  getCurrent: () => _lightingStepMark[markKey] ?? 0,
                  set: (v) => _lightingStepMark[markKey] = v,
                  action: onRightLong,
                ),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 26.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildLightingSwitchControl({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 35.h,
      width: 60.w,
      child: CupertinoSwitch(
        value: value,
        onChanged: (v) {
          uiTapHaptic();
          onChanged(v);
        },
        activeColor: const Color(0xFF0088FE),
      ),
    );
  }

  Widget _buildLightingSliderControl({
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return SizedBox(
      width: 118.w,
      child: _DimmerPill(percent: value, onChanged: onChanged),
    );
  }

  Widget _buildLightingLargeRow({
    required Widget icon,
    required String deviceName,
    required String statusText,
    required Widget controls,
    required String mode,
    required bool modeFilled,
    VoidCallback? onModeTap,
    VoidCallback? onNavigate,
  }) {
    return Container(
      height: _lightingLargeRowHeightForWidgetSize(_lightingWidgetSize),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26.r),
      ),
      padding: EdgeInsets.only(left: 8.w, right: 10.w, top: 10.h, bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onNavigate == null
                ? null
                : () {
                    uiTapHaptic();
                    onNavigate();
                  },
            child: dashboardLightingIconFrame(icon),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onNavigate == null
                  ? null
                  : () {
                      uiTapHaptic();
                      onNavigate();
                    },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deviceName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF111827),
                      height: 1.08,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _ModeBadge(
                        mode: mode,
                        filled: modeFilled,
                        onTap: onModeTap,
                      ),
                      SizedBox(width: 10.w),
                      Flexible(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          controls,
        ],
      ),
    );
  }

  double _lightingSmallCardHeight({bool compact = false}) {
    if (compact) {
      return 8.h + kDashboardLightingIconSide + 6.h + 30.h + 6.h + 18.h + 8.h;
    }
    return 12.h + kDashboardLightingIconSide + 8.h + 38.h + 8.h + 20.h + 12.h;
  }

  Widget _buildLightingCard({
    required String deviceName,
    required String status,
    required String iconImage,
    required String mode,
    required bool modeFilled,
    Widget? iconWidget,
    Widget? controls,
    VoidCallback? onTap,
    VoidCallback? onModeTap,
    bool? compactOverride,
    double? cardHeightOverride,
    bool uniformControlSlot = false,
  }) {
    final bool compact = compactOverride ?? _lightingHorizontalScroll;
    final double controlSlotWidth = uniformControlSlot
        ? (compact ? 72.w : 96.w)
        : (compact ? 58.w : 88.w);
    final double controlMaxWidth = uniformControlSlot
        ? controlSlotWidth
        : (compact ? 72.w : 96.w);
    final double controlContentWidth = uniformControlSlot
        ? (compact ? 72.w : 87.w)
        : (compact ? 72.w : 96.w);
    final double controlContentHeight = compact ? 30.h : 35.h;
    final double vPad = compact ? 8.h : 12.h;
    final double gap = compact ? 6.h : 8.h;
    final double titleH = compact ? 30.h : 38.h;
    final double statusH = compact ? 18.h : 20.h;
    final radius = BorderRadius.circular(26.r);
    final Widget iconArea = dashboardLightingIconFrame(
      iconWidget ??
          Image.asset(
            iconImage,
            width: kDashboardLightingIconSide,
            height: kDashboardLightingIconSide,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: kDashboardLightingIconSide,
              height: kDashboardLightingIconSide,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
    );
    final double cardHeight =
        cardHeightOverride ?? _lightingSmallCardHeight(compact: compact);
    final double resolvedTitleH = cardHeightOverride == null
        ? titleH
        : math.max(
            titleH,
            cardHeight -
                (vPad * 2) -
                kDashboardLightingIconSide -
                (gap * 2) -
                statusH,
          );
    final Widget cardBody = SizedBox(
      height: cardHeight,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: radius,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: vPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kDashboardLightingIconSide,
              width: double.infinity,
              child: Align(alignment: Alignment.centerLeft, child: iconArea),
            ),
            SizedBox(height: gap),
            SizedBox(
              height: resolvedTitleH,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: gap),
            SizedBox(
              height: statusH,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                          fontFamily: 'Inter',
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (controls != null) ...[
                    SizedBox(width: 6.w),
                    SizedBox(
                      width: controlSlotWidth,
                      height: statusH,
                      child: OverflowBox(
                        maxWidth: controlMaxWidth,
                        maxHeight: controlContentHeight,
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: controlContentWidth,
                          height: controlContentHeight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: controls,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
    final Widget card = Stack(
      children: [
        cardBody,
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(mode: mode, filled: modeFilled, onTap: onModeTap),
        ),
      ],
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          uiTapHaptic();
          onTap();
        },
        borderRadius: radius,
        child: card,
      ),
    );
  }

  Widget _lightingProgress100() {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          center: Alignment.center,
          startAngle: -math.pi / 2,
          colors: [
            Color(0xFF15DFFE), // Vibrant cyan-blue at top (12 o'clock)
            Color(0xFF87CEEB), // Light aqua cyan at bottom (6 o'clock)
            Color(0xFF00BFFF), // Bright blue transitioning back
            Color(0xFF15DFFE), // Vibrant cyan-blue completing the circle
          ],
          stops: [0.0, 0.5, 0.75, 1.0],
        ),
      ),
      padding: EdgeInsets.all(3.w),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          '100%',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class _DashboardSectionNameDialog extends StatefulWidget {
  const _DashboardSectionNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_DashboardSectionNameDialog> createState() =>
      _DashboardSectionNameDialogState();
}

class _DashboardSectionNameDialogState
    extends State<_DashboardSectionNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final String value = _controller.text.trim();
    if (value.isNotEmpty) Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(left:14.w, right: 14.w, top:2.h, bottom: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 36.h,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Name section',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _confirm(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Inter',
                    color: const Color(0xFF111827),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Section name',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 11.h,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.r),
                      borderSide: const BorderSide(
                        color: Color(0xFF0088FE),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: _confirm,
                  child: Container(
                    height: 52.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088FE),
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10.w,
            top: 0.h,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tightFor(
                width:30.w,
                height: 30.w,
              ),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
              ),
              icon: Icon(
                Icons.close_rounded,
                size: 17.sp,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// Header

class _Header extends StatelessWidget {
  const _Header({
    required this.onMenuTap,
    required this.onEditTap,
    required this.onAddTap,
  });

  final VoidCallback onMenuTap;
  final VoidCallback onEditTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final double rightWidth = 32.w + 13.w + 32.w; // = 77.w

    return Row(
      children: [
        // Left area (match right width)
        SizedBox(
          width: rightWidth,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _PressableCircleSurface(
              side: 44.w,
              enableHaptic: false,
              onTap: onMenuTap,
              child: Image.asset(
                'assets/Group 35 (1).png',
                width: 26.w,
                height: 17.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Title (now truly centered)
        Expanded(
          child: Center(
            child: Text(
              'Dashboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),

        // Right area
        SizedBox(
          width: rightWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PressableCircleSurface(
                  side: 32.w,
                  enableHaptic: false,
                  onTap: onEditTap,
                  child: Image.asset(
                    'assets/image 89.png',
                    width: 22.w,
                    height: 22.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 13.w),
                _PressableCircleSurface(
                  side: 32.w,
                  enableHaptic: false,
                  onTap: onAddTap,
                  child: Icon(
                    Icons.add_rounded,
                    color: const Color(0xFF111827),
                    size: 23.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    this.imagePath,
  });

  final String label;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    final List<Color> selectedBorderColors = switch (label) {
      'Light' ||
      'Lighting' => const <Color>[Color(0xFFFDD720), Color(0xFF00D1FF)],
      'Shading' => const <Color>[Color(0xFF00D1FF), Color(0xFF38A4FE)],
      'HVAC' => const <Color>[Color(0xFF0088FE), Color(0xFFFE019A)],
      'Ventilation' => const <Color>[Color(0xFF00D1FF), Color(0xFF2AA8FF)],
      'Security' => const <Color>[Color(0xFF0088FE), Color(0xFFEB0FFD)],
      _ => const <Color>[Color(0xFFFDD720), Color(0xFF00D1FF)],
    };

    // ✅ auto width based on content (text)
    Widget pillBody(Widget child) {
      return IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0, // ✅ no extra forced width
            maxWidth: 220.w, // ✅ prevent too wide pills
          ),
          child: child,
        ),
      );
    }

    Widget innerRow({required bool selected}) {
      const iconBgColor = Color(0xFFF3F4F6);
      const iconActiveOnWhite = Color(0xFFFAB300);
      const iconActiveOnGray = Color(0xFF6B7280);
      const iconInactive = Color(0xFF111827);
      final iconActiveColor = (iconBgColor == Colors.white)
          ? iconActiveOnWhite
          : iconActiveOnGray;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w), // ✅ compact padding
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ icon circle
            Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 22.w,
                      height: 22.w,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      icon,
                      size: 20.sp,
                      color: selected ? iconActiveColor : iconInactive,
                    ),
            ),
            SizedBox(width: 10.w),

            // ✅ full text (no ellipsis)
            Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              uiTapHaptic();
              onTap!();
            },
      borderRadius: radius,
      child: isSelected
          ? pillBody(
              Container(
                height: 63.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: selectedBorderColors,
                  ),
                  borderRadius: radius,
                ),
                padding: EdgeInsets.all(1.6.r),
                child: Container(
                  height: 63.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: radius,
                  ),
                  child: innerRow(selected: true),
                ),
              ),
            )
          : pillBody(
              Container(
                height: 63.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFE1E1E1),
                    width: 1.5,
                  ),
                  borderRadius: radius,
                ),
                child: innerRow(selected: false),
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(
    this.title, {
    this.onEditTap,
    this.showEditButton = false,
    this.headerBackgroundImagePath,
  });

  final String title;
  final VoidCallback? onEditTap;
  final bool showEditButton;
  final String? headerBackgroundImagePath;

  @override
  Widget build(BuildContext context) {
    final Widget titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
            fontFamily: 'Inter',
          ),
        ),
        if (showEditButton && onEditTap != null)
          GestureDetector(
            onTap: onEditTap,
            child: Row(
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    fontFamily: 'Inter',
                    color: const Color(0xFF0088FE),
                  ),
                ),
                SizedBox(width: 5.w),
                Image.asset(
                  'assets/images/back_arro.png',
                  height: 11.h,
                  width: 11.w,
                  fit: BoxFit.contain,
                  color: const Color(0xFF0088FE),
                ),
              ],
            ),
          ),
      ],
    );

    final String? imagePath = headerBackgroundImagePath;
    if (imagePath == null || imagePath.isEmpty) {
      return titleRow;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.file(
            File(imagePath),
            width: double.infinity,
            height: 86.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 12.h),
        titleRow,
      ],
    );
  }
}

class _DashboardShakeWrapper extends StatefulWidget {
  const _DashboardShakeWrapper({required this.shaking, required this.child});

  final bool shaking;
  final Widget child;

  @override
  State<_DashboardShakeWrapper> createState() => _DashboardShakeWrapperState();
}

class _DashboardShakeWrapperState extends State<_DashboardShakeWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant _DashboardShakeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.shaking) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller
        ..stop()
        ..value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.shaking) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final double wave = math.sin(_controller.value * math.pi * 2);
        return Transform.rotate(angle: wave * 0.018, child: child);
      },
    );
  }
}

class _DashboardDraggableReorderSlot extends StatelessWidget {
  const _DashboardDraggableReorderSlot({
    required this.deviceId,
    required this.child,
    required this.feedbackWidth,
    required this.feedbackHeight,
    required this.onDragStarted,
    required this.onDragEnded,
    required this.onReorder,
  });

  final String deviceId;
  final Widget child;
  final double feedbackWidth;
  final double feedbackHeight;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;
  final ValueChanged<String> onReorder;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (DragTargetDetails<String> details) =>
          details.data != deviceId,
      onAcceptWithDetails: (DragTargetDetails<String> details) =>
          onReorder(details.data),
      builder: (context, candidateData, rejectedData) {
        final bool isHovering = candidateData.isNotEmpty;
        return LongPressDraggable<String>(
          data: deviceId,
          delay: const Duration(milliseconds: 250),
          onDragStarted: onDragStarted,
          onDragEnd: (_) => onDragEnded(),
          feedback: Material(
            color: Colors.transparent,
            elevation: 10,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(26.r),
            child: SizedBox(
              width: feedbackWidth,
              height: feedbackHeight,
              child: child,
            ),
          ),
          childWhenDragging: Opacity(opacity: 0.28, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: isHovering
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(26.r),
                    border: Border.all(
                      color: const Color(0xFF0088FE),
                      width: 2,
                    ),
                  )
                : null,
            child: child,
          ),
        );
      },
    );
  }
}

// ---------------------------
// Common Card Wrapper
// ---------------------------
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, this.compact = false});
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26.r), // ✅ FIX
      ),
      padding: EdgeInsets.all(compact ? 8.w : 16.w),
      child: child,
    );
  }
}

class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.mode, required this.filled, this.onTap});

  final String mode;
  final bool filled;
  final VoidCallback? onTap;

  static const Color _softGrey = Color(0xFFE1E1E1);
  static const Color _themeBlue = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: filled ? _themeBlue : _softGrey,
        shape: BoxShape.circle,
        // border: filled
        //     ? null
        //     : Border.all(color: _themeBlue.withValues(alpha: 0.45)),
      ),
      alignment: Alignment.center,
      child: Text(
        mode,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : _themeBlue,
        ),
      ),
    );
    if (onTap == null) return badge;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap == null
            ? null
            : () {
                uiTapHaptic();
                onTap!();
              },
        splashColor: _softGrey,
        highlightColor: const Color(0xFFE5E7EB),
        child: badge,
      ),
    );
  }
}

/// White at rest; gray fill only while the pointer is down (Material 3 ink
/// does not reliably match that).
class _PressableCircleSurface extends StatefulWidget {
  const _PressableCircleSurface({
    required this.side,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.marked = false,
    this.enableHaptic = true,
    this.idleTransparent = false,
  });

  final double side;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;

  /// When true, fill stays gray (last-used / "marked" control).
  final bool marked;
  final bool enableHaptic;

  /// No white disk at rest — only show fill while pressed or marked.
  final bool idleTransparent;

  static const Color _pressedFill = Color(0xFFE5E7EB);

  @override
  State<_PressableCircleSurface> createState() =>
      _PressableCircleSurfaceState();
}

class _PressableCircleSurfaceState extends State<_PressableCircleSurface> {
  bool _pressed = false;
  bool _longPressHandled = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final Color fill = (widget.marked || _pressed)
        ? _PressableCircleSurface._pressedFill
        : widget.idleTransparent
        ? Colors.transparent
        : Colors.white;
    final Widget circle = Container(
      width: widget.side,
      height: widget.side,
      decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: widget.child,
    );
    if (widget.onTap == null && widget.onLongPress == null) return circle;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        _longPressHandled = false;
        _setPressed(true);
      },
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (_longPressHandled) {
                _longPressHandled = false;
                _setPressed(false);
                return;
              }
              if (widget.enableHaptic) uiTapHaptic();
              widget.onTap!();
              _setPressed(false);
            },
      onLongPressStart: widget.onLongPressStart == null
          ? null
          : (_) {
              _longPressHandled = true;
              if (widget.enableHaptic) uiTapHaptic();
              widget.onLongPressStart!();
              _setPressed(false);
            },
      onLongPressEnd: widget.onLongPressEnd == null
          ? null
          : (_) {
              if (widget.enableHaptic) uiTapHaptic();
              widget.onLongPressEnd!();
              _setPressed(false);
            },
      onLongPress: widget.onLongPress == null && widget.onLongPressStart == null
          ? null
          : () {
              // If caller only provided the old onLongPress, call it here.
              if (widget.onLongPressStart == null &&
                  widget.onLongPress != null) {
                _longPressHandled = true;
                if (widget.enableHaptic) uiTapHaptic();
                widget.onLongPress!();
                _setPressed(false);
              }
            },
      child: circle,
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({
    required this.child,
    this.size,
    this.onTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.marked = false,
    this.idleTransparent = false,
  });

  final Widget child;
  final double? size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final bool marked;
  final bool idleTransparent;

  @override
  Widget build(BuildContext context) {
    final double side = (size ?? 32).w;
    return _PressableCircleSurface(
      side: side,
      onTap: onTap,
      onLongPress: onLongPress,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      marked: marked,
      idleTransparent: idleTransparent,
      child: child,
    );
  }
}

// ---------------------------
// Light Cards
// ---------------------------
class _LightDimmerCard extends StatelessWidget {
  const _LightDimmerCard({
    required this.title,
    required this.percent,
    required this.mode,
    required this.modeFilled,
    this.isOn = true,
    this.imagePath,
    this.imagePathOff,
    this.onPercentChanged,
    this.onNavigate,
    this.onModeTap,
    this.showModeBadge = true,
    this.compact = false,
    this.uniformControls = false,
  });

  final String title;
  final double percent;
  final String mode;
  final bool modeFilled;
  final bool showModeBadge;
  final bool compact;
  final bool uniformControls;
  final bool isOn;
  final String? imagePath;
  final String? imagePathOff;
  final ValueChanged<double>? onPercentChanged;
  final VoidCallback? onNavigate;
  final VoidCallback? onModeTap;

  String? get _displayImagePath {
    if ((!isOn || percent <= 0.001) && imagePathOff != null) {
      return imagePathOff;
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final top = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displayImagePath != null
            ? Image.asset(
                _displayImagePath!,
                width: compact ? 34.w : 52.w,
                height: compact ? 34.w : 52.w,
                fit: BoxFit.contain,
              )
            : Icon(
                Icons.lightbulb_outline,
                size: 52.sp,
                color: percent <= 0.001
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF15DFFE),
              ),
        SizedBox(height: compact ? 3.h : 10.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF111827),
            height: 1.18,
          ),
          maxLines: compact ? 4 : 2,
          overflow: compact ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
      ],
    );

    return Stack(
      children: [
        _CardShell(
          compact: compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onNavigate != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      uiTapHaptic();
                      onNavigate!();
                    },
                    borderRadius: BorderRadius.circular(18.r),
                    child: top,
                  ),
                )
              else
                top,
              const Spacer(),
              Row(
                children: [
                  SizedBox(
                    width: uniformControls ? 52.w : (compact ? 32.w : 52.w),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${(percent * 100).round()}%',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111827),
                        ),
                        textAlign: TextAlign.left,
                        // maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                  //SizedBox(width: 10.w),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 35.h,
                        width: 60.w,
                        child: CupertinoSwitch(
                          value: percent > 0.001,
                          onChanged: onPercentChanged == null
                              ? null
                              : (v) {
                                  uiTapHaptic();
                                  onPercentChanged!(v ? 1.0 : 0.0);
                                },
                          activeColor: const Color(0xFF0088FE),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showModeBadge)
          Positioned(
            right: 12.w,
            top: 12.w,
            child: _ModeBadge(mode: mode, filled: modeFilled, onTap: onModeTap),
          ),
      ],
    );
  }
}

class _DimmerPill extends StatelessWidget {
  const _DimmerPill({required this.percent, this.onChanged});

  final double percent;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);
    final bool isOff = p <= 0;
    final h = 35.h;
    final radius = 24.r;

    const Color offGreyFill = Color(0xFFE5E7EB);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double w =
            constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 133.w;

        final Widget pill = Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: isOff ? offGreyFill : Colors.white,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: const [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              children: [
                if (!isOff)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: (1 - p),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1E1E1),
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(radius),
                              left: Radius.circular(
                                (1 - p) >= 0.98 ? radius : 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 12.w,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      size: 18.sp,
                      color: isOff
                          ? const Color(0xFF111827)
                          : const Color(0xFFFAB300),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        if (onChanged == null) return pill;

        void applyDx(double dx) {
          onChanged!((dx / w).clamp(0.0, 1.0));
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) {
            uiTapHaptic();
            applyDx(d.localPosition.dx);
          },
          onHorizontalDragStart: (_) => uiTapHaptic(),
          onHorizontalDragUpdate: (d) => applyDx(d.localPosition.dx),
          child: pill,
        );
      },
    );
  }
}

class _ThermostatCard extends StatelessWidget {
  const _ThermostatCard({
    required this.title,
    required this.value,
    required this.mode,
    required this.modeFilled,
    required this.onMinus,
    required this.onPlus,
    this.isOn = true,
    this.minusMarked = false,
    this.plusMarked = false,
    this.imagePath,
    this.imagePathOff,
    this.onModeTap,
    this.onNavigate,
    this.showModeBadge = true,
    this.compact = false,
    this.uniformControls = false,
  });

  final String title;
  final double value;
  final String mode;
  final bool modeFilled;
  final bool isOn;
  final String? imagePath;
  final String? imagePathOff;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool showModeBadge;
  final VoidCallback? onModeTap;
  final VoidCallback? onNavigate;
  final bool minusMarked;
  final bool plusMarked;
  final bool compact;
  final bool uniformControls;

  String? get _displayImagePath {
    if (!isOn && imagePathOff != null) {
      return imagePathOff;
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final Widget headerColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displayImagePath != null
            ? Image.asset(
                _displayImagePath!,
                width: compact ? 34.w : 52.w,
                height: compact ? 34.w : 52.w,
                fit: BoxFit.contain,
              )
            : Icon(
                Icons.thermostat_outlined,
                size: 44.sp,
                color: const Color(0xFF0088FE),
              ),
        SizedBox(height: compact ? 3.h : 10.h),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title.split('\n').isNotEmpty ? title.split('\n')[0] : title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                    height: 1.15,
                  ),
                  maxLines: compact ? 4 : 2,
                  overflow: compact
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ),
              if (title.contains('\n')) ...[
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title.split('\n').length > 1 ? title.split('\n')[1] : '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF111827),
                      height: 1.15,
                      //fontWeight: FontWeight.w700,
                    ),
                    maxLines: compact ? 4 : 2,
                    overflow: compact
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Stack(
      children: [
        _CardShell(
          compact: compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: onNavigate != null
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            uiTapHaptic();
                            onNavigate!();
                          },
                          borderRadius: BorderRadius.circular(18.r),
                          child: headerColumn,
                        ),
                      )
                    : headerColumn,
              ),
              SizedBox(height: compact ? 2.h : 10.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool compactControls =
                      !uniformControls &&
                      (compact || constraints.maxWidth < 120);
                  final double btnSize = compactControls ? 22 : 35;
                  return Row(
                    children: [
                      _CircleBtn(
                        size: btnSize,
                        marked: minusMarked,
                        onTap: onMinus,
                        child: Icon(
                          Icons.remove,
                          size: compactControls ? 15.sp : 23.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${value.toStringAsFixed(1)}° c',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      _CircleBtn(
                        size: btnSize,
                        marked: plusMarked,
                        onTap: onPlus,
                        child: Icon(
                          Icons.add,
                          size: compactControls ? 15.sp : 23.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        if (showModeBadge)
          Positioned(
            right: 12.w,
            top: 12.w,
            child: _ModeBadge(mode: mode, filled: modeFilled, onTap: onModeTap),
          ),
      ],
    );
  }
}

class _BlindCard extends StatelessWidget {
  const _BlindCard({
    required this.title,
    required this.downPercent,
    required this.upPercent,
    required this.mode,
    required this.modeFilled,
    required this.onDown,
    required this.onUp,
    this.onDownLong,
    this.onUpLong,
    this.onDownLongStart,
    this.onDownLongEnd,
    this.onUpLongStart,
    this.onUpLongEnd,
    this.downMarked = false,
    this.upMarked = false,
    this.imagePath,
    this.previewLevel,
    this.levelPercent,
    this.useAwningPreview = false,
    this.blindAngle,
    this.useBlindSlatsPreview = false,
    this.slatsPreviewOverride,
    this.compactControlButtons = false,
    this.compact = false,
    this.softPreviewInterior = false,
    this.onModeTap,
    this.onNavigate,
    this.showModeBadge = true,
    this.uniformControls = false,
  });

  final String title;
  final int downPercent;
  final int upPercent;
  final String mode;
  final bool modeFilled;
  final bool showModeBadge;
  final String? imagePath;
  final double? previewLevel;

  /// When set, shows one level % between down/up (awning: 0↓ … 100↑).
  final int? levelPercent;
  final bool useAwningPreview;
  final double? blindAngle;
  final bool useBlindSlatsPreview;
  final Widget? slatsPreviewOverride;
  final bool compactControlButtons;
  final bool compact;
  final bool softPreviewInterior;
  final bool uniformControls;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final VoidCallback? onDownLong;
  final VoidCallback? onUpLong;
  final VoidCallback? onDownLongStart;
  final VoidCallback? onDownLongEnd;
  final VoidCallback? onUpLongStart;
  final VoidCallback? onUpLongEnd;
  final VoidCallback? onModeTap;
  final VoidCallback? onNavigate;
  final bool downMarked;
  final bool upMarked;

  @override
  Widget build(BuildContext context) {
    Widget titleInkWell(Widget child) {
      if (onNavigate == null) return child;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            uiTapHaptic();
            onNavigate!();
          },
          borderRadius: BorderRadius.circular(18.r),
          child: child,
        ),
      );
    }

    return Stack(
      children: [
        _CardShell(
          compact: compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (slatsPreviewOverride != null)
                titleInkWell(
                  compact
                      ? SizedBox(
                          width: 36.w,
                          height: 36.w,
                          child: FittedBox(child: slatsPreviewOverride!),
                        )
                      : slatsPreviewOverride!,
                )
              else if (previewLevel != null)
                titleInkWell(
                  useBlindSlatsPreview
                      ? DashboardBlindSlatsIcon(
                          level: previewLevel!,
                          angle: blindAngle ?? 1.0,
                        )
                      : useAwningPreview
                      ? DashboardAwningLevelIcon(
                          level: previewLevel!,
                          softInterior: softPreviewInterior,
                        )
                      : DashboardBlindSlatsIcon(
                          level: previewLevel!,
                          angle: 1.0,
                        ),
                )
              else if (imagePath != null)
                titleInkWell(
                  Image.asset(
                    imagePath!,
                    width: compact ? 36.w : 65.w,
                    height: compact ? 36.w : 65.w,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: compact ? 3.h : 17.h),
              Expanded(
                child: titleInkWell(
                  SizedBox.expand(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF111827),
                          height: 1.18,
                        ),
                        maxLines: compact ? 4 : 2,
                        overflow: compact
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: compact ? 2.h : 8.h),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool compactControls =
                        !uniformControls && (compact || compactControlButtons);
                    final double controlSize = compactControls ? 22 : 35;
                    final double iconSize = compactControls ? 9.sp : 13.sp;
                    final Widget downBtn = _CircleBtn(
                      marked: downMarked,
                      onTap: onDown,
                      onLongPress: onDownLong,
                      onLongPressStart: onDownLongStart,
                      onLongPressEnd: onDownLongEnd,
                      size: controlSize,
                      idleTransparent: false,
                      child: Image.asset(
                        'assets/Mask group (17).png',
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                        color: const Color(0xFF6B7280),
                      ),
                    );
                    final Widget upBtn = _CircleBtn(
                      marked: upMarked,
                      onTap: onUp,
                      onLongPress: onUpLong,
                      onLongPressStart: onUpLongStart,
                      onLongPressEnd: onUpLongEnd,
                      size: controlSize,
                      idleTransparent: false,
                      child: Transform.rotate(
                        angle: math.pi,
                        child: Image.asset(
                          'assets/Mask group (17).png',
                          width: iconSize,
                          height: iconSize,
                          fit: BoxFit.contain,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    );

                    if (levelPercent != null) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            downBtn,
                            Expanded(
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '$levelPercent%',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: upBtn,
                            ),
                          ],
                        ),
                      );
                    }

                    Widget levelStat() {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/Group 32.jpg',
                            width: 10.w,
                            height: 17.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '$downPercent%',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ],
                      );
                    }

                    Widget angleStat() {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/Vector 4.jpg',
                            width: 8.w,
                            height: 17.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '$upPercent%',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ],
                      );
                    }

                    return SizedBox(
                      width: constraints.maxWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          downBtn,
                          Expanded(
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    levelStat(),
                                    SizedBox(
                                      width: compactControls ? 3.w : 10.w,
                                    ),
                                    angleStat(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          upBtn,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showModeBadge)
          Positioned(
            right: 12.w,
            top: 12.w,
            child: _ModeBadge(mode: mode, filled: modeFilled, onTap: onModeTap),
          ),
      ],
    );
  }
}

class _ToggleCard extends StatefulWidget {
  const _ToggleCard({
    required this.title,
    required this.isOn,
    required this.mode,
    required this.modeFilled,
    this.imagePath,
    this.imagePathOff,
    this.onNavigate,
    this.onIsOnChanged,
    this.onModeTap,
    this.compact = false,
    this.uniformControls = false,
  });

  final String title;
  final bool isOn;
  final String mode;
  final bool modeFilled;
  final String? imagePath;
  final String? imagePathOff;
  final VoidCallback? onNavigate;
  final ValueChanged<bool>? onIsOnChanged;
  final VoidCallback? onModeTap;
  final bool compact;
  final bool uniformControls;

  @override
  State<_ToggleCard> createState() => _ToggleCardState();
}

class _ToggleCardState extends State<_ToggleCard> {
  late bool _on;

  @override
  void initState() {
    super.initState();
    _on = widget.isOn;
  }

  @override
  void didUpdateWidget(covariant _ToggleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOn != widget.isOn) {
      _on = widget.isOn;
    }
  }

  String? get _heroImagePath {
    if (!_on && widget.imagePathOff != null) {
      return widget.imagePathOff;
    }
    return widget.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final Widget headerColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroImagePath != null
            ? Image.asset(
                _heroImagePath!,
                width: widget.compact ? 34.w : 52.w,
                height: widget.compact ? 34.w : 52.w,
                fit: BoxFit.contain,
              )
            : Icon(
                Icons.water_drop_outlined,
                size: 42.sp,
                color: const Color(0xFF00C2FF),
              ),
        SizedBox(height: widget.compact ? 3.h : 17.h),
        Expanded(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
              height: 1.15,
            ),
            maxLines: widget.compact ? 4 : 2,
            overflow: widget.compact
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Stack(
      children: [
        _CardShell(
          compact: widget.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: widget.onNavigate != null
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            uiTapHaptic();
                            widget.onNavigate!();
                          },
                          borderRadius: BorderRadius.circular(18.r),
                          child: headerColumn,
                        ),
                      )
                    : headerColumn,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _on ? 'On' : 'Off',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                      0,
                      widget.compact && !widget.uniformControls ? -5.h : 0,
                    ),
                    child: SizedBox(
                      height: widget.compact && !widget.uniformControls
                          ? 24.h
                          : 35.h,
                      width: widget.compact && !widget.uniformControls
                          ? 40.w
                          : 60.w,
                      child: CupertinoSwitch(
                        value: _on,
                        onChanged: (v) {
                          uiTapHaptic();
                          setState(() => _on = v);
                          widget.onIsOnChanged?.call(v);
                        },
                        activeColor: const Color(0xFF0088FE),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          top: 12.w,
          child: _ModeBadge(
            mode: widget.mode,
            filled: widget.modeFilled,
            onTap: widget.onModeTap,
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatefulWidget {
  const _ChartCard();

  @override
  State<_ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<_ChartCard> {
  static const int _points = 20;

  late final math.Random _rng;
  late Timer _timer;
  late List<double> _main;
  late List<double> _secondary;
  double _marker = 0.55;

  @override
  void initState() {
    super.initState();
    _rng = math.Random();

    _main = <double>[
      0.18,
      0.24,
      0.40,
      0.34,
      0.55,
      0.78,
      0.46,
      0.30,
      0.64,
      0.52,
      0.45,
      0.36,
      0.42,
      0.54,
      0.60,
      0.58,
      0.62,
      0.70,
      0.74,
      0.68,
    ];
    _secondary = <double>[
      0.22,
      0.48,
      0.62,
      0.44,
      0.40,
      0.72,
      0.58,
      0.50,
      0.82,
      0.66,
      0.54,
      0.40,
      0.52,
      0.70,
      0.80,
      0.62,
      0.72,
      0.58,
      0.66,
      0.60,
    ];

    // Safety: if someone changes the lists above, keep lengths consistent.
    _main = _main.take(_points).toList(growable: true);
    _secondary = _secondary.take(_points).toList(growable: true);
    while (_main.length < _points) {
      _main.add(0.5);
    }
    while (_secondary.length < _points) {
      _secondary.add(0.55);
    }

    _timer = Timer.periodic(const Duration(milliseconds: 650), (_) {
      // Move the marker slowly like a realtime cursor.
      _marker += 0.02;
      if (_marker > 1.0) _marker = 0.0;

      _main = _shiftAdd(_main, _nextValue(_main.last, maxDelta: 0.12));
      _secondary = _shiftAdd(
        _secondary,
        _nextValue(_secondary.last, maxDelta: 0.10),
      );

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<double> _shiftAdd(List<double> series, double next) {
    final out = List<double>.from(series);
    if (out.isNotEmpty) out.removeAt(0);
    out.add(next);
    return out;
  }

  double _nextValue(double current, {required double maxDelta}) {
    // Smoothed random walk, clamped to keep it in a nice visual band.
    final delta = (_rng.nextDouble() * 2 - 1) * maxDelta;
    return (current + delta).clamp(0.12, 0.88);
  }

  double _sampleAtPercent(List<double> series, double percent) {
    if (series.isEmpty) return 0.5;
    if (series.length == 1) return series.first;
    final p = percent.clamp(0.0, 1.0);
    final x = p * (series.length - 1);
    final i = x.floor();
    final t = x - i;
    final a = series[i];
    final b = series[(i + 1).clamp(0, series.length - 1)];
    return a + (b - a) * t;
  }

  @override
  Widget build(BuildContext context) {
    final v = _sampleAtPercent(_main, _marker);
    final tempC = 18 + v * 12; // 18..30°C range for demo
    final label = '${tempC.toStringAsFixed(1)}°C';

    return Container(
      height: 210.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: CustomPaint(
          painter: _WaveChartPainter(
            markerXPercent: _marker,
            label: label,
            mainSeries: _main,
            secondarySeries: _secondary,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _WaveChartPainter extends CustomPainter {
  _WaveChartPainter({
    required this.markerXPercent,
    required this.label,
    required this.mainSeries,
    required this.secondarySeries,
  });

  final double markerXPercent; // 0..1
  final String label;
  final List<double> mainSeries;
  final List<double> secondarySeries;

  @override
  void paint(Canvas canvas, Size size) {
    final blue = const Color(0xFF0088FE);
    final lightBlue = const Color(0xFF9DBDFF);

    final chartTop = 0.0;
    final chartBottom = size.height - 0.5;
    final chartHeight = chartBottom - chartTop;

    List<Offset> toPoints(List<double> series) {
      final n = series.length;
      return List.generate(n, (i) {
        final t = i / (n - 1);
        final x = t * size.width;
        final y = chartTop + (1 - series[i]) * chartHeight;
        return Offset(x, y);
      });
    }

    final mainPts = toPoints(mainSeries);
    final secPts = toPoints(secondarySeries);

    Path smoothPath(List<Offset> pts) {
      if (pts.length < 2) return Path();
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (int i = 0; i < pts.length - 1; i++) {
        final p0 = i == 0 ? pts[i] : pts[i - 1];
        final p1 = pts[i];
        final p2 = pts[i + 1];
        final p3 = i + 2 < pts.length ? pts[i + 2] : p2;

        // Catmull-Rom to Bezier conversion.
        final cp1 = Offset(
          p1.dx + (p2.dx - p0.dx) / 6,
          p1.dy + (p2.dy - p0.dy) / 6,
        );
        final cp2 = Offset(
          p2.dx - (p3.dx - p1.dx) / 6,
          p2.dy - (p3.dy - p1.dy) / 6,
        );
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
      }
      return path;
    }

    final secondaryPath = smoothPath(secPts);
    final mainPath = smoothPath(mainPts);

    // Area fill under secondary curve.
    final fillPath = Path.from(secondaryPath)
      ..lineTo(size.width, chartBottom)
      ..lineTo(0, chartBottom)
      ..close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = blue.withOpacity(0.10);

    final secondaryPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = lightBlue.withOpacity(0.85);

    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = blue;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(secondaryPath, secondaryPaint);
    canvas.drawPath(mainPath, mainPaint);

    // Marker.
    final mx = (size.width * markerXPercent).clamp(0.0, size.width);
    double sampleYAtX(List<Offset> pts, double x) {
      for (int i = 0; i < pts.length - 1; i++) {
        final a = pts[i];
        final b = pts[i + 1];
        if (x >= a.dx && x <= b.dx) {
          final t = (x - a.dx) / (b.dx - a.dx);
          return a.dy + (b.dy - a.dy) * t;
        }
      }
      return pts.last.dy;
    }

    final my = sampleYAtX(mainPts, mx);

    final markerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = blue;

    // Solid line from point to bottom (like the screenshot).
    canvas.drawLine(Offset(mx, my), Offset(mx, chartBottom), markerPaint);

    // Dot on the curve.
    canvas.drawCircle(Offset(mx, my), 4, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(mx, my),
      4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = blue,
    );

    // Label pill (painted, so it matches exactly).
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const pillPadX = 10.0;
    const pillPadY = 6.0;
    final pillW = tp.width + pillPadX * 2;
    final pillH = tp.height + pillPadY * 2;
    final pillTop = 0.0;
    final pillLeft = (mx - pillW / 2).clamp(0.0, size.width - pillW);

    final pillRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(pillLeft, pillTop, pillW, pillH),
      const Radius.circular(10),
    );
    canvas.drawRRect(pillRRect, Paint()..color = blue);

    tp.paint(canvas, Offset(pillLeft + pillPadX, pillTop + pillPadY));

    // Dashed guide from pill to the curve (subtle).
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = blue.withOpacity(0.9);

    final y1 = pillTop + pillH + 6;
    final y2 = (my - 6).clamp(y1, chartBottom);
    const dash = 5.0;
    const gap = 4.0;
    double y = y1;
    while (y < y2) {
      final yEnd = (y + dash).clamp(y1, y2);
      canvas.drawLine(Offset(mx, y), Offset(mx, yEnd), dashPaint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _WaveChartPainter oldDelegate) {
    return oldDelegate.markerXPercent != markerXPercent ||
        oldDelegate.label != label ||
        !listEquals(oldDelegate.mainSeries, mainSeries) ||
        !listEquals(oldDelegate.secondarySeries, secondarySeries);
  }
}

// ---------------------------
// Circular progress painter
// ---------------------------
// class _CircularProgressPainter extends CustomPainter {
//   _CircularProgressPainter({required this.progress, required this.strokeWidth});
//
//   final double progress;
//   final double strokeWidth;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;
//
//     final bg = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..color = const Color(0xFFE1E1E1);
//
//     final fg = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round
//       ..color = const Color(0xFF0088FE);
//
//     canvas.drawCircle(center, radius, bg);
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       -math.pi / 2,
//       2 * math.pi * progress,
//       false,
//       fg,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
//     return oldDelegate.progress != progress ||
//         oldDelegate.strokeWidth != strokeWidth;
//   }
// }

// Screen body widgets for CustomBottomNavBar
// class _DevicesBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: 18.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // -------- Header (top bar) ----------
//               Padding(
//                 padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 10.h),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           'Devices',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF111827),
//                           ),
//                         ),
//                       ),
//                     ),
//                     _CircleIconButton(
//                       icon: Icons.more_horiz,
//                       onTap: () {},
//                     ),
//                     SizedBox(width: 10.w),
//                     _CircleIconButton(
//                       icon: Icons.add,
//                       bg: const Color(0xFF0088FE),
//                       iconColor: Colors.white,
//                       onTap: () {},
//                     ),
//                   ],
//                 ),
//               ),

//               // -------- Search ----------
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 14.w),
//                 child: _SearchBar(),
//               ),

//               SizedBox(height: 10.h),

//               // -------- Filter chips ----------
//               SizedBox(
//                 height: 34.h,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   padding: EdgeInsets.symmetric(horizontal: 14.w),
//                   children: const [
//                     _FilterChipPill(label: 'All', selected: true),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Favorites'),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Smart'),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Groups'),
//                     SizedBox(width: 8),
//                     _FilterChipPill(label: 'Category'),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 12.h),

//               // -------- Section Title ----------
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 14.w),
//                 child: Text(
//                   'Devices',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF111827),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 8.h),

//               // -------- List (rows) ----------
//               _DeviceListCard(
//                 children: [
//                   // RGBW
//                   _DeviceRow(
//                     topRight: const _TimeTag(text: '18:32', blueIcon: true),
//                     leading: const _GradientCircleIcon(size: 34),
//                     title: 'RGBW',
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: const [
//                             _ModeDot(text: 'A', filled: false),
//                             SizedBox(width: 6),
//                             _SmallText('Off'),
//                           ],
//                         ),
//                         const SizedBox(height: 2),
//                         const _TinyGreyText('LCD0C12'),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: const [
//                             _TagChip(text: 'Lighting', bg: Color(0xFF0088FE)),
//                             SizedBox(width: 6),
//                             _TagChip(text: 'Bathroom', bg: Color(0xFFFE019A)),
//                           ],
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const _CircleMiniBtn(icon: Icons.remove),
//                         SizedBox(width: 10.w),
//                         const _CircleMiniBtn(icon: Icons.add),
//                         SizedBox(width: 10.w),
//                         const _ToggleSwitch(isOn: true),
//                       ],
//                     ),
//                   ),

//                   const _RowDivider(),

//                   // Alarm
//                   _DeviceRow(
//                     leading: const _LockIcon(),
//                     title: 'Alarm',
//                     subtitle: const _SmallText('Disarmed'),
//                     trailing: const _CircleActionBlue(icon: Icons.power_settings_new),
//                   ),

//                   const _RowDivider(),

//                   // Bathroom
//                   _DeviceRow(
//                     leading: const _PowerRingIcon(),
//                     title: 'Bathroom',
//                     subtitle: Row(
//                       children: const [
//                         _ModeDot(text: 'M', filled: true),
//                         SizedBox(width: 8),
//                         Text(
//                           '24.6°categories',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF111827),
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const _CircleMiniBtn(icon: Icons.remove),
//                         SizedBox(width: 10.w),
//                         const _CircleMiniBtn(icon: Icons.add),
//                       ],
//                     ),
//                   ),

//                   const _RowDivider(),

//                   // Blind Living Room (selected highlight row)
//                   _DeviceRow(
//                     selected: true,
//                     topRight: const _StarTimeTag(time: '20:36'),
//                     leading: const _BlindGreenIcon(),
//                     title: 'Blind Living Room',
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         SizedBox(height: 2),
//                         _BlindStatsRow(),
//                         SizedBox(height: 3),
//                         _TinyGreyText('D012U12'),
//                       ],
//                     ),
//                     trailing: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         _CircleMiniBtn(icon: Icons.keyboard_arrow_up),
//                         SizedBox(height: 10),
//                         _CircleMiniBtn(icon: Icons.keyboard_arrow_down),
//                       ],
//                     ),
//                   ),

//                   const _RowDivider(),

//                   // Block Irrigation Schedule (blue play row)
//                   _DeviceRow(
//                     leading: const _PlayCircleIcon(),
//                     title: 'Block Irrigation Schedule',
//                     subtitle: const _SmallText('Blocked'),
//                     trailing: const _CircleActionBlue(icon: Icons.play_arrow),
//                   ),

//                   const _RowDivider(),

//                   // Brightness (with pill slider)
//                   _DeviceRow(
//                     topRight: const _StarOnly(),
//                     leading: const _SunIcon(),
//                     title: 'Brightness',
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         _BoldSmall('54%'),
//                         SizedBox(height: 2),
//                         _TinyGreyText('W5BT'),
//                       ],
//                     ),
//                     trailing: const _BrightnessPill(),
//                   ),

//                   const _RowDivider(),

//                   // Card Reader(s)
//                   _DeviceRow(
//                     leading: const _BulbIcon(),
//                     title: 'Card Reader(s)',
//                     subtitle: const _SmallText('Blocked'),
//                     trailing: const _ToggleSwitch(isOn: false),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 18.h),

//               // -------- Control units ----------
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 14.w),
//                 child: Text(
//                   'Control units',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF111827),
//                   ),
//                 ),
//               ),

//               SizedBox(height: 8.h),

//               _DeviceListCard(
//                 children: const [
//                   _ControlUnitRow(
//                     icon: Icons.memory,
//                     iconColor: Color(0xFF0088FE),
//                     title: 'CORE20',
//                     sub: 'CORE20-4B37-3419-363A',
//                   ),
//                   _RowDivider(),
//                   _ControlUnitRow(
//                     icon: Icons.warning_amber_rounded,
//                     iconColor: Color(0xFFFE019A),
//                     title: 'D012',
//                     sub: '11 Devices',
//                     sub2: 'CORE20-4B37-3419-363A',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _AnalyticsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Analytics',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Analytics Screen',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

// Devices Screen Helper Widgets

//
// class _DeviceListCard extends StatelessWidget {
//   const _DeviceListCard({required this.children});
//   final List<Widget> children;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 14.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18.r),
//       ),
//       child: Column(children: children),
//     );
//   }
// }
//
// class _DeviceRow extends StatelessWidget {
//   const _DeviceRow({
//     required this.leading,
//     required this.title,
//     required this.subtitle,
//     required this.trailing,
//     this.topRight,
//     this.selected = false,
//   });
//
//   final Widget leading;
//   final String title;
//   final Widget subtitle;
//   final Widget trailing;
//   final Widget? topRight;
//   final bool selected;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: selected ? const Color(0xFFEAF1FF) : Colors.white,
//       padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
//       child: Stack(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(width: 6.w),
//               SizedBox(
//                 width: 34.w,
//                 height: 34.w,
//                 child: Center(child: leading),
//               ),
//               SizedBox(width: 10.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF111827),
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     subtitle,
//                   ],
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               trailing,
//               SizedBox(width: 4.w),
//             ],
//           ),
//           if (topRight != null) Positioned(right: 0, top: 0, child: topRight!),
//         ],
//       ),
//     );
//   }
// }
//
// class _RowDivider extends StatelessWidget {
//   const _RowDivider();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 1,
//       margin: EdgeInsets.only(left: 56.w),
//       color: const Color(0xFFF1F1F1),
//     );
//   }
// }
//
// class _SearchBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40.h,
//       padding: EdgeInsets.symmetric(horizontal: 12.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(22.r),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.search, size: 18.sp, color: const Color(0xFF6B7280)),
//           SizedBox(width: 8.w),
//           Text(
//             'Search',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: const Color(0xFF9CA3AF),
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _FilterChipPill extends StatelessWidget {
//   const _FilterChipPill({required this.label, this.selected = false});
//   final String label;
//   final bool selected;
//
//   @override
//   Widget build(BuildContext context) {
//     final border = selected ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB);
//     final text = selected ? const Color(0xFF0088FE) : const Color(0xFF111827);
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: border, width: 1),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 12.sp,
//           color: text,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
//
// class _CircleIconButton extends StatelessWidget {
//   const _CircleIconButton({
//     required this.icon,
//     required this.onTap,
//     this.bg = const Color(0xFFF3F4F6),
//     this.iconColor = const Color(0xFF111827),
//   });
//
//   final IconData icon;
//   final VoidCallback onTap;
//   final Color bg;
//   final Color iconColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(999),
//       child: Container(
//         width: 32.w,
//         height: 32.w,
//         decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
//         alignment: Alignment.center,
//         child: Icon(icon, size: 18.sp, color: iconColor),
//       ),
//     );
//   }
// }
//
// class _CircleMiniBtn extends StatelessWidget {
//   const _CircleMiniBtn({required this.icon});
//   final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 30.w,
//       height: 30.w,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         shape: BoxShape.circle,
//       ),
//       alignment: Alignment.center,
//       child: Icon(icon, size: 18.sp, color: const Color(0xFF111827)),
//     );
//   }
// }
//
// class _CircleActionBlue extends StatelessWidget {
//   const _CircleActionBlue({required this.icon});
//   final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFF0088FE),
//         shape: BoxShape.circle,
//       ),
//       alignment: Alignment.center,
//       child: Icon(icon, size: 18.sp, color: Colors.white),
//     );
//   }
// }
//
// class _ToggleSwitch extends StatelessWidget {
//   const _ToggleSwitch({required this.isOn});
//   final bool isOn;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 52.w,
//       height: 30.h,
//       padding: EdgeInsets.all(2.w),
//       decoration: BoxDecoration(
//         color: isOn ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB),
//         borderRadius: BorderRadius.circular(99),
//       ),
//       child: Align(
//         alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           width: 30.86.w,
//           height: 30.86.w,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _SmallText extends StatelessWidget {
//   const _SmallText(this.text);
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w400,
//         color: const Color(0xFF6B7280),
//       ),
//     );
//   }
// }
//
// class _BoldSmall extends StatelessWidget {
//   const _BoldSmall(this.text);
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w700,
//         color: const Color(0xFF111827),
//       ),
//     );
//   }
// }
//
// class _TinyGreyText extends StatelessWidget {
//   const _TinyGreyText(this.text);
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 10.sp,
//         fontWeight: FontWeight.w400,
//         color: const Color(0xFF9CA3AF),
//       ),
//     );
//   }
// }

// class _ModeDot extends StatelessWidget {
//   const _ModeDot({required this.text, required this.filled});
//   final String text;
//   final bool filled;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 18.w,
//       height: 18.w,
//       decoration: BoxDecoration(
//         color: filled ? const Color(0xFF6B7280) : const Color(0xFFE5E7EB),
//         shape: BoxShape.circle,
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 10.sp,
//           fontWeight: FontWeight.w700,
//           color: filled ? Colors.white : const Color(0xFF111827),
//         ),
//       ),
//     );
//   }
// }

// Not working this code;
//
// class _TagChip extends StatelessWidget {
//   const _TagChip({required this.text, required this.bg});
//   final String text;
//   final Color bg;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(6.r),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 10.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
//
// class _TimeTag extends StatelessWidget {
//   const _TimeTag({required this.text, this.blueIcon = false});
//   final String text;
//   final bool blueIcon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           Icons.wifi,
//           size: 12.sp,
//           color: blueIcon ? const Color(0xFF0088FE) : const Color(0xFF9CA3AF),
//         ),
//         SizedBox(width: 4.w),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 10.sp,
//             color: const Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _StarTimeTag extends StatelessWidget {
//   const _StarTimeTag({required this.time});
//   final String time;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24)),
//         SizedBox(width: 4.w),
//         Text(
//           time,
//           style: TextStyle(
//             fontSize: 10.sp,
//             color: const Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _StarOnly extends StatelessWidget {
//   const _StarOnly();
//
//   @override
//   Widget build(BuildContext context) {
//     return Icon(Icons.star, size: 14.sp, color: const Color(0xFFFBBF24));
//   }
// }
//
// class _GradientCircleIcon extends StatelessWidget {
//   const _GradientCircleIcon({this.size = 34});
//   final double size;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size.w,
//       height: size.w,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: SweepGradient(
//           colors: [
//             Color(0xFF15DFFE),
//             Color(0xFF0088FE),
//             Color(0xFFFE019A),
//             Color(0xFFFFD700),
//             Color(0xFF15DFFE),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _LockIcon extends StatelessWidget {
//   const _LockIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFFFE4F1),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.lock_outline,
//         size: 18.sp,
//         color: const Color(0xFFFE019A),
//       ),
//     );
//   }
// }
//
// class _PowerRingIcon extends StatelessWidget {
//   const _PowerRingIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFEAFBF2),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.power_settings_new,
//         size: 18.sp,
//         color: const Color(0xFF10B981),
//       ),
//     );
//   }
// }
//
// class _BlindGreenIcon extends StatelessWidget {
//   const _BlindGreenIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFEAFBF2),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.blinds_outlined,
//         size: 18.sp,
//         color: const Color(0xFF84CC16),
//       ),
//     );
//   }
// }
//
// class _PlayCircleIcon extends StatelessWidget {
//   const _PlayCircleIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFEAF1FF),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.play_arrow,
//         size: 18.sp,
//         color: const Color(0xFF0088FE),
//       ),
//     );
//   }
// }
//
// class _SunIcon extends StatelessWidget {
//   const _SunIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFFFFBEB),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.wb_sunny_outlined,
//         size: 18.sp,
//         color: const Color(0xFFFBBF24),
//       ),
//     );
//   }
// }
//
// class _BulbIcon extends StatelessWidget {
//   const _BulbIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 34.w,
//       height: 34.w,
//       decoration: const BoxDecoration(
//         color: Color(0xFFF3F4F6),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.lightbulb_outline,
//         size: 18.sp,
//         color: const Color(0xFF84CC16),
//       ),
//     );
//   }
// }
//
// class _BlindStatsRow extends StatelessWidget {
//   const _BlindStatsRow();
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const _ModeDot(text: 'A', filled: false),
//         SizedBox(width: 10.w),
//         Icon(Icons.arrow_downward, size: 14.sp, color: const Color(0xFF111827)),
//         SizedBox(width: 4.w),
//         Text(
//           '0%',
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF111827),
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Icon(Icons.arrow_upward, size: 14.sp, color: const Color(0xFF111827)),
//         SizedBox(width: 4.w),
//         Text(
//           '50%',
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF111827),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _BrightnessPill extends StatelessWidget {
//   const _BrightnessPill();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150.w,
//       height: 30.h,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(99),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 95.w,
//             height: 30.h,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(99),
//             ),
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.only(left: 10.w),
//             child: Icon(
//               Icons.wb_sunny_outlined,
//               size: 16.sp,
//               color: const Color(0xFF111827),
//             ),
//           ),
//           Expanded(child: Container()),
//         ],
//       ),
//     );
//   }
// }
//
// class _ControlUnitRow extends StatelessWidget {
//   const _ControlUnitRow({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.sub,
//     this.sub2,
//   });
//
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String sub;
//   final String? sub2;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
//       child: Row(
//         children: [
//           Container(
//             width: 34.w,
//             height: 34.w,
//             decoration: const BoxDecoration(
//               color: Color(0xFFF3F4F6),
//               shape: BoxShape.circle,
//             ),
//             alignment: Alignment.center,
//             child: Icon(icon, size: 18.sp, color: iconColor),
//           ),
//           SizedBox(width: 10.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF111827),
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   sub,
//                   style: TextStyle(
//                     fontSize: 11.sp,
//                     color: const Color(0xFF6B7280),
//                   ),
//                 ),
//                 if (sub2 != null) ...[
//                   SizedBox(height: 2.h),
//                   Text(
//                     sub2!,
//                     style: TextStyle(
//                       fontSize: 10.sp,
//                       color: const Color(0xFF9CA3AF),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _ToggleColorswitch extends StatelessWidget {
  const _ToggleColorswitch({required this.isOn});
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w, // ✅ closer to iOS toggle size
      height: 35.h,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isOn ? const Color(0xFF0088FE) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 28.w,
          height: 28.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// Home Blind Living Room preview — level shows slat count, angle shows slat tilt.
class _HomeBlindSlatsIcon extends StatelessWidget {
  const _HomeBlindSlatsIcon({
    required this.level,
    required this.angle,
    this.softInterior = false,
  });

  final double level;
  final double angle;
  final bool softInterior;

  @override
  Widget build(BuildContext context) {
    final double side = kDashboardLightingIconSide;
    final double pad = softInterior ? 0 : 3.w;
    final double outerR = 6.r;
    final double innerR = math.max(0.0, outerR - pad);
    final Color interiorColor = softInterior
        ? const Color(0xFFF3F4F6)
        : kDeviceOffGreyFill;

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: interiorColor,
        borderRadius: BorderRadius.circular(outerR),
        border: Border.all(
          color: kDeviceOffGreyBorder,
          width: softInterior ? 2.w : 1.w,
        ),
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
              painter: _HomeBlindSlatsPainter(
                level: level.clamp(0.0, 1.0),
                angle: angle.clamp(0.0, 1.0),
                cornerRadius: innerR,
                backgroundColor: interiorColor,
                edgeToEdge: softInterior,
              ),
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBlindSlatsPainter extends CustomPainter {
  const _HomeBlindSlatsPainter({
    required this.level,
    required this.angle,
    this.cornerRadius = 0,
    this.backgroundColor = kDeviceOffGreyFill,
    this.edgeToEdge = false,
  });

  final double level;
  final double angle;
  final double cornerRadius;
  final Color backgroundColor;
  final bool edgeToEdge;

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

    canvas.drawRRect(clipRrect, Paint()..color = backgroundColor);

    canvas.save();
    canvas.clipRRect(clipRrect);

    final double horizontalInset = edgeToEdge ? 0 : size.width * 0.015;
    final double cx = size.width / 2;
    final double usableW = size.width - (horizontalInset * 2);
    final double bandH = size.height / _slatCount;
    const double gap = 0.8;
    final double maxSlatInBand = math.max(2.0, bandH - gap);
    final double a = angle.clamp(0.0, 1.0);
    final double slatH = maxSlatInBand * a.clamp(0.14, 1.25);
    final double topW = usableW * 1.02;
    final double baseTaper = 0.74 + 0.16 * a;
    final double flatBlend = a * a;
    final double taperT = (baseTaper * (1 - flatBlend) + 1.0 * flatBlend).clamp(
      0.66,
      1.0,
    );
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
  bool shouldRepaint(covariant _HomeBlindSlatsPainter old) =>
      old.level != level ||
      old.angle != angle ||
      old.cornerRadius != cornerRadius ||
      old.backgroundColor != backgroundColor ||
      old.edgeToEdge != edgeToEdge;
}
