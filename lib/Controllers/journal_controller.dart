import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Models/journal_entry.dart';

class JournalController extends GetxController {
  static const _storageKey = 'journal_entries';
  final _box = GetStorage();
  final entries = <JournalEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
    if (entries.isEmpty) {
      seedMockData();
    }
  }

  void _load() {
    final raw = _box.read<List<dynamic>>(_storageKey) ?? [];
    entries.assignAll(raw
        .whereType<Map>()
        .map((e) => JournalEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList());
  }

  void _save() {
    _box.write(_storageKey, entries.map((e) => e.toJson()).toList());
  }

  void seedMockData() {
    final today = DateTime.now();
    final rnd = Random(42);
    for (int i = -10; i <= 10; i++) {
      final d = today.add(Duration(days: i));
      // Skip some days deliberately
      if (rnd.nextBool()) {
        final mood = (i % 3 == 0)
            ? 'negative'
            : (i % 3 == 1)
                ? 'positive'
                : 'neutral';
        entries.add(JournalEntry(
          id: 'mock-$i',
          date: _fmt(d),
          type: 'text',
          status: 'published',
          mood: mood,
          content: 'Mock entry for ${_fmt(d)} with mood $mood',
        ));
      }
    }
    _save();
  }

  void addText({required DateTime date, required String content, bool publish = true}) {
    final e = JournalEntry(
      id: 'txt-${DateTime.now().millisecondsSinceEpoch}',
      date: _fmt(date),
      type: 'text',
      status: publish ? 'published' : 'draft',
      mood: _inferMood(content),
      content: content,
    );
    entries.add(e);
    _save();
  }

  void addVoice({required DateTime date, required int durationSec, bool publish = true}) {
    final e = JournalEntry(
      id: 'v-${DateTime.now().millisecondsSinceEpoch}',
      date: _fmt(date),
      type: 'voice',
      status: publish ? 'published' : 'draft',
      mood: durationSec > 30 ? 'negative' : 'positive',
      durationSec: durationSec,
    );
    entries.add(e);
    _save();
  }

  Map<String, List<JournalEntry>> entriesByDateRange(DateTime start, DateTime end) {
    final map = <String, List<JournalEntry>>{};
    for (final e in entries) {
      final d = DateTime.parse(e.date);
      if (!d.isBefore(start) && !d.isAfter(end)) {
        map.putIfAbsent(e.date, () => []).add(e);
      }
    }
    return map;
  }

  String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _inferMood(String text) {
    final t = text.toLowerCase();
    if (t.contains('sad') || t.contains('tired') || t.contains('anxious')) return 'negative';
    if (t.contains('happy') || t.contains('grateful') || t.contains('good')) return 'positive';
    return 'neutral';
  }
}
