import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/base.dart';

import 'auth_page_model.dart';

// When this screen is open, the host should already be set.
class AuthScreen extends ConsumerStatefulWidget {
  final Object? exception;

  const AuthScreen({this.exception, super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController(),
      password = TextEditingController();

  String? error;

  @override
  Widget build(BuildContext context) {
    ref.listen(backendInfoProvider, (previous, next) {
      if (!next.hasError) return;
      backToEndpoint(context, exception: next.error!);
    });
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          leading: BackButton(onPressed: () => backToEndpoint(context)),
          title: Text(
              "${ref.watch(backendInfoProvider).whenOrNull(data: (i) => i.users == 0 ? "Register" : "Login") ?? "..."} - ${accountBox.get("host")}")),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Username"),
                controller: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a username";
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(hintText: "Password"),
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a password";
                  }
                  return null;
                },
              ),
              Visibility(
                  visible: error != null,
                  child: Text(
                    error ?? "This should not be visible...",
                    style: const TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: ref.watch(backendInfoProvider).whenOrNull(
                      data: (data) => () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() => this.error = null);
                            final error = await submitAuth(context,
                                data.users == 0, username.text, password.text);
                            setState(() => this.error = error);
                          }),
                  child: Text(ref.watch(backendInfoProvider).whenOrNull(
                          data: (data) =>
                              data.users == 0 ? "Register" : "Login") ??
                      "...")),
            ],
          )),
    ));
  }
}
