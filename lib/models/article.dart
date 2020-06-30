class Article {
  final String title;
  final String url;
  final String imageUrl;
  final String publisher;
  bool isRead;

  Article({
    this.title,
    this.url,
    this.imageUrl,
    this.publisher,
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
      isRead: $isRead 
    }""";
  }
}
