import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/screens/browsers/tag_browser.dart';
import 'package:tagit_frontend/widgets/drawer.dart';

import 'browsers/file_browser.dart';

part 'home_page.g.dart';

@riverpod
class TabBarIndex extends _$TabBarIndex {
  @override
  int build() => 0;
  void set(int i) => state = i;
}

@riverpod
class HomeAppBarTitle extends _$HomeAppBarTitle {
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

class AppBarText extends ConsumerWidget {
  const AppBarText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Text(ref.watch(homeAppBarTitleProvider));
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
          title: const AppBarText(),
          bottom: TabBar(
            onTap: (i) {
              ref.read(tabBarIndexProvider.notifier).set(i);
              if (i == 0) {
                final current = ref.read(currentTagProvider)?.fullName();
                ref.read(tagBrowserListProvider(parent: current).notifier).refresh(parent: current);
              } else if (i == 1) {
                ref.read(fileBrowserListProvider.notifier).refresh();
              }
            },
            tabs: const [
              Tab(icon: Icon(Icons.tag)),
              Tab(icon: Icon(Icons.file_copy)),
            ],
          ),
        ),
        body: const TabBarView(children: [
          TagBrowserNavigator(),
          FileBrowser(),
        ]),
      ),
    );
  }
}
