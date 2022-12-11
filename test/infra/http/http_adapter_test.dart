import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_study/data/protocols/http/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<dynamic> request(
      {required String url,
      required HttpMethod method,
      Map? body,
      Map<String, String>? headers}) async {
    Map<String, String> defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    Map<String, String> castedHeaders = headers?.cast<String, String>() ?? {};
    castedHeaders.addAll(defaultHeaders);

    final encodedBody = body != null ? jsonEncode(body) : null;
    final uri = Uri.parse(url);
    await client.post(uri, headers: castedHeaders, body: encodedBody);
  }
}

void main() {
  final url = faker.internet.httpUrl();
  final uri = Uri.parse(url);
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  final body = {'any_key': 'any_value'};
  final encodedBody = jsonEncode(body);

  late ClientSpy client;
  late HttpAdapter sut;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
  });

  group('post', () {
    test('Should call post with correct values', () async {
      when(() => client.post(uri, headers: headers, body: encodedBody))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(
          url: url, method: HttpMethod.post, headers: headers, body: body);

      verify(() => client.post(uri, headers: headers, body: encodedBody))
          .called(1);
    });

    test('Should call post with correct values without body', () async {
      when(() => client.post(
            uri,
            headers: headers,
          )).thenAnswer((_) async => Response('{}', 200));

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
  });
}
