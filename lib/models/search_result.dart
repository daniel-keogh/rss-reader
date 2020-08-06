class SearchResult {
  final String title;
  final String xmlUrl;
  final String publisherImg;
  final String website;

  const SearchResult({
    this.title,
    this.xmlUrl,
    this.publisherImg,
    this.website,
  });

  @override
  String toString() {
    return """
    {
      title: $title, 
      xmlUrl: $xmlUrl,
      publisherImg: $publisherImg,
      website: $website
    }""";
  }
}
