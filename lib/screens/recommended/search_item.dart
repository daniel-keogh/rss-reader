import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';

class SearchItem extends StatelessWidget {
  final SearchResult searchResult;
  final String category;

  SearchItem({
    Key key,
    @required this.searchResult,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionsProvider>(
      builder: (context, value, child) => ListTile(
        title: Padding(
          padding: EdgeInsets.only(bottom: 6.0),
          child: Text(
            searchResult.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: searchResult.website != null
            ? Text(Uri.parse(searchResult.website).host)
            : null,
        leading: searchResult.publisherImg != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  searchResult.publisherImg,
                ),
                backgroundColor: Colors.transparent,
              )
            : null,
        trailing: !value.isSubscribed(searchResult.xmlUrl)
            ? IconButton(
                icon: Icon(Icons.add_circle),
                color: Colors.blueAccent,
                onPressed: () => value.add(
                  Subscription(
                    title: searchResult.title,
                    xmlUrl: searchResult.xmlUrl,
                    category: category,
                  ),
                ),
              )
            : IconButton(
                icon: Icon(Icons.check_circle),
                color: Colors.redAccent,
                onPressed: () => value.deleteByXmlUrl(searchResult.xmlUrl),
              ),
      ),
    );
  }
}
