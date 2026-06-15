import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/core/utils/ui_tap_haptic.dart';
import 'package:workpleis/features/device_details/device_dashboard_sync.dart';
import 'package:workpleis/features/device_details/screen/device_details_screen.dart';

import '../../devices/screen/devices_screen.dart';
import '../../home/widget/Add_section.dart';
import '../../home/widget/editAddSectionSheet.dart';
import '../../menu/screen/menu_screen.dart';
import '../../nav_bar/screen/custom_bottom_nav_bar.dart';
import '../../notifications/screen/notifications_screen.dart';
import '../../settings/screen/settings_screen.dart';


class Zone_Category_Screen extends StatefulWidget {
  const Zone_Category_Screen({
    super.key,
    this.screenTitle = 'Zone/Categories',
  });

  /// Shown in the top app bar; driven by menu query `?title=`.
  final String screenTitle;

  static const String routeName = '/zone_category';

  static String routeWithTitle(String title) =>
      '$routeName?title=${Uri.encodeComponent(title)}';


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
  State<Zone_Category_Screen> createState() => _Zone_Category_ScreenState();
}

enum _DashboardEditSection { light, lighting }

class _Zone_Category_ScreenState extends State<Zone_Category_Screen> {
  late int _categoryPillIndex;

  double _bedroomDimmer = 0.72;
  double _bathroomThermostat = 24.6;
  int _awningDown = 0;
  int _awningUp = 72;
  int _blindRoomLevel = 0;
  int _blindRoomAngle = 72;
  final List<int> _shadeDown = [100, 100, 100];
  final List<int> _shadeUp = [50, 50, 50];
  double _favThermostatM = 24.6;
  double _favThermostatA = 24.6;

  /// A/M mode badges and step marks (match [HomeScreen]).
  bool _bedroomManual = false;
  bool _bathroomManual = true;
  bool _blindManual = true;
  bool _lightingLedBadge1Manual = false;
  int _bathroomThermoMark = 0;
  int _awningMark = 0;
  int _blindRoomMark = 0;
  bool _irrigationOn = true;
  bool _motionSensorOn = true;
  final List<bool> _shadeManual = [true, false, true];
  final List<int> _shadeStepMark = [0, 0, 0];
  bool _favThermoMManual = true;
  bool _favThermoAManual = false;
  int _favThermoMMark = 0;
  int _favThermoAMark = 0;
  bool _ventilationManual = true;
  bool _livingRoomManual = true;

  /// Lighting section widget size from Edit sheet (S/M = grid, L/XL = large rows).
  String _lightingWidgetSize = 'S';
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

  List<String> _lightDeviceOrder =
      List<String>.from(_kDefaultLightDeviceOrder);
  List<String> _lightingDeviceOrder =
      List<String>.from(_kDefaultLightingDeviceOrder);
  final List<String> _lightRemovedDevices = <String>[];
  final List<String> _lightingRemovedDevices = <String>[];

  String _lightSectionTitle = 'Light';
  bool _lightHorizontalScroll = false;
  bool _lightingHorizontalScroll = false;
  _DashboardEditSection? _editingSection;
  String? _selectedEditDeviceId;

  late final VoidCallback _dashboardSyncListener;
  bool _suppressDashboardSyncPull = false;

  void _pullFromDashboardSync() {
    if (_suppressDashboardSyncPull) return;
    final DeviceDashboardSync sync = DeviceDashboardSync.instance;
    setState(() {
      final DeviceControlSnapshot light =
          sync.snapshotFor('Light dinning room');
      _bedroomDimmer =
          light.isOn ? light.dimmerPercent.clamp(0.0, 1.0) : 0.0;

      final DeviceControlSnapshot bath =
          sync.snapshotFor('Bathroom heating thermostat');
      _bathroomThermostat = bath.thermostatCelsius;
      _irrigationOn = sync.snapshotFor('Irrigation entry').isOn;
      _motionSensorOn = sync.snapshotFor('Motion Sensor').isOn;

      final DeviceControlSnapshot awning =
          sync.snapshotFor('Awning garden 123');
      _awningDown = awning.blindDownPercent;
      _awningUp = awning.blindUpPercent;

      final DeviceControlSnapshot blind =
          sync.snapshotFor('Blind Living Room');
      _blindRoomLevel = blind.blindDownPercent;
      _blindRoomAngle = blind.blindUpPercent;
    });
  }

