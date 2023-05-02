import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/misc/colors.dart';
import 'package:tagit_frontend/screens/search.dart';
import 'package:tagit_frontend/screens/upload.dart';
import 'package:tagit_frontend/widgets/drawer.dart';

import '../widgets/browsers/file_browser.dart';
import '../widgets/browsers/tag_browser.dart';
import 'common.dart';

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
            indicatorColor: Colors.white70,
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
              Tab(icon: Icon(Icons.tag, color: CustomColor.tag)),
              Tab(icon: Icon(Icons.file_copy, color: CustomColor.file)),
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
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.upload),
                label: "Upload",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UploadScreen()))),
            SpeedDialChild(
              child: const Icon(Icons.tag),
              label: "Create Tag",
              onTap: () async {
                await createTag(context,
                    leading: ref.read(currentTagProvider)?.fullName());
                String? parent = ref.read(currentTagProvider)?.fullName();
                ref
                    .read(tagBrowserListProvider(parent: parent).notifier)
                    .refresh(parent: parent);
              },
            ),
          ],
        ),
      ),
    );
  }
}
