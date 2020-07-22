import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class SubscriptionsProvider extends ChangeNotifier {
  List<Subscription> _subscriptions = [];
  Set<String> _categories = {};

  final SubscriptionsDb _db = SubscriptionsDb.getInstance();

  SubscriptionsProvider() {
    _init();
  }

  Future<void> _init() async {
    _subscriptions = await _db.getAll();
    _categories = _getCategories();

    notifyListeners();
  }

  UnmodifiableListView<Subscription> get subscriptions {
    return UnmodifiableListView(_subscriptions);
  }

  UnmodifiableListView<String> get categories {
    return UnmodifiableListView(_categories);
  }

  void add(Subscription sub) {
    _subscriptions.add(sub);
    _categories = _getCategories();

    try {
      _db.insert(sub);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void addAll(List<Subscription> subs) {
    _subscriptions.addAll(subs);
    _categories = _getCategories();

    try {
      _db.insertAll(subs);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void deleteByXmlUrl(String xmlUrl) {
    _subscriptions.removeWhere((e) => e.xmlUrl == xmlUrl);
    _categories = _getCategories();

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

  Set<String> _getCategories() {
    return Set.from(_subscriptions.map((e) => e.category));
  }
}