  void _pushDashboardFor(String deviceTitle) {
    final DeviceControlSnapshot prev =
        DeviceDashboardSync.instance.snapshotFor(deviceTitle);
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

  bool get _lightingUsesLargeWidgets =>
      _lightingWidgetSize == 'L' || _lightingWidgetSize == 'XL';

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
      _lightDeviceOrder = next;
    } else {
      _lightingDeviceOrder = next;
    }
  }

  String _sectionRenameLabel(_DashboardEditSection section) =>
      section == _DashboardEditSection.light
          ? _lightSectionTitle
          : 'Lighting';

  bool _canMoveSelectedDevice(_DashboardEditSection section, int delta) {
    final String? id = _selectedEditDeviceId;
    if (id == null) return false;
    final List<String> order = _deviceOrderFor(section);
    final int index = order.indexOf(id);
    if (index < 0) return false;
    final int target = index + delta;
    return target >= 0 && target < order.length;
  }

  void _moveSelectedDevice(_DashboardEditSection section, int delta) {
    final String? id = _selectedEditDeviceId;
    if (id == null || !_canMoveSelectedDevice(section, delta)) return;
    final List<String> order = List<String>.from(_deviceOrderFor(section));
    final int index = order.indexOf(id);
    final int target = index + delta;
    order[index] = order[target];
    order[target] = id;
    setState(() => _setDeviceOrderFor(section, order));
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

  void _restoreRemovedDevice(_DashboardEditSection section) {
    final List<String> removed = _removedDevicesFor(section);
    if (removed.isEmpty) return;
    final String id = removed.removeLast();
    setState(() {
      final List<String> order = List<String>.from(_deviceOrderFor(section));
      order.add(id);
      _setDeviceOrderFor(section, order);
      _selectedEditDeviceId = id;
    });
  }

  Future<void> _renameDashboardSection(_DashboardEditSection section) async {
    final TextEditingController controller = TextEditingController(
      text: _sectionRenameLabel(section),
    );
    final String? next = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename section'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Section name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
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
    setState(() {
      _editingSection = null;
      _selectedEditDeviceId = null;
    });
  }

  void _openDashboardSectionEdit(
    BuildContext context,
    _DashboardEditSection section,
  ) {
    final List<String> order = _deviceOrderFor(section);
    setState(() {
      _editingSection = section;
      _selectedEditDeviceId ??=
          order.isNotEmpty ? order.first : null;
      if (_selectedEditDeviceId != null &&
          !order.contains(_selectedEditDeviceId)) {
        _selectedEditDeviceId = order.isNotEmpty ? order.first : null;
      }
    });
  }

  Widget _buildDashboardEditOverlay() {
    final _DashboardEditSection? section = _editingSection;
    if (section == null) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: EditAddSectionSheet(
        onClose: _closeDashboardSectionEdit,
        sectionRenameLabel: _sectionRenameLabel(section),
        onRenameTap: () => _renameDashboardSection(section),
        onAddDeviceTap: () => _restoreRemovedDevice(section),
        onMoveUp: () => _moveSelectedDevice(section, -1),
        onMoveDown: () => _moveSelectedDevice(section, 1),
        canMoveUp: _canMoveSelectedDevice(section, -1),
        canMoveDown: _canMoveSelectedDevice(section, 1),
        onRemove: () => _removeSelectedDevice(
          section,
          _closeDashboardSectionEdit,
        ),
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
        showWidgetSize: section == _DashboardEditSection.lighting,
        initialSize: _lightingWidgetSize,
        onSizeChanged: (v) => setState(() => _lightingWidgetSize = v),
      ),
    );
  }

  void _showLightSectionEdit(BuildContext context) =>
      _openDashboardSectionEdit(context, _DashboardEditSection.light);

  void _showLightingSectionEdit(BuildContext context) =>
      _openDashboardSectionEdit(context, _DashboardEditSection.lighting);

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
          child: child,
        ),
        if (selected)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
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
          top: 4.h,
          right: 4.w,
          child: GestureDetector(
            onTap: () => _removeDeviceById(
              section,
              deviceId,
              onEmpty: _closeDashboardSectionEdit,
            ),
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              'assets/images/cross.png',
              width: 28.w,
              height: 28.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  void _blindLivingRoomAdjustLevel(int delta) {
    _blindRoomLevel = (_blindRoomLevel + delta).clamp(0, 100);
    _pushDashboardFor('Blind Living Room');
  }

  void _blindLivingRoomAdjustAngle(int delta) {
    _blindRoomAngle = (_blindRoomAngle + delta).clamp(0, 100);
    _pushDashboardFor('Blind Living Room');
  }

  void _blindLivingRoomSetLevel(int percent) {
    _blindRoomLevel = percent.clamp(0, 100);
    _pushDashboardFor('Blind Living Room');
  }

  void _blindLivingRoomSetAngle(int percent) {
    _blindRoomAngle = percent.clamp(0, 100);
    _pushDashboardFor('Blind Living Room');
  }

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

  @override
  void initState() {
    super.initState();
    _categoryPillIndex = _categoryPillIndexForTitle(widget.screenTitle);
    _pullFromDashboardSync();
    _dashboardSyncListener = () {
      if (mounted) _pullFromDashboardSync();
    };
    DeviceDashboardSync.instance.addListener(_dashboardSyncListener);
  }

  @override
  void dispose() {
    DeviceDashboardSync.instance.removeListener(_dashboardSyncListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Zone_Category_Screen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screenTitle != widget.screenTitle) {
      _categoryPillIndex = _categoryPillIndexForTitle(widget.screenTitle);
    }
  }

  static int _categoryPillIndexForTitle(String title) {
    final t = title.toLowerCase();
    if (t.contains('security')) return 3;
    if (t.contains('shading')) return 1;
    if (t.contains('ventilation') || t.contains('hvac')) return 2;
    return 0;
  }

  Widget _buildHomeBody(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final headerChrome = 56.h;
    final scrollTopPadding = topInset + headerChrome + 10.h;
    final double editSheetInset = _editingSection != null ? 360.h : 0;

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
                        SizedBox(
                          height: 63.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _CategoryPill(
                                label: 'Light',
                                isSelected: _categoryPillIndex == 0,
                                icon: Icons.lightbulb_outline,
                                imagePath: 'assets/Mask group (3).png',
                                onTap: () {
                                  setState(() => _categoryPillIndex = 0);
                                  DeviceDetailsScreen.go(
                                    context,
                                    deviceTitle: 'Light dinning room',
                                    imageAssetPath: 'assets/Mask group (5).png',
                                    controlButtonCount: 3,
                                  );
                                },
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'Shading',
                                isSelected: _categoryPillIndex == 1,
                                icon: Icons.blinds_outlined,
                                imagePath: 'assets/Mask group (2).png',
                                onTap: () =>
                                    setState(() => _categoryPillIndex = 1),
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'HVAC',
                                isSelected: _categoryPillIndex == 2,
                                icon: Icons.ac_unit_outlined,
                                imagePath: 'assets/Mask group (4).png',
                                onTap: () =>
                                    setState(() => _categoryPillIndex = 2),
                              ),
                              SizedBox(width: 12.w),
                              _CategoryPill(
                                label: 'Security',
                                isSelected: _categoryPillIndex == 3,
                                icon: Icons.ac_unit_outlined,
                                imagePath: 'assets/securety.png',
                                onTap: () =>
                                    setState(() => _categoryPillIndex = 3),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        _SectionTitle(
                          _lightSectionTitle,
                          onEditTap: () => _showLightSectionEdit(context),
                        ),
                        SizedBox(height: 12.h),

                        _buildLightSectionDevices(),

                        SizedBox(height: 18.h),

                        _SectionTitle(
                          'Lighting',
                          onEditTap: () => _showLightingSectionEdit(context),
                        ),
                        SizedBox(height: 12.h),

                        _buildLightingSectionCards(),

                        SizedBox(height: 18.h),

                        _buildFavoritesSection(),
                        SizedBox(height: 18.h),

                        _buildShadingSection(),

                        SizedBox(height: 18.h),

                        const _SectionTitle('Chart Section'),
                        SizedBox(height: 12.h),

                        // ✅ Chart card
                        _ChartCard(),

                        SizedBox(height: 70.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_editingSection != null) _buildDashboardEditOverlay(),
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
                          title: widget.screenTitle,
                          onMenuTap: () {
                            ctx.push(MenuScreen.routeName);
                          },
                          onEditTap: () => _showLightSectionEdit(ctx),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      initialIndex: 2,
      translucentBottomBar: true,
      bottomBarBackgroundOpacity: 0,
      backgroundColor: Colors.white,
      // Voice/Home is index 2
      // drawer: Drawer(
      //   child: SafeArea(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         Padding(
      //           padding: EdgeInsets.all(20.w),
      //           child: Text(
      //             'Menu',
      //             style: TextStyle(
      //               fontSize: 22.sp,
      //               fontWeight: FontWeight.w600,
      //               color: const Color(0xFF111827),
      //             ),
      //           ),
      //         ),
      //         const Divider(height: 1),
      //         ListTile(
      //           leading: const Icon(Icons.menu, color: Color(0xFF111827)),
      //           title: Text(
      //             'Menu',
      //             style: TextStyle(
      //               fontSize: 16.sp,
      //               fontWeight: FontWeight.w500,
      //               color: const Color(0xFF111827),
      //             ),
      //           ),
      //           onTap: () {
      //             Navigator.pop(context);
      //             context.push(MenuScreen.routeName);
      //           },
      //         ),
      //
      //         ///PROFILE MENU OPTION
      //
      //         // ListTile(
      //         //   leading: const Icon(
      //         //     Icons.person_outline,
      //         //     color: Color(0xFF111827),
      //         //   ),
      //         //   title: Text(
      //         //     'Profile',
      //         //     style: TextStyle(
      //         //       fontSize: 16.sp,
      //         //       fontWeight: FontWeight.w500,
      //         //       color: const Color(0xFF111827),
      //         //     ),
      //         //   ),
      //         //   onTap: () {
      //         //     Navigator.pop(context);
      //         //     context.push(ProfileScreen.routeName);
      //         //   },
      //         // ),
      //
      //
      //
      //
      //
      //
      //         // ListTile(
      //         //   leading: const Icon(
      //         //     Icons.align_horizontal_center,
      //         //     color: Color(0xFF111827),
      //         //   ),
      //         //   title: Text(
      //         //     'Zones',
      //         //     style: TextStyle(
      //         //       fontSize: 16.sp,
      //         //       fontWeight: FontWeight.w500,
      //         //       color: const Color(0xFF111827),
      //         //     ),
      //         //   ),
      //         //   onTap: () {
      //         //     Navigator.pop(context);
      //         //
      //         //   },
      //         // ),
      //       ],
      //     ),
      //   ),
      // ),
      children: [
        // Index 0: Devices
        RepaintBoundary(child: DevicesScreen(showBottomNav: false)),
        // Index 1: Analytics (single shell nav: no second bottom bar)
        const RepaintBoundary(
          child: AnalyticsScreen(showBottomNav: false),
        ),
        // Index 2: Home/Voice
        RepaintBoundary(child: _buildHomeBody(context)),
        // Index 3: Notifications
        RepaintBoundary(child: NotificationsScreen(showBottomNav: false)),
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
                    fontSize: 16.sp,
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
              child: _buildThermostatCard(value: _favThermostatM),
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
              child: _buildThermostatCard(value: _favThermostatA),
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

  Widget _buildThermostatCard({required double value}) {
    return Container(
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
            'Bedroom Thermostat\nparents room',
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
          Align(
            alignment: Alignment.center,
            child: Text(
              '${value.toStringAsFixed(1)}°c',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightSectionDevices() {
    final List<String> ids = _lightDeviceOrder;
    if (ids.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_lightHorizontalScroll) {
      return SizedBox(
        height: _editingSection == _DashboardEditSection.light ? 200.h : 185.h,
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
              width: 168.w,
              child: Padding(
                padding: EdgeInsets.only(
                  top: _editingSection == _DashboardEditSection.light ? 8.h : 0,
                  right: _editingSection == _DashboardEditSection.light ? 8.w : 0,
                ),
                child: _wrapDashboardEditTarget(
                  section: _DashboardEditSection.light,
                  deviceId: id,
                  child: _buildLightDeviceCard(id),
                ),
              ),
            );
          },
        ),
      );
    }

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < ids.length; i += 2) {
      if (i > 0) rows.add(SizedBox(height: 12.h));
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _wrapDashboardEditTarget(
                section: _DashboardEditSection.light,
                deviceId: ids[i],
                child: _buildLightDeviceCard(ids[i]),
              ),
            ),
            if (i + 1 < ids.length) ...[
              SizedBox(width: 12.w),
              Expanded(
                child: _wrapDashboardEditTarget(
                  section: _DashboardEditSection.light,
                  deviceId: ids[i + 1],
                  child: _buildLightDeviceCard(ids[i + 1]),
                ),
              ),
            ] else
              const Expanded(child: SizedBox.shrink()),
          ],
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildLightDeviceCard(String deviceId) {
    final bool editing = _editingSection == _DashboardEditSection.light;
    final DeviceControlSnapshot diningLight = _snap('Light dinning room');
    final DeviceControlSnapshot bathroomHeat =
        _snap('Bathroom heating thermostat');

    switch (deviceId) {
      case 'light_dining':
        return SizedBox(
          height: 185.h,
          child: _LightDimmerCard(
            title: 'Light dinning room ',
            percent: _bedroomDimmer,
            mode: _bedroomManual ? 'M' : 'A',
            modeFilled: _bedroomManual,
            showModeBadge: false,
            isOn: diningLight.isOn,
            imagePath: 'assets/Mask group (5).png',
            imagePathOff: 'assets/images/light_of.png',
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
          height: 185.h,
          child: _ThermostatCard(
            title: 'Bathroom heating thermostat',
            value: _bathroomThermostat,
            mode: _bathroomManual ? 'M' : 'A',
            modeFilled: _bathroomManual,
            showModeBadge: false,
            isOn: bathroomHeat.isOn,
            imagePath: 'assets/Mask group (6).png',
            imagePathOff: 'assets/images/bathroom_off.png',
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
                        _bathroomThermostat =
                            (_bathroomThermostat - 0.5).clamp(10.0, 35.0);
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
                        _bathroomThermostat =
                            (_bathroomThermostat + 0.5).clamp(10.0, 35.0);
                        _pushDashboardFor('Bathroom heating thermostat');
                      },
                    ),
          ),
        );
      case 'awning':
        return SizedBox(
          height: 185.h,
          child: _BlindCard(
            title: 'Awning garden 123',
            downPercent: _awningDown,
            upPercent: _awningUp,
            levelPercent: _awningUp,
            mode: _blindManual ? 'M' : 'A',
            modeFilled: _blindManual,
            showModeBadge: false,
            previewLevel: _awningUp / 100.0,
            useAwningPreview: true,
            imagePath: 'assets/Rectangle 823.png',
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
                : () => setState(() => _blindManual = !_blindManual),
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
          height: 185.h,
          child: _ToggleCard(
            title: 'Irrigation entry ',
            showModeBadge: false,
            isOn: _irrigationOn,
            imagePath: 'assets/Mask group (7).png',
            imagePathOff: 'assets/images/irrigation_of.png',
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
          height: 185.h,
          child: _BlindCard(
            title: 'Blind Living Room',
            downPercent: _blindRoomLevel,
            upPercent: _blindRoomAngle,
            mode: _blindManual ? 'M' : 'A',
            modeFilled: _blindManual,
            showModeBadge: false,
            previewLevel: _blindRoomLevel / 100.0,
            blindAngle: _blindRoomAngle / 100.0,
            useBlindSlatsPreview: true,
            imagePath: 'assets/Rectangle 823.png',
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
                      action: () => _blindLivingRoomAdjustLevel(10),
                    ),
            onDownLong: editing
                ? null
                : () => _flashMark(
                      value: 1,
                      getCurrent: () => _blindRoomMark,
                      set: (v) => _blindRoomMark = v,
                      action: () => _blindLivingRoomSetLevel(0),
                    ),
            onUp: editing
                ? () {}
                : () => _flashMark(
                      value: 2,
                      getCurrent: () => _blindRoomMark,
                      set: (v) => _blindRoomMark = v,
                      action: () => _blindLivingRoomAdjustAngle(-10),
                    ),
            onUpLong: editing
                ? null
                : () => _flashMark(
                      value: 2,
                      getCurrent: () => _blindRoomMark,
                      set: (v) => _blindRoomMark = v,
                      action: () => _blindLivingRoomSetAngle(100),
                    ),
          ),
        );
      case 'motion':
        return SizedBox(
          height: 185.h,
          child: _ToggleCard(
            title: 'Motion Sensor',
            showModeBadge: false,
            isOn: _motionSensorOn,
            imagePath: 'assets/images/update_sensor.png',
            imagePathOff: 'assets/images/motion_sensor_off.png',
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
    return _buildLightingSectionCardsSmall();
  }

  Widget _buildLightingSectionCardsSmall() {
    final List<String> ids = _lightingDeviceOrder;
    if (ids.isEmpty) return const SizedBox.shrink();

    final double cardWidth =
        (MediaQuery.sizeOf(context).width - 32.w - 24.w) / 3;

    if (_lightingHorizontalScroll) {
      final double cardHeight = _lightingSmallCardHeight(compact: true);
      final double listHeight = cardHeight +
          (_editingSection == _DashboardEditSection.lighting ? 8.h : 0);
      return SizedBox(
        height: listHeight,
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
              width: cardWidth,
              child: Padding(
                padding: EdgeInsets.only(
                  top: _editingSection == _DashboardEditSection.lighting ? 8.h : 0,
                  right:
                      _editingSection == _DashboardEditSection.lighting ? 8.w : 0,
                ),
                child: _wrapDashboardEditTarget(
                  section: _DashboardEditSection.lighting,
                  deviceId: id,
                  child: _buildLightingSmallCardById(id),
                ),
              ),
            );
          },
        ),
      );
    }

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < ids.length; i += 3) {
      if (i > 0) rows.add(SizedBox(height: 12.h));
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int col = 0; col < 3; col++) ...[
              if (col > 0) SizedBox(width: 12.w),
              Expanded(
                child: i + col < ids.length
                    ? _wrapDashboardEditTarget(
                        section: _DashboardEditSection.lighting,
                        deviceId: ids[i + col],
                        child: _buildLightingSmallCardById(ids[i + col]),
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

  Widget _buildLightingSmallCardById(String deviceId) {
    final bool editing = _editingSection == _DashboardEditSection.lighting;
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
          iconImage:
              'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
          iconWidget: DashboardLightSceneIcon(sceneIndex: scene.sceneIndex),
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Light Scene',
                imageAssetPath:
                    'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
                controlButtonCount: 3,
                controlMode: DeviceDetailsControlMode.lightSceneValues,
              )),
        );
      case 'rgbw':
        return _buildLightingCard(
          deviceName: 'RGBW room abc',
          status: '${(rgbw.rgbwIntensity * 100).round()}%',
          iconWidget: DashboardRgbwIcon(
            hue: rgbw.rgbwHue,
            saturation: rgbw.rgbwSaturation,
            intensity: rgbw.rgbwIntensity,
          ),
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'RGBW room abc',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 2,
                controlMode: DeviceDetailsControlMode.rgbwPicker,
              )),
        );
      case 'led_dimmer':
        return _buildLightingCard(
          deviceName: 'LED Dimmer living room',
          status: '${(led.ledDimmerPercent * 100).round()}%',
          iconWidget: DashboardRingProgressIcon(
            percent: led.ledDimmerPercent,
            ringStyle: DashboardRingStyle.led,
          ),
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'LED Dimmer living room',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.ledDimmer,
              )),
        );
      case 'heating_cooling':
        return _buildLightingCard(
          deviceName: 'Heating & Cooling',
          status: hvac.heatingCoolingStatusLabel,
          iconImage: 'assets/images/heating_cooling.png',
          iconWidget: DashboardHeatingCoolingIcon(isOn: hvac.isOn),
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Heating & Cooling',
                imageAssetPath: 'assets/images/heating_cooling.png',
                controlButtonCount: 3,
                controlMode: DeviceDetailsControlMode.heatingCooling,
              )),
        );
      case 'tunable_white':
        return _buildLightingCard(
          deviceName: 'Tunable white light',
          status: '${(tunable.tunableWhiteIntensity * 100).round()}%',
          iconImage: 'assets/white_light.png',
          iconWidget: DashboardTunableWhiteIcon(
            dotDx: tunable.tunableWhiteDotDx,
            dotDy: tunable.tunableWhiteDotDy,
            intensity: tunable.tunableWhiteIntensity,
          ),
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Tunable white light',
                imageAssetPath: 'assets/white_light.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.tunableWhite,
              )),
        );
      case 'ventilation':
        return _buildLightingCard(
          deviceName: 'Ventilation',
          status: '${(vent.ventilationPercent * 100).round()}%',
          iconWidget: DashboardVentilationIcon(percent: vent.ventilationPercent),
          iconImage: 'assets/images/ventilations.png',
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Ventilation',
                imageAssetPath: 'assets/images/ventilations.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.ventilation,
              )),
        );
      case 'fan_level_3':
        return _buildLightingCard(
          deviceName: 'Fan Level 3',
          status: fan.fanStatusLabel,
          iconImage: 'assets/images/Fun_level3.png',
          iconWidget: DashboardFanLevelIcon(level: fan.fanLevel),
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Fan Level 3',
                imageAssetPath: 'assets/images/Fun_level3.png',
                controlButtonCount: 3,
                controlMode: DeviceDetailsControlMode.fanLevel,
              )),
        );
      case 'presence':
        return _buildLightingCard(
          deviceName: 'Presence',
          status: presence.presenceLabel,
          iconImage: 'assets/images/comfort.png',
          iconWidget: DashboardPresenceModeIcon(
            modeIndex: presence.presenceModeIndex,
            isOn: presence.isOn,
          ),
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Presence',
                imageAssetPath: 'assets/images/comfort.png',
                controlButtonCount: 2,
                controlMode: DeviceDetailsControlMode.presenceModes,
              )),
        );
      case 'living_room':
        return _buildLightingCard(
          deviceName: 'Living room',
          status: '${living.thermostatRingCelsius.toStringAsFixed(1)}° c',
          iconWidget: DashboardThermostatRingIcon(
            percent: living.thermostatRingPercent,
            currentTempCelsius: living.thermostatCelsius,
          ),
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Living Room',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.thermostatRing,
              )),
        );
      case 'multi_value_switch':
        return _buildLightingCard(
          deviceName: 'Multi-Value Switch',
          status: multi.multiValueSwitchCaption,
          iconImage:
              'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
          iconWidget: DashboardMultiValueSwitchIcon(
            selectedIndex: multi.multiValueSwitchIndex,
            isOn: multi.isOn,
          ),
          onTap: detailsTap(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Multi-Value Switch',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 12,
                controlMode: DeviceDetailsControlMode.multiValueSwitch,
              )),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLightingSectionCardsLarge() {
    final List<String> ids = _lightingDeviceOrder;
    if (ids.isEmpty) return const SizedBox.shrink();

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < ids.length; i++) {
      final Widget row = _wrapDashboardEditTarget(
        section: _DashboardEditSection.lighting,
        deviceId: ids[i],
        child: _buildLightingLargeRowById(ids[i]),
      );
      if (i < ids.length - 1) {
        children.add(Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: row,
        ));
      } else {
        children.add(row);
      }
    }
    return Column(children: children);
  }

  Widget _buildLightingLargeRowById(String deviceId) {
    final bool editing = _editingSection == _DashboardEditSection.lighting;
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
          controls: _buildLightingStepButtons(
            markKey: 'scene',
            onDown: () => _patchSnap(
              'Light Scene',
              (p) => p.copyWith(sceneIndex: (p.sceneIndex - 1).clamp(0, 2)),
            ),
            onUp: () => _patchSnap(
              'Light Scene',
              (p) => p.copyWith(sceneIndex: (p.sceneIndex + 1).clamp(0, 2)),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Light Scene',
                imageAssetPath:
                    'assets/images/dcdf1889f2f1df21a26d7013b207a1a5cb57f5e9.png',
                controlButtonCount: 3,
                controlMode: DeviceDetailsControlMode.lightSceneValues,
              )),
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
          controls: _buildLightingStepButtons(
            markKey: 'rgbw',
            onDown: () => _patchSnap(
              'RGBW room abc',
              (p) => p.copyWith(
                rgbwIntensity: (p.rgbwIntensity - 0.10).clamp(0.0, 1.0),
              ),
            ),
            onUp: () => _patchSnap(
              'RGBW room abc',
              (p) => p.copyWith(
                rgbwIntensity: (p.rgbwIntensity + 0.10).clamp(0.0, 1.0),
              ),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'RGBW room abc',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 2,
                controlMode: DeviceDetailsControlMode.rgbwPicker,
              )),
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
          controls: _buildLightingStepButtons(
            markKey: 'led',
            onDown: () => _patchSnap(
              'LED Dimmer living room',
              (p) => p.copyWith(
                ledDimmerPercent: (p.ledDimmerPercent - 0.10).clamp(0.0, 1.0),
              ),
            ),
            onUp: () => _patchSnap(
              'LED Dimmer living room',
              (p) => p.copyWith(
                ledDimmerPercent: (p.ledDimmerPercent + 0.10).clamp(0.0, 1.0),
              ),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'LED Dimmer living room',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.ledDimmer,
              )),
        );
      case 'heating_cooling':
        return _buildLightingLargeRow(
          icon: DashboardHeatingCoolingIcon(isOn: hvac.isOn),
          deviceName: 'Heating & Cooling',
          statusText: hvac.heatingCoolingStatusLabel,
          controls: _buildLightingStepButtons(
            markKey: 'hvac',
            onDown: () => _patchSnap(
              'Heating & Cooling',
              (p) => p.copyWith(isOn: false),
            ),
            onUp: () => _patchSnap(
              'Heating & Cooling',
              (p) => p.copyWith(isOn: true),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Heating & Cooling',
                imageAssetPath: 'assets/images/heating_cooling.png',
                controlButtonCount: 3,
                controlMode: DeviceDetailsControlMode.heatingCooling,
              )),
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
          controls: _buildLightingStepButtons(
            markKey: 'tunable',
            onDown: () => _patchSnap(
              'Tunable white light',
              (p) => p.copyWith(
                tunableWhiteIntensity:
                    (p.tunableWhiteIntensity - 0.10).clamp(0.0, 1.0),
              ),
            ),
            onUp: () => _patchSnap(
              'Tunable white light',
              (p) => p.copyWith(
                tunableWhiteIntensity:
                    (p.tunableWhiteIntensity + 0.10).clamp(0.0, 1.0),
              ),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Tunable white light',
                imageAssetPath: 'assets/white_light.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.tunableWhite,
              )),
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
          controls: _buildLightingStepButtons(
            markKey: 'vent',
            onDown: () => _patchSnap(
              'Ventilation',
              (p) => p.copyWith(
                ventilationPercent:
                    (p.ventilationPercent - 0.10).clamp(0.0, 1.0),
              ),
            ),
            onUp: () => _patchSnap(
              'Ventilation',
              (p) => p.copyWith(
                ventilationPercent:
                    (p.ventilationPercent + 0.10).clamp(0.0, 1.0),
              ),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Ventilation',
                imageAssetPath: 'assets/images/ventilations.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.ventilation,
              )),
        );
      case 'fan_level_3':
        return _buildLightingLargeRow(
          icon: DashboardFanLevelIcon(level: fan.fanLevel),
          deviceName: 'Fan Level 3',
          statusText: fan.fanStatusLabel,
          controls: _buildLightingStepButtons(
            markKey: 'fan',
            onDown: () => _patchSnap(
              'Fan Level 3',
              (p) => p.copyWith(fanLevel: (p.fanLevel - 1).clamp(0, 3)),
            ),
            onUp: () => _patchSnap(
              'Fan Level 3',
              (p) => p.copyWith(fanLevel: (p.fanLevel + 1).clamp(0, 3)),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Fan Level 3',
                imageAssetPath: 'assets/images/Fun_level3.png',
                controlButtonCount: 3,
                controlMode: DeviceDetailsControlMode.fanLevel,
              )),
        );
      case 'presence':
        return _buildLightingLargeRow(
          icon: DashboardPresenceModeIcon(
            modeIndex: presence.presenceModeIndex,
            isOn: presence.isOn,
          ),
          deviceName: 'Presence',
          statusText: presence.presenceLabel,
          controls: _buildLightingStepButtons(
            markKey: 'presence',
            onDown: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(
                isOn: true,
                presenceModeIndex: (p.presenceModeIndex - 1).clamp(0, 4),
              ),
            ),
            onDownLong: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(isOn: false),
            ),
            onUp: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(
                isOn: true,
                presenceModeIndex: (p.presenceModeIndex + 1).clamp(0, 4),
              ),
            ),
            onUpLong: () => _patchSnap(
              'Presence',
              (p) => p.copyWith(isOn: false),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Presence',
                imageAssetPath: 'assets/images/comfort.png',
                controlButtonCount: 2,
                controlMode: DeviceDetailsControlMode.presenceModes,
              )),
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
          controls: _buildLightingStepButtons(
            markKey: 'living',
            onDown: () => _patchSnap(
              'Living Room',
              (p) => p.copyWith(
                thermostatRingPercent:
                    (p.thermostatRingPercent - 0.10).clamp(0.0, 1.0),
              ),
            ),
            onUp: () => _patchSnap(
              'Living Room',
              (p) => p.copyWith(
                thermostatRingPercent:
                    (p.thermostatRingPercent + 0.10).clamp(0.0, 1.0),
              ),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Living Room',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 1,
                controlMode: DeviceDetailsControlMode.thermostatRing,
              )),
        );
      case 'multi_value_switch':
        return _buildLightingLargeRow(
          icon: DashboardMultiValueSwitchIcon(
            selectedIndex: multi.multiValueSwitchIndex,
            isOn: multi.isOn,
          ),
          deviceName: 'Multi-Value Switch',
          statusText: multi.multiValueSwitchCaption,
          controls: _buildLightingStepButtons(
            markKey: 'multi',
            onDown: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(
                isOn: true,
                multiValueSwitchIndex:
                    (p.multiValueSwitchIndex - 1).clamp(0, 2),
              ),
            ),
            onDownLong: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(isOn: false),
            ),
            onUp: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(
                isOn: true,
                multiValueSwitchIndex:
                    (p.multiValueSwitchIndex + 1).clamp(0, 2),
              ),
            ),
            onUpLong: () => _patchSnap(
              'Multi-Value Switch',
              (p) => p.copyWith(isOn: false),
            ),
          ),
          onNavigate: detailsNav(() => DeviceDetailsScreen.go(
                context,
                deviceTitle: 'Multi-Value Switch',
                imageAssetPath:
                    'assets/images/934930601db8766eee59e9c047c0269d6dba1f55.png',
                controlButtonCount: 12,
                controlMode: DeviceDetailsControlMode.multiValueSwitch,
              )),
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

  Widget _buildLightingLargeRow({
    required Widget icon,
    required String deviceName,
    required String statusText,
    required Widget controls,
    String? mode,
    bool modeFilled = false,
    VoidCallback? onModeTap,
    VoidCallback? onNavigate,
  }) {
    return Container(
      height: 90.h,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onNavigate == null
                      ? null
                      : () {
                          uiTapHaptic();
                          onNavigate();
                        },
                  child: Text(
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
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (mode != null) ...[
                      _ModeBadge(
                        mode: mode,
                        filled: modeFilled,
                        onTap: onModeTap,
                      ),
                      SizedBox(width: 10.w),
                    ],
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
          SizedBox(width: 8.w),
          controls,
        ],
      ),
    );
  }

  double _lightingSmallCardHeight({bool compact = false}) {
    if (compact) {
      return 8.h +
          kDashboardLightingIconSide +
          6.h +
          30.h +
          6.h +
          18.h +
          8.h;
    }
    return 12.h +
        kDashboardLightingIconSide +
        8.h +
        38.h +
        8.h +
        20.h +
        12.h;
  }

  Widget _buildLightingCard({
    required String deviceName,
    required String status,
    required String iconImage,
    Widget? iconWidget,
    VoidCallback? onTap,
  }) {
    // Small widget: icon + name + status only (tap opens details; no controls).
    final bool compact = _lightingHorizontalScroll;
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
    final double cardHeight = _lightingSmallCardHeight(compact: compact);
    final card = SizedBox(
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: iconArea,
              ),
            ),
            SizedBox(height: gap),
            SizedBox(
              height: titleH,
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
          ],
        ),
      ),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                uiTapHaptic();
                onTap!();
              },
        borderRadius: radius,
        child: card,
      ),
    );
  }


}

