import 'package:flutter/material.dart';

import '../main.dart';
import '../objects/tag.dart';
import '../objects/tileable.dart';
import '../requests.dart';

class TagBrowserNavigator extends StatelessWidget {
  const TagBrowserNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(settings: settings, builder: (context) => const TagBrowser());
      },
    );
  }

}

class TagBrowser extends StatefulWidget {

  final Tag? parent;
  final bool showBackButton;

  const TagBrowser({super.key, this.parent, this.showBackButton = false});

  @override
  State createState() => _TagBrowserState();

}

class _TagBrowserState extends State<TagBrowser> with RouteAware {

  List<Tileable>? tagsAndFiles;

  @override
  Widget build(BuildContext context) {
    return tagsAndFiles?.isEmpty ?? true ?
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
    /*return SimpleScaffold(
        title: widget.parent?.fullName() ?? "Browse Tags",
        body: body,
        backButton: widget.parent != null,
    );*/
  }

  Future<void> _loadContents() async {
    try {
      final newItems = await retrieveChildren(widget.parent?.fullName());
      if (widget.parent != null) newItems.insert(0, BackTile());
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

class BackTile extends Tileable {

  @override
  Widget createTile({required BuildContext context, void Function()? refreshCallback}) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          leading: const Icon(Icons.arrow_back),
          title: const Text("Back",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
    );
  }

}
