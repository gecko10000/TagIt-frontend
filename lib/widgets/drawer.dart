import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/widgets/browsers/file_browser.dart';
import 'package:tagit_frontend/widgets/browsers/tag_browser.dart';

import '../screens/not_implemented.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerTile(
            Icons.file_copy,
            "Tags",
            (context) => TagBrowserNavigator(
                scaffoldNameNotifier: backScaffoldTitleProvider.notifier)),
        DrawerTile(Icons.file_copy, "Files", (context) => const FileBrowser()),
        DrawerTile(
            Icons.search, "Search", (context) => const NotImplementedScreen()),
        DrawerTile(
            Icons.upload, "Upload", (context) => const NotImplementedScreen()),
        DrawerTile(Icons.settings, "Settings",
            (context) => const NotImplementedScreen()),
      ],
    ));
  }
}

class DrawerTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final Widget Function(BuildContext) callback;

  const DrawerTile(this.icon, this.title, this.callback, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
        child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          // cannot modify the provider while the widget is building
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ref.read(backScaffoldTitleProvider.notifier).set(title));
          return BackScaffold(body: callback(context), title: title);
        }));
      },
    ));
  }
}
