import 'package:flutter/material.dart';

import 'package:rssreader/screens/recommended/search_item.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/services/networking.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class RecommendedScreen extends StatefulWidget {
  final NetworkHelper nh = NetworkHelper();
  final SubscriptionsDb db = SubscriptionsDb.getInstance();

  final String category;

  RecommendedScreen({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  _RecommendedScreenState createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  List<String> _feeds = [];

  @override
  void initState() {
    super.initState();
    getCurrentSubs();
  }

  Future<void> getCurrentSubs() async {
    var all = await widget.db.getAll();
    _feeds = all.map((e) => e.xmlUrl).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Container(
        child: FutureBuilder(
          future: widget.nh.feedSearch(widget.category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<SearchResult> data = snapshot.data;

              return ListView.builder(
                itemBuilder: (context, index) {
                  return SearchItem(
                    searchResult: data[index],
                    isSubscribed: _feeds.contains(data[index].xmlUrl),
                    onSubscribe: () async {
                      await widget.db.insert(
                        Subscription(
                          title: data[index].title,
                          xmlUrl: data[index].xmlUrl,
                          category: widget.category,
                        ),
                      );
                    },
                    onUnsubscribe: () async {
                      await widget.db.deleteByXmlUrl(data[index].xmlUrl);
                    },
                  );
                },
                itemCount: data == null ? 0 : data.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
