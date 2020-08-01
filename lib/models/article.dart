class Article implements Comparable<Article> {
  int id;
  final int subscriptionId;
  final String title;
  final String url;
  final String imageUrl;
  final String publisher;
  final String category;
  final DateTime date;
  bool isRead;

  Article({
    this.id,
    this.subscriptionId,
    this.title,
    this.url,
    this.imageUrl,
    this.publisher,
    this.category,
    this.date,
    this.isRead,
  });

  Article.fromMap(Map<String, dynamic> map)
      : this(
          id: map["id"],
          subscriptionId: map["subscriptionId"],
          title: map["title"],
          url: map["url"],
          imageUrl: map["imageUrl"],
          publisher: map["publisher"],
          category: map["category"],
          date: DateTime.parse(map["date"]),
          isRead: map["isRead"] == 1 ? true : false,
        );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "subscriptionId": subscriptionId,
      "title": title,
      "url": url,
      "imageUrl": imageUrl,
      "publisher": publisher,
      "category": category,
      "date": date.toIso8601String(),
      "isRead": isRead ? 1 : 0,
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
      id : $id,
      subscriptionId: $subscriptionId,
      title: $title, 
      url: $url,
      imageUrl: $imageUrl,
      publisher: $publisher,
      category: $category,
      date: ${date.toIso8601String()},
      isRead: $isRead 
    }""";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  int compareTo(Article other) {
    return other.date.compareTo(date);
  }
}
