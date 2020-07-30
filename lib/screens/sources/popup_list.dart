import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/sources/dialog_text_field.dart';

enum _Action {
  unsubscribe,
  move,
}

class PopupList extends StatelessWidget {
  final Subscription subscription;
  final Function onUpdate;

  const PopupList({
    Key key,
    @required this.subscription,
    @required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SubscriptionsProvider>(
      context,
      listen: false,
    );

    return PopupMenuButton<_Action>(
      itemBuilder: (context) => _itemList(),
      padding: EdgeInsets.zero,
      onSelected: (value) async {
        switch (value) {
          case _Action.move:
            final result = await _showCategoryDialog(context, model.categories);

            if (result != null && result.trim().length != 0) {
              onUpdate();
              model.changeCategory(subscription.id, result.trim());
            }
            break;
          case _Action.unsubscribe:
            onUpdate();
            model.delete(subscription);
            break;
          default:
            break;
        }
      },
    );
  }

  List<PopupMenuItem<_Action>> _itemList() {
    return <PopupMenuItem<_Action>>[
      PopupMenuItem<_Action>(
        value: _Action.move,
        child: ListTile(
          title: const Text('Move'),
          leading: const Icon(Icons.edit),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      PopupMenuItem<_Action>(
        value: _Action.unsubscribe,
        child: ListTile(
          title: const Text('Unsubscribe'),
          leading: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    ];
  }

  Future<String> _showCategoryDialog(
    BuildContext context,
    Iterable<String> categories,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String result = subscription.category;
        String newCategory = '';

        return AlertDialog(
          title: const Text('Select Category'),
          contentPadding: EdgeInsets.only(top: 20.0),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RadioListTile(
                    title: DialogTextField(
                      onChanged: (value) {
                        newCategory = value;
                        setState(() => result = value);
                      },
                      initialValue: '',
                      placeholder: 'New Category',
                      autoFocus: false,
                    ),
                    value: newCategory,
                    groupValue: result,
                    onChanged: (value) {
                      setState(() => result = value);
                    },
                  ),
                  for (final category in categories)
                    RadioListTile(
                      title: Text(category),
                      value: category,
                      groupValue: result,
                      onChanged: (value) {
                        setState(() => result = value);
                      },
                    ),
                ],
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            FlatButton(
              child: const Text('SAVE'),
              onPressed: () => Navigator.of(context).pop(
                result != subscription.category ? result : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
