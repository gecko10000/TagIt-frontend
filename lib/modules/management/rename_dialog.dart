import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/displayable.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/management/rename_dialog_model.dart';

import '../../model/object/tag.dart';

class RenameDialog extends ConsumerStatefulWidget {
  final Displayable toRename;

  const RenameDialog(this.toRename, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RenameDialogState();
}

class _RenameDialogState extends ConsumerState<RenameDialog> {
  late bool isTag = widget.toRename is TagState;
  late String initialName = isTag
      ? (widget.toRename as TagState).name
      : (widget.toRename as SavedFileState).name;

  late TextEditingController controller =
      TextEditingController(text: initialName);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text("Enter a new name for ${isTag ? "tag" : "file"} $initialName:"),
      content: TextField(controller: controller),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => renameDisplayable(
                context, ref, widget.toRename, controller.text),
            child: const Text("Confirm"))
      ],
    );
  }
}
