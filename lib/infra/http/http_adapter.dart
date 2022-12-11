import 'dart:convert';

import 'package:flutter_study/data/protocols/http/index.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<dynamic> request(
      {required String url,
      required HttpMethod method,
      Map? body,
      Map? headers}) async {
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
