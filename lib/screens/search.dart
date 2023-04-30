import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagit_frontend/requests.dart';

import '../objects/common.dart';
import '../objects/saved_file.dart';

part 'search.g.dart';

@riverpod
class SearchResults extends _$SearchResults {
  // TODO: cancel current search if there is one

  @override
  FutureOr<List<Tileable>> build() => [];

  String currentQuery = "";

  void search(String query) async {
    currentQuery = query;
    state = const AsyncValue.loading();
    try {
      List<SavedFile> files = await sendFileSearch(query);
      if (currentQuery == query) {
        state = AsyncValue.data(files);
      }
    } on SearchFormatException catch (ex, st) {
      if (currentQuery == query) {
        state = currentQuery == "" ? const AsyncValue.data([]) : AsyncValue.error(ex, st);
      }
    } on SocketException catch (ex, st) {
      state = AsyncValue.error(ex, st);
    }
  }
}

class SearchFormatException implements Exception {
  final int index;
  SearchFormatException(this.index);
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState createState() => _SearchScreenState();
}
class _SearchScreenState extends ConsumerState<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: TextFormField(
          autofocus: true,
          onChanged: (s) => ref.read(searchResultsProvider.notifier).search(s),
        ),
      ),
      body: ref.watch(searchResultsProvider).when(
          data: (results) => results.isEmpty ? const Text("No results.") : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, i) => results[i].createTile(context: context, ref: ref, onTap: (){}),
          ),
          error: (err, st) => err is SearchFormatException ? Text("Typo at index ${err.index}") : Text(err.toString()),
          loading: () => const CircularProgressIndicator(),
      ),
    );
  }

}
