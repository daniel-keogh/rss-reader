import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/db/subscriptions_db.dart';

class SubscriptionsProvider extends ChangeNotifier {
  Set<Subscription> _subscriptions = HashSet<Subscription>();

  final _db = SubscriptionsDb();

  SubscriptionsProvider() {
    _init();
  }

  Future<void> _init() async {
    _subscriptions = HashSet<Subscription>.from(
      await _db.getAll(),
    );

    notifyListeners();
  }

  UnmodifiableListView<Subscription> get subscriptions {
    return UnmodifiableListView(
      _subscriptions.toList()..sort(),
    );
  }

  UnmodifiableListView<String> get categories {
    // Get a (sorted) set of all the categories
    final sorted = Set<String>.from(
      _subscriptions.map((e) => e.category).toList()
        ..sort(
          (a, b) => a.toUpperCase().compareTo(b.toUpperCase()),
        ),
    );

    return UnmodifiableListView(sorted);
  }

  void add(Subscription sub) {
    // True if `sub` is not in `_subscriptions`
    if (_subscriptions.add(sub)) {
      try {
        _db.insert(sub);
      } catch (e) {
        // TODO:
        print(e);
      }

      notifyListeners();
    }
  }

  void addAll(Iterable<Subscription> subs) {
    final newSubs = <Subscription>[];

    subs.forEach((e) {
      // True if `e` is not in `_subscriptions`
      if (_subscriptions.add(e)) {
        newSubs.add(e);
      }
    });

    try {
      _db.insertAll(newSubs);
    } catch (e) {
      // TODO:
      print(e);
    }

    notifyListeners();
  }

  void delete(Subscription sub) {
    // Only true if `sub` was in `_subscriptions`
    if (_subscriptions.remove(sub)) {
      try {
        _db.deleteById(sub.id);
      } catch (e) {
        // TODO:
        print(e);
      }

      notifyListeners();
    }
  }

  void deleteById(int id) {
    final sub = _subscriptions.firstWhere((e) => e.id == id);
    final bool wasRemoved = _subscriptions.remove(sub);

    if (wasRemoved) {
      try {
        _db.deleteById(id);
      } catch (e) {
        // TODO:
        print(e);
      }

      notifyListeners();
    }
  }

  void deleteAllById(Iterable<int> ids) {
    for (final int id in ids) {
      final sub = _subscriptions.firstWhere((e) => e.id == id);
      final bool wasRemoved = _subscriptions.remove(sub);

      if (wasRemoved) {
        try {
          _db.deleteById(id);
        } catch (e) {
          // TODO:
          print(e);
        }
      }
    }

    notifyListeners();
  }

  void deleteByXmlUrl(String xmlUrl) {
    final sub = _subscriptions.firstWhere((e) => e.xmlUrl == xmlUrl);
    final bool wasRemoved = _subscriptions.remove(sub);

    if (wasRemoved) {
      try {
        _db.deleteByXmlUrl(xmlUrl);
      } catch (e) {
        // TODO:
        print(e);
      }

      notifyListeners();
    }
  }

  void deleteByCategory(String category) {
    _subscriptions.removeWhere((e) => e.category == category);

    try {
      _db.deleteByCategory(category);
    } catch (e) {
      // TODO:
      print(e);
    }

    notifyListeners();
  }

  bool isSubscribed(String xmlUrl) {
    return _subscriptions.map((e) => e.xmlUrl).contains(xmlUrl);
  }

  void moveCategory(int id, String category) {
    final sub = _subscriptions.firstWhere((e) => e.id == id);

    sub.category = category;

    try {
      _db.update(sub);
    } catch (e) {
      // TODO:
      print(e);
    }

    notifyListeners();
  }

  void renameExistingCategory(String oldName, String newName) {
    final subs = _subscriptions.where((e) => e.category == oldName);

    if (subs.length == 0) {
      return;
    }

    subs.forEach((e) {
      e.category = newName;

      try {
        _db.update(e);
      } catch (e) {
        // TODO:
        print(e);
      }
    });

    notifyListeners();
  }
}
