import 'package:flutter/material.dart';

import 'package:rssreader/components/search_item.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/services/networking.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class RecommendedScreen extends StatefulWidget {
  final String category;

  RecommendedScreen({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  _RecommendedScreenState createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  final NetworkHelper nh = NetworkHelper();
  final SubscriptionsDb db = SubscriptionsDb.getInstance();
  final List<String> feeds = [];

  @override
  void initState() {
    super.initState();
    getCurrentSubs();
  }

  Future getCurrentSubs() async {
    var all = await db.getAll();
    setState(() {
      feeds.addAll(all.map((e) => e.xmlUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Container(
        child: FutureBuilder(
          future: nh.feedSearch(widget.category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<SearchResult> data = snapshot.data;

              return ListView.builder(
                itemBuilder: (context, index) {
                  return SearchItem(
                    searchResult: data[index],
                    isSubscribed: feeds.contains(data[index].xmlUrl),
                    handleSub: () async {
                      await db.insert(Subscription(
                        title: data[index].title,
                        xmlUrl: data[index].xmlUrl,
                        category: widget.category,
                      ));
                    },
                    handleUnsub: () async {
                      await db.deleteByXmlUrl(data[index].xmlUrl);
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
