import 'package:flutter/material.dart';
import 'package:tagit_frontend/widgets/file_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // custom name set on the backend? make this stateful?
          // if date is april 1, TaGit?
          title: const Text("TagIt"),
        ),
        drawer: const SideDrawer(),
        body: const FileListView()
    );
  }
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

        child: ListView(
          children: [
            DrawerTile(Icons.file_copy, "Files", (context) => const HomeScreen()),
            DrawerTile(Icons.tag, "Tags", (context) => const HomeScreen()),
            DrawerTile(Icons.search, "Search", (context) => const HomeScreen())
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
