import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/tag.dart';
import 'package:tagit_frontend/modules/management/tag/delete_dialog_model.dart';

class DeleteTagDialog extends ConsumerWidget {
  final TagState tag;

  const DeleteTagDialog(this.tag, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("Delete tag ${tag.fullName()}?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
          onPressed: () => deleteTag(context, ref, tag),
          child: const Text("Confirm"),
        )
      ],
    );
  }
}
