import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/common.dart';

import '../main.dart';
import '../objects/tag.dart';
import '../objects/tileable.dart';
import '../requests.dart';

class BrowseScreen extends StatefulWidget {

  final Tag? parent;

  const BrowseScreen({super.key, this.parent});

  @override
  State createState() => _BrowseScreenState();

}

class _BrowseScreenState extends State<BrowseScreen> with RouteAware {

  List<Tileable>? tagsAndFiles;

  @override
  Widget build(BuildContext context) {
    Widget body = tagsAndFiles?.isEmpty ?? true ?
        Align(
          alignment: Alignment.center,
          child: tagsAndFiles == null ?
          const CircularProgressIndicator() :
          const Text("Nothing here.",
              style: TextStyle(fontSize: 32),
          )
        ) :
        ListView.builder(
          itemCount: tagsAndFiles?.length,
          itemBuilder: (context, i) => tagsAndFiles?[i].createTile(context: context, refreshCallback: refresh),
        );
    return SimpleScaffold(
        title: widget.parent?.fullName() ?? "Browse Tags",
        body: body,
        backButton: widget.parent != null,
    );
  }

  Future<void> _loadContents() async {
    try {
      final newItems = await retrieveChildren(widget.parent?.fullName());
      setState(() => tagsAndFiles = newItems);
    } catch (error, t) {
      print("ERROR: $error");
      print(t);
      // TODO: exponential backoff reloading?
    }
  }

  void refresh() {
    _loadContents();
  }

  @override
  void didPush() => setState(() {
    refresh();
  });

  @override
  void didPopNext() => setState(() {
    refresh();
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TagIt.browseObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    TagIt.browseObserver.unsubscribe(this);
  }
}
