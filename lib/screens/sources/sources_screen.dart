import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/components/confirm_dialog.dart';
import 'package:rssreader/components/rounded_bottom_sheet.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/sources/dialogs.dart';
import 'package:rssreader/screens/sources/sources_list_screen.dart';
import 'package:rssreader/services/opml_service.dart';
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
            final file = await OpmlService.export();

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
        if (model.categories.isEmpty) {
          return const Center(
            child: Text('You are not subscribed to any feeds.'),
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
                      children: <ListTile>[
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Rename'),
                          onTap: () async {
                            Navigator.pop(context);

                            final result = await showRenameDialog(
                              context,
                              category,
                            );

                            if (result != null) {
                              model.renameExistingCategory(category, result);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_sweep),
                          title: const Text('Delete Feeds'),
                          onTap: () async {
                            Navigator.pop(context);

                            final confirmation = await showConfirmDialog(
                              context: context,
                              message:
                                  'Are you sure you want to delete everything in this category?',
                            );

                            if (confirmation) {
                              model.deleteByCategory(category);
                            }
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
          children: <ListTile>[
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  Routes.catalog,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Import OPML file'),
              onTap: () async {
                final subs = await OpmlService.import();

                if (subs.isNotEmpty) {
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
