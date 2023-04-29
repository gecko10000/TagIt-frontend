import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/misc/stack.dart' as my;

part 'common.g.dart';

@riverpod
class BackScaffoldName extends _$BackScaffoldName {
  final my.Stack<String> _stack = my.Stack(initial: "none");

  @override
  String build() => _stack.peek();
  void set(String s) {
    _stack.replace(s);
    state = _stack.peek();
  }
  void push(String s) {
    _stack.push(s);
    state = _stack.peek();
  }
  void pop() {
    _stack.pop();
    state = _stack.peek();
  }
}

class _BackScaffoldTitle extends ConsumerWidget {
  const _BackScaffoldTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Text(ref.watch(backScaffoldNameProvider));
}

class BackScaffold extends ConsumerWidget {

  final String title;
  final Widget body;

  BackScaffold({super.key, required this.body, required this.title, required WidgetRef ref}) {
    Future(() {
      ref.read(backScaffoldNameProvider.notifier).push(title);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const _BackScaffoldTitle(),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(backScaffoldNameProvider.notifier).pop();
            },
          ),
        ),
        body: body
    );
  }
}
