import 'package:get/get.dart';

/// Controller for Stress Management flow.
class StressController extends GetxController {
  /// Stress level from 1 (low) to 5 (very high)
  final RxInt level = 3.obs;

  /// Selected stressor keyword
  final RxString selectedStressor = 'Loneliness'.obs;

  /// Optional manual override for impact (1..5). When set, `impactLabel` uses this.
  final RxnInt manualImpact = RxnInt();

  /// Available stressors shown as bubbles
  final List<String> stressors = const [
    'Work',
    'Relationship',
    'Kids',
    'Loneliness',
    'Life',
    'Finance',
    'Health',
    'Study',
    'Traffic',
    'Other',
  ];

  void setLevel(int newLevel) {
    if (newLevel < 1 || newLevel > 5) return;
    level.value = newLevel;
  }

  void selectStressor(String s) {
    if (stressors.contains(s)) selectedStressor.value = s;
  }

  /// Set or clear the manual impact override. Pass null to clear.
  void setManualImpact(int? v) {
    if (v == null) {
      manualImpact.value = null;
      return;
    }
    if (v < 1 || v > 5) return;
    manualImpact.value = v;
  }

  void clearManualImpact() => manualImpact.value = null;

  /// Label used on the level slider screen
  String get levelLabel => switch (level.value) {
        1 => 'Very Low',
        2 => 'Low',
        3 => 'Moderate',
        4 => 'Elevated',
        5 => 'Very High',
        _ => 'Moderate',
      };

  /// Label used on the overview subtitle (matches design at level 3)
  String get overviewSubtitle => switch (level.value) {
        1 || 2 => 'Low Stress',
        3 => 'Elevated Stress',
        4 || 5 => 'Very High Stress',
        _ => 'Elevated Stress',
      };

  /// Impact label shown in the stressors screen and overview stats
  String get impactLabel {
    final v = manualImpact.value ?? _effectiveImpactFromModel();
    return impactLabelFor(v);
  }

  /// Helper to map impact numeric [1..5] to label
  String impactLabelFor(int v) => switch (v) {
        1 => 'Very Low',
        2 => 'Low',
        3 => 'Moderate',
        4 => 'High',
        5 => 'Very High',
        _ => 'Moderate',
      };

  /// Compute model-based impact value [1..5]
  int _effectiveImpactFromModel() {
    // Slightly bias to high if specific stressors like Loneliness are selected
    final bias = selectedStressor.value == 'Loneliness' ? 1 : 0;
    return (level.value + bias).clamp(1, 5);
  }
}
