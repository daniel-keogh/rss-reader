import 'package:flutter/material.dart';

import 'package:rssreader/screens/category//search_item.dart';
import 'package:rssreader/models/catalog_photo.dart';
import 'package:rssreader/models/search_result.dart';
import 'package:rssreader/services/networking.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final CatalogPhoto photo;

  CategoryScreen({
    Key key,
    @required this.category,
    @required this.photo,
  }) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final NetworkHelper _nh = NetworkHelper();

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: FadeTransition(
                opacity: _animation,
                child: Text(widget.category),
              ),
              background: Hero(
                tag: widget.photo.title,
                child: Image.asset(
                  widget.photo.asset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverSafeArea(
            sliver: FutureBuilder(
              future: _nh.feedSearch(widget.category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<SearchResult> data = snapshot.data;

                  return (data != null && data.length > 0)
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => SearchItem(
                              searchResult: data[index],
                              category: widget.category,
                            ),
                            childCount: data.length,
                          ),
                        )
                      : SliverFillRemaining(
                          hasScrollBody: false,
                          child: const Center(
                            child: const Text('No results found.'),
                          ),
                        );
                } else {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Center(
                      child: const CircularProgressIndicator(),
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
