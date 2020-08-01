import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rssreader/models/article.dart';
import 'package:rssreader/providers/articles_provider.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/components/article_bottom_sheet.dart';
import 'package:rssreader/components/side_drawer.dart';
import 'package:rssreader/screens/home/article_item.dart';
import 'package:rssreader/screens/home/filter_button.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';
import 'package:rssreader/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Filter filter;

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<SubscriptionsProvider>(context).categories;
    final tabs = ['All', ...categories];

    return DefaultTabController(
      length: categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: _appbarActions(context),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56.0),
            child: Container(
              width: double.infinity,
              child: TabBar(
                isScrollable: true,
                tabs: <Widget>[
                  for (final tab in tabs) Tab(text: tab),
                ],
              ),
            ),
          ),
        ),
        drawer: SideDrawer(),
        body: TabBarView(
          children: <Widget>[
            for (final tab in tabs) _buildList(context, tab),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, String category) {
    final model = Provider.of<ArticlesProvider>(context);

    List<Article> articles;

    if (filter == Filter.read) {
      articles = model.getReadByCategory(category);
    } else if (filter == Filter.unread) {
      articles = model.getUnreadByCategory(category);
    } else {
      articles = model.getByCategory(category);
    }

    return articles.length != 0
        ? Scrollbar(
            child: RefreshIndicator(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var article = articles[index];

                  return Selector<SettingsProvider, OpenIn>(
                    selector: (context, settings) => settings.openIn,
                    builder: (context, prov, child) => ArticleItem(
                      article: article,
                      handleTap: () async {
                        if (prov == OpenIn.internal) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                article: article,
                              ),
                            ),
                          );
                        } else {
                          if (await canLaunch(article.url)) {
                            await launch(article.url);
                          }
                        }

                        model.markAsRead(article);
                      },
                      handleLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: bottomSheetShape,
                          builder: (context) => ArticleBottomSheet(
                            article: article,
                          ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(thickness: 0.5);
                },
                itemCount: articles.length,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              onRefresh: model.refreshAll,
            ),
          )
        : const Center(
            child: const CircularProgressIndicator(),
          );
  }

  List<Widget> _appbarActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.done_all),
        tooltip: 'Mark all as read',
        onPressed: () {
          Provider.of<ArticlesProvider>(
            context,
            listen: false,
          ).markAllAsRead();
        },
      ),
      FilterButton(
        onSelected: (value) {
          setState(() => filter = value);
        },
      ),
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Search',
        onPressed: () {},
      ),
    ];
  }
}
