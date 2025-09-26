import 'package:ai_therapy/Models/mindful_models.dart';
import 'package:ai_therapy/Services/mindful_service.dart';
import 'package:get/get.dart';

class MindfulController extends GetxController {
  MindfulController({MindfulService? service})
      : _service = service ?? MindfulService();

  final MindfulService _service;

  final RxBool catalogLoading = false.obs;
  final RxnString catalogError = RxnString();
  final RxList<MindfulnessGoal> goals = <MindfulnessGoal>[].obs;
  final RxList<MindfulnessSoundscape> soundscapes = <MindfulnessSoundscape>[].obs;

  final RxBool sessionsLoading = false.obs;
  final RxBool sessionsRefreshing = false.obs;
  final RxnString sessionsError = RxnString();
  final RxList<MindfulnessSession> sessions = <MindfulnessSession>[].obs;
  final RxInt _sessionsLimit = 20.obs;
  final RxInt _nextOffset = 0.obs;
  final RxBool hasMoreSessions = false.obs;
  final RxString sessionExerciseFilter = ''.obs;
  final RxString sessionGoalFilter = ''.obs;
  final RxString sessionRangeFilter = ''.obs;

  final RxBool activeLoading = false.obs;
  final RxnString activeError = RxnString();
  final Rxn<MindfulnessSession> activeSession = Rxn<MindfulnessSession>();

  final RxBool statsLoading = false.obs;
  final RxnString statsError = RxnString();
  final Rxn<MindfulnessStatsOverview> statsOverview = Rxn<MindfulnessStatsOverview>();
  final RxList<MindfulnessDailyStat> dailyStats = <MindfulnessDailyStat>[].obs;
  final RxString statsRange = '30d'.obs;
  final RxString statsExerciseFilter = ''.obs;

  final RxMap<int, List<MindfulnessSessionEvent>> sessionEvents = <int, List<MindfulnessSessionEvent>>{}.obs;
  final RxMap<int, bool> sessionEventsLoading = <int, bool>{}.obs;
  final RxMap<int, String?> sessionEventsError = <int, String?>{}.obs;

  final RxBool initialised = false.obs;

  static const List<String> exerciseTypes = ['breathing', 'mindfulness', 'relax', 'sleep'];

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    if (initialised.value) {
      await Future.wait([
        loadCatalog(force: false),
        refreshSessions(reset: true),
        refreshStats(range: statsRange.value.isNotEmpty ? statsRange.value : null),
        fetchActiveSession(),
      ]);
      return;
    }

