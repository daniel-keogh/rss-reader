import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

import 'package:rssreader/models/article.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';

class NetworkHelper {
  final _client = http.Client();

  Stream<Iterable<Article>> loadFeeds(
    Iterable<Subscription> subscriptions,
  ) async* {
    for (final sub in subscriptions) {
      yield await loadFeed(sub);
    }
  }

  Future<Iterable<Article>> loadFeed(Subscription sub) async {
    try {
      final response = await _client.get(sub.xmlUrl);

      try {
        return _parseRss(response.body, sub);
      } catch (e) {
        return _parseAtom(response.body, sub);
      }
    } catch (e) {
      return [];
    }
  }

  List<Article> _parseRss(String body, Subscription sub) {
    final feed = RssFeed.parse(body);

    final df = DateFormat('EEE, d MMM yyyy HH:mm:ss z');

    return feed.items.map((item) {
      String img;
      if (item.media.contents.isNotEmpty) {
        img = item.media.contents[0].url;
      } else {
        img = item.enclosure?.url;
      }

      return Article(
        subscriptionId: sub.id,
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

      if (item.media.contents.isNotEmpty) {
        img = item.media.contents[0].url;
      }

      return Article(
        subscriptionId: sub.id,
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
      'http://feedly.com/v3/search/feeds?query=$query&count=$count&locale=$locale',
    );

    var searchResults = <SearchResult>[];

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
