import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
//import 'package:url_launcher/url_launcher.dart';

class NetworkHelper {
  static const String FEED_URL = 'https://www.theguardian.com/world/zimbabwe/rss';

  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
  }

  load() async {
    loadFeed().then((result) {
      result.items.forEach((element) { print(element.title); });
    });
  }
}