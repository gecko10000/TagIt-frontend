import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/browser.dart';

import '../objects/tag.dart';

class TagTile extends StatelessWidget {

  final Tag tag;
  final void Function(BuildContext)? onTap;

  void defaultOnTap(BuildContext context) {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => BrowseScreen(parent: tag)
      )
    );
  }

  const TagTile(this.tag, {super.key, this.onTap});

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
          onTap: () => onTap == null ? defaultOnTap(context) : onTap!(context),
        )

    );
  }
}
