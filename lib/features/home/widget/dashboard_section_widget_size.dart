import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Canonical dashboard section layout sizes.
enum SectionLayout {
  list,
  small,
  medium,
  large,
  extraLarge,
}

const String kSectionLayoutStorageList = 'list';
const String kSectionLayoutStorageSmall = 'small';
const String kSectionLayoutStorageMedium = 'medium';
const String kSectionLayoutStorageLarge = 'large';
const String kSectionLayoutStorageExtraLarge = 'extraLarge';

const List<SectionLayout> kSectionLayouts = <SectionLayout>[
  SectionLayout.list,
  SectionLayout.small,
  SectionLayout.medium,
  SectionLayout.large,
  SectionLayout.extraLarge,
];

const Color _textPrimary = Color(0xFF111827);
const Color _textSecondary = Color(0xFF6B7280);

String sectionLayoutToStorage(SectionLayout layout) {
  switch (layout) {
    case SectionLayout.list:
      return kSectionLayoutStorageList;
    case SectionLayout.small:
      return kSectionLayoutStorageSmall;
    case SectionLayout.medium:
      return kSectionLayoutStorageMedium;
    case SectionLayout.large:
      return kSectionLayoutStorageLarge;
    case SectionLayout.extraLarge:
      return kSectionLayoutStorageExtraLarge;
  }
}

SectionLayout parseSectionLayout(String raw) {
  switch (raw) {
    case kSectionLayoutStorageList:
    case 'List':
      return SectionLayout.list;
    case kSectionLayoutStorageSmall:
      return SectionLayout.small;
    case kSectionLayoutStorageMedium:
      return SectionLayout.medium;
    case kSectionLayoutStorageLarge:
    case 'L':
      return SectionLayout.large;
    case kSectionLayoutStorageExtraLarge:
    case 'XL':
      return SectionLayout.extraLarge;
    // Legacy persisted values (pre five-layout system).
    case 'S':
      return SectionLayout.list;
    case 'M':
      return SectionLayout.small;
    default:
      return SectionLayout.large;
  }
}

String canonicalSectionLayoutStorage(String raw) =>
    sectionLayoutToStorage(parseSectionLayout(raw));

String sectionLayoutSelectorLabel(SectionLayout layout) {
  switch (layout) {
    case SectionLayout.list:
      return 'List';
    case SectionLayout.small:
      return 'S';
    case SectionLayout.medium:
      return 'M';
    case SectionLayout.large:
      return 'L';
    case SectionLayout.extraLarge:
      return 'XL';
  }
}

bool sectionLayoutUsesListRows(String raw) =>
    parseSectionLayout(raw) == SectionLayout.list;

bool sectionLayoutUsesCompactGrid(String raw) =>
    parseSectionLayout(raw) == SectionLayout.small;

bool sectionLayoutUsesMediumGrid(String raw) =>
    parseSectionLayout(raw) == SectionLayout.medium;

class DashboardSectionSizeSegment extends StatelessWidget {
  const DashboardSectionSizeSegment({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final SectionLayout selected = parseSectionLayout(value);

    Widget iconFor(SectionLayout layout, Color color) {
      switch (layout) {
        case SectionLayout.list:
          return  Image.asset(
            'assets/images/size_S.png',
            width: 26.w,
            height: 17.h,
            fit: BoxFit.contain,
            color: color,
            colorBlendMode: BlendMode.srcIn,
          );
            //_DashboardSizeThreeLineIcon(color: color);
        case SectionLayout.small:
          return Image.asset(
            'assets/images/size_M.png',
            width: 26.w,
            height: 17.h,
            fit: BoxFit.contain,
            color: color,
            colorBlendMode: BlendMode.srcIn,
          );

            //_DashboardSizeTwoLineIcon(color: color);
        case SectionLayout.medium:
          return _DashboardSizeMediumGridIcon(color: color);
        case SectionLayout.large:
          return Image.asset(
            'assets/images/size_L.png',
            width: 26.w,
            height: 17.h,
            fit: BoxFit.contain,
            color: color,
            colorBlendMode: BlendMode.srcIn,
          );
        case SectionLayout.extraLarge:
          return Image.asset(
            'assets/images/size_XL.png',
            width: 26.w,
            height: 17.h,
            fit: BoxFit.contain,
            color: color,
            colorBlendMode: BlendMode.srcIn,
          );
      }
    }

    Widget item(SectionLayout layout) {
      final bool isSelected = selected == layout;
      final Color iconColor = isSelected ? _textPrimary : _textSecondary;
      final String label = sectionLayoutSelectorLabel(layout);

      return GestureDetector(
        onTap: () => onChanged(sectionLayoutToStorage(layout)),
        child: Container(
          height: 35.h,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
              ),
              iconFor(layout, iconColor),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: 280.w,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
         // color: Colors.white.withOpacity(0.22),
          color: Color(0xFFF3F4F6).withOpacity(0.5), 
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Row(
          children: [
            for (final SectionLayout layout in kSectionLayouts) ...[
              Expanded(child: item(layout)),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashboardSizeThreeLineIcon extends StatelessWidget {
  const _DashboardSizeThreeLineIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget line() {
      return Container(
        width: 20.w,
        height: 3.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1.5.r),
        ),
      );
    }

    return SizedBox(
      width: 26.w,
      height: 17.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          line(),
          SizedBox(height: 2.5.h),
          line(),
          SizedBox(height: 2.5.h),
          line(),
        ],
      ),
    );
  }
}

class _DashboardSizeTwoLineIcon extends StatelessWidget {
  const _DashboardSizeTwoLineIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget line() {
      return Container(
        width: 18.w,
        height: 3.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1.5.r),
        ),
      );
    }

    return SizedBox(
      width: 26.w,
      height: 17.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          line(),
          SizedBox(height: 4.h),
          line(),
        ],
      ),
    );
  }
}

class _DashboardSizeMediumGridIcon extends StatelessWidget {
  const _DashboardSizeMediumGridIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget cell() {
      return Container(
        width: 11.w,
        height: 7.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(0.r),
        ),
      );
    }

    return SizedBox(
      width: 26.w,
      height: 17.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cell(),
              SizedBox(width: 1.w),
              cell(),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cell(),
              SizedBox(width: 1.w),
              cell(),
            ],
          ),
        ],
      ),
    );
  }
}