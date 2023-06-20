import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/objects/saved_file.dart';
import 'package:tagit_frontend/widgets/content_viewer.dart';

import '../../objects/common.dart';
import '../../objects/tag.dart';
import '../../requests.dart';
import '../error_display.dart';

part 'tag_browser.g.dart';

class TagBrowserNavigator extends StatefulWidget {
  final Refreshable scaffoldNameNotifier;
  final Tag? parent;

  const TagBrowserNavigator(
      {super.key, required this.scaffoldNameNotifier, this.parent});

  @override
  State createState() => _TagBrowserNavigatorState();
}

class _TagBrowserNavigatorState extends State<TagBrowserNavigator> {
  final RouteObserver _browseObserver = RouteObserver<MaterialPageRoute>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [_browseObserver],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => TagBrowser(
                  parent: widget.parent,
                  observer: _browseObserver,
                  scaffoldNameNotifier: widget.scaffoldNameNotifier,
                ));
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
      list.then((l) => l.insert(0, UpTile()));
    }
    return list;
  }

  @override
  FutureOr<List<Tileable>> build({String? parent}) async {
    return addBackButton(retrieveChildren(parent), parent);
  }
}

class TagBrowser extends ConsumerStatefulWidget {
  final Tag? parent;
  final RouteObserver observer;
  final Refreshable scaffoldNameNotifier;

  const TagBrowser(
      {super.key,
      this.parent,
      required this.observer,
      required this.scaffoldNameNotifier});

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
            itemBuilder: (context, i) {
              void Function() onTap;
              final Tileable item = tagsAndFiles[i];
              if (item is Tag) {
                onTap = () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TagBrowser(
                              parent: item,
                              observer: widget.observer,
                              scaffoldNameNotifier: widget.scaffoldNameNotifier,
                            )));
              } else if (item is SavedFile) {
                onTap = () => openContentView(context,
                    item); // without an onTap, hoverColor does not work
              } else {
                // back tile
                onTap = () async {
                  String? grandparentName = widget.parent?.parent;
                  Tag? grandparent = grandparentName == null
                      ? null
                      : await getTag(grandparentName);
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TagBrowser(
                              parent: grandparent,
                              observer: widget.observer,
                              scaffoldNameNotifier:
                                  widget.scaffoldNameNotifier)));
                };
              }
              return tagsAndFiles[i]
                  .createTile(context: context, ref: ref, onTap: onTap);
            });
      },
      error: (err, stack) => ErrorDisplay(text: err.toString()),
      loading: () => const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void refresh() {
    Future(() {
      String? fullName = widget.parent?.fullName();
      ref.invalidate(tagBrowserListProvider(parent: fullName));
      ref.read(widget.scaffoldNameNotifier).set(fullName ?? "Tags");
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
    widget.observer.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    widget.observer.unsubscribe(this);
  }
}

class UpTile extends Tileable {
  @override
  Widget createTile(
      {required BuildContext context,
      required WidgetRef ref,
      required void Function() onTap}) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        leading: const Icon(Icons.arrow_upward),
        title: const Text(
          "Up",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
