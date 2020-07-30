import 'package:flutter/material.dart';

import 'package:rssreader/models/catalog_photo.dart';

class CatalogItem extends StatelessWidget {
  final CatalogPhoto photo;
  final Function handleTap;

  CatalogItem({
    Key key,
    @required this.photo,
    @required this.handleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          bottom: 0.0,
          child: _buildGridTile(),
        ),
        Positioned.fill(
          child: Material(
            elevation: 100,
            color: Colors.transparent,
            child: InkWell(
              onTap: handleTap,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGridTile() {
    return GridTile(
      footer: Material(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            bottom: const Radius.circular(4),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: GridTileBar(
          backgroundColor: Colors.black54,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(photo.title),
          ),
        ),
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Hero(
          tag: photo.title,
          child: Image.asset(
            photo.asset,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
