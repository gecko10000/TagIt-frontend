import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/view/widget/displayable.dart';
import 'package:tagit_frontend/view_model/browse.dart';

class BrowseScreen extends ConsumerWidget {
  final String? tag;

  const BrowseScreen({this.tag, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topCenter,
      child: ref.watch(browseListProvider(tag)).when(
        data: (list) => DisplayableGrid(list),
        error: (error, st) => Text("${error.runtimeType}: $error\n$st"),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
