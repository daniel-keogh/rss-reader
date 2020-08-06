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
    final fmtQuery = query.toLowerCase().trim();

    return fmtQuery.isNotEmpty
        ? FutureBuilder(
            future: _nh.feedSearch(fmtQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final List<SearchResult> data = snapshot.data;

                return data.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) => SearchItem(
                          searchResult: data[index],
                          category: 'Uncategorized',
                        ),
                        itemCount: data.length,
                      )
                    : const Center(
                        child: Text('No results found'),
                      );
              } else {
                return const LinearProgressIndicator();
              }
            },
          )
        : const Center(
            child: Text('Enter a feed name or a URL'),
          );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.primaryTextTheme.headline5.color.withOpacity(0.75),
        ),
      ),
      textTheme: theme.textTheme.copyWith(
        headline5: theme.textTheme.headline5.copyWith(
          color: theme.primaryTextTheme.headline5.color,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }
}
