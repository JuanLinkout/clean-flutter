import 'package:faker/faker.dart';
import 'package:flutter_study/data/protocols/http/index.dart';
import 'package:flutter_study/data/usecases/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient = HttpClientSpy();
  String url = faker.internet.httpUrl();
  RemoteAuthentication sut =
      RemoteAuthentication(httpClient: httpClient, url: url);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test("Should call HttpCliente with correct values", () async {
    final email = faker.internet.email();
    final password = faker.internet.password();

    await sut.auth(email: email, password: password);

    verify(httpClient.request(url: url, mehtod: 'post'));
  });
}
