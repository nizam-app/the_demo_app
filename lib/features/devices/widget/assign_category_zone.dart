import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _bgOverlay = Color(0x99000000);
const _sheetBg = Color(0xFFF2F3F5);
const _cardBg = Colors.white;
const _primaryBlue = Color(0xFF0088FE);
const _textPrimary = Color(0xFF111827);
const _textSecondary = Color(0xFF6B7280);

class AssignCategoryZoneSheet extends StatefulWidget {
  const AssignCategoryZoneSheet({super.key});

  @override
  State<AssignCategoryZoneSheet> createState() =>
      _AssignCategoryZoneSheetState();
}

class _AssignCategoryZoneSheetState
    extends State<AssignCategoryZoneSheet> {

  String selectedCategory = "Shading";

  List<String> selectedZones = [
    "Whole house",
    "Living room"
  ];

  final categories = [
    "Lighting",
    "Shading",
    "Heating / Cooling",
    "Ventilation",
    "Gates",
    "Safety",
    "Irrigation",
    "Machinery",
    "Charging",
    "Maintenance",
  ];

  final zones = [
    "Whole house",
    "Living room",
    "Kitchen",
    "Parents room",
    "Kids room",
    "Bathroom",
    "Garden",
    "Garage",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgOverlay,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0.h),
                decoration: BoxDecoration(
                  color: _sheetBg,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(26.r)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      
                      children: [
                        /// HEADER
                        Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 10.h, 0.w, 0.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Assign category & zone',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _textPrimary,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                              // close
                              Container(
                                width: 30.w,
                                height: 30.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Center(
                                    child: Icon(Icons.close_rounded,
                                        size: 20.sp, color: _textPrimary),
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        ),
                     

                SizedBox(height: 20.h),

                /// CATEGORIES CARD
                _Card(
                  title: "Categories",
                  children: [
                    ...categories.map((item) {
                      final selected =
                          item == selectedCategory;
                      return _RadioRow(
                        title: item,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            selectedCategory = item;
                          });
                        },
                      );
                    }),
                    _AddRow(label: "Add category")
                  ],
                ),

                SizedBox(height: 16.h),

                /// ZONES CARD
                _Card(
                  title: "Zones",
                  children: [
                    ...zones.map((item) {
                      final selected =
                      selectedZones.contains(item);
                      return _CheckboxRow(
                        title: item,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (selected) {
                              selectedZones.remove(item);
                            } else {
                              selectedZones.add(item);
                            }
                          });
                        },
                      );
                    }),
                    _AddRow(label: "Add zone")
                  ],
                ),
                      ],
                    ),
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

class _Card extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Card({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp, // Section title
              fontWeight: FontWeight.w600,
              color: _textPrimary,
              
            ),
          ),
          SizedBox(height: 12.h),
          ...children
        ],
      ),
    );
  }
}


class _RadioRow extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _RadioRow({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? _primaryBlue
                      : _textSecondary,
                  width: 2,
                ),
                color: selected
                    ? _primaryBlue
                    : Colors.transparent,
              ),
              child: selected
                  ? Icon(Icons.check,
                  size: 14.sp,
                  color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp, // Name/Main text
                fontWeight: FontWeight.w400,
                color: _textPrimary,
                fontFamily: 'Inter'
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _CheckboxRow({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? _primaryBlue
                      : _textSecondary,
                  width: 2,
                ),
                color: selected
                    ? _primaryBlue
                    : Colors.transparent,
              ),
              child: selected
                  ? Icon(Icons.check,
                  size: 14.sp,
                  color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter' ,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddRow extends StatelessWidget {
  final String label;

  const _AddRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline,
              color: _primaryBlue, size: 22.sp),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: _primaryBlue,
              fontFamily: 'Inter'
            ),
          ),
        ],
      ),
    );
  }
}