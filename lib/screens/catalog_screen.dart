import 'package:flutter/material.dart';

import 'package:rssreader/components/catalog_item.dart';
import 'package:rssreader/models/catalog_photo.dart';
import 'package:rssreader/screens/recommended_screen.dart';

class CatalogScreen extends StatelessWidget {
  final List<CatalogPhoto> _photos = [
    CatalogPhoto(
      title: "News",
      assetName: "assets/catalog/news.jpg",
    ),
    CatalogPhoto(
      title: "Technology",
      assetName: "assets/catalog/tech.jpg",
    ),
    CatalogPhoto(
      title: "Science & Space",
      assetName: "assets/catalog/science.jpg",
    ),
    CatalogPhoto(
      title: "Business",
      assetName: "assets/catalog/business.jpg",
    ),
    CatalogPhoto(
      title: "Software Development",
      assetName: "assets/catalog/software.jpg",
    ),
    CatalogPhoto(
      title: "DIY",
      assetName: "assets/catalog/diy.jpg",
    ),
    CatalogPhoto(
      title: "Books",
      assetName: "assets/catalog/books.jpg",
    ),
    CatalogPhoto(
      title: "Music",
      assetName: "assets/catalog/music.jpg",
    ),
    CatalogPhoto(
      title: "Gaming",
      assetName: "assets/catalog/gaming.jpg",
    ),
    CatalogPhoto(
      title: "Sport",
      assetName: "assets/catalog/sport.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
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
