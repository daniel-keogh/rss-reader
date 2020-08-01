import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/db/articles_db.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/services/networking.dart';

class ArticlesProvider extends ChangeNotifier {
  Set<Article> _articles = SplayTreeSet<Article>();

  SubscriptionsProvider subscriptions;

  final _db = ArticlesDb();
  final NetworkHelper _nh = NetworkHelper();

  ArticlesProvider() {
    _init();
  }

  Future<void> _init() async {
    _articles = SplayTreeSet<Article>.from(
      await _db.getAll(),
    );

    notifyListeners();

    refreshAll();
  }

  Future<void> refresh(Subscription subscription) async {
    final data = await _nh.loadFeed(subscription);
    _articles.addAll(data);

    notifyListeners();
  }

  Future<void> refreshAll() async {
    await for (final data in _nh.loadFeeds(subscriptions.subscriptions)) {
      _articles.addAll(data);
      notifyListeners();
    }
  }

  UnmodifiableListView<Article> get articles {
    return UnmodifiableListView(_articles);
  }

  UnmodifiableListView<Article> get unread {
    final unread = _articles.where((e) => e.isRead = false);

    return UnmodifiableListView(unread);
  }

  UnmodifiableListView<Article> get read {
    final read = _articles.where((e) => e.isRead = true);

    return UnmodifiableListView(read);
  }

  UnmodifiableListView<Article> getByCategory([String category = 'All']) {
    return UnmodifiableListView(
      _articles.where((e) => category == 'All' || e.category == category),
    );
  }

  UnmodifiableListView<Article> getReadByCategory([String category = 'All']) {
    return UnmodifiableListView(_articles.where((e) {
      return ((category == 'All' || e.category == category) && e.isRead);
    }));
  }

  UnmodifiableListView<Article> getUnreadByCategory([String category = 'All']) {
    return UnmodifiableListView(_articles.where((e) {
      return ((category == 'All' || e.category == category) && !e.isRead);
    }));
  }

//  UnmodifiableListView<Article> getBySubscription(Subscription subscription) {
//    return UnmodifiableListView(
//      _articles.where((e) => category == 'All' || e. == category),
//    );
//  }

  void markAsRead(Article article) {
    final a = _articles.firstWhere((e) => e.url == article.url);

    a.isRead = true;

    notifyListeners();
  }

  void markAllAsRead() {
    _articles.forEach((e) {
      e.isRead = true;
    });

    notifyListeners();
  }

  void markAllAsUnread() {
    _articles.forEach((e) {
      e.isRead = false;
    });

    notifyListeners();
  }

  void prune() {
    final ids = subscriptions.subscriptions.map((e) => e.id).toSet();

    _articles.retainWhere((e) => ids.contains(e.subscriptionId));

    notifyListeners();
  }
}
