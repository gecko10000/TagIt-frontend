import 'package:dio/dio.dart';
import 'package:tagit_frontend/model/api/base.dart';

class AuthenticationAPI {
  AuthenticationAPI._();

  static Future<Response> _auth(
      String endpoint, String username, String password) async {
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
}
