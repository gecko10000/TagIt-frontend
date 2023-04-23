import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/misc/strings.dart';

abstract class Tileable {
  Widget createTile({required BuildContext context, required WidgetRef ref, required void Function() onTap});
}

void renameObject<T extends Tileable>(
    BuildContext context,
    String objectType,
    String objectName,
    Future<void> Function(String, WidgetRef) renameCallback,
    TextEditingController controller,
    WidgetRef ref) {
  Future<String?> newName = showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Renaming ${objectType.toTitleCase()} \"$objectName\""),
            content: Stack(
              children: [
                TextField(
                  onSubmitted: ((name) => Navigator.pop(context, name)),
                  controller: controller,
                  autofocus: true,
                  autocorrect: false,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.value.text),
                child: const Text("Rename"),
              ),
            ],
          ));
  newName.then((value) async {
    if (value == null) return;
    await renameCallback(value, ref);
  });
}

void deleteObject<T extends Tileable>(
    BuildContext context,
    String objectType,
    String objectName,
    Future<void> Function(WidgetRef) deleteCallback,
    WidgetRef ref) {
  Future<bool?> deleted = showDialog<bool>(
    context: context,
    // listener so that pressing enter confirms deletion
    builder: (context) => RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          Navigator.pop(context, true);
        }
      },
      child: AlertDialog(
        title: Text("Delete ${objectType.toTitleCase()}"),
        content: Text(
            "Are you sure you want to delete ${objectType.toLowerCase()} \"$objectName\"?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ),
  );
  deleted.then((value) async {
    if (!(value ?? false)) return;
    await deleteCallback(ref);
  });
}
