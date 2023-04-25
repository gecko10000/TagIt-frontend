import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../objects/common.dart';

part 'search.g.dart';

@riverpod
class SearchResults extends _$SearchResults {
  // TODO: cancel current search if there is one

  @override
  FutureOr<List<Tileable>> build() => [];
}

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: TextFormField(
          autofocus: true,
        ),
      ),
    );
  }

}
