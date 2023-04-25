import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common.g.dart';

@riverpod
class BackScaffoldName extends _$BackScaffoldName {
  @override
  String build() => "Tags";
  void set(String s) => state = s;
}

class _BackScaffoldTitle extends ConsumerWidget {
  const _BackScaffoldTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Text(ref.watch(backScaffoldNameProvider));
}

class BackScaffold extends StatelessWidget {

  final String title;
  final Widget body;

  const BackScaffold({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const _BackScaffoldTitle(),
          leading: const BackButton(),
        ),
        body: body
    );
  }
}
