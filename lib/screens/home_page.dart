import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/screens/not_implemented.dart';
import 'package:tagit_frontend/screens/tag_browser.dart';
import 'package:tagit_frontend/widgets/drawer.dart';

part 'home_page.g.dart';


@riverpod
class AppBarTitle extends _$AppBarTitle {
  List<String> tabNames = ["Tags", "Files"];
  int index = 0;

  @override
  String build() => tabNames[index];
  void _update() {
    state = tabNames[index];
  }

  void set(String s) {
    tabNames[index] = s;
    _update();
  }

  void switchTab(int i) {
    index = i;
    _update();
  }
}

class AppBarText extends ConsumerWidget {
  const AppBarText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Text(ref.watch(appBarTitleProvider));
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
              onTap: (i) => ref.read(appBarTitleProvider.notifier).switchTab(i),
              tabs: const [
                Tab(icon: Icon(Icons.tag)),
                Tab(icon: Icon(Icons.file_copy)),
              ],
            ),
          ),
          body: const TabBarView(children: [
            TagBrowserNavigator(),
            NotImplementedScreen(),
          ]),
        ),
    );
  }

}
