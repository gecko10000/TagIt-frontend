import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/misc/extensions.dart';
import 'package:tagit_frontend/requests.dart';

part 'account.g.dart';

@riverpod
class Backend extends _$Backend {
  @override
  Future<BackendInfo?> build() => getBackendInfo();
}

void addUser(BuildContext context) {

}

class AccountScreen extends ConsumerWidget {
  AccountScreen({super.key});

  final Box box = Hive.box("account");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backend = ref.watch(backendProvider).value;

    return Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text("Logged into ${box.get("host")}"),
            if (backend != null) Text("Backend Version ${backend.version}"),
            if (backend != null) Text("${backend.users} user${backend.users.smartS()} total"),
            TextButton(
                onPressed: () => print("adding user"),
                child: const Text("Register Another User")),
            TextButton(
                onPressed: () async {
                  await box.put("error", "You've been logged out.");
                  await box.delete("token");
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text("Log Out")),
          ],
        )));
  }
}
