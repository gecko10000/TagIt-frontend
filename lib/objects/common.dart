import 'package:flutter/material.dart';
import 'package:tagit_frontend/misc/strings.dart';

void renameObject<T>(BuildContext context, String objectType, String objectName, T object,
    Future<void> Function(T, String) renamingFunction, void Function()? refreshCallback, TextEditingController controller) {
  Future<String?> newName = showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Renaming ${objectType.toTitleCase()} \"$objectName\""),
        content: Stack(
          children: [
            TextField(
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
    await renamingFunction(object, value);
    if (refreshCallback != null) refreshCallback();
  });
}

void deleteObject<T>(BuildContext context, String objectType, String objectName, T object, Future<void> Function(T) deletionFunction, void Function()? refreshCallback) {
  Future<bool?> deleted = showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete ${objectType.toTitleCase()}"),
      content: Text("Are you sure you want to delete ${objectType.toLowerCase()} \"$objectName\"?"),
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
  );
  deleted.then((value) async {
    if (!(value ?? false)) return;
    await deletionFunction(object);
    if (refreshCallback != null) refreshCallback();
  });
}
