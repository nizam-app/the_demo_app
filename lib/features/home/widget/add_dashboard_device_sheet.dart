import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardAddDeviceOption {
  const DashboardAddDeviceOption({
    required this.id,
    required this.title,
    required this.imagePath,
    this.iconWidget,
    this.subText,
  });

  final String id;
  final String title;
  final String imagePath;
  final Widget? iconWidget;
  final String? subText;
}

Future<List<String>?> showAddDashboardDeviceSheet(
  BuildContext context, {
  required List<DashboardAddDeviceOption> devices,
  Set<String> disabledDeviceIds = const <String>{},
  List<String> initialSelectedDeviceIds = const <String>[],
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    barrierColor: Colors.black.withOpacity(0.25),
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => AddDashboardDeviceSheet(
        scrollController: controller,
        devices: devices,
        disabledDeviceIds: disabledDeviceIds,
        initialSelectedDeviceIds: initialSelectedDeviceIds,
      ),
    ),
  );
}

class AddDashboardDeviceSheet extends StatefulWidget {
  const AddDashboardDeviceSheet({
    super.key,
    required this.scrollController,
    required this.devices,
    this.disabledDeviceIds = const <String>{},
    this.initialSelectedDeviceIds = const <String>[],
  });

  final ScrollController scrollController;
  final List<DashboardAddDeviceOption> devices;
  final Set<String> disabledDeviceIds;
  final List<String> initialSelectedDeviceIds;

  @override
  State<AddDashboardDeviceSheet> createState() =>
      _AddDashboardDeviceSheetState();
}

class _AddDashboardDeviceSheetState extends State<AddDashboardDeviceSheet> {
  static const _bg = Colors.white;
  static const _textPrimary = Color(0xFF111827);
  static const _divider = Color(0xFFE5E7EB);
  static const _closeBg = Color(0xFFF3F4F6);
  static const _selectedBg = Color(0xFFEAF1FF);

  final List<String> _selectedIds = <String>[];

  @override
  void initState() {
    super.initState();
    final Set<String> availableIds = widget.devices
        .map((DashboardAddDeviceOption device) => device.id)
        .toSet();
    _selectedIds.addAll(
      widget.initialSelectedDeviceIds.where(availableIds.contains),
    );
  }

  void _closeWithSelection() {
    Navigator.of(context).pop(List<String>.from(_selectedIds));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: Container(
        color: _bg,
        child: Column(
          children: [
            SizedBox(
              height: 52.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Add dashboard device',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    child: GestureDetector(
                      onTap: _closeWithSelection,
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: _closeBg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close,
                          size: 20.sp,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: widget.scrollController,
                padding: EdgeInsets.only(bottom: 24.h),
                itemCount: widget.devices.length,
                separatorBuilder: (_, index) {
                  final String leftId = widget.devices[index].id;
                  final String rightId = widget.devices[index + 1].id;
                  final bool bothSelected =
                      _selectedIds.contains(leftId) &&
                      _selectedIds.contains(rightId);
                  return Container(
                    height: 1.h,
                    color: bothSelected ? _selectedBg : _divider,
                    margin: bothSelected
                        ? EdgeInsets.zero
                        : EdgeInsets.only(left: 50.w),
                  );
                },
                itemBuilder: (context, i) {
                  final DashboardAddDeviceOption device = widget.devices[i];
                  final bool disabled = widget.disabledDeviceIds.contains(
                    device.id,
                  );
                  final bool selected = _selectedIds.contains(device.id);
                  final int orderIndex = _selectedIds.indexOf(device.id);
                  final int? badgeCount = selected ? orderIndex + 1 : null;
                  return _AddDashboardDeviceRow(
                    imagePath: device.imagePath,
                    iconWidget: device.iconWidget,
                    title: device.title,
                    subText: device.subText,
                    selected: selected,
                    enabled: !disabled,
                    badgeCount: badgeCount,
                    onTap: disabled
                        ? null
                        : () {
                            setState(() {
                              if (selected) {
                                _selectedIds.remove(device.id);
                              } else {
                                _selectedIds.add(device.id);
                              }
                            });
                          },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddDashboardDeviceRow extends StatelessWidget {
  const _AddDashboardDeviceRow({
    required this.imagePath,
    required this.title,
    this.iconWidget,
    this.onTap,
    this.subText,
    this.selected = false,
    this.enabled = true,
    this.badgeCount,
  });

  final String imagePath;
  final String title;
  final Widget? iconWidget;
  final String? subText;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;
  final int? badgeCount;

  static const _textPrimary = Color(0xFF111827);
  static const _textSecondary = Color(0xFF6B7280);
  static const _selectedBg = Color(0xFFEAF1FF);
  static const _badgeBlue = Color(0xFF0088FE);

  @override
  Widget build(BuildContext context) {
    final Color titleColor = enabled ? _textPrimary : _textSecondary;

    return Material(
      color: selected ? _selectedBg : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: enabled ? onTap : null,
            splashColor: selected ? _selectedBg : null,
            highlightColor: selected ? _selectedBg.withOpacity(0.5) : null,
            child: Opacity(
              opacity: enabled ? 1 : 0.45,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 16.h),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      color: selected ? _selectedBg : null,
                      alignment: Alignment.center,
                      child: iconWidget != null
                          ? FittedBox(fit: BoxFit.contain, child: iconWidget)
                          : Image.asset(
                              imagePath,
                              width: 26.w,
                              height: 26.h,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.device_hub,
                                size: 24.sp,
                                color: _textSecondary,
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
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: titleColor,
                            ),
                          ),
                          if (subText != null && subText!.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              subText!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: _textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (badgeCount != null)
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: const BoxDecoration(
                          color: _badgeBlue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$badgeCount',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (selected)
            SizedBox(
              height: 1.h,
              child: ColoredBox(color: _selectedBg),
            ),
        ],
      ),
    );
  }
}
