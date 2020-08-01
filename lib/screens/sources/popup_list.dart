import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum _Action {
  unsubscribe,
  move,
}

class PopupList extends StatelessWidget {
  final Function onMove;
  final Function onUnsubscribe;

  const PopupList({
    Key key,
    @required this.onMove,
    @required this.onUnsubscribe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Action>(
      itemBuilder: (context) => _buildItems(),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case _Action.move:
            onMove();
            break;
          case _Action.unsubscribe:
            onUnsubscribe();
            break;
          default:
            break;
        }
      },
    );
  }

  List<PopupMenuItem<_Action>> _buildItems() {
    return <PopupMenuItem<_Action>>[
      PopupMenuItem<_Action>(
        value: _Action.move,
        child: ListTile(
          title: const Text('Move'),
          leading: const Icon(Icons.edit),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      PopupMenuItem<_Action>(
        value: _Action.unsubscribe,
        child: ListTile(
          title: const Text('Unsubscribe'),
          leading: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    ];
  }
}
