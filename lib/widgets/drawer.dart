import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/common.dart';
import 'package:tagit_frontend/widgets/browsers/tag_browser.dart';

import '../screens/not_implemented.dart';

class SideDrawer extends StatelessWidget {

  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

        child: ListView(
          children: [
            DrawerTile(Icons.file_copy, "Tags", (context) => BackScaffold(
              body: TagBrowserNavigator(
                  scaffoldNameNotifier: backScaffoldTitleProvider.notifier
              ), // TODO: update name in AppBar somehow (callback?) remove SimpleScaffold entirely, maybe
              title: "Tags",
            )),
            //DrawerTile(Icons.file_copy, "Files", (context) => const FileScreen()),
            DrawerTile(Icons.search, "Search", (context) => const NotImplementedScreen()),
            DrawerTile(Icons.upload, "Upload", (context) => const NotImplementedScreen()),
            DrawerTile(Icons.settings, "Settings", (context) => const NotImplementedScreen()),
          ],
        )
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget Function(BuildContext) callback;

  const DrawerTile(this.icon, this.title, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: callback));
          },
        )
    );
  }
}
