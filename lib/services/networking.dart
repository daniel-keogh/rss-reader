import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rssreader/models/article.dart';
import 'package:webfeed/webfeed.dart';

import 'package:rssreader/db/subscriptions_db.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';

class NetworkHelper {
  final _client = http.Client();
  final _db = SubscriptionsDb();

  Stream<List<Article>> loadFeeds() async* {
    final List<Subscription> subscriptions = await _db.getAll();

    for (final sub in subscriptions) {
      try {
        final response = await _client.get(sub.xmlUrl);

        try {
          yield _parseRss(response.body, sub);
        } catch (e) {
          print("$e: ${sub.title} -- ${sub.xmlUrl}");
          yield _parseAtom(response.body, sub);
        }
      } catch (e) {
        print("$e: ${sub.title} -- ${sub.xmlUrl}");
      }
    }
  }

  List<Article> _parseRss(String body, Subscription sub) {
    final feed = RssFeed.parse(body);

    final df = DateFormat("EEE, d MMM yyyy HH:mm:ss z");

    return feed.items.map((item) {
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
  }

  List<Article> _parseAtom(String body, Subscription sub) {
    final feed = AtomFeed.parse(body);

    return feed.items.map((item) {
      String img;

      if (item.media.contents.length > 0) {
        img = item.media.contents[0].url;
      }

      return Article(
        title: item.title,
        imageUrl: img,
        isRead: false,
        publisher: feed.title,
        url: item.links[0].href,
        date: DateTime.parse(item.updated),
        category: sub.category,
      );
    }).toList();
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
