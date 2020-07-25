import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/services/opml.dart';
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
        onPressed: () => _showModalBottomSheet(context),
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
      builder: (context, value, child) => Scrollbar(
        child: ListView.separated(
          itemBuilder: (context, index) {
            final category = value.categories.elementAt(index);
            final items = value.subscriptions.where(
              (e) => e.category == category,
            );

            return ExpansionTile(
              title: Text(category),
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    for (final item in items)
                      ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.xmlUrl),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent,
                          tooltip: 'Unsubscribe',
                          onPressed: () => value.delete(item),
                        ),
                      ),
                  ],
                  shrinkWrap: true,
                  physics: const ScrollPhysics(
                    parent: const PageScrollPhysics(),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(thickness: 0.5),
          itemCount: value.categories.length,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: const Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Container(
          height: 130.0,
          color: Colors.transparent,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
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
                  List<Subscription> subs = await Opml.import();

                  Provider.of<SubscriptionsProvider>(
                    context,
                    listen: false,
                  ).addAll(subs);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
