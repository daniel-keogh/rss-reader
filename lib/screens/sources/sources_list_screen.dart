import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/sources/popup_list.dart';

class SourcesListScreen extends StatelessWidget {
  final String category;

  final GlobalKey<AnimatedListState> _globalKey = GlobalKey();

  SourcesListScreen({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Consumer<SubscriptionsProvider>(
        builder: (context, model, child) {
          final List<Subscription> items = model.subscriptions
              .where(
                (e) => e.category == category,
              )
              .toList();

          if (items.length != null && items.length > 0) {
            return Scrollbar(
              child: AnimatedList(
                key: _globalKey,
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(items[index].title),
                          ),
                          subtitle: Text(items[index].xmlUrl),
                          trailing: PopupList(
                            subscription: items[index],
                            onUpdate: () => _deleteItem(index),
                          ),
                          contentPadding: const EdgeInsets.only(
                            top: 4.0,
                            bottom: 4.0,
                            left: 12.0,
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                initialItemCount: items.length,
              ),
            );
          }

          return const Center(
            child: const Text('There are no subscriptions in this category.'),
          );
        },
      ),
    );
  }

  void _deleteItem(int index) {
    _globalKey.currentState.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: const ListTile(),
      ),
    );
  }
}
