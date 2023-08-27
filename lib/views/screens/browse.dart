import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/view_models/browse.dart';
import 'package:tagit_frontend/views/widgets/displayable.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ref.watch(browseListProvider).when(
              data: (list) => DisplayableGrid(list),
              error: (error, st) => Text("${error.runtimeType}: $error\n$st"),
              loading: () => CircularProgressIndicator(),
            ),
      ),
    );
  }
}
