import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/sources/dialogs.dart';
import 'package:rssreader/screens/sources/popup_list.dart';

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
    return !_selectMultiple
        ? AppBar(
            title: Text(widget.category),
          )
        : AppBar(
            title: Text(
              '${_checkboxValues.values.where((e) => e == true).length}',
            ),
            leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearSelection,
            ),
            actions: <Widget>[
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
              )
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
      trailing: PopupList(
        subscription: item,
        onUpdate: () => _deleteItem(index),
      ),
      onLongPress: () {
        setState(() {
          _selectMultiple = true;
          _checkboxValues[item.id] = true;
        });
      },
      contentPadding: const EdgeInsets.only(
        top: 4.0,
        bottom: 4.0,
        left: 12.0,
      ),
    );
  }

  Widget _buildCheckbox(Subscription item) {
    return CheckboxListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(item.title),
      ),
      subtitle: Text(item.xmlUrl),
      value: _checkboxValues[item.id] ?? false,
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
        child: const ListTile(),
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
