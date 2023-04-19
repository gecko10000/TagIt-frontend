import 'package:flutter/material.dart';
import 'package:tagit_frontend/misc/strings.dart';

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
