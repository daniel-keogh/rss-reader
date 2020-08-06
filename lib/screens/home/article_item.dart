import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:rssreader/components/article_bottom_sheet.dart';
import 'package:rssreader/providers/articles_provider.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';
import 'package:rssreader/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:rssreader/models/article.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleItem extends StatelessWidget {
  final Article article;
  final OpenIn openIn;

  ArticleItem({
    Key key,
    @required this.article,
    @required this.openIn,
  }) : super(key: key);

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        const Radius.circular(4),
      ),
      child: SizedBox(
        width: 120.0,
        child: CachedNetworkImage(
          imageUrl: article.imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 250),
          errorWidget: (context, url, error) => Container(
            child: SizedBox(
              height: 80.0,
              child: const Center(
                child: Icon(Icons.error),
              ),
            ),
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 18.0,
              left: 12.0,
              bottom: 4.0,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            article.publisher,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            article.title,
                            style: TextStyle(
                              fontSize: 16.5,
                              color:
                                  article.isRead ? Colors.grey : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (article.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          bottom: 12.0,
                          right: 18.0,
                        ),
                        child: _buildImage(),
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      timeago.format(article.date),
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      color: Colors.grey,
                      onPressed: () => _openBottomSheet(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () => _handleTap(context),
          onLongPress: () => _openBottomSheet(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: const Divider(height: 0),
        ),
      ],
    );
  }

  _handleTap(BuildContext context) async {
    if (openIn == OpenIn.internal) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(
            article: article,
          ),
        ),
      );
    } else {
      if (await canLaunch(article.url)) {
        await launch(article.url);
      }
    }

    Provider.of<ArticlesProvider>(
      context,
      listen: false,
    ).markAsRead(article);
  }

  _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: bottomSheetShape,
      builder: (context) => ArticleBottomSheet(
        article: article,
      ),
    );
  }
}
