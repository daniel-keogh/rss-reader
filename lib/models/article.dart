class Article implements Comparable<Article> {
  final String title;
  final String url;
  final String imageUrl;
  final String publisher;
  final String category;
  final DateTime date;
  bool isRead;

  Article({
    this.title,
    this.url,
    this.imageUrl,
    this.publisher,
    this.category,
    this.date,
    this.isRead,
  });

  @override
  String toString() {
    return """
    {
      title: $title, 
      url: $url,
      imageUrl: $imageUrl,
      publisher: $publisher,
      category: $category,
      date: $date,
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
