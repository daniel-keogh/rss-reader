import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/components/rounded_bottom_sheet.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/sources/rename_dialog.dart';
import 'package:rssreader/screens/sources/sources_list_screen.dart';
import 'package:rssreader/services/opml.dart';
import 'package:rssreader/utils/constants.dart';
import 'package:rssreader/utils/routes.dart';

class SourcesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sources'),
        actions: _appbarActions(),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddBottomSheet(context),
      ),
    );
  }

  List<Widget> _appbarActions() {
    return <Widget>[
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.save_alt),
          tooltip: 'Export OPML',
          onPressed: () async {
            File file = await Opml.export();

            if (file != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("File exported to: '${file.path}'"),
                  action: SnackBarAction(
                    onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
                    label: 'OK',
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          },
        ),
      ),
    ];
  }

  Widget _buildBody() {
    return Consumer<SubscriptionsProvider>(
      builder: (context, model, child) {
        if (model.categories.length == null || model.categories.length == 0) {
          return const Center(
            child: const Text('You are not subscribed to any feeds.'),
          );
        }

        return Scrollbar(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final category = model.categories.elementAt(index);

              return ListTile(
                title: Text(category),
                leading: Icon(Icons.folder_open),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SourcesListScreen(
                        category: category,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: bottomSheetShape,
                    builder: (context) => RoundedBottomSheet(
                      tiles: <ListTile>[
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text("Rename"),
                          onTap: () async {
                            Navigator.pop(context);

                            final result = await showRenameDialog(
                              context,
                              category,
                            );

                            if (result != null) {
                              model.renameCategory(category, result);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_sweep),
                          title: const Text("Delete Feeds"),
                          onTap: () {
                            Navigator.pop(context);
                            model.deleteByCategory(category);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(thickness: 0.5),
            itemCount: model.categories.length,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: bottomSheetShape,
      builder: (context) {
        return RoundedBottomSheet(
          tiles: <ListTile>[
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Search"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  Routes.catalog,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text("Import OPML file"),
              onTap: () async {
                final List<Subscription> subs = await Opml.import();

                if (subs.length > 0) {
                  Provider.of<SubscriptionsProvider>(
                    context,
                    listen: false,
                  ).addAll(subs);
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
