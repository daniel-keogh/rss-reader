import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
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

      builder.element(
        'body',
        isSelfClosing: false,
        nest: () {
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
        },
      );
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

  Future import() async {
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['opml', 'xml'],
    );

    try {
      String xml = await file.readAsString();
      XmlDocument doc = parse(xml);

      XmlElement opml = doc.findElements('opml').first;
      XmlElement body = opml.findElements('body').first;

      body.findElements('outline').forEach((outline) {
        XmlAttribute category = outline.attributes.firstWhere(
          (element) => element.name == XmlName.fromString('text'),
          orElse: () => null,
        );

        outline.findElements('outline').forEach((item) async {
          Map<String, String> attributes = {};

          item.attributes.forEach(
            (attr) => attributes[attr.name.toString()] = attr.value,
          );

          await _db.insert(
            Subscription(
              title: attributes['title'],
              xmlUrl: attributes['xmlUrl'],
              category: category?.value ?? 'Uncategorized',
            ),
          );
        });
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
