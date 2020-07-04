class SearchResult {
  final String title;
  final String description;
  final String xmlUrl;
  final String publisherImg;
  final String website;

  SearchResult({
    this.title,
    this.description,
    this.xmlUrl,
    this.publisherImg,
    this.website,
  });

  @override
  String toString() {
    return """
    {
      title: $title, 
      description: $description,
      xmlUrl: $xmlUrl,
      publisherImg: $publisherImg,
      website: $website
    }""";
  }
}
