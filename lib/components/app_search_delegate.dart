import 'package:flutter/material.dart';

abstract class AppSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      AnimatedOpacity(
        opacity: query.isEmpty ? 0.0 : 1.0,
        duration: Duration(milliseconds: 200),
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.primaryTextTheme.headline5.color.withOpacity(0.75),
        ),
      ),
      textTheme: theme.textTheme.copyWith(
        headline5: theme.textTheme.headline5.copyWith(
          color: theme.primaryTextTheme.headline5.color,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }
}
