import 'dart:convert';

class MindfulnessGoal {
  MindfulnessGoal({
    required this.code,
    required this.title,
    required this.defaultExerciseType,
    required this.recommendedDurations,
    required this.recommendedSoundscapeSlugs,
    Map<String, dynamic>? metadata,
    this.shortTagline,
    this.description,
  }) : metadata = metadata ?? const {};

  final String code;
  final String title;
  final String? shortTagline;
  final String? description;
  final String defaultExerciseType;
  final List<int> recommendedDurations;
  final List<String> recommendedSoundscapeSlugs;
  final Map<String, dynamic> metadata;

  factory MindfulnessGoal.fromJson(Map<String, dynamic> json) {
    return MindfulnessGoal(
      code: json['code'] as String,
      title: json['title'] as String,
      shortTagline: json['short_tagline'] as String?,
      description: json['description'] as String?,
      defaultExerciseType: json['default_exercise_type'] as String,
      recommendedDurations: _castIntList(json['recommended_durations']),
      recommendedSoundscapeSlugs: _castStringList(json['recommended_soundscape_slugs']),
      metadata: _castMap(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'short_tagline': shortTagline,
      'description': description,
      'default_exercise_type': defaultExerciseType,
      'recommended_durations': recommendedDurations,
      'recommended_soundscape_slugs': recommendedSoundscapeSlugs,
      'metadata': metadata,
    };
  }
}

class MindfulnessSoundscape {
  MindfulnessSoundscape({
    required this.id,
    required this.slug,
    required this.name,
    required this.audioUrl,
    this.description,
    this.loopSeconds,
    this.isActive = true,
  });

  final int id;
  final String slug;
  final String name;
  final String? description;
  final String audioUrl;
  final int? loopSeconds;
  final bool isActive;

