import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rssreader/models/article.dart';
import 'package:webfeed/webfeed.dart';

import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class NetworkHelper {
  final _client = http.Client();
  final _db = SubscriptionsDb.getInstance();

  Future<List<Article>> loadFeeds() async {
    final df = DateFormat("EEE, d MMM yyyy HH:mm:ss z");

    List<Subscription> subscriptions = await _db.getAll();

    List<Article> articles = [];

    for (var sub in subscriptions) {
      try {
        final response = await _client.get(sub.xmlUrl);
        RssFeed feed = RssFeed.parse(response.body);

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
            date: df.parse(item.pubDate),
            category: sub.category,
          );
        }).toList();

        articles.addAll(batch);
      } catch (e) {
        print(e);
      }
    }

    return articles;
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
              publisherImg: item['visualUrl'],
              website: item['website'],
            ),
          )
          .toList();
    }

    return searchResults;
  }
}