// ---------------------------
// Header



class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.onMenuTap,
    required this.onEditTap});

  final String title;
  final VoidCallback onMenuTap;
  final VoidCallback onEditTap;

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
            child: InkWell(
              onTap: onMenuTap,
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 44.w,
                height: 44.w,
                child: Center(
                  child: Image.asset(
                    'assets/Group 35 (1).png',
                    width: 26.w,
                    height: 17.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Title (now truly centered)
        Expanded(
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                InkWell(
                  onTap: onEditTap,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/image 89.png',
                        width: 22.w,
                        height: 22.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 13.w),
                InkWell(
                  onTap: () => Zone_Category_Screen.showAddSectionSheet(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_rounded,
                        color: const Color(0xFF111827),
                        size: 23.sp,
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
                color: Color(0xFFF3F4F6),
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
                  : Icon(icon, size: 20.sp, color: const Color(0xFF111827)),
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
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFD700), // yellow
                Color(0xFF00FF99), // green-ish
                Color(0xFF15DFFE), // cyan
              ],
              stops: [0.0, 0.55, 1.0],
            ),
            borderRadius: radius,
          ),
          padding: EdgeInsets.all(1.6.r), // ✅ border thickness
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
  const _SectionTitle(this.title, {this.onEditTap});

  final String title;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Row(
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

        GestureDetector(
          onTap: onEditTap ??
              () => Zone_Category_Screen.showEditAddSectionSheet(context),
          child:
          Row(
            children: [
              Text("Edit", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp, fontFamily: "Inter", color: Color(0xFf0088FE)),),
              SizedBox(width: 5.w,),
              Image.asset(
                "assets/images/back_arro.png",
                height: 11.h,
                width: 11.w,
                fit: BoxFit.contain,
                color: Color(0xFf0088FE),
              ),
            ],
          ),

        ),
      ],
    );
  }
}

