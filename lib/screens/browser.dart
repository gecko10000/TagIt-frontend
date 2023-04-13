import 'package:flutter/cupertino.dart';
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

  List<Tileable> tagsAndFiles = [];

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
        title: widget.parent?.fullName() ?? "Browse Tags",
        body: tagsAndFiles.isEmpty
            ? const Align(
                child: Text("Nothing here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32
                  ),
                )
              )
            : ListView.builder(
                itemCount: tagsAndFiles.length,
                itemBuilder: (context, i) => tagsAndFiles[i].createTile(context: context, refreshCallback: refresh),
              ),
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
