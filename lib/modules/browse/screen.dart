import 'package:flutter/material.dart';
import 'package:tagit_frontend/model/object/tag.dart';
import 'package:tagit_frontend/modules/browse/browser.dart';
import 'package:tagit_frontend/modules/browse/browser_model.dart';

class BrowseScreen extends StatelessWidget {
  final String tagName;

  // This variable defines whether or not navigating to a child
  // tag will push the new screen onto the navigation stack.
  // Used in the context of opening the browser from a tag.
  final bool stackPush;

  const BrowseScreen({required this.tagName, this.stackPush = true, super.key});

  @override
  Widget build(BuildContext context) {
    final body = TagBrowser(tagName: tagName, stackPush: stackPush);
    AppBar? appBar;
    if (tagName == "" && stackPush) {
      appBar = null;
    } else {
      final leading = tagName == ""
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () => stackPush
                  ? Navigator.pop(context)
                  : popAndOpenTagBrowser(
                      context, TagState.getParentName(tagName)),
            );
      final title = tagName == "" ? null : Text(tagName);
      final actions = stackPush
          ? <Widget>[]
          : [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close))
            ];
      appBar = AppBar(
        automaticallyImplyLeading: false,
        leading: leading,
        title: title,
        actions: actions,
      );
    }
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
