import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

Map<String, String> defaultHeaders() {
  final headers = <String, String>{};
  final token = accountBox.get("token");
  if (token != null) {
    headers["Authorization"] = "Bearer $token";
  }
  return headers;
}

Dio _createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: accountBox.get("host") ?? "",
  ));
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers.addAll(defaultHeaders());
      handler.next(options);
    },
    onError: (e, handler) => handler.next(e),
  ));
  return dio;
}

Box accountBox = Hive.box("account");
Dio client = _createDio();

// To be called when the endpoint is set or changed.
// Otherwise, the client will continue to use the old host.
void refreshClientEndpoint() {
  client = _createDio();
}

Map<String, String> fileGetParams() {
  final token = accountBox.get("token");
  return token == null ? {} : {"token": token};
}

Uri url(String endpoint, {Map<String, dynamic>? queryParameters}) {
  return Uri.parse(accountBox.get("host"))
      .resolve(endpoint)
      .replace(queryParameters: queryParameters);
}

class RequestException implements Exception {
  final int statusCode;
  final String message;

  const RequestException(this.statusCode, this.message);

  @override
  String toString() {
    return message.isEmpty ? statusCode.toString() : "$statusCode - $message";
  }
}
