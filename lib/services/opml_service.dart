import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:opml/opml.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rssreader/models/subscription.dart';
import 'package:rssreader/db/subscriptions_db.dart';

class OpmlService {
  OpmlService._();

  static Future<File> export() async {
    final db = SubscriptionsDb();
    final subscriptions = await db.getAll();

    final opmlBody = <OpmlOutline>[];

    Set<String> categories = Set.from(
      subscriptions.map((item) => item.category),
    );

    categories.forEach((category) {
      final feeds = <OpmlOutline>[];

      subscriptions.forEach((sub) {
        if (sub.category == category) {
          feeds.add(
            OpmlOutline(
              type: 'rss',
              text: sub.title,
              title: sub.title,
              xmlUrl: sub.xmlUrl,
            ),
          );
        }
      });

      opmlBody.add(
        OpmlOutline(
          title: category,
          text: category,
          children: feeds,
        ),
      );
    });

    final head = OpmlHead(
      title: 'rssfeed Export',
      dateCreated: DateTime.now().toUtc().toIso8601String(),
    );

    final doc = OpmlDocument(
      head: head,
      body: opmlBody,
    );

    return await _writeDocumentToFile(doc);
  }

  static Future<File> _writeDocumentToFile(OpmlDocument doc) async {
    final directory = await getExternalStorageDirectory();

    final df = DateFormat('yyyy-MM-dd');
    final file = File(
      '${directory.path}/rssreader_${df.format(DateTime.now())}.opml',
    );

    return file.writeAsString(
      doc.toXmlString(pretty: true, indent: '\t'),
    );
  }

  static Future<List<Subscription>> import() async {
    final file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['bin', 'xml'],
    );

    if (file == null) {
      return [];
    }

    try {
      final imported = <Subscription>[];

      final String xml = await file.readAsString();
      final opml = OpmlDocument.parse(xml);

      opml.body.forEach((outline) {
        final category = outline.text ?? outline.title;
        final feeds = outline.children;

        feeds.forEach((feed) {
          if (feed.type == 'rss') {
            imported.add(
              Subscription(
                title: feed.text ?? feed.title,
                category: category ?? 'Uncategorized',
                xmlUrl: feed.xmlUrl,
              ),
            );
          }
        });
      });

      return imported;
    } catch (e) {
      throw 'Failed to import feeds';
    }
  }
}
