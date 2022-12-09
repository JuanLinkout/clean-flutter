import '../entities/index.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory AuthenticationParams.fromMap(Map<String, dynamic> map) {
    return AuthenticationParams(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}
