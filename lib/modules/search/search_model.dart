import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagit_frontend/model/api/search.dart';
import 'package:tagit_frontend/model/object/saved_file.dart';
import 'package:tagit_frontend/modules/search/help.dart';

final searchInputProvider = StateProvider.autoDispose((ref) => "");

final searchResultsProvider =
    FutureProvider.autoDispose<List<SavedFileState>>((ref) async {
  String query = ref.watch(searchInputProvider);
  return SearchAPI.fileSearch(query);
});

void openSearchHelpPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const SearchHelpPage()));
}
