import 'package:flutter/material.dart';
import 'package:rssreader/components/article_item.dart';

import 'package:webfeed/domain/rss_feed.dart';

import 'package:rssreader/components/list_drawer.dart';
import 'package:rssreader/models/article.dart';
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
    RssFeed result = await widget.nh.loadFeed();

    if (result.items.length > 0) {
      setState(() {
        feedItems = result.items.map((item) {
          return Article(
            title: item.title,
            imageUrl: item.media.contents[0].url,
            isRead: false,
            publisher: result.title,
            url: item.link,
          );
        }).toList();
      });
    }
  }

  Widget _buildList() {
    return feedItems.length != 0
        ? RefreshIndicator(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ArticleItem(
                  article: feedItems[index],
                  handleTap: () {
                    widget.nh.viewArticle(feedItems[index].url);
                    setState(() {
                      feedItems[index].isRead = true;
                    });
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 0.5,
                );
              },
              itemCount: feedItems.length,
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            onRefresh: refreshFeeds,
          )
        : Center(child: CircularProgressIndicator());
  }

  List<Widget> _appbarActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.done_all),
        tooltip: 'Mark all as read',
        onPressed: () {},
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
