class Subscription {
  final String title;
  final String category;
  final String xmlUrl;

  Subscription({
    this.title,
    this.category,
    this.xmlUrl,
  });

  @override
  String toString() {
    return """
    {
      title: $title, 
      category: $category,
      xmlUrl: $xmlUrl,
    }""";
  }
}
