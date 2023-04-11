import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../widgets/drawer.dart';

class SimpleScaffold extends StatelessWidget {

  final String title;
  final Widget body;
  final bool backButton;

  const SimpleScaffold({super.key, required this.body, required this.title, this.backButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // custom name set on the backend? make this stateful?
          // if date is april 1, TaGit?
          title: Text(title),
          leading: backButton ? const BackButton() : null,
        ),
        drawer: const SideDrawer(),
        body: body
    );
  }
}

class InfiniteScrollView<T> extends StatefulWidget {

  final Widget Function(T) widgetFunction;
  final Future<void> Function(int, PagingController<int, T>) loadingFunction;

  const InfiniteScrollView(this.widgetFunction, this.loadingFunction, {super.key});

  @override
  State createState() => _InfiniteScrollViewState<T>();

}

class _InfiniteScrollViewState<T> extends State<InfiniteScrollView<T>> {

  final PagingController<int, T> _pagingController = PagingController<int, T>(firstPageKey: 0);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>(pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: (ctx, item, index) => widget.widgetFunction(item)
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => widget.loadingFunction(pageKey, _pagingController));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

}
