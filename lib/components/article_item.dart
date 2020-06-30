import 'package:flutter/material.dart';

import 'package:rssreader/models/article.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  const ArticleItem({
    Key key,
    @required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(bottom: 6.0),
        child: Text(
          article.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: Text(article.publisher),
      leading: Image.network(article.imageUrl),
      onTap: () {
        print(article);
      },
    );
  }
}
