import 'package:flutter/material.dart';
import 'package:tagit_frontend/models/objects/saved_file.dart';
import 'package:tagit_frontend/view_models/browse.dart';

import '../../models/objects/displayable.dart';
import '../../models/objects/tag.dart';

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
          child: child,
        ));
  }

  Widget tagInner(BuildContext context, Tag tag) {
    return InkWell(
        onTap: () => openTag(context, tag),
        child: GridTile(
          footer: Center(child: Text(tag.name)),
          child: const Icon(
            Icons.sell,
            size: 100,
          ),
        ));
  }

  Widget fileInner(BuildContext context, SavedFile savedFile) {
    return InkWell(
        onTap: () => openFile(context, savedFile),
        child: GridTile(
          footer: Center(child: Text(savedFile.info.name)),
          child: const Icon(
            Icons.file_copy,
            size: 100,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return borderedGridTile(
        child: displayable.when(
      tag: (tag) => tagInner(context, tag),
      file: (file) => fileInner(context, file),
    ));
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
