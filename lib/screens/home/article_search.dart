import 'package:flutter/material.dart';

import 'package:rssreader/components/app_search_delegate.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/screens/home/article_item.dart';

class ArticleSearch extends AppSearchDelegate {
  final List<Article> articles;
  final Function onResultTap;
  final Function onResultLongPress;

  ArticleSearch({
    this.articles,
    this.onResultTap,
    this.onResultLongPress,
  });

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final fmtQuery = query.toLowerCase().trim();

    List<Article> results;

    if (fmtQuery.isEmpty) {
      // Show everything
      results = articles;
    } else {
      results = articles
          .where((e) => e.title.toLowerCase().contains(fmtQuery.toLowerCase()))
          .toList();

      if (results.isEmpty) {
        return const Center(
          child: Text('No results found.'),
        );
      }
    }

    return Scrollbar(
      child: ListView.builder(
        itemBuilder: (context, index) => ArticleItem(
          article: results[index],
          handleTap: onResultTap,
          handleLongPress: onResultLongPress,
        ),
        itemCount: results.length,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
      ),
    );
  }
}
