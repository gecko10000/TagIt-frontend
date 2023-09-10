import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/browse/tag_tile.dart';

import '../../common/widgets/bordered_grid_tile.dart';
import '../../model/object/child_tag.dart';
import '../../model/object/displayable.dart';
import 'file_tile.dart';

class GridSquare extends StatelessWidget {
  final Displayable displayable;
  final bool stackPush;

  const GridSquare(
      {required this.displayable, this.stackPush = true, super.key});

  @override
  Widget build(BuildContext context) {
    Widget tileInner = displayable is ChildTagState
        ? TagTile(
            displayable as ChildTagState,
            stackPush: stackPush,
          )
        : displayable is SavedFileState
            ? FileTile(displayable as SavedFileState)
            : throw Exception();
    return BorderedGridTile(
      child: tileInner,
    );
  }
}

class DisplayableGrid extends StatelessWidget {
  final AsyncValue<List<Displayable>> displayables;
  final Widget Function(BuildContext, Displayable)? itemBuilder;
  final bool stackPush;

  const DisplayableGrid(
      {required this.displayables,
      this.itemBuilder,
      super.key,
      this.stackPush = true});

  Widget gridView(List<Displayable> displayables) {
    if (displayables.isEmpty) {
      return const Center(child: Text("Nothing here."));
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200),
      itemBuilder: (context, i) {
        final displayable = displayables[i];
        return itemBuilder != null
            ? itemBuilder!(context, displayable)
            : GridSquare(
                displayable: displayable,
                stackPush: stackPush,
              );
      },
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
