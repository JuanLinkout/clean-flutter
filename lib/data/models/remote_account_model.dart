import 'package:flutter_study/domain/entities/index.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel(this.token);

  factory RemoteAccountModel.fromMap(Map json) {
    final token = json['accessToken'];
    return RemoteAccountModel(token);
  }

  AccountEntity toAccountEntity() {
    return AccountEntity(token);
  }
}
