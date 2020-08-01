import 'package:flutter/material.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool enabled;
  final int count;
  final List<Widget> actions;
  final Function onClear;

  const SelectionAppBar({
    Key key,
    @required this.title,
    @required this.enabled,
    @required this.count,
    @required this.actions,
    @required this.onClear,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 600),
      firstChild: AppBar(
        title: Text(title),
      ),
      secondChild: AppBar(
        title: Text(count.toString()),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: onClear,
        ),
        backgroundColor: Colors.blueGrey,
        actions: actions,
      ),
      crossFadeState:
          !enabled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
