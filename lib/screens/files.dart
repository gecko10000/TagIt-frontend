import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/common.dart';

class NotImplementedScreen extends StatelessWidget {
  const NotImplementedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleScaffold(
        title: "Not Available",
        body: Align(
          child: Text("Not implemented",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32
            ),
          )
        )
    );
  }

}
