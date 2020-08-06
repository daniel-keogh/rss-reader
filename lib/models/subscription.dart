class Subscription implements Comparable<Subscription> {
  int id;
  final String title;
  String category;
  final String xmlUrl;

  Subscription({
    this.id,
    this.title,
    this.category,
    this.xmlUrl,
  });

  Subscription.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'],
          title: map['title'],
          category: map['category'],
          xmlUrl: map['xmlUrl'],
        );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'category': category,
      'xmlUrl': xmlUrl,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  int compareTo(Subscription other) {
    return title.toLowerCase().compareTo(other.title.toLowerCase());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          xmlUrl == other.xmlUrl;

  @override
  int get hashCode => title.hashCode ^ xmlUrl.hashCode;

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
