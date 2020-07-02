import 'dart:convert';

import 'package:flutter/material.dart';

class RecommendedScreen extends StatefulWidget {
  final String category;

  const RecommendedScreen({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  _RecommendedScreenState createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Container(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString(
            'assets/sources.json',
          ),
          builder: (context, snapshot) {
            List<dynamic> data = json.decode(snapshot.data.toString());

            if (data != null) {
              data.removeWhere((item) => item['category'] != widget.category);
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("title: " + data[index]['title']),
                      Text("xmlUrl: " + data[index]['xmlUrl']),
                      Text("category: " + data[index]['category']),
                    ],
                  ),
                );
              },
              itemCount: data == null ? 0 : data.length,
            );
          },
        ),
      ),
    );
  }
}
