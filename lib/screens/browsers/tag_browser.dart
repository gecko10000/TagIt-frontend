import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/screens/home_page.dart';

import '../../main.dart';
import '../../objects/tag.dart';
import '../../objects/tileable.dart';
import '../../requests.dart';

part 'tag_browser.g.dart';

class TagBrowserNavigator extends StatelessWidget {
  const TagBrowserNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [TagIt.browseObserver],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            settings: settings, builder: (context) => const TagBrowser());
      },
    );
  }
}

@Riverpod(keepAlive: true)
class CurrentTag extends _$CurrentTag {
  @override
  Tag? build() => null;
  void set(Tag? tag) {
    state = tag;
  }
}

@riverpod
class TagBrowserList extends _$TagBrowserList {
  Future<List<Tileable>> addBackButton(
      Future<List<Tileable>> list, String? parent) {
    if (parent != null) {
      list.then((l) => l.insert(0, BackTile()));
    }
    return list;
  }

  @override
  FutureOr<List<Tileable>> build({String? parent}) async {
    // don't need to return anything here
    // because refresh is called immediately
    // from didPush
    return [];
  }

  void refresh({String? parent}) async {
    state =
        AsyncValue.data(await addBackButton(retrieveChildren(parent), parent));
  }
}

class TagBrowser extends ConsumerStatefulWidget {
  final Tag? parent;

  const TagBrowser({super.key, this.parent});

  @override
  ConsumerState createState() => _TagBrowserState();
}

class _TagBrowserState extends ConsumerState<TagBrowser>
    with RouteAware, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tagsAndFiles =
        ref.watch(tagBrowserListProvider(parent: widget.parent?.fullName()));
    return tagsAndFiles.when(
      data: (tagsAndFiles) {
        if (tagsAndFiles.isEmpty) {
          return const Align(
              alignment: Alignment.center,
              child: Text(
                "Nothing here.",
                style: TextStyle(fontSize: 32),
              ));
        }
        return ListView.builder(
          itemCount: tagsAndFiles.length,
          itemBuilder: (context, i) =>
              tagsAndFiles[i].createTile(context: context, ref: ref),
        );
      },
      error: (err, stack) => Text("Error: $err"),
      loading: () => const Align(
          alignment: Alignment.center, child: CircularProgressIndicator()),
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
      String? fullName = widget.parent?.fullName();
      ref
          .read(tagBrowserListProvider(parent: fullName).notifier)
          .refresh(parent: fullName);
      ref.read(homeAppBarTitleProvider.notifier).set(fullName ?? "Tags");
      ref.read(currentTagProvider.notifier).set(widget.parent);
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
        title: const Text(
          "Back",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
