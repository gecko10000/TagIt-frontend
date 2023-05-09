import 'package:flutter/material.dart';
import 'package:tagit_frontend/requests.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final urlController = TextEditingController(text: "https://"),
      usernameController = TextEditingController(),
      passwordController = TextEditingController();

  bool https = true;
  bool isUrlValid = true;
  String prevUrl = "https://";

  void submit() {}

  Future<void> verifyURLInput(String s) async {
    final uri = Uri.tryParse(s);
    bool valid = uri == null ? false : await checkUri(uri);
    // future because this is called sync if the URI is invalid
    Future(() => setState(() => isUrlValid = valid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
            alignment: Alignment.center,
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("TagIt", style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 20),
                    const Text("Log In", style: TextStyle(fontSize: 32)),
                    Row(
                      children: [
                        Tooltip(
                          message: https ? "HTTPS is secure." : "HTTP is not secure!",
                          child: Switch(
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.red[900],
                            value: https,
                            onChanged: (b) => setState(() {
                              https = b;
                              prevUrl =
                                  "http${https ? "s" : ""}://${prevUrl.split('/').skip(2).join()}";
                              urlController.text = prevUrl;
                              verifyURLInput(prevUrl);
                            }),
                          ),
                        ),
                        Expanded(
                            child: TextFormField(
                          style: const TextStyle(fontSize: 20),
                          controller: urlController,
                          autocorrect: false,
                          decoration:
                              const InputDecoration(hintText: "example.com:80"),
                          validator: (u) {
                            return isUrlValid ? null : "Invalid URL.";
                          },
                          onChanged: (s) {
                            if (!s.startsWith(RegExp(r"https?://"))) {
                              urlController.text = prevUrl;
                              return;
                            }
                            setState(() => https = s.startsWith("https"));
                            prevUrl = urlController.text;
                            verifyURLInput(s);
                          },
                          //onFieldSubmitted: (s) => _formKey.currentState!.validate(),
                        )),
                      ],
                    ),
                  ],
                )))));
  }
}
