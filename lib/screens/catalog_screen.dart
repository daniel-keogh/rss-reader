import 'package:flutter/material.dart';

import 'package:rssreader/components/catalog_item.dart';
import 'package:rssreader/models/catalog_photo.dart';
import 'package:rssreader/screens/recommended_screen.dart';

class CatalogScreen extends StatelessWidget {
  static const String route = '/catalog';

  final List<CatalogPhoto> _photos = [
    CatalogPhoto(
      title: "News",
      asset: "assets/catalog/news.jpg",
    ),
    CatalogPhoto(
      title: "Technology",
      asset: "assets/catalog/tech.jpg",
    ),
    CatalogPhoto(
      title: "Science & Space",
      asset: "assets/catalog/science.jpg",
    ),
    CatalogPhoto(
      title: "Business",
      asset: "assets/catalog/business.jpg",
    ),
    CatalogPhoto(
      title: "Software Development",
      asset: "assets/catalog/software.jpg",
    ),
    CatalogPhoto(
      title: "DIY",
      asset: "assets/catalog/diy.jpg",
    ),
    CatalogPhoto(
      title: "Books",
      asset: "assets/catalog/books.jpg",
    ),
    CatalogPhoto(
      title: "Music",
      asset: "assets/catalog/music.jpg",
    ),
    CatalogPhoto(
      title: "Gaming",
      asset: "assets/catalog/gaming.jpg",
    ),
    CatalogPhoto(
      title: "Sport",
      asset: "assets/catalog/sport.jpg",
    ),
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
      body: GridView.count(
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
    );
  }
}
