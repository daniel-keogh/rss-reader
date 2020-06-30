import 'package:flutter/material.dart';

import 'package:webfeed/domain/rss_feed.dart';

import 'package:rssreader/components/list_drawer.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/services/networking.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NetworkHelper nh = NetworkHelper();
  List<Article> feedItems = [];

  @override
  void initState() {
    super.initState();
    refreshFeeds();
  }

  Future<void> refreshFeeds() async {
    RssFeed result = await nh.loadFeed();

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
            child: ListView.builder(
              itemBuilder: (context, index) {
                var item = feedItems[index];

                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.publisher),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.imageUrl),
                  ),
                  onTap: () {
                    print(item);
                  },
                );
              },
              itemCount: feedItems.length,
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
