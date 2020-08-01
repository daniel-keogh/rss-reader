import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/sources/dialogs.dart';
import 'package:rssreader/screens/sources/popup_list.dart';
import 'package:rssreader/screens/sources/selection_appbar.dart';

class SourcesListScreen extends StatefulWidget {
  final String category;

  SourcesListScreen({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  _SourcesListScreenState createState() => _SourcesListScreenState();
}

class _SourcesListScreenState extends State<SourcesListScreen> {
  final GlobalKey<AnimatedListState> _globalKey = GlobalKey();

  bool _selectMultiple = false;
  Map<int, bool> _checkboxValues = {};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Consumer<SubscriptionsProvider>(
        builder: (context, model, child) {
          final items = model.subscriptions
              .where((e) => e.category == widget.category)
              .toList();

          return Scaffold(
            appBar: _buildAppBar(model, items),
            body: (items.length != null && items.length > 0)
                ? Scrollbar(
                    child: AnimatedList(
                      key: _globalKey,
                      itemBuilder: (context, index, animation) {
                        _checkboxValues[items[index].id] ??= false;

                        return SizeTransition(
                          sizeFactor: animation,
                          child: Column(
                            children: <Widget>[
                              if (!_selectMultiple)
                                _buildListTile(items[index], index)
                              else
                                _buildCheckbox(items[index]),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      initialItemCount: items.length,
                    ),
                  )
                : const Center(
                    child: const Text(
                      'There are no subscriptions in this category.',
                    ),
                  ),
          );
        },
      ),
      onWillPop: _onWillPop,
    );
  }

  Widget _buildAppBar(SubscriptionsProvider model, List<Subscription> items) {
    return SelectionAppBar(
      title: Text(widget.category),
      count: _checkboxValues.values.where((e) => e == true).length,
      enabled: _selectMultiple,
      onClear: _clearSelection,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.select_all),
          tooltip: 'Select all',
          onPressed: () {
            setState(() {
              _checkboxValues.forEach(
                (key, value) => _checkboxValues[key] = true,
              );
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          tooltip: 'Move all',
          onPressed: () async {
            final result = await showCategoryDialog(
              context: context,
              categories: model.categories,
              currentCategory: widget.category,
            );

            if (result != null && result.trim().length != 0) {
              _checkboxValues.forEach((key, value) {
                if (value) {
                  int index = items.indexWhere((e) => e.id == key);

                  _deleteItem(index);
                  items.removeAt(index);

                  model.moveCategory(key, result.trim());
                }
              });
            }

            _clearSelection();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_sweep),
          tooltip: 'Delete all',
          onPressed: () {
            _checkboxValues.forEach((key, value) {
              if (value) {
                int index = items.indexWhere((e) => e.id == key);

                _deleteItem(index);
                items.removeAt(index);

                model.deleteById(key);
              }
            });

            _clearSelection();
          },
        ),
      ],
    );
  }

  _buildListTile(Subscription item, int index) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(item.title),
      ),
      subtitle: Text(item.xmlUrl),
      isThreeLine: true,
      trailing: Consumer<SubscriptionsProvider>(
        builder: (context, model, child) => PopupList(
          onMove: () async {
            final result = await showCategoryDialog(
              context: context,
              categories: model.categories,
              currentCategory: item.category,
            );

            if (result != null && result.trim().length != 0) {
              _deleteItem(index);
              model.moveCategory(item.id, result.trim());
            }
          },
          onUnsubscribe: () {
            _deleteItem(index);
            model.delete(item);
          },
        ),
      ),
      onLongPress: () {
        setState(() {
          _selectMultiple = true;
          _checkboxValues[item.id] = true;
        });
      },
    );
  }

  Widget _buildCheckbox(Subscription item) {
    return CheckboxListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(item.title),
      ),
      subtitle: Text(item.xmlUrl),
      isThreeLine: true,
      value: _checkboxValues[item.id],
      onChanged: (bool value) {
        setState(() => _checkboxValues[item.id] = value);
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  void _deleteItem(int index) {
    _globalKey.currentState.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: Container(
          color: Colors.grey.withOpacity(0.1),
          child: const ListTile(),
        ),
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      _selectMultiple = false;
      _checkboxValues.clear();
    });
  }

  Future<bool> _onWillPop() {
    if (_selectMultiple) {
      _clearSelection();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
