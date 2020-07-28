import 'package:rssreader/models/article.dart';

class Favourite {
  int id;
  Article article;

  Favourite({
    this.id,
    String title,
    String url,
    String imageUrl,
    String publisher,
    String date,
  }) {
    article = Article(
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
    article = Article(
      title: map["title"],
      url: map["url"],
      imageUrl: map["imageUrl"],
      publisher: map["publisher"],
      date: DateTime.parse(map["date"]),
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": article.title,
      "url": article.url,
      "imageUrl": article.imageUrl,
      "publisher": article.publisher,
      "date": article.date.toIso8601String(),
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
      title: ${article.title}, 
      url: ${article.url},
      imageUrl: ${article.imageUrl},
      publisher: ${article.publisher},
      date: ${article.date.toIso8601String()}
    }""";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Favourite &&
          runtimeType == other.runtimeType &&
          article == other.article;

  @override
  int get hashCode => article.hashCode;
}
