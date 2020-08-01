import 'package:flutter/material.dart';

enum Filter {
  read,
  unread,
  all,
}

class FilterButton extends StatelessWidget {
  final Function onSelected;

  final Map<String, Filter> options = {
    'All Articles': Filter.all,
    'Read': Filter.read,
    'Unread': Filter.unread,
  };

  FilterButton({
    Key key,
    @required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Filter>(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filter',
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) {
        return <PopupMenuItem<Filter>>[
          for (final key in options.keys)
            PopupMenuItem(
              child: Text(key),
              value: options[key],
            ),
        ];
      },
    );
  }
}
