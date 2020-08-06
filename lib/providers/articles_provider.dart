import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/db/articles_db.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/services/networking.dart';

class ArticlesProvider extends ChangeNotifier {
  final Set<Article> _articles = HashSet<Article>();

  SubscriptionsProvider subsProv;

  final _db = ArticlesDb();
  final _nh = NetworkHelper();

  ArticlesProvider() {
    _init();
  }

  Future<void> _init() async {
    _articles.addAll(await _db.getAll());

    notifyListeners();

    await refreshAll();
  }

  Future<void> refresh(Subscription subscription) async {
    final data = await _nh.loadFeed(subscription);

    _articles.addAll(data);
    _db.insertAll(_articles);

    notifyListeners();
  }

  Future<void> refreshAll() async {
    await for (final data in _nh.loadFeeds(subsProv.subscriptions)) {
      _articles.addAll(data);
      _db.insertAll(_articles);

      notifyListeners();
    }
  }

  UnmodifiableListView<Article> get articles {
    return UnmodifiableListView(
      _articles.toList()..sort(),
    );
  }

  UnmodifiableListView<Article> getBySubscription(Subscription subscription) {
    return UnmodifiableListView(
      _articles.where((e) => e.subscriptionId == subscription.id).toList()
        ..sort(),
    );
  }

  UnmodifiableListView<Article> getByCategory([String category = 'All']) {
    return UnmodifiableListView(
      _articles
          .where((e) => category == 'All' || e.category == category)
          .toList()
            ..sort(),
    );
  }

  UnmodifiableListView<Article> getReadByCategory([String category = 'All']) {
    return UnmodifiableListView(
      _articles
          .where((e) =>
              ((category == 'All' || e.category == category) && e.isRead))
          .toList()
            ..sort(),
    );
  }

  UnmodifiableListView<Article> getUnreadByCategory([String category = 'All']) {
    return UnmodifiableListView(
      _articles.where(
        (e) => ((category == 'All' || e.category == category) && !e.isRead),
      ),
    );
  }

  void markAsRead(Article article) {
    final a = _articles.firstWhere((e) => e.url == article.url);

    a.isRead = true;

    notifyListeners();

    _db.updateReadStatus(article);
  }

  void updateStatus(bool isRead) {
    _articles.forEach((e) => e.isRead = isRead);

    notifyListeners();

    _db.updateAllReadStatus(isRead);
  }

  void update() {
    final subs = subsProv.subscriptions;
    final ids = subs.map((e) => e.id).toSet();

    _articles
      ..retainWhere((e) => ids.contains(e.subscriptionId))
      ..forEach((e) {
        subs.forEach((sub) {
          if (sub.id == e.subscriptionId) {
            e.category = sub.category;
          }
        });
      });

    notifyListeners();
  }
}
