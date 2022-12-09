import 'package:flutter_study/domain/entities/account_entity.dart';
import 'package:flutter_study/domain/usecases/index.dart';

import '../protocols/http/index.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, mehtod: 'post');

    return AccountEntity('token');
  }
}
