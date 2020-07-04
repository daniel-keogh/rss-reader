import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class NetworkHelper {
  final _client = http.Client();
  final _db = SubscriptionsDb.getInstance();

  Future<List<RssFeed>> loadFeeds() async {
    List<Subscription> subscriptions = await _db.getAll();

    List<RssFeed> feeds = [];
    for (var sub in subscriptions) {
      try {
        final response = await _client.get(sub.xmlUrl);
        feeds.add(RssFeed.parse(response.body));
      } catch (e) {
        print(e);
      }
    }

    return feeds;
  }

  Future viewArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<List<SearchResult>> feedSearch(
    String query, [
    int count = 20,
    String locale = 'en',
  ]) async {
    query = Uri.encodeComponent(query.toLowerCase());

    var res = await _client.get(
      "http://feedly.com/v3/search/feeds?query=$query&count=$count&locale=$locale",
    );

    List<SearchResult> searchResults = [];

    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      searchResults = data['results']
          .map<SearchResult>(
            (item) => SearchResult(
              title: item['title'],
              xmlUrl: item['feedId'].toString().substring(5),
              description: item['description'],
              publisherImg: item['visualUrl'],
              website: item['website'],
            ),
          )
          .toList();
    }

    return searchResults;
  }
}
