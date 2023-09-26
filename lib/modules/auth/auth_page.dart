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

  void submit() async {
    final bool reg = await ref.watch(isRegisterProvider.future);
    if (!context.mounted) return;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => this.error = null);
    final error = await submitAuth(context, reg, username.text, password.text);
    setState(() => this.error = error);
  }

  @override
  Widget build(BuildContext context) {
    // If the endpoint doesn't work for whatever reason,
    // we send the user back to the endpoint entry page.
    ref.listen(backendInfoProvider, (previous, next) {
      if (!next.hasError) return;
      backToEndpoint(context, exception: next.error!);
    });
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                leading: BackButton(onPressed: () => backToEndpoint(context)),
                title: Text(
                    "${ref.watch(isRegisterProvider).whenOrNull(data: (reg) => reg ? "Register" : "Login") ?? "..."} - ${accountBox.get("host")}")),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Form(
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
                        onFieldSubmitted: (s) => submit(),
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
                        onFieldSubmitted: (s) => submit(),
                      ),
                      Visibility(
                          visible: error != null,
                          child: Text(
                            error ?? "This should not be visible...",
                            style: const TextStyle(color: Colors.red),
                          )),
                      TextButton(
                          onPressed: ref
                              .watch(isRegisterProvider)
                              .whenOrNull(data: (reg) => submit),
                          child: Text(ref.watch(isRegisterProvider).whenOrNull(
                                  data: (reg) => reg ? "Register" : "Login") ??
                              "...")),
                    ],
                  )),
            )));
  }
}
