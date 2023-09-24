import 'package:flutter/material.dart';

class SearchHelpPage extends StatelessWidget {
  const SearchHelpPage({super.key});

  Widget bulletpoint(String text) => Text("\u2022 $text");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Format")),
      body: Container(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            bulletpoint("Search terms indicate tags by default."),
            bulletpoint("Add \"file:\" before a term to indicate filename."),
            bulletpoint(
                "Combine search terms with \"and\" (&/&& work too) or \"or\" (|/|| work too)."),
            bulletpoint("Negate terms with \"not:\" or an exclamation mark."),
          ])),
    );
  }
}
