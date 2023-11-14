import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import 'delete_dialog_model.dart';

class DeleteFileDialog extends ConsumerWidget {
  final SavedFileState savedFile;

  const DeleteFileDialog(this.savedFile, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("Delete file ${savedFile.name}?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => deleteSavedFile(context, ref, savedFile),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            )),
      ],
    );
  }
}
