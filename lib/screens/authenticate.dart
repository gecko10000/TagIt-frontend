import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tagit_frontend/requests.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final urlController = TextEditingController(),
      usernameController = TextEditingController(),
      passwordController = TextEditingController();

  bool validUrl = false;
  String? urlError;
  Future<void>? lastVerification;
  String? loginError;
  Box box = Hive.box("account");

  void submit() async {
    await box.put("host", fixUri(urlController.text));
    try {
      final token =
          await login(usernameController.text, passwordController.text);
      box.put("token", token);
    } on RequestException catch (ex) {
      setState(() {
        loginError = ex.message;
      });
    }
  }

  void setError(String? newError) {
    // use a Future because we can't setState during build
    // (verifyURLInput can call this synchronously during build)
    setState(() {
      urlError = newError;
      if (newError == null) validUrl = true;
    });
  }

  String fixUri(String s) {
    return (s.startsWith(RegExp(r'https?://')) ? s : "https://$s") +
        (s.endsWith('/') ? '' : '/');
  }

  Future<void> verifyURLInput() async {
    if (validUrl) return;
    String s = urlController.text;
    if (s.isEmpty) {
      setError("An input is required.");
      return;
    }
    // add https:// if it's not there already
    // also, append a slash at the end if it's missing
    // (Uri#resolve requires a slash to work properly)
    final uriString = fixUri(s);
    final uri = Uri.tryParse(uriString);
    if (uri == null) {
      setError("Could not parse URL.");
      return;
    }
    String? version = await getVersion(uri: uri);
    // async gap, need to ensure input matches current value
    if (urlController.text != s) return;
    setError(version != null ? null : "$uri is not a valid TagIt backend.");
  }

  late FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    const double width = 500;
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: width),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Center(
                      child: Text("TagIt", style: TextStyle(fontSize: 48))),
                  const SizedBox(height: 20),
                  const Center(
                      child: Text("Log In", style: TextStyle(fontSize: 32))),
                  const SizedBox(height: 20),
                  const Text("Host"),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      focusNode: focusNode,
                      style: const TextStyle(fontSize: 20),
                      controller: urlController,
                      autocorrect: false,
                      decoration:
                          const InputDecoration(hintText: "mytagitbackend.com"),
                      validator: (_) {
                        return urlError;
                      },
                      onChanged: (_) => setState(() => validUrl = false),
                      onFieldSubmitted: (_) {
                        verifyURLInput();
                        // stop field from losing focus
                        focusNode.requestFocus();
                      },
                    )),
                    validUrl
                        ? const Icon(Icons.check_circle)
                        : TextButton(
                            onPressed: () => verifyURLInput(),
                            child: const Text("Verify"))
                  ]),
                  const SizedBox(height: 20),
                  const Text("Username"),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: usernameController,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 20),
                  const Text("Password"),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: passwordController,
                    autocorrect: false,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: TextButton(
                          onPressed: () async {
                            await verifyURLInput();
                            if (_formKey.currentState!.validate()) {
                              submit();
                            }
                          },
                          child: const Text("Submit"))),
                  Center(
                      child: Visibility(
                    visible: loginError != null,
                    child: Text(loginError ?? "No error"),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    focusNode = FocusNode();
    final host = box.get("host");
    if (host != null) urlController.text = host;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
