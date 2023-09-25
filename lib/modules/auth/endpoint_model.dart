import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/base.dart';
import 'package:tagit_frontend/model/object/backend_info.dart';
import 'package:tagit_frontend/modules/auth/auth_page.dart';

import '../../model/api/auth.dart';

final endpointProvider =
    StateProvider<String>((ref) => accountBox.get("host") ?? "");

final _schemaRegex = RegExp(r'^https?://');
final _portRegex = RegExp(r':\d{1,5}$');
const _defaultPort = 10000;

// Returns the BackendInfo and the URL that worked.
final multiUrlBackendInfoProvider =
    FutureProvider<(BackendInfo, String)>((ref) {
  String input = ref.watch(endpointProvider);
  final endpoints = [input];
  if (!input.contains(_schemaRegex)) {
    // Note: we do not suggest HTTP as it may
    // take precedence over HTTPS since the first
    // result is returned, not the best one.
    // Also, don't use HTTP, moron. If you really
    // want, specify it yourself.
    endpoints.add("https://$input");
  }
  if (!input.contains(_portRegex)) {
    // use toList to make a clone and
    // avoid concurrent modification.
    for (final endpoint in endpoints.toList()) {
      endpoints.add("$endpoint:$_defaultPort");
    }
  }
  final optimalEndpointFuture = Completer<(BackendInfo, String)>();
  final futures = endpoints
      .map((e) => AuthenticationAPI.getEndpointInfo(endpoint: e).then((value) {
            // this way, we can immediately bubble up a result if it succeeds
            optimalEndpointFuture.complete((value, e));
            return value as BackendInfo?;
          }).onError((error, stackTrace) => null));

  Future.wait(futures).whenComplete(() {
    if (optimalEndpointFuture.isCompleted) return;
    // if nothing succeeded, we complete it with an error
    optimalEndpointFuture.completeError(NoEndpointFoundException(endpoints));
  });
  return optimalEndpointFuture.future;
});

class NoEndpointFoundException implements Exception {
  final List<String> triedEndpoints;

  const NoEndpointFoundException(this.triedEndpoints);
}

void setHost(String url) async {
  await accountBox.put("host", url);
  refreshClientEndpoint();
}

void submitEndpoint(BuildContext context, (BackendInfo, String) info) async {
  await accountBox.put("host", info.$2);
  refreshClientEndpoint();
  if (context.mounted) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthScreen()));
  }
}
