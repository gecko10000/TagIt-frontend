import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T?> showRiverpodDialog<T>(
    {required BuildContext context,
    required Widget child,
    RouteSettings? routeSettings,
    bool barrierDismissible = true}) {
  return showDialog<T>(
      barrierColor: Colors.black.withOpacity(0.75),
      context: context,
      routeSettings: routeSettings,
      barrierDismissible: barrierDismissible,
      builder: (_) => ProviderScope(
          parent: ProviderScope.containerOf(context), child: child));
}
