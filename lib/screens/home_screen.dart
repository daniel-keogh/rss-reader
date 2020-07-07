import 'package:flutter/material.dart';
import 'package:rssreader/components/article_item.dart';

import 'package:webfeed/domain/rss_feed.dart';
import 'package:intl/intl.dart';

import 'package:rssreader/components/list_drawer.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/services/networking.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/';

  final nh = NetworkHelper();
  final df = DateFormat("EEE, d MMM yyyy HH:mm:ss z");

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
    List<RssFeed> result = await widget.nh.loadFeeds();

    result.forEach((feed) {
      if (feed.items.length > 0) {
        List<Article> batch = feed.items.map((item) {
          String img;
          if (item.media.contents.length > 0) {
            img = item.media.contents[0].url;
          } else {
            img = item.enclosure?.url;
          }

          return Article(
            title: item.title,
            imageUrl: img,
            isRead: false,
            publisher: feed.title,
            url: item.link,
            date: widget.df.parse(item.pubDate),
          );
        }).toList();

        setState(() {
          feedItems.addAll(batch);
        });
      }
    });

    setState(() {
      feedItems.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  Widget _buildList() {
    return feedItems.length != 0
        ? Scrollbar(
            child: RefreshIndicator(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var article = feedItems[index];
                  return ArticleItem(
                    article: article,
                    handleTap: () {
                      article.view();
                      setState(() => article.isRead = true);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(thickness: 0.5);
                },
                itemCount: feedItems.length,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: _appbarActions(),
      ),
      drawer: ListDrawer(),
      body: Container(
        child: _buildList(),
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
        return <PopupMenuItem<String>>[
          PopupMenuItem(
            child: Text('Show all'),
            value: 'all',
          ),
          PopupMenuItem(
            child: Text('Show all read'),
            value: 'read',
          ),
          PopupMenuItem(
            child: Text('Show all unread'),
            value: 'unread',
          ),
        ];
      },
    );
  }
}
