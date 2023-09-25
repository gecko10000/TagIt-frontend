import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tagit_frontend/model/api/base.dart';
import 'package:tagit_frontend/modules/auth/auth_page.dart';
import 'package:tagit_frontend/modules/auth/endpoint.dart';

import 'home_model.dart';
import 'nav_bar/nav_bar.dart';

late BuildContext homeContext;

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    homeContext = context;
    return SafeArea(
        child: ValueListenableBuilder(
            valueListenable: accountBox.listenable(),
            builder: (context, value, child) {
              final needsEndpoint = value.get("host") == null;
              if (needsEndpoint) {
                return const EndpointScreen();
              }
              final needsAuth = value.get("token") == null;
              return needsAuth
                  ? const AuthScreen()
                  : Scaffold(
                      body: ref.watch(pageProvider),
                      bottomNavigationBar: const HomeNavBar(),
                    );
            }));
  }
}
