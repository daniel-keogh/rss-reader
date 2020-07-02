import 'dart:io';

import 'package:xml/xml.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class Opml {
  static final _db = SubscriptionsDb.getInstance();

  Future<File> export() async {
    List<Subscription> subscriptions = await _db.getAll();

    Set<String> categories = Set.from(
      subscriptions.map((item) => item.category),
    );

    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('opml', nest: () {
      builder.attribute('version', '2.0');
      builder.element('head', nest: () {
        builder.element('title', nest: () {
          builder.text('rssfeed export');
        });
        builder.element('dateCreated', nest: () {
          builder.text(DateTime.now());
        });
      });

      builder.element('body', nest: () {
        categories.forEach((category) {
          builder.element('outline', nest: () {
            builder.attribute('text', category);
            builder.attribute('title', category);

            subscriptions.forEach((sub) {
              if (sub.category == category) {
                builder.element('outline', nest: () {
                  builder.attribute('text', sub.title);
                  builder.attribute('title', sub.title);
                  builder.attribute('type', 'rss');
                  builder.attribute('xmlUrl', sub.xmlUrl);
                });
              }
            });
          });
        });
      });
    });

    final xml = builder.build();
    return await _writeXmlString(xml);
  }

  Future<File> _writeXmlString(XmlNode xml) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory.path}/subscriptions.opml');

    return file.writeAsString(
      xml.toXmlString(
        pretty: true,
        indent: '\t',
      ),
    );
  }

//  Future<String> _readXml() async {
//    try {
//      final directory = await getExternalStorageDirectory();
//      final file = File('${directory.path}/subscriptions.opml');
//
//      return await file.readAsString();
//    } catch (e) {
//      return null;
//    }
//  }
}
