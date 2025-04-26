import 'dart:async';

import 'package:client/core/provider/current_user_provider.dart';
import 'package:client/feature/auth/model/user_model.dart';
import 'package:client/feature/auth/repositories/auth_local_repository.dart';
import 'package:client/feature/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../model/token_model.dart';

final authViewModelProvider =
    AsyncNotifierProvider.autoDispose<AuthViewmodel, Object?>(
        AuthViewmodel.new);

// final authLoginViewModelProvider =
//     AsyncNotifierProvider.autoDispose<AuthLoginViewModel, AccessTokenModel?>(
//         AuthLoginViewModel.new);

class AuthViewmodel extends AutoDisposeAsyncNotifier<Object?> {
  late RestAuthRepository _restAuthRepository;
  late AuthTokenPersistenceRepository _authTokenPersistenceRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  FutureOr<Object?> build() async {
    _restAuthRepository = ref.watch(restAuthRepositoryProvider);
    _authTokenPersistenceRepository = ref.watch(authTokenPersistenceProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
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
  Future<Object?> getCurrentUserData() async {
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
        Right(value: final value) => _getSucessData(value)
      };

      print(value);
      return value.value;
    }

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
  AsyncValue<Object?> _loginSuccess(AccessTokenModel accessToken) {
    _authTokenPersistenceRepository.setToken(accessToken.access_token);

    // set the user to be used in the app
    _currentUserNotifier.fetchPopulateUserState(accessToken);
    return state = AsyncValue.data(accessToken);
  }

  AsyncValue<Object?> _getSucessData(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}

// /// Handle login
// class AuthLoginViewModel extends AutoDisposeAsyncNotifier<AccessTokenModel?> {
//   late RestAuthRepository _restAuthRepository;
//   late AuthTokenPersistenceRepository _authTokenPersistenceRepository;
//   @override
//   FutureOr<AccessTokenModel?> build() {
//     _restAuthRepository = ref.watch(restAuthRepositoryProvider);

//     return null;
//   }

//   /// Signs the user in if credentials provided is correct
//   Future<void> login({required String email, required String password}) async {
//     state = AsyncValue.loading();

//     final res = await _restAuthRepository.login(
//       email: email,
//       password: password,
//     );

//     final value = switch (res) {
//       Left(value: final error) => state =
//           AsyncValue.error(error, StackTrace.current),
//       Right(value: final ok) => _loginSuccess(ok)
//     };
//   }

//   /// Saves access token in device storage
//   AsyncValue<AccessTokenModel?> _loginSuccess(AccessTokenModel accessToken) {
//     _authTokenPersistenceRepository.setToken(accessToken.access_token);
//     return state = AsyncValue.data(accessToken);
//   }
// }
