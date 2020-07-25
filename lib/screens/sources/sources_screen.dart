import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/services/opml.dart';
import 'package:rssreader/utils/routes.dart';

class SourcesScreen extends StatelessWidget {
  SnackBar _getSnackBar(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        onPressed: () {},
        label: 'OK',
      ),
      duration: Duration(seconds: 5),
    );
  }

  List<Widget> _appbarActions() {
    return <Widget>[
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.save_alt),
          tooltip: 'Export',
          onPressed: () async {
            File file = await Opml.export();

            if (file != null) {
              var msg = "File exported to: '${file.path}'";
              Scaffold.of(context).showSnackBar(_getSnackBar(msg));
            }
          },
        ),
      ),
    ];
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Container(
          height: 190.0,
          color: Colors.transparent,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Search"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    Routes.catalog,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text("Import OPML file"),
                onTap: () async {
                  List<Subscription> subs = await Opml.import();

                  Provider.of<SubscriptionsProvider>(
                    context,
                    listen: false,
                  ).addAll(subs);

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.link),
                title: Text("RSS link"),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
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
                          icon: Icon(Icons.delete),
                          color: Colors.redAccent,
                          tooltip: 'Unsubscribe',
                          onPressed: () => value.delete(item),
                        ),
                      ),
                  ],
                  shrinkWrap: true,
                  physics: ScrollPhysics(parent: PageScrollPhysics()),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => Divider(thickness: 0.5),
          itemCount: value.categories.length,
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sources'),
        actions: _appbarActions(),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showModalBottomSheet(context),
      ),
    );
  }
}
