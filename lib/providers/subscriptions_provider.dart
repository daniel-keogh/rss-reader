import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/db/subscriptions_db.dart';

class SubscriptionsProvider extends ChangeNotifier {
  List<Subscription> _subscriptions = [];

  final _db = SubscriptionsDb();

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
    Iterable<String> sorted = Set<String>.from(
      _subscriptions.map((e) => e.category).toList()
        ..sort(
          (a, b) => a.toUpperCase().compareTo(b.toUpperCase()),
        ),
    );

    return UnmodifiableListView(sorted);
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

  void deleteByCategory(String category) {
    _subscriptions.removeWhere((e) => e.category == category);

    try {
      _db.deleteByCategory(category);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  bool isSubscribed(String xmlUrl) {
    return _subscriptions.map((e) => e.xmlUrl).contains(xmlUrl);
  }

  void changeCategory(int subId, String category) {
    final index = _subscriptions.indexWhere((e) => e.id == subId);

    _subscriptions[index].category = category;

    try {
      _db.update(_subscriptions[index]);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void renameCategory(String oldName, String newName) {
    _subscriptions.where((e) => e.category == oldName).forEach((e) {
      e.category = newName;

      try {
        _db.update(e);
      } catch (e) {
        print(e);
      }
    });

    notifyListeners();
  }
}
