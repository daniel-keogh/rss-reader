import 'package:flutter/material.dart';

import 'package:rssreader/utils/constants.dart';

class RoundedBottomSheet extends StatelessWidget {
  final List<ListTile> tiles;

  const RoundedBottomSheet({
    Key key,
    @required this.tiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          padding: bottomSheetPadding,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[...tiles],
        )
      ],
    );
  }
}
