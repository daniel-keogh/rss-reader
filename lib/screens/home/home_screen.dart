import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';

import 'package:rssreader/components/side_drawer.dart';
import 'package:rssreader/screens/home/article_item.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';
import 'package:rssreader/services/networking.dart';

class HomeScreen extends StatefulWidget {
  final nh = NetworkHelper();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> feedItems = [];

  @override
  void initState() {
    super.initState();
    refreshFeeds();
  }

  Future<void> refreshFeeds() async {
    List<Article> articles = await widget.nh.loadFeeds();

    setState(() {
      feedItems = articles..sort((a, b) => b.date.compareTo(a.date));
    });
  }

  Widget _buildList(String category) {
    List<Article> articles;

    if (category == 'All') {
      articles = feedItems;
    } else {
      articles = feedItems.where((e) => e.category == category).toList();
    }

    return articles.length != 0
        ? Scrollbar(
            child: RefreshIndicator(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var article = articles[index];

                  return ArticleItem(
                    article: article,
                    handleTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            article: article,
                          ),
                        ),
                      );

                      setState(() => article.isRead = true);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(thickness: 0.5);
                },
                itemCount: articles.length,
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              onRefresh: refreshFeeds,
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  List<Widget> _appbarActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.done_all),
        tooltip: 'Mark all as read',
        onPressed: () {
          setState(() {
            feedItems.forEach((item) => item.isRead = true);
          });
        },
      ),
      _FilterButton(
        onSelected: (value) {},
      ),
      IconButton(
        icon: Icon(Icons.search),
        tooltip: 'Search',
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<SubscriptionsProvider>(context).categories;
    final tabs = ['All', ...categories];

    return DefaultTabController(
      length: categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: _appbarActions(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
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
            for (final tab in tabs) _buildList(tab),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final Function onSelected;

  _FilterButton({
    Key key,
    @required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.filter_list),
      tooltip: 'Filter',
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          for (var i in ['All', 'Read', 'Unread'])
            PopupMenuItem(
              child: Text(i),
              value: i.toLowerCase(),
            ),
        ];
      },
    );
  }
}
