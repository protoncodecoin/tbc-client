import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/data_class/repository/repository.dart';

class RestAuthRepostory implements AuthRepository {
  @override
  final String serverUrl = 'http://10.0.2.2:8000/api/v1/users';

  @override
  Future<Map<String, dynamic>> signUp({
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
        return data;
      }
      if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body) as Map<String, dynamic>;

        throw Exception(errorMessage["detail"]);
      } else {
        throw Exception("Network error occurred");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, dynamic>> login(
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
        return data;
        //
      }
      if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorMessage["detail"]);
      } else {
        // Undocumented error
        throw Exception("Network Error occurred");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
