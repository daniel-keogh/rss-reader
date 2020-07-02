import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void viewArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
