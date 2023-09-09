import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/modules/search/search_model.dart';

import '../browse/grid.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onChanged: (s) => ref.read(searchInputProvider.notifier).state = s,
          ),
          Expanded(
            child:
                DisplayableGrid(displayables: ref.watch(searchResultsProvider)),
          )
        ]);
  }
}
