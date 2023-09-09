import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/browse/tag_display.dart';

import '../../model/object/child_tag.dart';
import '../../model/object/displayable.dart';
import 'file_display.dart';

class GridSquare extends StatelessWidget {
  static const double _borderWidth = 1;

  final Displayable displayable;

  const GridSquare({required this.displayable, super.key});

  Widget borderedGridTile({required Widget child}) {
    return Container(
        padding: const EdgeInsets.all(2),
        child: Container(
          padding: const EdgeInsets.all(_borderWidth),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: _borderWidth)),
          child: child,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget tileInner = displayable is ChildTag
        ? TagDisplay(displayable as ChildTag)
        : displayable is SavedFile
            ? FileDisplay(displayable as SavedFile)
            : throw Exception();
    return borderedGridTile(
      child: tileInner,
    );
  }
}

class DisplayableGrid extends StatelessWidget {
  final AsyncValue<List<Displayable>> displayables;

  const DisplayableGrid({required this.displayables, super.key});

  Widget gridView(List<Displayable> displayables) {
    if (displayables.isEmpty) {
      return const Center(child: Text("Nothing here."));
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200),
      itemBuilder: (context, i) => GridSquare(displayable: displayables[i]),
      itemCount: displayables.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return displayables.when(
      data: (data) => gridView(data),
      error: (err, stack) => Text("Error: $err\n$stack"),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