// ---------------------------
// Common Card Wrapper
// ---------------------------
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(26.r), // ✅ FIX
      ),
      padding: EdgeInsets.all(16.w), // ✅ FIX
      child: child,
    );
  }
}

class _ModeBadge extends StatelessWidget {
  const _ModeBadge({
    required this.mode,
    required this.filled,
    this.onTap,
  });

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

class _PressableCircleSurface extends StatefulWidget {
  const _PressableCircleSurface({
    required this.side,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.marked = false,
    this.enableHaptic = true,
    this.idleTransparent = false,
  });

  final double side;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool marked;
  final bool enableHaptic;
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
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
      ),
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
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              _longPressHandled = true;
              if (widget.enableHaptic) uiTapHaptic();
              widget.onLongPress!();
              _setPressed(false);
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
    this.marked = false,
    this.idleTransparent = false,
  });

  final Widget child;
  final double? size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool marked;
  final bool idleTransparent;

  @override
  Widget build(BuildContext context) {
    final double side = (size ?? 32).w;
    return _PressableCircleSurface(
      side: side,
      onTap: onTap,
      onLongPress: onLongPress,
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
  });

  final String title;
  final double percent;
  final String mode;
  final bool modeFilled;
  final bool showModeBadge;
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
                width: 52.w,
                height: 52.w,
                fit: BoxFit.contain,
              )
            : Icon(
                Icons.lightbulb_outline,
                size: 52.sp,
                color: percent <= 0.001
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF15DFFE),
              ),
        SizedBox(height: 10.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF111827),
            height: 1.18,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    return Stack(
      children: [
        _CardShell(
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
                    width: 52.w,
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
                        softWrap: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _DimmerPill(
                      percent: percent,
                      onChanged: onPercentChanged,
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
            child: _ModeBadge(
              mode: mode,
              filled: modeFilled,
              onTap: onModeTap,
            ),
          ),
      ],
    );
  }
}

