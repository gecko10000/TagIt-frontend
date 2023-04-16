import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class SimpleScaffold extends StatelessWidget {

  final String title;
  final Widget body;
  final bool backButton;

  const SimpleScaffold({super.key, required this.body, required this.title, this.backButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: backButton ? const BackButton() : null,
        ),
        drawer: backButton ? const SideDrawer() : null,
        body: body
    );
  }
}
