import 'package:flutter/material.dart';

import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/screens/category/search_item.dart';
import 'package:rssreader/services/networking.dart';

class SearchPage extends SearchDelegate {
  final _nh = NetworkHelper();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      AnimatedOpacity(
        opacity: query.isEmpty ? 0.0 : 1.0,
        duration: Duration(milliseconds: 200),
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final String fmtQuery = query.toLowerCase().trim();

    return fmtQuery.isNotEmpty
        ? FutureBuilder(
            future: _nh.feedSearch(fmtQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final List<SearchResult> data = snapshot.data;

                return data.length > 0
                    ? ListView.builder(
                        itemBuilder: (context, index) => SearchItem(
                          searchResult: data[index],
                          category: "Uncategorized",
                        ),
                        itemCount: data.length,
                      )
                    : const Center(
                        child: const Text("No results found"),
                      );
              } else {
                return const LinearProgressIndicator();
              }
            },
          )
        : const Center(
            child: const Text("Enter a feed name or a URL"),
          );
  }
}
