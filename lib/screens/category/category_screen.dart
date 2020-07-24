import 'package:flutter/material.dart';

import 'package:rssreader/screens/category//search_item.dart';
import 'package:rssreader/models/catalog_photo.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/services/networking.dart';
import 'package:rssreader/services/subscriptions_db.dart';

class CategoryScreen extends StatelessWidget {
  final NetworkHelper nh = NetworkHelper();
  final SubscriptionsDb db = SubscriptionsDb.getInstance();

  final String category;
  final CatalogPhoto photo;

  CategoryScreen({
    Key key,
    @required this.category,
    @required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(category),
              background: Hero(
                tag: photo.title,
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverSafeArea(
            sliver: FutureBuilder(
              future: nh.feedSearch(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<SearchResult> data = snapshot.data;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => SearchItem(
                        searchResult: data[index],
                        category: category,
                      ),
                      childCount: data == null ? 0 : data.length,
                    ),
                  );
                } else {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
