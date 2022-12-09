abstract class HttpClient {
  Future<void>? request(
      {required String url, required HttpMethod mehtod, Map body});
}

enum HttpMethod { post, get, put, delete }
