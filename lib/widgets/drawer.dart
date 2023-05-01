import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/screens/search.dart';
import 'package:tagit_frontend/widgets/browsers/file_browser.dart';
import 'package:tagit_frontend/widgets/browsers/tag_browser.dart';

import '../screens/not_implemented.dart';

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
                  ref: ref,
                )),
        DrawerTile(
            Icons.file_copy,
            "Files",
            (context) {
              return BackScaffold(
                body: const FileBrowser(),
                title: "Files",
                ref: ref,
              );
            }),
        DrawerTile(Icons.search, "Search", (context) => const SearchScreen()),
        DrawerTile(Icons.upload, "Upload", (context) {
          uploadFiles(context);
          return null;
        }),
        DrawerTile(
            Icons.settings,
            "Settings",
            (context) => BackScaffold(
                  body: const NotImplementedScreen(),
                  title: "Settings",
                  ref: ref,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          // cannot modify the provider while the widget is building
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ref.read(backScaffoldNameProvider.notifier).set(title));
          return result;
        }));
      },
    ));
  }
}
