import './http_method.dart';

abstract class HttpClient {
  Future<Map>? request(
      {required String url, required HttpMethod mehtod, Map body});
}
