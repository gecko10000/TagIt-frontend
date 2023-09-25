import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/auth.dart';
import 'package:tagit_frontend/model/api/base.dart';
import 'package:tagit_frontend/modules/auth/endpoint.dart';
import 'package:tagit_frontend/modules/home/home.dart';

final backendInfoProvider =
    FutureProvider.autoDispose((ref) => AuthenticationAPI.getEndpointInfo());

Future<String?> submitAuth(BuildContext context, bool register, String username,
    String password) async {
  if (register) {
    try {
      await AuthenticationAPI.register(username, password);
    } on DioException catch (ex) {
      final response = ex.response;
      if (response != null && response.statusCode == 400) {
        return response.data.toString();
      }
      return (ex.error ?? ex).toString();
    }
  }
  late final String token;
  try {
    token = await AuthenticationAPI.login(username, password);
  } on DioException catch (ex) {
    final response = ex.response;
    if (response != null && response.statusCode == 400) {
      return response.data.toString();
    }
    return (ex.error ?? ex).toString();
  }
  await accountBox.put("token", token);
  if (context.mounted) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Home()));
  }
  return null;
}

void backToEndpoint(BuildContext context, {Object? exception}) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => EndpointScreen(
                exception: exception,
              )));
}
