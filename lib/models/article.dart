class Article {
  final String title;
  final String url;
  final String imageUrl;
  final String publisher;
  final DateTime date;
  bool isRead;

  Article({
    this.title,
    this.url,
    this.imageUrl,
    this.publisher,
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
      date: $date,
      isRead: $isRead 
    }""";
  }
}
