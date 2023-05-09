import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String text;
  const ErrorDisplay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: Colors.red),
        const SizedBox(width: 2),
        Text(text)
      ],
    );
  }
}
