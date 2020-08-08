import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/components/article_bottom_sheet.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:rssreader/screens/home/article_item.dart';
import 'package:rssreader/utils/constants.dart';

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
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: bottomSheetShape,
                builder: (context) => ArticleBottomSheet(
                  article: articles[index],
                ),
              );
            },
          ),
        );
      },
      itemCount: articles.length,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    );
  }
}
