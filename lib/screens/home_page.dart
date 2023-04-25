import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/screens/search.dart';
import 'package:tagit_frontend/widgets/drawer.dart';

import '../widgets/browsers/file_browser.dart';
import '../widgets/browsers/tag_browser.dart';

part 'home_page.g.dart';

@riverpod
class TabBarIndex extends _$TabBarIndex {
  @override
  int build() => 0;
  void set(int i) => state = i;
}

@riverpod
class TabBarName extends _$TabBarName {
  List<String> tabNames = ["Tags", "Files"];
  late int tab;

  @override
  String build() {
    tab = ref.watch(tabBarIndexProvider);
    return tabNames[tab];
  }

  void set(String s) {
    state = tabNames[tab] = s;
  }
}

class _AppBarText extends ConsumerWidget {
  const _AppBarText();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      Text(ref.watch(tabBarNameProvider));
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const SideDrawer(),
        appBar: AppBar(
          title: const _AppBarText(),
          bottom: TabBar(
            onTap: (i) {
              ref.read(tabBarIndexProvider.notifier).set(i);
              if (i == 0) {
                final current = ref.read(currentTagProvider)?.fullName();
                ref
                    .read(tagBrowserListProvider(parent: current).notifier)
                    .refresh(parent: current);
              } else if (i == 1) {
                ref.read(fileBrowserListProvider.notifier).refresh();
              }
            },
            tabs: const [
              Tab(icon: Icon(Icons.tag)),
              Tab(icon: Icon(Icons.file_copy)),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen())),
                icon: const Icon(Icons.search)),
          ],
        ),
        body: TabBarView(children: [
          TagBrowserNavigator(
              scaffoldNameNotifier: tabBarNameProvider.notifier),
          const FileBrowser(),
        ]),
      ),
    );
  }
}
