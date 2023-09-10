import 'package:flutter/material.dart';

class BorderedGridTile extends StatelessWidget {
  static const double _paddingWidth = 2;
  static const double _borderWidth = 1;

  final Widget child;

  const BorderedGridTile({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(_paddingWidth),
        child: Container(
          padding: const EdgeInsets.all(_borderWidth),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: _borderWidth)),
          child: child,
        ));
  }
}
