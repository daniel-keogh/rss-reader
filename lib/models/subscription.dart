class Subscription {
  int id;
  String title;
  String category;
  String xmlUrl;

  Subscription({
    this.id,
    this.title,
    this.category,
    this.xmlUrl,
  });

  Subscription.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    category = map["category"];
    xmlUrl = map["xmlUrl"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": title,
      "category": category,
      "xmlUrl": xmlUrl,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  @override
  String toString() {
    return """
    {
      id: $id,
      title: $title, 
      category: $category,
      xmlUrl: $xmlUrl,
    }""";
  }
}
