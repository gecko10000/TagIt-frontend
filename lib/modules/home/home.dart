import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:share_handler/share_handler.dart';
import 'package:tagit_frontend/model/api/base.dart';
import 'package:tagit_frontend/modules/auth/auth_page.dart';
import 'package:tagit_frontend/modules/auth/endpoint.dart';
import 'package:tagit_frontend/modules/upload/upload_model.dart';

import 'home_model.dart';
import 'nav_bar/nav_bar.dart';

late BuildContext homeContext;

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
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
              // don't use a ternary because HomeNavBar
              // stays loaded otherwise (needs to be
              // autoDispose to reset on open)
              if (needsAuth) return const AuthScreen();
              return Scaffold(
                body: ref.watch(pageProvider),
                bottomNavigationBar: const HomeNavBar(),
              );
            }));
  }

  Future<void> handleIncomingShare() async {
    final handler = ShareHandlerPlatform.instance;
    final media = await handler.getInitialSharedMedia();
    if (media == null) return;
    final attachments = media.attachments;
    if (attachments == null) return;
    final filePaths = attachments.nonNulls.map((att) => att.path).toList();
    if (filePaths.isEmpty) return;
    final platformFiles = filePaths.map((path) => toPlatformFile(path));
    final uploads = await uploadFiles(platformFiles);
    ref.read(homeIndexProvider.notifier).state = uploadPageIndex;
    ref.read(uploadsProvider.notifier).addAll(uploads);
  }

  @override
  void initState() {
    super.initState();
    handleIncomingShare();
  }

  PlatformFile toPlatformFile(String path) {
    File file = File(path);
    String name = path.substring(path.lastIndexOf('/') + 1);
    int size = file.lengthSync();
    PlatformFile platformFile =
        PlatformFile(name: name, size: size, readStream: file.openRead());
    return platformFile;
  }
}
