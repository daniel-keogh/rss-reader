import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/providers/articles_provider.dart';
import 'package:rssreader/screens/home/article_search.dart';

enum Filter {
  read,
  unread,
  all,
}

class HomeTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final Filter filter;
  final Function onFilterChanged;

  static const Map<String, Filter> _options = {
    'All Articles': Filter.all,
    'Read': Filter.read,
    'Unread': Filter.unread,
  };

  const HomeTabBar({
    Key key,
    this.tabs,
    this.filter,
    this.onFilterChanged,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(112.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Home'),
          const SizedBox(height: 3),
          Text(
            _getSubtitle(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.done_all),
          tooltip: 'Mark all as read',
          onPressed: () {
            Provider.of<ArticlesProvider>(
              context,
              listen: false,
            ).updateStatus(true);
          },
        ),
        PopupMenuButton<Filter>(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filter',
          padding: EdgeInsets.zero,
          onSelected: onFilterChanged,
          itemBuilder: (context) {
            return <PopupMenuItem<Filter>>[
              for (final key in _options.keys)
                PopupMenuItem(
                  child: Text(key),
                  value: _options[key],
                ),
            ];
          },
        ),
        Consumer<ArticlesProvider>(
          builder: (context, model, child) => IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArticleSearch(
                  articles: model.articles,
                ),
              );
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          width: double.infinity,
          child: TabBar(
            isScrollable: true,
            tabs: <Widget>[
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
      ),
    );
  }

  String _getSubtitle() {
    if (filter == Filter.unread) {
      return "Unread";
    } else if (filter == Filter.read) {
      return "Read";
    }
    return "All Articles";
  }
}
