import 'package:rssreader/models/article.dart';

class Favourite {
  int id;
  Article _article;

  String get title => _article.title;
  String get url => _article.url;
  String get imageUrl => _article.imageUrl;
  String get publisher => _article.publisher;
  String get date => _article.date.toIso8601String();

  Favourite({
    this.id,
    String title,
    String url,
    String imageUrl,
    String publisher,
    String date,
  }) {
    _article = Article(
      title: title,
      url: url,
      imageUrl: imageUrl,
      publisher: publisher,
      date: DateTime.parse(date),
    );
  }

  Favourite.fromArticle(Article article)
      : this(
          title: article.title,
          url: article.url,
          imageUrl: article.imageUrl,
          publisher: article.publisher,
          date: article.date.toIso8601String(),
        );

  Favourite.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    _article = Article(
      title: map["title"],
      url: map["url"],
      imageUrl: map["imageUrl"],
      publisher: map["publisher"],
      date: DateTime.parse(map["date"]),
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": title,
      "url": url,
      "imageUrl": imageUrl,
      "publisher": publisher,
      "date": date,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  @override
  String toString() {
    return """
    {
      id: $id,
      title: $title, 
      url: $url,
      imageUrl: $imageUrl,
      publisher: $publisher,
      date: $date
    }""";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Favourite &&
          runtimeType == other.runtimeType &&
          _article == other._article;

  @override
  int get hashCode => _article.hashCode;
}
