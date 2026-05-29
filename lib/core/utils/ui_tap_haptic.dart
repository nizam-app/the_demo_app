import 'package:flutter/services.dart';

/// Light tap feedback for dashboard/device control buttons (+/−/↑/↓ and peers).
void uiTapHaptic() => HapticFeedback.mediumImpact();
