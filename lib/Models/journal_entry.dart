class JournalEntry {
  final String id;
  final String date; // yyyy-MM-dd
  final String type; // 'voice' | 'text'
  final String status; // 'draft' | 'published'
  final String mood; // 'positive' | 'negative' | 'neutral'
  final String? content; // for text
  final int? durationSec; // for voice

  JournalEntry({
    required this.id,
    required this.date,
    required this.type,
    required this.status,
    required this.mood,
    this.content,
    this.durationSec,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'] as String,
        date: json['date'] as String,
        type: json['type'] as String,
        status: json['status'] as String,
        mood: json['mood'] as String,
        content: json['content'] as String?,
        durationSec: json['durationSec'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'type': type,
        'status': status,
        'mood': mood,
        if (content != null) 'content': content,
        if (durationSec != null) 'durationSec': durationSec,
      };
}
