import 'package:flutter/material.dart';

import 'package:rssreader/screens/catalog/catalog_photo.dart';

class CatalogItem extends StatelessWidget {
  final CatalogPhoto photo;
  final Function handleTap;

  CatalogItem({
    Key key,
    @required this.photo,
    @required this.handleTap,
  }) : super(key: key);

  Widget _buildGridTile() {
    return GridTile(
      footer: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(4),
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
        child: Image.asset(
          photo.asset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

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
            color: Colors.transparent,
            child: InkWell(
              onTap: handleTap,
            ),
          ),
        )
      ],
    );
  }
}
