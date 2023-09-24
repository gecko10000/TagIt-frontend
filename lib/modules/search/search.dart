import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/search.dart';
import 'package:tagit_frontend/modules/search/search_model.dart';

import '../browse/grid.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsValue = ref.watch(searchResultsProvider);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.search),
            Flexible(
                child: TextFormField(
              onChanged: (s) =>
                  ref.read(searchInputProvider.notifier).state = s,
            )),
            IconButton(
                onPressed: () => openSearchHelpPage(context),
                icon: const Icon(Icons.help))
          ]),
          Expanded(
              child: Center(
                  child: resultsValue.when(
                      data: (results) => DisplayableGrid(displayables: results),
                      error: (ex, st) {
                        if (ex is SearchFormatException) {
                          final index = ex.index;
                          final text = ref.watch(searchInputProvider);
                          const errorDisplayRange = 3;
                          final beforeError = text.substring(
                              max(0, index - errorDisplayRange), index);
                          final afterError = text.substring(index + 1,
                              min(index + errorDisplayRange + 1, text.length));
                          return Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      "Invalid input at index $index: \"$beforeError"),
                              TextSpan(
                                  text: text[index],
                                  style: const TextStyle(
                                      decorationColor: Colors.red,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.wavy)),
                              TextSpan(text: "$afterError\""),
                            ]),
                            style: const TextStyle(fontSize: 20),
                          );
                        }
                        return Text("$ex\n$st");
                      },
                      loading: () => const CircularProgressIndicator())))
        ]);
  }
}
