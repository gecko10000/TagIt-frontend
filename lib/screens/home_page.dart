import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/screens/tag_browser.dart';
import 'package:tagit_frontend/widgets/drawer.dart';

import 'file_browser.dart';

part 'home_page.g.dart';

@riverpod
class TabBarIndex extends _$TabBarIndex {
  @override
  int build() => 0;
  void set(int i) => state = i;
}

@riverpod
class AppBarTitle extends _$AppBarTitle {
  List<String> tabNames = ["Tags", "Files"];

  @override
  String build() => tabNames[ref.watch(tabBarIndexProvider)];

  void set(String s) {
    state = tabNames[ref.watch(tabBarIndexProvider)] = s;
  }
}

class AppBarText extends ConsumerWidget {
  const AppBarText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      Text(ref.watch(appBarTitleProvider));
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
                print("Current is $current");
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
