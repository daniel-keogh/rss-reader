import 'package:flutter/material.dart';

class RoundedBottomSheet extends StatelessWidget {
  final List<ListTile> children;

  const RoundedBottomSheet({
    Key key,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[...children],
        )
      ],
    );
  }
}
