import 'package:client/feature/auth/repositories/auth_remote_repository.dart';

abstract class AuthRepository {
  factory AuthRepository() => RestAuthRepostory();

  /// Base url
  final String serverUrl = "";

  /// Create a new user account
  Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  });

  /// Log User in
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
}
