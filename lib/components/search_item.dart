import 'package:flutter/material.dart';

import 'package:rssreader/models/search_result.dart';

class SearchItem extends StatelessWidget {
  final SearchResult searchResult;
  final Function handlePress;

  SearchItem({
    Key key,
    @required this.searchResult,
    @required this.handlePress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(bottom: 6.0),
        child: Text(
          searchResult.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: searchResult.website != null
          ? Text(Uri.parse(searchResult.website).host)
          : null,
      leading: searchResult.publisherImg != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(
                searchResult.publisherImg,
              ),
              backgroundColor: Colors.transparent,
            )
          : null,
      trailing: IconButton(
        icon: Icon(Icons.add_circle),
        color: Colors.blueAccent,
        onPressed: handlePress,
      ),
    );
  }
}
