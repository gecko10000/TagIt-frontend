import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/model/object/tag_counts.dart';
import 'package:tagit_frontend/view_model/browse.dart';

import '../../model/object/child_tag.dart';
import '../../model/object/displayable.dart';
import '../../model/object/tag.dart';

class GridSquare extends StatelessWidget {
  static const double _borderWidth = 1;

  final Tag parentTag;
  final Displayable displayable;

  const GridSquare(
      {required this.parentTag, required this.displayable, super.key});

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

  Widget tagCounts(TagCounts counts) {
    final fileString = counts.files == counts.totalFiles
        ? counts.files
        : "${counts.files} (${counts.totalFiles})";
    final tagString = counts.tags == counts.totalTags
        ? counts.tags
        : "${counts.tags} (${counts.totalTags})";
    return Tooltip(
      message: "${counts.files} direct files\n"
          "${counts.totalFiles} total files\n"
          "${counts.tags} direct subtags\n"
          "${counts.totalTags} total subtags",
      child: Text("$fileString / $tagString"),
    );
  }

  Widget tagInner(BuildContext context, ChildTag tag) {
    return InkWell(
        onTap: () => openTag(context, parentTag, tag),
        child: GridTile(
          header: Center(child: tagCounts(tag.counts)),
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
          footer: Center(child: Text(savedFile.name)),
          child: const Icon(
            Icons.file_copy,
            size: 100,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget tileInner = displayable is ChildTag
        ? tagInner(context, displayable as ChildTag)
        : displayable is SavedFile
            ? fileInner(context, displayable as SavedFile)
            : throw Exception();
    return borderedGridTile(
      child: tileInner,
    );
  }
}

class DisplayableGrid extends StatelessWidget {
  final Tag parentTag;
  final List<Displayable> displayables;

  const DisplayableGrid(
      {required this.parentTag, required this.displayables, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200),
      itemBuilder: (context, i) =>
          GridSquare(parentTag: parentTag, displayable: displayables[i]),
      itemCount: displayables.length,
    );
  }
}
