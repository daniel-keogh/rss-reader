class CatalogPhoto {
  String asset;
  String title;

  CatalogPhoto({
    this.asset,
    this.title,
  });

  @override
  String toString() {
    return """
    {
      asset: $asset,
      title: $title, 
    }""";
  }
}
