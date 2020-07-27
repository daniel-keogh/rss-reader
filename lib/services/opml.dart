import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/db/subscriptions_db.dart';

class Opml {
  static Future<File> export() async {
    final _db = SubscriptionsDb();
    List<Subscription> subscriptions = await _db.getAll();

    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element('opml', nest: () {
      builder.attribute('version', '2.0');

      builder.element(
        'head',
        isSelfClosing: false,
        nest: () {
          builder.element('title', nest: () {
            builder.text('rssfeed Export');
          });
          builder.element('dateCreated', nest: () {
            builder.text(DateTime.now().toUtc().toIso8601String());
          });
        },
      );

      builder.element(
        'body',
        isSelfClosing: false,
        nest: () {
          Set<String> categories = Set.from(
            subscriptions.map((item) => item.category),
          );

          categories.forEach((category) {
            builder.element('outline', nest: () {
              builder.attribute('text', category);
              builder.attribute('title', category);

              subscriptions.forEach((sub) {
                if (sub.category == category) {
                  builder.element('outline', nest: () {
                    builder.attribute('type', 'rss');
                    builder.attribute('text', sub.title);
                    builder.attribute('title', sub.title);
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
    return await _writeXmlToFile(xml);
  }

  static Future<File> _writeXmlToFile(XmlNode xml) async {
    final directory = await getExternalStorageDirectory();

    final df = DateFormat('yyyy-MM-dd');
    final file = File(
      '${directory.path}/rssreader_${df.format(DateTime.now())}.opml',
    );

    return file.writeAsString(
      xml.toXmlString(
        pretty: true,
        indent: '\t',
      ),
    );
  }

  static Future<List<Subscription>> import() async {
    final List<Subscription> imported = [];

    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['bin', 'xml'],
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

        outline.findElements('outline').forEach((item) {
          Map<String, String> attributes = {};

          item.attributes.forEach(
            (attr) => attributes[attr.name.toString()] = attr.value,
          );

          if (attributes['type'] == 'rss') {
            imported.add(
              Subscription(
                title: attributes['text'] ?? attributes['title'],
                category: category?.value ?? 'Uncategorized',
                xmlUrl: attributes['xmlUrl'],
              ),
            );
          }
        });
      });
    } catch (e) {
      print(e);
    }

    return imported;
  }
}
