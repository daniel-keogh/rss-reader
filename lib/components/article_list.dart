import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/article.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:rssreader/screens/home/article_item.dart';

class ArticleList extends StatelessWidget {
  final List<Article> articles;

  ArticleList({
    Key key,
    this.articles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Selector<SettingsProvider, OpenIn>(
          selector: (context, settings) => settings.openIn,
          builder: (context, openIn, child) => ArticleItem(
            article: articles[index],
            openIn: openIn,
          ),
        );
      },
      itemCount: articles.length,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    );
  }
}
