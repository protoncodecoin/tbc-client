import 'dart:convert';
import "dart:io";

import 'package:client/core/error/app_error.dart';
import 'package:client/feature/auth/model/token_model.dart';
import 'package:client/feature/auth/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../core/data_class/repository/repository.dart';

/// Provider for [RestAuthReposity]
final restAuthRepositoryProvider =
    Provider.autoDispose((ref) => RestAuthRepository());

/// Concreate class to handle Restful API authentication
class RestAuthRepository implements AuthRepository {
  @override
  final String serverUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api/v1/users'
      : "http://127.0.0.1:8000/";

  @override
  Future<Either<AppError, UserModel>> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // final urlPath = Uri.http(uriAuthority, localURL);
      final urlPath = Uri.parse('$serverUrl/signup');
      final response = await http.post(
        urlPath,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            "username": username,
            "email": email,
            "password": password,
            "password2": confirmPassword,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return Right(UserModel.fromMap(data));
      }
      if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body) as Map<String, dynamic>;

        return Left(AppError(errorMessage["detail"]));
      } else {
        return Left(AppError("Network error occurred"));
      }
    } catch (e) {
      return Left(AppError(e.toString()));
    }
  }

  @override
  Future<Either<AppError, AccessTokenModel>> login(
      {required String email, required String password}) async {
    final urlPath = Uri.parse('$serverUrl/login');
    try {
      final response = await http.post(
        urlPath,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "password": password,
          "username": email,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return Right(AccessTokenModel.fromMap(data));
        //
      }
      if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body) as Map<String, dynamic>;
        return Left(
          AppError(
            errorMessage["detail"],
          ),
        );
      } else {
        // Undocumented error
        return Left(AppError("Network Error occurred"));
      }
    } catch (e) {
      return Left(AppError(e.toString()));
    }
  }

  @override
  Future<Either<AppError, UserModel>> getUserData(token) async {
    final urlPath = '$serverUrl/profile';

    try {
      final response =
          await http.get(Uri.parse(urlPath), headers: {'x-user-token': token});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return Right(UserModel.fromMap(data));
      }
      if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body) as Map<String, dynamic>;
        return Left(
          AppError(
            errorMessage["detail"],
          ),
        );
      }
      if (response.statusCode == 401) {
        return Left(AppError("Unauthorized User"));
      } else {
        /// undocumented Error
        return Left(AppError("Network error occurred"));
      }
    } catch (e) {
      return Left(AppError(e.toString()));
    }
  }
}
