import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> listTiles;

  SettingsSection({
    Key key,
    @required this.title,
    @required this.listTiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) => listTiles[index],
          itemCount: listTiles.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
