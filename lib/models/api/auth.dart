import 'dart:convert';

import 'package:http/http.dart';
import 'package:tagit_frontend/models/api/base.dart';

class AuthenticationAPI {

  static Future<Response> _auth(String endpoint, String username,
      String password) async {
    final response = await client.post(url("auth/$endpoint"),
        body: {"username": username, "password": password});
    return response;
  }

  static Future<String> login(String username, String password) async {
    final response = await _auth("login", username, password);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return json["token"];
  }

  static Future<void> register(String username, String password) async =>
      await _auth("register", username, password);
}
