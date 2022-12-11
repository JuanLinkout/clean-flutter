import './http_method.dart';

abstract class HttpClient {
  Future<dynamic> request(
      {required String url, required HttpMethod method, Map? body});
}
