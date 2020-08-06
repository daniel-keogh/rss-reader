import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';

class SearchItem extends StatelessWidget {
  final SearchResult searchResult;
  final String category;

  const SearchItem({
    Key key,
    @required this.searchResult,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              searchResult.title,
              style: const TextStyle(
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
                  backgroundColor: Colors.black.withOpacity(0.1),
                )
              : null,
          trailing: Consumer<SubscriptionsProvider>(
            builder: (context, model, child) => AnimatedSwitcher(
              child: !model.isSubscribed(searchResult.xmlUrl)
                  ? IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Subscribe',
                      color: Colors.blueAccent,
                      key: ValueKey(1),
                      onPressed: () => model.add(
                        Subscription(
                          title: searchResult.title,
                          xmlUrl: searchResult.xmlUrl,
                          category: category,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      tooltip: 'Unsubscribe',
                      color: Colors.redAccent,
                      key: ValueKey(2),
                      onPressed: () =>
                          model.deleteByXmlUrl(searchResult.xmlUrl),
                    ),
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
