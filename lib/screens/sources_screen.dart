import 'dart:io';

import 'package:flutter/material.dart';

import 'package:rssreader/components/subscription_item.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/screens/catalog_screen.dart';
import 'package:rssreader/services/opml.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class SourcesScreen extends StatefulWidget {
  static const String route = '/sources';

  final _opml = Opml();
  final _subsDb = SubscriptionsDb.getInstance();

  @override
  _SourcesScreenState createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  List<Subscription> subscriptions = [];

  @override
  void initState() {
    super.initState();
    loadSubscriptions();
  }

  void loadSubscriptions() async {
    var subs = await widget._subsDb.getAll();
    setState(() {
      subscriptions.addAll(subs);
    });
  }

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
            File file = await widget._opml.export();

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
                title: Text("Catalog"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    CatalogScreen.route,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text("Import OPML"),
                onTap: () async {
                  await Opml().import();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sources'),
        actions: _appbarActions(),
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return SubscriptionItem(
              subscription: subscriptions[index],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(thickness: 0.5);
          },
          itemCount: subscriptions.length,
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showModalBottomSheet(context),
      ),
    );
  }
}
