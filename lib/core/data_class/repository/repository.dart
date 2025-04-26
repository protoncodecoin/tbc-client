import 'package:client/core/error/app_error.dart';
import 'package:client/feature/auth/model/token_model.dart';
import 'package:client/feature/auth/model/user_model.dart';
import 'package:client/feature/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  factory AuthRepository() => RestAuthRepository();

  /// Base url
  final String serverUrl = "";

  /// Create a new user account.
  /// Returns a UserModel or AppError
  Future<Either<AppError, UserModel>> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  });

  /// Log User in.
  /// Returns a UserModel or AppError
  Future<Either<AppError, AccessTokenModel>> login({
    required String email,
    required String password,
  });

  /// Get current User Data
  Future<Either<AppError, UserModel>> getUserData(String token);
}
