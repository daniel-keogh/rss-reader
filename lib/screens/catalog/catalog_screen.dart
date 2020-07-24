import 'package:flutter/material.dart';

import 'package:rssreader/models/catalog_photo.dart';
import 'package:rssreader/screens/catalog/catalog_item.dart';
import 'package:rssreader/screens/category/category_screen.dart';

class CatalogScreen extends StatelessWidget {
  static const String _path = 'assets/catalog';

  final List<CatalogPhoto> _photos = [
    const CatalogPhoto(
      title: "News",
      asset: "$_path/news.jpg",
    ),
    const CatalogPhoto(
      title: "Technology",
      asset: "$_path/tech.jpg",
    ),
    const CatalogPhoto(
      title: "Science & Space",
      asset: "$_path/science.jpg",
    ),
    const CatalogPhoto(
      title: "Business",
      asset: "$_path/business.jpg",
    ),
    const CatalogPhoto(
      title: "Software Development",
      asset: "$_path/software.jpg",
    ),
    const CatalogPhoto(
      title: "DIY",
      asset: "$_path/diy.jpg",
    ),
    const CatalogPhoto(
      title: "Books",
      asset: "$_path/books.jpg",
    ),
    const CatalogPhoto(
      title: "Music",
      asset: "$_path/music.jpg",
    ),
    const CatalogPhoto(
      title: "Gaming",
      asset: "$_path/gaming.jpg",
    ),
    const CatalogPhoto(
      title: "Sport",
      asset: "$_path/sport.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
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
          padding: const EdgeInsets.all(8),
          childAspectRatio: 0.85,
          children: [
            for (final photo in _photos)
              CatalogItem(
                photo: photo,
                handleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                        category: photo.title,
                        photo: photo,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
