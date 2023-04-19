import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/screens/not_implemented.dart';
import 'package:tagit_frontend/screens/tag_browser.dart';
import 'package:tagit_frontend/widgets/drawer.dart';

part 'home_page.g.dart';

final tabNames = ["Tags", "Files"];

@riverpod
class AppBarTitle extends _$AppBarTitle {

  @override
  String build() => tabNames[0];

  void set(String s) => state = s;
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
            title: Text(ref.watch(appBarTitleProvider)),
            bottom: TabBar(
              onTap: (i) {
                ref.read(appBarTitleProvider.notifier).set(tabNames[i]);
              },
              tabs: [
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
