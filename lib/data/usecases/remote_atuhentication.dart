import 'package:flutter_study/domain/entities/index.dart';
import 'package:flutter_study/domain/helpers/index.dart';
import 'package:flutter_study/domain/usecases/index.dart';

import '../models/index.dart';
import '../protocols/http/index.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final body = RemoteAuthenticationParams.fromDomain(params).toMap();
      final httpResponse = await httpClient.request(
          url: url, mehtod: HttpMethod.post, body: body);

      if (httpResponse != null) {
        return RemoteAccountModel.fromMap(httpResponse).toAccountEntity();
      } else {
        throw HttpError.serverError;
      }
    } on HttpError catch (error) {
      if (error == HttpError.unauthorized) {
        throw DomainError.invalidCredentials;
      } else {
        throw DomainError.unexpected;
      }
    }
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
