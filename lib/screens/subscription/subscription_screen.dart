import 'package:flutter/material.dart';

import 'package:rssreader/models/subscription.dart';

class SubscriptionScreen extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionScreen({
    Key key,
    this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subscription.title),
      ),
      body: Container(),
    );
  }
}
