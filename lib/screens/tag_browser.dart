import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/objects/common.dart';
import 'package:tagit_frontend/screens/home_page.dart';

import '../main.dart';
import '../objects/tag.dart';
import '../objects/tileable.dart';

class TagBrowserNavigator extends StatelessWidget {
  const TagBrowserNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [TagIt.browseObserver],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(settings: settings, builder: (context) => const TagBrowser());
      },
    );
  }

}

class TagBrowser extends ConsumerStatefulWidget {

  final Tag? parent;
  final bool showBackButton;

  const TagBrowser({super.key, this.parent, this.showBackButton = false});

  @override
  ConsumerState createState() => _TagBrowserState();

}

class _TagBrowserState extends ConsumerState<TagBrowser> with RouteAware, AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tagsAndFiles = ref.watch(tileableChildrenListProvider(parent: widget.parent?.fullName()));
    return tagsAndFiles.when(
        data: (tagsAndFiles) {
          if (tagsAndFiles.isEmpty) {
            return const Align(
              alignment: Alignment.center,
                child: Text("Nothing here.",
              style: TextStyle(fontSize: 32),
            ));
          }
          return ListView.builder(
            itemCount: tagsAndFiles.length,
            itemBuilder: (context, i) => tagsAndFiles[i].createTile(context: context, ref: ref),
          );
        },
        error: (err, stack) => Text("Error: $err"),
        loading: () => const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator()
        ),
      );
    /*return tagsAndFiles.isEmpty ?? true ?
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
    );*/
  }

  @override
  bool get wantKeepAlive => true;

  /*Future<void> _loadContents() async {
    try {
      final newItems = await retrieveChildren(widget.parent?.fullName());
      if (widget.parent != null) newItems.insert(0, BackTile());
      setState(() => tagsAndFiles = newItems);
    } catch (error, t) {
      print("ERROR: $error");
      print(t);
      // TODO: exponential backoff reloading?
    }
  }*/

  void refresh() {
    Future(() {
      ref.watch(appBarTitleProvider.notifier).set(widget.parent?.fullName() ?? "Tags");
    });
  }

  @override
  void didPush() => refresh();

  @override
  void didPopNext() => refresh();

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
  Widget createTile({required BuildContext context, required WidgetRef ref}) {
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
