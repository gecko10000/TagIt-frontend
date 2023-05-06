import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/screens/search.dart';
import 'package:tagit_frontend/widgets/browsers/file_browser.dart';
import 'package:tagit_frontend/widgets/browsers/tag_browser.dart';

import '../screens/not_implemented.dart';
import '../screens/upload.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
        child: ListView(
      children: [
        DrawerTile(
            Icons.tag,
            "Tags",
            (context) => BackScaffold(
                  body: TagBrowserNavigator(
                      scaffoldNameNotifier: backScaffoldNameProvider.notifier),
                  title: "Tags",
                )),
        DrawerTile(Icons.file_copy, "Files", (context) {
          return const BackScaffold(
            body: FileBrowser(),
            title: "Files",
          );
        }),
        DrawerTile(Icons.search, "Search", (context) => const SearchScreen()),
        DrawerTile(Icons.upload, "Upload", (context) => const UploadScreen()),
        DrawerTile(
            Icons.settings,
            "Settings",
            (context) => const BackScaffold(
                  body: NotImplementedScreen(),
                  title: "Settings",
                )),
      ],
    ));
  }
}

class DrawerTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final Widget? Function(BuildContext) callback;

  const DrawerTile(this.icon, this.title, this.callback, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
        child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Widget? result = callback(context);
        if (result == null) return;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => result));
      },
    ));
  }
}
