import 'package:flutter/material.dart';

class BackScaffold extends StatelessWidget {
  final String? name;
  final Widget child;

  const BackScaffold({this.name, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: AppBar(
        leading: const BackButton(),
        title: name == null ? null : Text(name!),
      ),
    );
  }
}
