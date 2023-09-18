import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';

import 'delete_dialog_model.dart';

class DeleteDialog extends ConsumerWidget {
  final SavedFileState savedFile;

  // Used to invalidate the file after closing
  final WidgetRef parentRef;

  const DeleteDialog(this.savedFile, this.parentRef, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("Delete ${savedFile.name}?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        TextButton(
            onPressed: () => deleteSavedFile(context, parentRef, savedFile),
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            )),
      ],
    );
  }
}
