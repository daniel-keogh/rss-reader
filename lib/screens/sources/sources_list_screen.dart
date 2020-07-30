import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';

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
                    child: ListTile(
                      title: Text(items[index].title),
                      subtitle: Text(items[index].xmlUrl),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.redAccent,
                        tooltip: 'Unsubscribe',
                        onPressed: () {
                          model.delete(items[index]);
                          _deleteItem(index);
                        },
                      ),
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
