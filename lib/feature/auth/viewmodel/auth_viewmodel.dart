import 'dart:async';

import 'package:client/feature/auth/model/user_model.dart';
import 'package:client/feature/auth/repositories/auth_local_repository.dart';
import 'package:client/feature/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../model/token_model.dart';

final authRegisterViewModelProvider =
    AsyncNotifierProvider.autoDispose<AuthRegisterViewmodel, UserModel?>(
        AuthRegisterViewmodel.new);

final authLoginViewModelProvider =
    AsyncNotifierProvider.autoDispose<AuthLoginViewModel, AccessTokenModel?>(
        AuthLoginViewModel.new);

class AuthRegisterViewmodel extends AutoDisposeAsyncNotifier<UserModel?> {
  late RestAuthRepository _restAuthRepository;
  late AuthTokenPersistenceRepository _authTokenPersistenceRepository;

  @override
  FutureOr<UserModel?> build() async {
    _restAuthRepository = ref.watch(restAuthRepositoryProvider);
    _authTokenPersistenceRepository = ref.watch(authTokenPersistenceProvider);
    // await _authTokenPersistenceRepository.init();
    return null;
  }

  /// Create user account
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // set loading state
    state = const AsyncValue.loading();

    final res = await _restAuthRepository.signUp(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    final value = switch (res) {
      Left(value: final error) => state =
          AsyncValue.error(error, StackTrace.current),
      Right(value: final ok) => state = AsyncValue.data(ok)
    };

    print(value);
  }

  /// Initializes sharePreferences before using to save access token
  Future<void> initSharePreferences() async {
    await _authTokenPersistenceRepository.init();
  }

  /// Get User data from server
  Future<UserModel?> getCurrentUserData() async {
    state = AsyncValue.loading();
    final accessToken = _authTokenPersistenceRepository.getToken();

    print(accessToken);

    if (accessToken != null) {
      final res = await _restAuthRepository.getUserData(accessToken);

      final value = switch (res) {
        // TODO: use status code instead of error message
        Left(value: final error) => state = error.message == "Unauthorized User"
            ? state = AsyncValue.data(null)
            : state = AsyncValue.error(error, StackTrace.current),
        Right(value: final value) => state = AsyncValue.data(value)
      };

      print(value);
      return value.value;
    }

    return null;
  }
}

/// Handle login
class AuthLoginViewModel extends AutoDisposeAsyncNotifier<AccessTokenModel?> {
  late RestAuthRepository _restAuthRepository;
  late AuthTokenPersistenceRepository _authTokenPersistenceRepository;
  @override
  FutureOr<AccessTokenModel?> build() {
    _restAuthRepository = ref.watch(restAuthRepositoryProvider);

    return null;
  }

  /// Signs the user in if credentials provided is correct
  Future<void> login({required String email, required String password}) async {
    state = AsyncValue.loading();

    final res = await _restAuthRepository.login(
      email: email,
      password: password,
    );

    final value = switch (res) {
      Left(value: final error) => state =
          AsyncValue.error(error, StackTrace.current),
      Right(value: final ok) => _loginSuccess(ok)
    };
  }

  /// Saves access token in device storage
  AsyncValue<AccessTokenModel?> _loginSuccess(AccessTokenModel accessToken) {
    _authTokenPersistenceRepository.setToken(accessToken.access_token);
    return state = AsyncValue.data(accessToken);
  }
}
