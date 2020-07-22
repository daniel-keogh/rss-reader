import 'package:flutter/material.dart';

import 'package:rssreader/screens/catalog/catalog_item.dart';
import 'package:rssreader/screens/catalog/catalog_photo.dart';
import 'package:rssreader/screens/recommended/recommended_screen.dart';

class CatalogScreen extends StatelessWidget {
  static const String _path = 'assets/catalog';

  final List<CatalogPhoto> _photos = [
    CatalogPhoto(title: "News", asset: "$_path/news.jpg"),
    CatalogPhoto(title: "Technology", asset: "$_path/tech.jpg"),
    CatalogPhoto(title: "Science & Space", asset: "$_path/science.jpg"),
    CatalogPhoto(title: "Business", asset: "$_path/business.jpg"),
    CatalogPhoto(title: "Software Development", asset: "$_path/software.jpg"),
    CatalogPhoto(title: "DIY", asset: "$_path/diy.jpg"),
    CatalogPhoto(title: "Books", asset: "$_path/books.jpg"),
    CatalogPhoto(title: "Music", asset: "$_path/music.jpg"),
    CatalogPhoto(title: "Gaming", asset: "$_path/gaming.jpg"),
    CatalogPhoto(title: "Sport", asset: "$_path/sport.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      body: Scrollbar(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          childAspectRatio: 0.85,
          children: _photos.map<Widget>((photo) {
            return CatalogItem(
              photo: photo,
              handleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecommendedScreen(
                      category: photo.title,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
