import 'package:flutter_study/domain/entities/account_entity.dart';
import 'package:flutter_study/domain/usecases/index.dart';

import '../protocols/http/index.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    await httpClient.request(
        url: url,
        mehtod: HttpMethod.post,
        body: RemoteAuthenticationParams.fromDomain(params).toMap());

    return AccountEntity('token');
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
          email: params.email, password: params.password);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory RemoteAuthenticationParams.fromMap(Map<String, dynamic> map) {
    return RemoteAuthenticationParams(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}
