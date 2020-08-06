import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/components/article_list.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/articles_provider.dart';

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

          if (articles != null && articles.isNotEmpty) {
            return Scrollbar(
              child: RefreshIndicator(
                child: ArticleList(articles: articles),
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
