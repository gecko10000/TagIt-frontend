import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/tags.dart';

import '../objects/tag.dart';

class TagTile extends StatelessWidget {

  final Tag tag;

  const TagTile(this.tag, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(tag.name),
          //splashColor: Colors.green,
          //hoverColor: CustomColor.paynesGray,
          //tileColor: CustomColor.paynesGray.withOpacity(0.9),
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => TagScreen(parent: tag.fullName())
          )
          ),
        )

    );
  }
}
