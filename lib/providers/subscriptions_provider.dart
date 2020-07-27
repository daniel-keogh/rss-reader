import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/db/subscriptions_db.dart';

class SubscriptionsProvider extends ChangeNotifier {
  List<Subscription> _subscriptions = [];

  final SubscriptionsDb _db = SubscriptionsDb.getInstance();

  SubscriptionsProvider() {
    _init();
  }

  Future<void> _init() async {
    _subscriptions = await _db.getAll();

    notifyListeners();
  }

  UnmodifiableListView<Subscription> get subscriptions {
    return UnmodifiableListView(_subscriptions);
  }

  UnmodifiableListView<String> get categories {
    return UnmodifiableListView(
      Set.from(_subscriptions.map((e) => e.category)),
    );
  }

  void add(Subscription sub) {
    _subscriptions.add(sub);

    try {
      _db.insert(sub);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void addAll(List<Subscription> subs) {
    _subscriptions.addAll(subs);

    try {
      _db.insertAll(subs);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void delete(Subscription subscription) {
    deleteByXmlUrl(subscription.xmlUrl);
  }

  void deleteByXmlUrl(String xmlUrl) {
    _subscriptions.removeWhere((e) => e.xmlUrl == xmlUrl);

    try {
      _db.deleteByXmlUrl(xmlUrl);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  bool isSubscribed(String xmlUrl) {
    return _subscriptions.map((e) => e.xmlUrl).contains(xmlUrl);
  }
}