class _DimmerPill extends StatelessWidget {
  const _DimmerPill({
    required this.percent,
    this.onChanged,
  });

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
        final double w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
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
                width: 52.w,
                height: 52.w,
                fit: BoxFit.contain,
              )
            : Icon(
                Icons.thermostat_outlined,
                size: 44.sp,
                color: const Color(0xFF0088FE),
              ),
        SizedBox(height: 10.h),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
              SizedBox(height: 10.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool compact = constraints.maxWidth < 120;
                  final double btnSize = compact ? 30 : 35;
                  return Row(
                    children: [
                      _CircleBtn(
                        size: btnSize,
                        marked: minusMarked,
                        onTap: onMinus,
                        child: Icon(
                          Icons.remove,
                          size: compact ? 20.sp : 23.sp,
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
                          size: compact ? 20.sp : 23.sp,
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
            child: _ModeBadge(
              mode: mode,
              filled: modeFilled,
              onTap: onModeTap,
            ),
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
    this.downMarked = false,
    this.upMarked = false,
    this.imagePath,
    this.previewLevel,
    this.levelPercent,
    this.useAwningPreview = false,
    this.blindAngle,
    this.useBlindSlatsPreview = false,
    this.compactControlButtons = false,
    this.onModeTap,
    this.onNavigate,
    this.showModeBadge = true,
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
  final bool compactControlButtons;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final VoidCallback? onDownLong;
  final VoidCallback? onUpLong;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (previewLevel != null)
                titleInkWell(
                  useBlindSlatsPreview
                      ? DashboardBlindSlatsIcon(
                          level: previewLevel!,
                          angle: blindAngle ?? 1.0,
                        )
                      : useAwningPreview
                          ? DashboardAwningLevelIcon(level: previewLevel!)
                          : DashboardBlindSlatsIcon(
                              level: previewLevel!,
                              angle: 1.0,
                            ),
                )
              else if (imagePath != null)
                titleInkWell(
                  Image.asset(
                    imagePath!,
                    width: 65.w,
                    height: 65.w,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: 17.h),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double controlSize = compactControlButtons ? 40 : 35;
                    final double iconSize = compactControlButtons ? 14.sp : 13.sp;
                    final Widget downBtn = _CircleBtn(
                      marked: downMarked,
                      onTap: onDown,
                      onLongPress: onDownLong,
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
                                      fontSize: 18.sp,
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
                              fontSize: 18.sp,
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
                              fontSize: 18.sp,
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
                                      width: compactControlButtons ? 8.w : 10.w,
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
            child: _ModeBadge(
              mode: mode,
              filled: modeFilled,
              onTap: onModeTap,
            ),
          ),
      ],
    );
  }
}

class _ToggleCard extends StatefulWidget {
  const _ToggleCard({
    required this.title,
    required this.isOn,
    this.imagePath,
    this.imagePathOff,
    this.onNavigate,
    this.onIsOnChanged,
    this.showModeBadge = true,
  });

  final String title;
  final bool isOn;
  final String? imagePath;
  final String? imagePathOff;
  final VoidCallback? onNavigate;
  final ValueChanged<bool>? onIsOnChanged;
  final bool showModeBadge;

  @override
  State<_ToggleCard> createState() => _ToggleCardState();
}

class _ToggleCardState extends State<_ToggleCard> {
  late bool _on;
  late bool _manualMode;

  @override
  void initState() {
    super.initState();
    _on = widget.isOn;
    _manualMode = false;
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
                width: 52.w,
                height: 52.w,
                fit: BoxFit.contain,
              )
            : Icon(
                Icons.water_drop_outlined,
                size: 42.sp,
                color: const Color(0xFF00C2FF),
              ),
        SizedBox(height: 17.h),
        Expanded(
          child: Text(
            widget.title,
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
      ],
    );

    return Stack(
      children: [
        _CardShell(
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
                  SizedBox(
                    height: 35.h,
                    width: 60.w,
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
                ],
              ),
            ],
          ),
        ),
        if (widget.showModeBadge)
          Positioned(
            right: 12.w,
            top: 12.w,
            child: _ModeBadge(
              mode: _manualMode ? 'M' : 'A',
              filled: _manualMode,
              onTap: () => setState(() => _manualMode = !_manualMode),
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