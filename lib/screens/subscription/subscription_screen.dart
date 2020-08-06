import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rssreader/components/article_bottom_sheet.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/articles_provider.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:rssreader/screens/home/article_item.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';
import 'package:rssreader/utils/constants.dart';

class SubscriptionScreen extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionScreen({
    Key key,
    this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subscription.title),
      ),
      body: Consumer<ArticlesProvider>(
        builder: (context, model, child) {
          final articles = model.getBySubscription(subscription);
          print(articles);
          if (articles.length != null && articles.isNotEmpty) {
            return Scrollbar(
              child: RefreshIndicator(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    var article = articles[index];

                    return Selector<SettingsProvider, OpenIn>(
                      selector: (context, settings) => settings.openIn,
                      builder: (context, prov, child) => ArticleItem(
                        article: article,
                        handleTap: () async {
                          if (prov == OpenIn.internal) {
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

                          model.markAsRead(article);
                        },
                        handleLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: bottomSheetShape,
                            builder: (context) => ArticleBottomSheet(
                              article: article,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 0.5);
                  },
                  itemCount: articles.length,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                onRefresh: () => model.refresh(subscription),
              ),
            );
          }

          return const Center(
            child: Text('There are no articles from this feed.'),
          );
        },
      ),
    );
  }
}
