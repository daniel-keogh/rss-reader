import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/subscription/subscription_screen.dart';
import 'package:rssreader/utils/routes.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Scrollbar(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Material(
                        elevation: 4.0,
                        child: ListTile(
                          title: Text(
                            'RSS Reader',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ListTile(
                          title: const Text('Favourites'),
                          leading: const Icon(Icons.favorite_border),
                          onTap: () {
                            Navigator.popAndPushNamed(
                              context,
                              Routes.favourites,
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Catalog'),
                        leading: const Icon(Icons.grid_on),
                        onTap: () {
                          Navigator.popAndPushNamed(context, Routes.catalog);
                        },
                      ),
                      ListTile(
                        title: const Text('Sources'),
                        leading: const Icon(Icons.library_books),
                        onTap: () {
                          Navigator.popAndPushNamed(context, Routes.sources);
                        },
                      ),
                      const Divider(),
                      Consumer<SubscriptionsProvider>(
                        builder: (context, value, child) => ListView.builder(
                          itemBuilder: (context, index) {
                            final category = value.categories.elementAt(index);
                            final items = value.subscriptions
                                .where((e) => e.category == category)
                                .toList();

                            return ExpansionTile(
                              title: Text(category),
                              children: <Widget>[
                                ListView(
                                  children: <Widget>[
                                    for (final item in items)
                                      ListTile(
                                        title: Text(item.title),
                                        dense: true,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return SubscriptionScreen(
                                                  subscription: item,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                              ],
                            );
                          },
                          itemCount: value.categories.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 8.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Material(
                  elevation: 4.0,
                  child: ListTile(
                    title: const Text('Settings'),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      Navigator.popAndPushNamed(context, Routes.settings);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
