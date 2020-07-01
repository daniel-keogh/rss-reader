import 'dart:io';

import 'package:xml/xml.dart';
import 'package:path_provider/path_provider.dart';

class Subscriptions {
  List<String> feeds = [
    'https://www.theguardian.com/world/zimbabwe/rss',
  ];

  Future<File> export() async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('opml', nest: () {
      builder.attribute('version', '2.0');
      builder.element('head', nest: () {
        builder.element('title', nest: () {
          builder.text('Feed Export');
        });
        builder.element('dateCreated', nest: () {
          builder.text(DateTime.now());
        });
      });

      builder.element('body', nest: () {
        feeds.forEach((element) {
          builder.element('outline', nest: () {
            builder.attribute('text', 'test');
            builder.attribute('title', 'test');
            builder.attribute('type', 'rss');
            builder.attribute('xmlUrl', element);
          });
        });
      });
    });

    final xml = builder.build();
    return await _writeXmlString(xml);
  }

  Future<File> _writeXmlString(XmlNode xml) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory.path}/export.opml');

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
//      final file = File('${directory.path}/export.opml');
//
//      return await file.readAsString();
//    } catch (e) {
//      return null;
//    }
//  }
}
