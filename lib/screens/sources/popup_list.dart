import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';

enum MenuAction {
  unsub,
  move,
}

class PopupList extends StatelessWidget {
  final Iterable<String> categories;
  final Subscription subscription;

  const PopupList({
    Key key,
    @required this.categories,
    @required this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SubscriptionsProvider>(
      context,
      listen: false,
    );

    return PopupMenuButton<MenuAction>(
      padding: EdgeInsets.zero,
      onSelected: (value) async {
        switch (value) {
          case MenuAction.move:
            final result = await _showCategoryDialog(context, categories);

            if (result != null && result.trim().length != 0) {
              model.changeCategory(subscription.id, result.trim());
            }
            break;
          case MenuAction.unsub:
            model.delete(subscription);
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => <PopupMenuItem<MenuAction>>[
        PopupMenuItem<MenuAction>(
          value: MenuAction.move,
          child: Text('Move'),
        ),
        PopupMenuItem<MenuAction>(
          value: MenuAction.unsub,
          child: Text('Unsubscribe'),
        ),
      ],
    );
  }

  Future<String> _showCategoryDialog(
    BuildContext context,
    Iterable<String> categories,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String result = subscription.category;

        return AlertDialog(
          title: const Text('Select Category'),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  for (final category in categories)
                    RadioListTile(
                      title: Text(category),
                      value: category,
                      groupValue: result,
                      onChanged: (value) {
                        setState(() => result = value);
                      },
                    )
                ],
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(result),
            ),
            FlatButton(
              child: const Text('SAVE'),
              onPressed: () => Navigator.of(context).pop(result),
            ),
          ],
        );
      },
    );
  }
}
