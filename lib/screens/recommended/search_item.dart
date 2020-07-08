import 'package:flutter/material.dart';

import 'package:rssreader/models/search_result.dart';

class SearchItem extends StatefulWidget {
  final SearchResult searchResult;
  final bool isSubscribed;
  final Function onSubscribe;
  final Function onUnsubscribe;

  SearchItem({
    Key key,
    @required this.searchResult,
    @required this.isSubscribed,
    @required this.onSubscribe,
    @required this.onUnsubscribe,
  }) : super(key: key);

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  bool isSubscribed;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.isSubscribed;
  }

  void toggleIsSubscribed() {
    setState(() {
      isSubscribed = !isSubscribed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(bottom: 6.0),
        child: Text(
          widget.searchResult.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: widget.searchResult.website != null
          ? Text(Uri.parse(widget.searchResult.website).host)
          : null,
      leading: widget.searchResult.publisherImg != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(
                widget.searchResult.publisherImg,
              ),
              backgroundColor: Colors.transparent,
            )
          : null,
      trailing: !isSubscribed
          ? IconButton(
              icon: Icon(Icons.add_circle),
              color: Colors.blueAccent,
              onPressed: () {
                widget.onSubscribe();
                toggleIsSubscribed();
              },
            )
          : IconButton(
              icon: Icon(Icons.check_circle),
              color: Colors.redAccent,
              onPressed: () {
                widget.onUnsubscribe();
                toggleIsSubscribed();
              },
            ),
    );
  }
}
