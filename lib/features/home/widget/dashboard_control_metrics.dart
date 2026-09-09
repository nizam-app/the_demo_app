import 'dashboard_section_widget_size.dart';

/// Fixed interactive control dimensions for dashboard device cards.
class DashboardControlMetrics {
  const DashboardControlMetrics({
    required this.circularButtonSize,
    required this.circularButtonGap,
    required this.toggleWidth,
    required this.toggleHeight,
    required this.sliderWidth,
    required this.sliderHeight,
    required this.controlSlotWidth,
    required this.expandSlider,
    required this.controlFillsSlot,
  });

  final double circularButtonSize;
  final double circularButtonGap;
  final double toggleWidth;
  final double toggleHeight;
  final double sliderWidth;
  final double sliderHeight;
  final double controlSlotWidth;
  final bool expandSlider;
  final bool controlFillsSlot;

  /// S-layout compact fixed metrics (150.h cards, three-column grid).
  static const DashboardControlMetrics s = DashboardControlMetrics(
    circularButtonSize: 22,
    circularButtonGap: 4,
    toggleWidth: 38,
    toggleHeight: 22,
    sliderWidth: 58,
    sliderHeight: 24,
    controlSlotWidth: 58,
    expandSlider: false,
    controlFillsSlot: false,
  );

  /// M-layout compact fixed metrics (168.h cards, two-column grid).
  static const DashboardControlMetrics m = DashboardControlMetrics(
    circularButtonSize: 30,
    circularButtonGap: 8,
    toggleWidth: 45,
    toggleHeight: 28,
    sliderWidth: 100,
    sliderHeight: 32,
    controlSlotWidth: 100,
    expandSlider: false,
    controlFillsSlot: false,
  );

  /// L-layout fixed metrics (green-marked reference controls).
  static const DashboardControlMetrics l = DashboardControlMetrics(
    circularButtonSize: 35,
    circularButtonGap: 10,
    toggleWidth: 51,
    toggleHeight: 31,
    sliderWidth: 118,
    sliderHeight: 35,
    controlSlotWidth: 118,
    expandSlider: false,
    controlFillsSlot: false,
  );

  /// XL-layout fixed metrics (220.h cards).
  /// Circular buttons match [l] (Light Scene reference); toggles stay larger.
  static const DashboardControlMetrics xl = DashboardControlMetrics(
    circularButtonSize: 35,
    circularButtonGap: 10,
    toggleWidth: 56,
    toggleHeight: 36,
    sliderWidth: 118,
    sliderHeight: 38,
    controlSlotWidth: 86,
    expandSlider: false,
    controlFillsSlot: false,
  );

  /// Returns fixed control metrics for S, M, L, and XL card layouts.
  /// List layout returns null so it keeps its existing sizing.
  static DashboardControlMetrics? forLayout(SectionLayout layout) {
    switch (layout) {
      case SectionLayout.small:
        return s;
      case SectionLayout.medium:
        return m;
      case SectionLayout.large:
        return l;
      case SectionLayout.extraLarge:
        return xl;
      case SectionLayout.list:
        return null;
    }
  }

  static DashboardControlMetrics? fromStorage(String widgetSize) =>
      forLayout(parseSectionLayout(widgetSize));
}
