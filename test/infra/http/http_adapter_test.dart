import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_study/data/protocols/http/index.dart';
import 'package:flutter_study/infra/http/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  final body = {'any_key': 'any_value'};
  final encodedBody = jsonEncode(body);

  late ClientSpy client;
  late HttpAdapter sut;
  late String url;
  late Uri uri;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
  });

  When mockPostRequest({Map? payload}) {
    String? encodedPayload = payload != null ? jsonEncode(payload) : null;
    return when(() => client.post(uri, headers: headers, body: encodedPayload));
  }

  void mockPostResponse(
      {required int statusCode, String responseBody = '{}', Map? payload}) {
    return mockPostRequest(payload: payload)
        .thenAnswer((_) async => Response(responseBody, statusCode));
  }

  void mockPostError() {
    return mockPostRequest().thenThrow(Exception());
  }

  group('post', () {
    test('Should call post with correct values', () async {
      mockPostResponse(
          statusCode: 200,
          responseBody: '{"any_key": "anyvalue"}',
          payload: body);

      await sut.request(
          url: url, method: HttpMethod.post, headers: headers, body: body);

      verify(() => client.post(uri, headers: headers, body: encodedBody))
          .called(1);
    });

    test('Should call post with correct values without body', () async {
      mockPostResponse(
          statusCode: 200, responseBody: '{"any_key": "anyvalue"}');

      await sut.request(
        url: url,
        method: HttpMethod.post,
        headers: headers,
      );

      verify(() => client.post(
            uri,
            headers: headers,
          )).called(1);
    });

    test('Should return data if status is 200', () async {
      mockPostResponse(
          statusCode: 200,
          responseBody: '{"any_key": "any_value"}',
          payload: body);

      final response = await sut.request(
          url: url, method: HttpMethod.post, headers: headers, body: body);

      expect(response, {"any_key": "any_value"});
    });

    test('Should return null if status is 200', () async {
      mockPostResponse(statusCode: 200, responseBody: '', payload: body);

      final response = await sut.request(
          url: url, method: HttpMethod.post, headers: headers, body: body);

      expect(response, null);
    });

    test('Should return null if status is 204', () async {
      mockPostResponse(statusCode: 200, responseBody: '', payload: body);

      final response = await sut.request(
          url: url, method: HttpMethod.post, headers: headers, body: body);

      expect(response, null);
    });

    test('Should return BadRequestError if status is 400', () async {
      mockPostResponse(statusCode: 400, payload: body);

      final future = sut.request(
          url: url, method: HttpMethod.post, headers: headers, body: body);

      expect(future, throwsA(HttpError.badRequest));
    });

    test(
        'Should return BadRequestError if status is 400 and no payload is sent',
        () async {
      mockPostResponse(statusCode: 400);

      final future =
          sut.request(url: url, method: HttpMethod.post, headers: headers);

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return Unauthorized if status is 401', () async {
      mockPostResponse(statusCode: 401);

      final future =
          sut.request(url: url, method: HttpMethod.post, headers: headers);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return Unauthorized if status is 403', () async {
      mockPostResponse(statusCode: 403);

      final future =
          sut.request(url: url, method: HttpMethod.post, headers: headers);

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return Unauthorized if status is 404', () async {
      mockPostResponse(statusCode: 404);

      final future =
          sut.request(url: url, method: HttpMethod.post, headers: headers);

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if status is 500', () async {
      mockPostResponse(statusCode: 500);

      final future =
          sut.request(url: url, method: HttpMethod.post, headers: headers);

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockPostError();

      final future =
          sut.request(url: url, method: HttpMethod.post, headers: headers);

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
