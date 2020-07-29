import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              article.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: article.isRead ? Colors.grey : null,
              ),
            ),
          ),
          subtitle: Text(
            article.publisher,
            style: TextStyle(fontSize: 12),
          ),
          trailing: article.imageUrl != null
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(4),
                  ),
                  child: SizedBox(
                    width: 100.0,
                    child: CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                      errorWidget: (context, url, error) => Container(
                        child: const Center(
                          child: const Icon(Icons.error),
                        ),
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                )
              : null,
          onTap: handleTap,
          onLongPress: handleLongPress,
        ),
      ],
    );
  }
}
