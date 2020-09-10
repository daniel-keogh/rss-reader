import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/sources/selectable_tile.dart';
import 'package:rssreader/screens/sources/dialogs.dart';
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
  final Map<int, bool> _checkboxValues = {};

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SubscriptionsProvider>(context);

    final items = model.subscriptions
        .where((e) => e.category == widget.category)
        .toList();

    return WillPopScope(
      child: Scaffold(
        appBar: SelectionAppBar(
          title: widget.category,
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

                if (result != null) {
                  _forSelected(items, (key) => model.moveCategory(key, result));
                }

                _clearSelection();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_sweep),
              tooltip: 'Delete all',
              onPressed: () {
                _forSelected(items, (key) => model.deleteById(key));
                _clearSelection();
              },
            ),
          ],
        ),
        body: (items.length != null && items.isNotEmpty)
            ? Scrollbar(
                child: AnimatedList(
                  key: _globalKey,
                  itemBuilder: (context, index, animation) {
                    final item = items[index];

                    return SizeTransition(
                      sizeFactor: animation,
                      child: Column(
                        children: <Widget>[
                          SelectableTile(
                            subscription: item,
                            enable: _selectMultiple,
                            isChecked: _checkboxValues[item.id] ??= false,
                            onChecked: (bool value) {
                              setState(() => _checkboxValues[item.id] = value);
                            },
                            onLongPress: () {
                              setState(() {
                                _selectMultiple = true;
                                _checkboxValues[item.id] = true;
                              });
                            },
                            onMove: () async {
                              final result = await showCategoryDialog(
                                context: context,
                                categories: model.categories,
                                currentCategory: item.category,
                              );

                              if (result != null) {
                                _deleteItem(index);
                                model.moveCategory(item.id, result);
                              }
                            },
                            onUnsubscribe: () {
                              _deleteItem(index);
                              model.delete(item);
                            },
                          ),
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
                child: Text(
                  'There are no subscriptions in this category.',
                ),
              ),
      ),
      onWillPop: _onWillPop,
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

  void _forSelected(List<Subscription> items, Function cb) {
    _checkboxValues.forEach((key, value) {
      if (value) {
        int index = items.indexWhere((e) => e.id == key);

        _deleteItem(index);
        items.removeAt(index);

        cb(key);
      }
    });
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
