import 'package:faker/faker.dart';
import 'package:flutter_study/data/protocols/http/index.dart';
import 'package:flutter_study/data/usecases/index.dart';
import 'package:flutter_study/domain/helpers/index.dart';
import 'package:flutter_study/domain/usecases/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient = HttpClientSpy();
  String url = faker.internet.httpUrl();
  RemoteAuthentication sut =
      RemoteAuthentication(httpClient: httpClient, url: url);

  final email = faker.internet.email();
  final password = faker.internet.password();
  final params = AuthenticationParams(email: email, password: password);
  final body = RemoteAuthenticationParams.fromDomain(params).toMap();

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test("Should call HttpCliente with correct values", () async {
    final accessToken = faker.guid.guid();
    final name = faker.person.name();
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenAnswer((_) async => {'accessToken': accessToken, 'name': name});

    await sut.auth(params);
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenThrow(HttpError.badRequest);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw NotFound if HttpClient returns 404", () async {
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenThrow(HttpError.notFound);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw ServerError if HttpClient returns 502", () async {
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenThrow(HttpError.serverError);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw invalidCredentialsError if HttpClient returns 401",
      () async {
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenThrow(HttpError.unauthorized);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Should return an Account if HttpClient returns 200", () async {
    final accessToken = faker.guid.guid();
    final name = faker.person.name();
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenAnswer((_) async => {'accessToken': accessToken, 'name': name});
    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });

  test("Should throw ServerError if response is empty", () async {
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenAnswer((_) => null);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if response is invalid", () async {
    when(httpClient.request(url: url, mehtod: HttpMethod.post, body: body))
        .thenAnswer((_) async => {'invalid_key': 'invalid_value'});
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
