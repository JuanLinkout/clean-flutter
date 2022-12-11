import 'package:flutter_study/data/protocols/http/index.dart';
import 'package:flutter_study/domain/entities/index.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel(this.token);

  factory RemoteAccountModel.fromMap(Map json) {
    final token = json['accessToken'];

    if (token != null) {
      return RemoteAccountModel(token);
    } else {
      throw HttpError.invalidData;
    }
  }

  AccountEntity toAccountEntity() {
    return AccountEntity(token);
  }
}
