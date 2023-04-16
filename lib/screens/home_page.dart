import 'package:flutter/material.dart';
import 'package:tagit_frontend/screens/not_implemented.dart';
import 'package:tagit_frontend/screens/tag_browser.dart';
import 'package:tagit_frontend/widgets/drawer.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const SideDrawer(),
          appBar: AppBar(
            title: const Text("Tags"),
            bottom: const TabBar(
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