    try {
      await Future.wait([
        loadCatalog(force: true),
        refreshSessions(reset: true),
        refreshStats(range: statsRange.value.isNotEmpty ? statsRange.value : null),
        fetchActiveSession(),
      ]);
    } finally {
      initialised.value = true;
    }
  }

  Future<void> loadCatalog({bool force = false}) async {
    if (!force && catalogLoading.value) return;
    catalogLoading.value = true;
    catalogError.value = null;
    try {
      final goalsData = await _service.listGoals();
      final soundscapeData = await _service.listSoundscapes();
      goals.assignAll(goalsData);
      soundscapes.assignAll(soundscapeData);
    } on MindfulApiException catch (error) {
      catalogError.value = error.message;
    } catch (error) {
      catalogError.value = error.toString();
    } finally {
      catalogLoading.value = false;
    }
  }

  Future<void> refreshSessions({bool reset = true}) async {
    if (reset) {
      sessionsLoading.value = true;
    } else {
      sessionsRefreshing.value = true;
    }
    sessionsError.value = null;

    final queryExercise = sessionExerciseFilter.value.isEmpty ? null : sessionExerciseFilter.value;
    final queryGoal = sessionGoalFilter.value.isEmpty ? null : sessionGoalFilter.value;
    final queryRange = sessionRangeFilter.value.isEmpty ? null : sessionRangeFilter.value;
    final offset = reset ? 0 : _nextOffset.value;

    try {
      final response = await _service.listSessions(
        limit: _sessionsLimit.value,
        offset: offset,
        exerciseType: queryExercise,
        goalCode: queryGoal,
        range: queryRange,
      );

      if (reset) {
        sessions.assignAll(response.items);
      } else {
        sessions.addAll(response.items);
      }

  _nextOffset.value = response.nextOffset;
  hasMoreSessions.value = response.items.length >= _sessionsLimit.value;
    } on MindfulApiException catch (error) {
      sessionsError.value = error.message;
    } catch (error) {
      sessionsError.value = error.toString();
    } finally {
      sessionsLoading.value = false;
      sessionsRefreshing.value = false;
    }
  }

  Future<void> loadMoreSessions() async {
    if (!hasMoreSessions.value || sessionsRefreshing.value) return;
    await refreshSessions(reset: false);
  }

  Future<void> fetchActiveSession() async {
    if (activeLoading.value) return;
    activeLoading.value = true;
    activeError.value = null;
    try {
      final session = await _service.getActiveSession();
      activeSession.value = session;
    } on MindfulApiException catch (error) {
      activeError.value = error.message;
    } catch (error) {
      activeError.value = error.toString();
    } finally {
      activeLoading.value = false;
    }
  }

  Future<MindfulnessSession> startSession(MindfulSessionCreatePayload payload) async {
    final session = await _service.createSession(payload);
    activeSession.value = session;
    sessions.insert(0, session);
    return session;
  }

  Future<MindfulnessSession> refreshSessionDetail(int sessionId) async {
    final detail = await _service.getSessionDetail(sessionId);
    _replaceSession(detail);
    if (activeSession.value?.id == detail.id) {
      activeSession.value = detail;
    }
    return detail;
  }

  Future<MindfulnessSession> updateSessionProgress(
    int sessionId,
    MindfulSessionProgressPayload payload,
  ) async {
    final session = await _service.updateSessionProgress(sessionId, payload);
    _replaceSession(session);
    if (activeSession.value?.id == session.id) {
      activeSession.value = session;
    }
    return session;
  }

  Future<MindfulnessSession> completeSession(
    int sessionId,
    MindfulSessionCompletePayload payload,
  ) async {
    final session = await _service.completeSession(sessionId, payload);
    _replaceSession(session);
    if (activeSession.value?.id == session.id) {
      if (session.status == 'completed') {
        activeSession.value = null;
      } else {
        activeSession.value = session;
      }
    }
    return session;
  }

  Future<List<MindfulnessSessionEvent>> loadSessionEvents(int sessionId, {bool force = false}) async {
    final isLoading = sessionEventsLoading[sessionId] ?? false;
    if (isLoading && !force) return sessionEvents[sessionId] ?? const [];

    sessionEventsLoading[sessionId] = true;
    sessionEventsError[sessionId] = null;
    sessionEventsLoading.refresh();
    sessionEventsError.refresh();

    try {
      final events = await _service.listSessionEvents(sessionId);
      sessionEvents[sessionId] = events;
      sessionEvents.refresh();
      return events;
    } on MindfulApiException catch (error) {
      sessionEventsError[sessionId] = error.message;
      sessionEventsError.refresh();
      rethrow;
    } catch (error) {
      sessionEventsError[sessionId] = error.toString();
      sessionEventsError.refresh();
      rethrow;
    } finally {
      sessionEventsLoading[sessionId] = false;
      sessionEventsLoading.refresh();
    }
  }

  Future<MindfulnessSessionEvent> createSessionEvent(
    int sessionId,
    MindfulSessionEventPayload payload,
  ) async {
    final event = await _service.addSessionEvent(sessionId, payload);
    final current = sessionEvents[sessionId] ?? const [];
    sessionEvents[sessionId] = [...current, event];
    sessionEvents.refresh();
    return event;
  }

  Future<void> refreshStats({String? range, String? exerciseType}) async {
    statsLoading.value = true;
    statsError.value = null;

    if (range != null) {
      statsRange.value = range;
    }
    if (exerciseType != null) {
      statsExerciseFilter.value = exerciseType;
    }

    try {
      final overview = await _service.getStatsOverview(range: _sanitizeString(statsRange.value));
      final daily = await _service.getDailyStats(
        days: _resolveDaysForRange(statsRange.value),
        exerciseType: _sanitizeString(statsExerciseFilter.value),
      );
      statsOverview.value = overview;
      dailyStats.assignAll(daily);
    } on MindfulApiException catch (error) {
      statsError.value = error.message;
    } catch (error) {
      statsError.value = error.toString();
    } finally {
      statsLoading.value = false;
    }
  }

  void applySessionFilters({String? exerciseType, String? goalCode, String? range}) {
    if (exerciseType != null) {
      sessionExerciseFilter.value = exerciseType;
    }
    if (goalCode != null) {
      sessionGoalFilter.value = goalCode;
    }
    if (range != null) {
      sessionRangeFilter.value = range;
    }
    refreshSessions(reset: true);
  }

  void clearSessionFilters() {
    sessionExerciseFilter.value = '';
    sessionGoalFilter.value = '';
    sessionRangeFilter.value = '';
    refreshSessions(reset: true);
  }

  void setStatsRange(String range) {
    statsRange.value = range;
    refreshStats(range: range);
  }

  void setStatsExerciseFilter(String exerciseType) {
    statsExerciseFilter.value = exerciseType;
    refreshStats(exerciseType: exerciseType);
  }

  void _replaceSession(MindfulnessSession session) {
    final index = sessions.indexWhere((element) => element.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
      sessions.refresh();
    } else {
      sessions.insert(0, session);
    }
  }

  String? _sanitizeString(String value) {
    if (value.isEmpty) return null;
    return value;
  }

  int _resolveDaysForRange(String range) {
    switch (range) {
      case '7d':
        return 7;
      case '30d':
        return 30;
      case '90d':
        return 90;
      case '1y':
        return 365;
      default:
        final parsed = int.tryParse(range.replaceAll(RegExp(r'[^0-9]'), ''));
        return parsed != null && parsed > 0 ? parsed : 30;
    }
  }
}
