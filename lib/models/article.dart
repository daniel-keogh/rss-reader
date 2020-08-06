class Article implements Comparable<Article> {
  int id;
  final int subscriptionId;
  final String title;
  final String url;
  final String imageUrl;
  final DateTime date;
  bool isRead;
  final String publisher;
  String category;

  Article({
    this.id,
    this.subscriptionId,
    this.title,
    this.url,
    this.imageUrl,
    this.date,
    this.isRead,
    this.publisher,
    this.category,
  });

  Article.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'],
          subscriptionId: map['subscriptionId'],
          title: map['title'],
          url: map['url'],
          imageUrl: map['imageUrl'],
          date: DateTime.parse(map['date']),
          isRead: map['isRead'] == 1,
          publisher: map['publisher'],
          category: map['category'],
        );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'subscriptionId': subscriptionId,
      'title': title,
      'url': url,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'isRead': isRead ? 1 : 0,
    };

    if (id != null) {
      map['id'] = id;
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
      date: ${date.toIso8601String()},
      isRead: $isRead,
      publisher: $publisher,
      category: $category
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
