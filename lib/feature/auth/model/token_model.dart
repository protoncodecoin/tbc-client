// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// Access token from the server
class AccessTokenModel {
  final String access_token;
  final String token_type;

  const AccessTokenModel({
    required this.access_token,
    required this.token_type,
  });

  AccessTokenModel copyWith({
    String? access_token,
    String? token_type,
  }) {
    return AccessTokenModel(
      access_token: access_token ?? this.access_token,
      token_type: token_type ?? this.token_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': access_token,
      'token_type': token_type,
    };
  }

  factory AccessTokenModel.fromMap(Map<String, dynamic> map) {
    return AccessTokenModel(
      access_token: map['access_token'] as String,
      token_type: map['token_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccessTokenModel.fromJson(String source) =>
      AccessTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TokenModel(access_token: $access_token, token_type: $token_type)';

  @override
  bool operator ==(covariant AccessTokenModel other) {
    if (identical(this, other)) return true;

    return other.access_token == access_token && other.token_type == token_type;
  }

  @override
  int get hashCode => access_token.hashCode ^ token_type.hashCode;
}
