import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/services/opml_service.dart';
import 'package:rssreader/utils/routes.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 280.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              'Add some feeds to get started.',
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
            const SizedBox(height: 26.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Text(
                      'Import OPML',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    highlightedBorderColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    onPressed: () async {
                      final subs = await OpmlService.import();

                      Provider.of<SubscriptionsProvider>(
                        context,
                        listen: false,
                      ).addAll(subs);
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: OutlineButton(
                    child: Text(
                      'Catalog',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    highlightedBorderColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    onPressed: () => Navigator.of(context).pushNamed(
                      Routes.catalog,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
