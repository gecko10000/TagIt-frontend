import 'package:flutter/material.dart';

import '../../models/objects/displayable.dart';

class GridSquare extends StatelessWidget {
  static const double _borderWidth = 1;

  final Displayable displayable;

  const GridSquare(this.displayable, {super.key});

  Widget borderedGridTile({required Widget child}) {
    return Container(
        padding: const EdgeInsets.all(2),
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(_borderWidth),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: _borderWidth)),
          child: const Placeholder(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return displayable.when(
      tag: (tag) => borderedGridTile(child: Placeholder()),
      file: (file) => borderedGridTile(child: Icon(Icons.file_copy)),
    );
  }
}

class DisplayableGrid extends StatelessWidget {
  final List<Displayable> displayables;

  const DisplayableGrid(this.displayables, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: displayables.map((e) => GridSquare(e)).toList(),
    );
  }
}
