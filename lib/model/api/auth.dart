import 'package:dio/dio.dart';
import 'package:tagit_frontend/model/api/base.dart';

import '../object/backend_info.dart';

class AuthenticationAPI {
  AuthenticationAPI._();

  static Future<Response> _auth(String endpoint, String username,
      String password) async {
    final response = await client.post("/auth/$endpoint",
        data: FormData.fromMap({"username": username, "password": password}));
    return response;
  }

  static Future<String> login(String username, String password) async {
    final response = await _auth("login", username, password);
    return response.data["token"];
  }

  static Future<void> register(String username, String password) async =>
      await _auth("register", username, password);

  // This serves as both a backend info retriever for the current host,
  // and for any host that's provided. This makes it useful during
  // endpoint entry and when retrieving in settings.
  static Future<BackendInfo> getEndpointInfo({String? endpoint}) async {
    final endpointClient =
    endpoint == null ? client : Dio(BaseOptions(baseUrl: endpoint));
    final response = await endpointClient.get("/tagit/version");
    return BackendInfo.fromJson(response.data);
  }

}
