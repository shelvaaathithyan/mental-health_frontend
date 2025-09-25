import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class HapticService {
  const HapticService._();

  static Future<void> feedback(FeedbackType type) async {
    if (kIsWeb) return;

    try {
      final canVibrate = await Vibrate.canVibrate;
      if (!canVibrate) return;

      Vibrate.feedback(type);
    } catch (error) {
      debugPrint('HapticService feedback skipped: $error');
    }
  }
}
