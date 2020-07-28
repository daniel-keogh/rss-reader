import 'package:flutter/material.dart';

import 'package:rssreader/models/article.dart';

class ArticleItem extends StatelessWidget {
  final Article article;
  final Function handleTap;
  final Function handleLongPress;

  ArticleItem({
    Key key,
    @required this.article,
    @required this.handleTap,
    @required this.handleLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(bottom: 6.0),
        child: Text(
          article.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: article.isRead ? Colors.grey : null,
          ),
        ),
      ),
      subtitle: Text(
        article.publisher,
        style: TextStyle(fontSize: 12),
      ),
      leading:
          article.imageUrl != null ? Image.network(article.imageUrl) : null,
      onTap: handleTap,
      onLongPress: handleLongPress,
    );
  }
}
