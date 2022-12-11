abstract class HttpClient {
  Future<Map>? request(
      {required String url, required HttpMethod mehtod, Map body});
}

enum HttpMethod { post, get, put, delete }
