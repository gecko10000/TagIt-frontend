import 'package:hive/hive.dart';
import 'package:http/http.dart';

final Client client = _APIClient(Client());
Box accountBox = Hive.box("account");

Map<String, String> defaultHeaders() {
  final headers = <String, String>{};
  final token = accountBox.get("token");
  if (token != null) {
    headers["Authorization"] = "Bearer $token";
  }
  return headers;
}

Uri url(String endpoint, {Map<String, dynamic>? queryParameters}) {
  return Uri.parse(accountBox.get("host"))
      .resolve(endpoint)
      .replace(queryParameters: queryParameters);
}

class _APIClient extends BaseClient {
  final Client _client;

  _APIClient(this._client);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers.addAll(defaultHeaders());
    StreamedResponse response = await _client.send(request);
    // response code not 2XX
    if (response.statusCode ~/ 100 != 2) {
      throw RequestException(
          response.statusCode, await response.stream.bytesToString());
    }
    return response;
  }
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