  factory MindfulnessSoundscape.fromJson(Map<String, dynamic> json) {
    return MindfulnessSoundscape(
      id: _asInt(json['id']) ?? 0,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      audioUrl: json['audio_url'] as String,
      loopSeconds: _asInt(json['loop_seconds']),
      isActive: (json['is_active'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'description': description,
      'audio_url': audioUrl,
      'loop_seconds': loopSeconds,
      'is_active': isActive,
    };
  }
}

class MindfulnessSession {
  MindfulnessSession({
    required this.id,
    required this.exerciseType,
    this.goalCode,
    this.soundscapeId,
    this.plannedDurationMinutes,
    this.actualMinutes,
    this.startAt,
    this.endAt,
    required this.status,
    this.scoreRestful,
    this.scoreFocus,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    this.plannedDurationSeconds,
    this.actualDurationSeconds,
    this.cyclesCompleted,
  })  : tags = tags ?? const [],
        metadata = metadata ?? const {};

  final int id;
  final String exerciseType;
  final String? goalCode;
  final int? soundscapeId;
  final double? plannedDurationMinutes;
  final double? actualMinutes;
  final DateTime? startAt;
  final DateTime? endAt;
  final String status;
  final double? scoreRestful;
  final double? scoreFocus;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final int? plannedDurationSeconds;
  final int? actualDurationSeconds;
  final int? cyclesCompleted;

  factory MindfulnessSession.fromJson(Map<String, dynamic> json) {
    return MindfulnessSession(
      id: _asInt(json['id']) ?? 0,
      exerciseType: json['exercise_type'] as String,
      goalCode: json['goal_code'] as String?,
      soundscapeId: _asInt(json['soundscape_id']),
      plannedDurationMinutes: _asDouble(json['planned_duration_minutes']),
      actualMinutes: _asDouble(json['actual_minutes']),
      startAt: _asDateTime(json['start_at']),
      endAt: _asDateTime(json['end_at']),
      status: json['status'] as String? ?? 'in_progress',
      scoreRestful: _asDouble(json['score_restful']),
      scoreFocus: _asDouble(json['score_focus']),
      tags: _castStringList(json['tags']),
      metadata: _castMap(json['metadata']),
      plannedDurationSeconds: _asInt(json['planned_duration_seconds']),
      actualDurationSeconds: _asInt(json['actual_duration_seconds']),
      cyclesCompleted: _asInt(json['cycles_completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_type': exerciseType,
      'goal_code': goalCode,
      'soundscape_id': soundscapeId,
      'planned_duration_minutes': plannedDurationMinutes,
      'actual_minutes': actualMinutes,
      'start_at': startAt?.toIso8601String(),
      'end_at': endAt?.toIso8601String(),
      'status': status,
      'score_restful': scoreRestful,
      'score_focus': scoreFocus,
      'tags': tags,
      'metadata': metadata,
      'planned_duration_seconds': plannedDurationSeconds,
      'actual_duration_seconds': actualDurationSeconds,
      'cycles_completed': cyclesCompleted,
    };
  }
}

class MindfulnessSessionList {
  const MindfulnessSessionList({
    required this.items,
    required this.nextOffset,
  });

  final List<MindfulnessSession> items;
  final int nextOffset;

  factory MindfulnessSessionList.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? const [])
        .map((item) => MindfulnessSession.fromJson(item as Map<String, dynamic>))
        .toList();
    return MindfulnessSessionList(
      items: items,
      nextOffset: _asInt(json['next_offset']) ?? 0,
    );
  }
}

class MindfulnessSessionEvent {
  MindfulnessSessionEvent({
    required this.id,
    required this.sessionId,
    required this.eventType,
    this.numericValue,
    this.textValue,
    this.occurredAt,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const {};

  final int id;
  final int sessionId;
  final String eventType;
  final double? numericValue;
  final String? textValue;
  final DateTime? occurredAt;
  final Map<String, dynamic> metadata;

  factory MindfulnessSessionEvent.fromJson(Map<String, dynamic> json) {
    return MindfulnessSessionEvent(
      id: _asInt(json['id']) ?? 0,
      sessionId: _asInt(json['session_id']) ?? 0,
      eventType: json['event_type'] as String,
      numericValue: _asDouble(json['numeric_value']),
      textValue: json['text_value'] as String?,
      occurredAt: _asDateTime(json['occurred_at']),
      metadata: _castMap(json['metadata']),
    );
  }
}

class MindfulnessStatsOverview {
  MindfulnessStatsOverview({
    this.range,
    required this.totalMinutes,
    required this.totalHours,
    required this.streakDays,
    required this.sessionsCount,
    this.avgSessionMinutes,
    List<MindfulnessExerciseBreakdown>? byExerciseType,
    this.lastSession,
  }) : byExerciseType = byExerciseType ?? const [];

  final String? range;
  final double totalMinutes;
  final double totalHours;
  final int streakDays;
  final int sessionsCount;
  final double? avgSessionMinutes;
  final List<MindfulnessExerciseBreakdown> byExerciseType;
  final MindfulnessSessionSummary? lastSession;

  factory MindfulnessStatsOverview.fromJson(Map<String, dynamic> json) {
    return MindfulnessStatsOverview(
      range: json['range'] as String?,
      totalMinutes: _asDouble(json['total_minutes']) ?? 0,
      totalHours: _asDouble(json['total_hours']) ?? 0,
      streakDays: _asInt(json['streak_days']) ?? 0,
      sessionsCount: _asInt(json['sessions_count']) ?? 0,
      avgSessionMinutes: _asDouble(json['avg_session_minutes']),
      byExerciseType: (json['by_exercise_type'] as List<dynamic>? ?? const [])
          .map((item) => MindfulnessExerciseBreakdown.fromJson(item as Map<String, dynamic>))
          .toList(),
      lastSession: json['last_session'] != null
          ? MindfulnessSessionSummary.fromJson(json['last_session'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MindfulnessExerciseBreakdown {
  MindfulnessExerciseBreakdown({
    required this.exerciseType,
    required this.minutes,
    required this.sessions,
  });

  final String exerciseType;
  final double minutes;
  final int sessions;

  factory MindfulnessExerciseBreakdown.fromJson(Map<String, dynamic> json) {
    return MindfulnessExerciseBreakdown(
      exerciseType: json['exercise_type'] as String,
      minutes: _asDouble(json['minutes']) ?? 0,
      sessions: _asInt(json['sessions']) ?? 0,
    );
  }
}

class MindfulnessSessionSummary {
  MindfulnessSessionSummary({
    required this.id,
    required this.exerciseType,
    this.endAt,
    this.minutes,
    this.scoreRestful,
    this.scoreFocus,
  });

  final int id;
  final String exerciseType;
  final DateTime? endAt;
  final double? minutes;
  final double? scoreRestful;
  final double? scoreFocus;

  factory MindfulnessSessionSummary.fromJson(Map<String, dynamic> json) {
    return MindfulnessSessionSummary(
      id: _asInt(json['id']) ?? 0,
      exerciseType: json['exercise_type'] as String,
      endAt: _asDateTime(json['end_at']),
      minutes: _asDouble(json['minutes']),
      scoreRestful: _asDouble(json['score_restful']),
      scoreFocus: _asDouble(json['score_focus']),
    );
  }
}

class MindfulnessDailyStat {
  MindfulnessDailyStat({
    required this.day,
    required this.minutes,
    this.exerciseType,
  });

  final DateTime day;
  final double minutes;
  final String? exerciseType;

  factory MindfulnessDailyStat.fromJson(Map<String, dynamic> json) {
    return MindfulnessDailyStat(
      day: _asDate(json['day']) ?? DateTime.now(),
      minutes: _asDouble(json['minutes']) ?? 0,
      exerciseType: json['exercise_type'] as String?,
    );
  }
}

class MindfulSessionCreatePayload {
  MindfulSessionCreatePayload({
    required this.exerciseType,
    required this.plannedDurationMinutes,
    this.goalCode,
    this.soundscapeId,
    this.metadata,
    this.tags,
  });

  final String exerciseType;
  final int plannedDurationMinutes;
  final String? goalCode;
  final int? soundscapeId;
  final Map<String, dynamic>? metadata;
  final List<String>? tags;

  Map<String, dynamic> toJson() {
    return {
      'exercise_type': exerciseType,
      'planned_duration_minutes': plannedDurationMinutes,
      if (goalCode != null) 'goal_code': goalCode,
      if (soundscapeId != null) 'soundscape_id': soundscapeId,
      if (metadata != null) 'metadata': metadata,
      if (tags != null) 'tags': tags,
    };
  }
}

class MindfulSessionProgressPayload {
  MindfulSessionProgressPayload({
    this.cyclesCompleted,
    this.elapsedSeconds,
    this.metadata,
  });

  final int? cyclesCompleted;
  final int? elapsedSeconds;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      if (cyclesCompleted != null) 'cycles_completed': cyclesCompleted,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class MindfulSessionCompletePayload {
  MindfulSessionCompletePayload({
    this.cyclesCompleted,
    this.ratingRelaxation,
    this.ratingStressBefore,
    this.ratingStressAfter,
    this.ratingMoodBefore,
    this.ratingMoodAfter,
    this.metadata,
  });

  final int? cyclesCompleted;
  final int? ratingRelaxation;
  final int? ratingStressBefore;
  final int? ratingStressAfter;
  final int? ratingMoodBefore;
  final int? ratingMoodAfter;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      if (cyclesCompleted != null) 'cycles_completed': cyclesCompleted,
      if (ratingRelaxation != null) 'rating_relaxation': ratingRelaxation,
      if (ratingStressBefore != null) 'rating_stress_before': ratingStressBefore,
      if (ratingStressAfter != null) 'rating_stress_after': ratingStressAfter,
      if (ratingMoodBefore != null) 'rating_mood_before': ratingMoodBefore,
      if (ratingMoodAfter != null) 'rating_mood_after': ratingMoodAfter,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class MindfulSessionEventPayload {
  MindfulSessionEventPayload({
    required this.eventType,
    this.numericValue,
    this.textValue,
    this.occurredAt,
    this.metadata,
  });

  final String eventType;
  final double? numericValue;
  final String? textValue;
  final DateTime? occurredAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'event_type': eventType,
      if (numericValue != null) 'numeric_value': numericValue,
      if (textValue != null) 'text_value': textValue,
      if (occurredAt != null) 'occurred_at': occurredAt!.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class MindfulApiException implements Exception {
  MindfulApiException(this.message, {this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() => 'MindfulApiException(message: $message, statusCode: $statusCode)';
}

List<int> _castIntList(dynamic value) {
  if (value == null) return const [];
  if (value is List) {
    return value
        .where((element) => element != null)
        .map((element) => _asInt(element) ?? 0)
        .toList();
  }
  return const [];
}

List<String> _castStringList(dynamic value) {
  if (value == null) return const [];
  if (value is List) {
    return value
        .where((element) => element != null)
        .map((element) => element.toString())
        .toList();
  }
  return const [];
}

Map<String, dynamic> _castMap(dynamic value) {
  if (value == null) return const {};
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, dynamic v) => MapEntry(key.toString(), v));
  }
  if (value is String) {
    try {
      final decoded = jsonDecode(value) as Map<String, dynamic>;
      return decoded;
    } catch (_) {
      return {'raw': value};
    }
  }
  return const {};
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _asDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}
