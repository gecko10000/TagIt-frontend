import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/tags.dart';

import '../screens/files.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

        child: ListView(
          children: [
            DrawerTile(Icons.file_copy, "Files", (context) => const FileScreen()),
            DrawerTile(Icons.tag, "Tags", (context) => const TagScreen()),
            DrawerTile(Icons.search, "Search", (context) => const FileScreen())
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
            Navigator.push(context, MaterialPageRoute(builder: callback));
          },
        )
    );
  }
}
