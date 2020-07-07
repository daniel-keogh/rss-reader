class CatalogPhoto {
  final String asset;
  final String title;

  const CatalogPhoto({
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
