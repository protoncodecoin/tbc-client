import 'package:client/feature/auth/model/token_model.dart';
import 'package:client/feature/auth/model/user_model.dart';
import 'package:client/feature/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final currentUserNotifierProvider =
    NotifierProvider<CurrentUserNotifier, UserModel?>(CurrentUserNotifier.new);

class CurrentUserNotifier extends Notifier<UserModel?> {
  late RestAuthRepository _restAuthProvider;

  @override
  UserModel? build() {
    _restAuthProvider = ref.watch(restAuthRepositoryProvider);
    return null;
  }

  /// Update the state
  void addUser(UserModel user) {
    state = user;
  }

  /// Only used to fetch data to be used as state value because the login route only returns the access token
  void fetchPopulateUserState(AccessTokenModel token) async {
    final res = await _restAuthProvider.getUserData(token.access_token);

    // final value = switch (res) {
    //   /// Failed to fetch data
    //   Left(value: _) => state = UserModel(id: -1, username: "", email: ""),
    //   Right(value: final ok) => state = ok,
    // };

    switch (res) {
      // Failed to fetch data
      case Left(value: _):
        state = state = UserModel(id: -1, username: "", email: "");
        break;
      case Right(value: final ok):
        state = ok;
        break;
    }
  }
}
