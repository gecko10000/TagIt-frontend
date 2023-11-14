import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/management/tag/rename_dialog_model.dart';

import '../../../model/object/tag.dart';

class TagRenameDialog extends ConsumerStatefulWidget {
  final TagState toRename;
  final bool stackPush;

  const TagRenameDialog(this.toRename, {required this.stackPush, super.key});

  @override
  ConsumerState<TagRenameDialog> createState() => _TagRenameDialogState();
}

class _TagRenameDialogState extends ConsumerState<TagRenameDialog> {
  late String initialName = widget.toRename.name;

  late TextEditingController controller =
      TextEditingController(text: initialName);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename Tag"),
      content: TextField(controller: controller),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => renameTag(
                context, ref, widget.toRename, controller.text,
                stackPush: widget.stackPush),
            child: const Text("Confirm"))
      ],
    );
  }
}
