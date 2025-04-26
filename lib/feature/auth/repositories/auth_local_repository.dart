import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authTokenPersistenceProvider =
    Provider((ref) => AuthTokenPersistenceRepository());

class AuthTokenPersistenceRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Set token in client storage
  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString("x-auth-token", token);
    }
  }

  /// Retrieve token from client storage
  String? getToken() {
    return _sharedPreferences.getString("x-auth-token");
  }
}
