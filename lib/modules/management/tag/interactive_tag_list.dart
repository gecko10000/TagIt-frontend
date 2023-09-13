import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';
import 'package:tagit_frontend/modules/management/file/saved_file_view_model.dart';

import '../../../model/object/saved_file.dart';
import 'interactive_tag_list_model.dart';

const fileTagListRouteName = "fileTagListRoute";

class InteractiveTagList extends ConsumerWidget {
  static const double maxWidth = 500;
  final String fileId;

  const InteractiveTagList(this.fileId, {super.key});

  Widget listTitle(String title) {
    return Tooltip(
        message: title,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ));
  }

  Widget tagListEntry(BuildContext context, WidgetRef ref,
      SavedFileState savedFile, String tag) {
    return Center(
        child: Material(
            child: ListTile(
      title: Text(tag),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => openTagBrowser(context, tag, stackPush: false)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => removeTag(context, ref, savedFile, tag),
          )
        ],
      ),
    )));
  }

  Widget addMoreTile(
      BuildContext context, WidgetRef ref, SavedFileState savedFile) {
    return Center(
        child: Material(
            child: ListTile(
      leading: const Icon(Icons.add),
      title: const Text("Add Tag"),
      onTap: () => addTags(context, ref, savedFile),
    )));
  }

  Widget tagList(
      BuildContext context, WidgetRef ref, SavedFileState savedFile) {
    final numTags = savedFile.tags.length;
    return Column(
      children: [
        listTitle(savedFile.name),
        Text("$numTags tags"),
        const SizedBox(height: 5),
        Flexible(
            child: ListView.builder(
          // add 1 for the addMoreTile
          itemCount: numTags + 1,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            if (i == numTags) return addMoreTile(context, ref, savedFile);
            return tagListEntry(context, ref, savedFile, savedFile.tags[i]);
          },
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(savedFileByUUIDProvider(fileId)).when(
        data: (savedFile) =>
            Center(child: LayoutBuilder(builder: ((context, constraints) {
              final child = tagList(context, ref, savedFile);
              final width = constraints.maxWidth;
              return width < maxWidth
                  ? child
                  : SizedBox(width: maxWidth, child: child);
            }))),
        error: (ex, st) => Text("$ex\n$st"),
        loading: () => const CircularProgressIndicator());
    /*final numTags = savedFile.tags.length;
    return SizedBox(
        width: 400,
        child: Material(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //mainAxisSize: MainAxisSize.min,
                children: [
              listTitle("Manage $numTags Tags"),
              SizedBox(height: 5),
              Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numTags,
                      itemBuilder: ((context, index) {
                        return Align(
                            alignment: Alignment.centerLeft,
                            child: Material(child: Text("test")));
                      })))
            ])));*/
  }
}
