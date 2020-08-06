import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/components/article_list.dart';
import 'package:rssreader/components/side_drawer.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/providers/articles_provider.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/screens/home/home_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Filter _filter = Filter.unread;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'All',
      ...Provider.of<SubscriptionsProvider>(context).categories
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: HomeTabBar(
          tabs: tabs,
          filter: _filter,
          onFilterChanged: (value) {
            print(value);
            setState(() => _filter = value);
          },
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
    return Consumer<ArticlesProvider>(
      builder: (context, model, child) {
        List<Article> articles;

        if (_filter == Filter.read) {
          articles = model.getReadByCategory(category);
        } else if (_filter == Filter.unread) {
          articles = model.getUnreadByCategory(category);
        } else {
          articles = model.getByCategory(category);
        }

        if (articles.isNotEmpty) {
          return Scrollbar(
            child: RefreshIndicator(
              child: ArticleList(articles: articles),
              onRefresh: model.refreshAll,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
