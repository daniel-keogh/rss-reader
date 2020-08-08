import 'package:flutter/material.dart';

import 'package:rssreader/components/app_search_delegate.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/screens/category/search_item.dart';
import 'package:rssreader/services/networking.dart';

class FeedSearch extends AppSearchDelegate {
  final _nh = NetworkHelper();

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
                return const Expanded(
                  child: LinearProgressIndicator(),
                );
              }
            },
          )
        : const Center(
            child: Text('Enter a feed name or a URL'),
          );
  }
}
