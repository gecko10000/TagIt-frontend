import 'package:flutter/material.dart';
import 'package:tagit_frontend/objects/saved_file.dart';

class FileTile extends StatelessWidget {

  final SavedFile file;

  const FileTile(this.file, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Text(file.name),
        //splashColor: Colors.green,
        //hoverColor: CustomColor.paynesGray,
        //tileColor: CustomColor.paynesGray.withOpacity(0.9),
        onTap: () => {}, // without an onTap, hoverColor does not work
      )

    );
  }
}
