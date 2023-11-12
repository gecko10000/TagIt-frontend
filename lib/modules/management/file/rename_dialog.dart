import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/management/file/rename_dialog_model.dart';

import '../../../model/object/saved_file.dart';

class FileRenameDialog extends ConsumerStatefulWidget {
  final SavedFileState toRename;

  const FileRenameDialog(this.toRename, {super.key});

  @override
  ConsumerState<FileRenameDialog> createState() => _FileRenameDialogState();
}

class _FileRenameDialogState extends ConsumerState<FileRenameDialog> {
  late String initialName = widget.toRename.name;

  late TextEditingController controller =
      TextEditingController(text: initialName);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename File"),
      content: TextField(controller: controller),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () =>
                renameFile(context, ref, widget.toRename, controller.text),
            child: const Text("Confirm"))
      ],
    );
  }
}
