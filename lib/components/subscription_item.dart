import 'package:flutter/material.dart';

import 'package:rssreader/models/subscription.dart';

class SubscriptionItem extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionItem({
    Key key,
    @required this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subscription.title),
      onLongPress: () {},
    );
  }
}
