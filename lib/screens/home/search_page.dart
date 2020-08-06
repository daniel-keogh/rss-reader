import 'package:flutter/material.dart';

import 'package:rssreader/models/article.dart';
import 'package:rssreader/screens/home/article_item.dart';

class ArticleSearch extends SearchDelegate {
  final List<Article> articles;
  final Function onResultTap;
  final Function onResultLongPress;

  ArticleSearch({
    this.articles,
    this.onResultTap,
    this.onResultLongPress,
  });

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
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

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
