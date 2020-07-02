class CatalogPhoto {
  String assetName;
  String title;

  CatalogPhoto({
    this.assetName,
    this.title,
  });

  @override
  String toString() {
    return """
    {
      assetName: $assetName,
      title: $title, 
    }""";
  }
}
