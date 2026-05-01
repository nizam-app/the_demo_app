import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Opens the "Add expose device" bottom sheet from the TCP/IP Integration screen.
void showAddExposeDeviceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.25),
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) => AddExposeDeviceSheet(
        scrollController: scrollController,
      ),
    ),
  );
}

/// Bottom sheet: "Add expose device" — scrollable list with title, sub-text, optional count badge, selected highlight.
class AddExposeDeviceSheet extends StatefulWidget {
  const AddExposeDeviceSheet({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<AddExposeDeviceSheet> createState() => _AddExposeDeviceSheetState();
}

class _AddExposeDeviceSheetState extends State<AddExposeDeviceSheet> {
  static const _bg = Colors.white;
  static const _textPrimary = Color(0xFF111827);
  static const _divider = Color(0xFFE5E7EB);
  static const _closeBg = Color(0xFFF3F4F6);
  static const _selectedBg = Color(0xFFEAF1FF);

  late final List<_AddDeviceItem> items;
  List<int> _selectedIndices = [5, 9]; // Push button, second Brightness sensor (for badge demo)

  @override
  void initState() {
    super.initState();
    items = <_AddDeviceItem>[
      _AddDeviceItem(
        imagePath: 'assets/images/irrigation.png',
        title: 'Irrigation',
        subText: 'SWICH-4B37-3419-363A-SW1',
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/sensor.png',
        title: 'Brightness sensor',
        subText: 'SENS-4B37-3419-363A-UI4',
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/Rectangle.png',
        title: 'RGB light',
        subText: 'RGB-4B37-3419-363A-07',
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/lock.png',
        title: 'Alram',
        subText: 'SWICH-4B37-3419-363A-SW1',
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/meter.png',
        title: 'Electric meter',
        subText: null,
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/play.png',
        title: 'Push button',
        subText: null,
        badgeCount: 3,
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/fan.png',
        title: 'Vent (3 levels)',
        subText: 'SWICH-4B37-3419-363A-SW3',
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/irrigation.png',
        title: 'Irrigation',
        subText: null,
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/brightness_sensor.png',
        title: 'Brightness sensor',
        subText: 'SENS-4B37-3419-363A-UI6',
        badgeCount: 2,
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/Rectangle.png',
        title: 'RGB light',
        subText: 'RGB-4B37-3419-363A-08',
      ),
      _AddDeviceItem(
        imagePath: 'assets/images/kitchen.png',
        title: 'Motion sensor',
        subText: null,
      ),
    ];
    // Pre-select items that show badge in design
    _selectedIndices = [5, 8];
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
            // Header: "Add expose device" centered, X on right
            SizedBox(
              height: 52.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Add expose device',
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
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: _closeBg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.close, size: 20.sp, color: _textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
           // Divider(height: 1.h, thickness: 1.h, color: _divider),
            // Scrollable list
            Expanded(
              child: ListView.separated(
                controller: widget.scrollController,
                padding: EdgeInsets.only(bottom: 24.h),
                itemCount: items.length,
                separatorBuilder: (_, index) {
                  // Between two selected rows use selection color full width so no white/grey gap
                  final bothSelected = _selectedIndices.contains(index) &&
                      _selectedIndices.contains(index + 1);
                  return Container(
                    height: 1.h,
                    color: bothSelected ? _selectedBg : _divider,
                    margin: bothSelected ? EdgeInsets.zero : EdgeInsets.only(left: 50.w),
                  );
                },
                itemBuilder: (context, i) {
                  final it = items[i];
                  final selected = _selectedIndices.contains(i);
                  final orderIndex = _selectedIndices.indexOf(i);
                  final badgeCount = it.badgeCount ?? (selected ? orderIndex + 1 : null);
                  return _AddDeviceRow(
                    imagePath: it.imagePath,
                    title: it.title,
                    subText: it.subText,
                    selected: selected,
                    badgeCount: badgeCount,
                    onTap: () {
                      setState(() {
                        if (_selectedIndices.contains(i)) {
                          _selectedIndices.remove(i);
                        } else {
                          _selectedIndices.add(i);
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

class _AddDeviceRow extends StatelessWidget {
  const _AddDeviceRow({
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.subText,
    this.selected = false,
    this.badgeCount,
  });

  final String imagePath;
  final String title;
  final String? subText;
  final VoidCallback onTap;
  final bool selected;
  final int? badgeCount;

  static const _textPrimary = Color(0xFF111827);
  static const _textSecondary = Color(0xFF6B7280);
  static const _selectedBg = Color(0xFFEAF1FF);
  static const _badgeBlue = Color(0xFF0088FE);
                                                              
  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _selectedBg : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            splashColor: selected ? _selectedBg : null,
            highlightColor: selected ? _selectedBg.withOpacity(0.5) : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 16.h),
              child: Row(
                children: [
                  // Icon area: same bg as row when selected so no white gap under image
                  Container(
                    width: 32.w,
                    height: 32.h,
                    color: selected ? _selectedBg : null,
                    alignment: Alignment.center,
                    child: Image.asset(
                      imagePath,
                      width: 26.w,
                      height: 26.h,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(Icons.device_hub, size: 24.sp, color: _textSecondary),
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
                            color: _textPrimary,
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
          // One pixel at bottom so selected block has no gap above next divider
          if (selected) SizedBox(height: 1.h, child: ColoredBox(color: _selectedBg)),
        ],
      ),
    );
  }
}

class _AddDeviceItem {
  final String imagePath;
  final String title;
  final String? subText;
  final int? badgeCount;

  const _AddDeviceItem({
    required this.imagePath,
    required this.title,
    this.subText,
    this.badgeCount,
  });
}