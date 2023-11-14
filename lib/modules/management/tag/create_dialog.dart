import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/object/tag.dart';

import 'create_dialog_model.dart';

class CreateDialog extends ConsumerStatefulWidget {
  final TagState parentTag;

  const CreateDialog(this.parentTag, {super.key});

  @override
  ConsumerState<CreateDialog> createState() => _CreateDialogState();
}

class _CreateDialogState extends ConsumerState<CreateDialog> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Tag"),
      content: TextField(controller: controller),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () =>
                createTag(context, ref, widget.parentTag, controller.text),
            child: const Text("Confirm"))
      ],
    );
  }
}
