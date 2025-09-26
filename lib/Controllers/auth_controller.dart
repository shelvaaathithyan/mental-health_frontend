import 'package:ai_therapy/Models/auth_models.dart';
import 'package:ai_therapy/Services/auth_local_store.dart';
import 'package:ai_therapy/Services/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthController._(this._store, this._authService);

  factory AuthController({AuthService? authService, AuthLocalStore? store}) {
    final resolvedStore = store ?? GetStorageAuthLocalStore();
    final resolvedService = authService ?? AuthService(store: resolvedStore);
    return AuthController._(resolvedStore, resolvedService);
  }

  final AuthLocalStore _store;
  final AuthService _authService;

  static const _tokenKey = 'auth.accessToken';
  static const _tokenTypeKey = 'auth.tokenType';
  static const _tokenExpiryKey = 'auth.expiresAt';
  static const _userKey = 'auth.user';

  final Rxn<AuthUser> currentUser = Rxn<AuthUser>();
  final RxnString accessToken = RxnString();
  final Rxn<DateTime> tokenExpiry = Rxn<DateTime>();
  final RxBool isLoading = false.obs;

  bool get isAuthenticated {
    final token = accessToken.value;
    final expiresAt = tokenExpiry.value;
    if (token == null || token.isEmpty) {
      return false;
    }
    if (expiresAt == null) {
      return true;
    }
    return DateTime.now().isBefore(expiresAt);
  }

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    return _performAuthAction(
      () => _authService.register(email: email, password: password),
    );
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    return _performAuthAction(
      () => _authService.login(email: email, password: password),
    );
  }

  Future<AuthUser> guestLogin({
    String? displayName,
  }) async {
    return _performAuthAction(
      () => _authService.guestLogin(displayName: displayName),
    );
  }

  Future<void> logout() async {
    await _store.remove(_tokenKey);
    await _store.remove(_tokenTypeKey);
    await _store.remove(_tokenExpiryKey);
    await _store.remove(_userKey);
    accessToken.value = null;
    tokenExpiry.value = null;
    currentUser.value = null;
  }

  Future<AuthUser> _performAuthAction(
    Future<AuthResponse> Function() action,
  ) async {
    if (isLoading.value) {
      return Future.error('Authentication already in progress');
    }

    try {
      isLoading.value = true;
      final response = await action();
      await _persistSession(response);
      return response.user;
    } on AuthException catch (error) {
      return Future.error(error.message);
    } catch (error) {
      return Future.error('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _persistSession(AuthResponse response) async {
    accessToken.value = response.accessToken;
    tokenExpiry.value = response.expiresAt;
    currentUser.value = response.user;

    await _store.write(_tokenKey, response.accessToken);
    await _store.write(_tokenTypeKey, response.tokenType);
    await _store.write(_tokenExpiryKey, response.expiresAt.toIso8601String());
    await _store.write(_userKey, response.user.toJson());
  }

  void _restoreSession() {
    final storedToken = _store.read<String>(_tokenKey);
    if (storedToken == null || storedToken.isEmpty) {
      return;
    }

    accessToken.value = storedToken;
    tokenExpiry.value = DateTime.tryParse(
      _store.read<String>(_tokenExpiryKey) ?? '',
    );

    final storedUser = _store.read(_userKey);
    if (storedUser is Map) {
      currentUser.value = AuthUser.fromJson(Map<String, dynamic>.from(storedUser));
    }
  }
}
