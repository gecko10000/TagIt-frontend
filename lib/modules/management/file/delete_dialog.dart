import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import 'delete_dialog_model.dart';

class DeleteDialog extends ConsumerWidget {
  final SavedFileState savedFile;

  const DeleteDialog(this.savedFile, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("Delete ${savedFile.name}?"),
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
