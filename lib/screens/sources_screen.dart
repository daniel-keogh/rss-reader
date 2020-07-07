import 'dart:io';

import 'package:flutter/material.dart';

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
  Set<String> categories = {};

  @override
  void initState() {
    super.initState();
    loadSubscriptions();
  }

  void loadSubscriptions() async {
    var subs = await widget._subsDb.getAll();

    setState(() {
      subscriptions.addAll(subs);
      categories = Set.from(subs.map((e) => e.category));
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
                title: Text("Search"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    CatalogScreen.route,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text("Import OPML file"),
                onTap: () {
                  widget._opml.import();
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
            String category = categories.elementAt(index);

            List<ListTile> items = subscriptions
                .where((e) => e.category == category)
                .map(
                  (e) => ListTile(
                    title: Text(e.title),
                    subtitle: Text(e.xmlUrl),
                  ),
                )
                .toList();

            return ExpansionTile(
              title: Text(category),
              children: <Widget>[
                ListView(
                  children: <Widget>[...items],
                  shrinkWrap: true,
                  physics: ScrollPhysics(parent: PageScrollPhysics()),
                )
              ],
            );
          },
          separatorBuilder: (context, index) => Divider(thickness: 0.5),
          itemCount: categories.length,
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add"),
        icon: Icon(Icons.add),
        onPressed: () => _showModalBottomSheet(context),
      ),
    );
  }
}
