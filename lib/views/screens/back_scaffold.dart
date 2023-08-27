import 'package:flutter/material.dart';

class BackScaffold extends StatelessWidget {
  final Widget child;

  const BackScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: AppBar(
        leading: BackButton(),
      ),
    );
  }
}
