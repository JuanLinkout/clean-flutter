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
    Response response = Response('', 500);

    try {
      if (method == HttpMethod.post) {
        response =
            await client.post(uri, headers: castedHeaders, body: encodedBody);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return handleResponse(response);
  }

  dynamic handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else {
      throw HttpError.serverError;
    }
  }
}
