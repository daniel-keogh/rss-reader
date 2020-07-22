import 'package:flutter/material.dart';

import 'package:rssreader/screens/recommended/search_item.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/services/networking.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class RecommendedScreen extends StatelessWidget {
  final NetworkHelper nh = NetworkHelper();
  final SubscriptionsDb db = SubscriptionsDb.getInstance();

  final String category;

  RecommendedScreen({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Container(
        child: FutureBuilder(
          future: nh.feedSearch(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<SearchResult> data = snapshot.data;

              return ListView.builder(
                itemBuilder: (context, index) {
                  return SearchItem(
                    searchResult: data[index],
                    category: category,
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
