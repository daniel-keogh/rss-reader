import 'package:flutter/material.dart';
import 'package:rssreader/models/subscription.dart';

enum _Action {
  unsubscribe,
  move,
}

class SelectableTile extends StatelessWidget {
  final Subscription subscription;
  final bool enable;
  final bool isChecked;

  final Function onMove;
  final Function onUnsubscribe;
  final Function onLongPress;
  final Function onChecked;

  const SelectableTile({
    Key key,
    @required this.subscription,
    @required this.enable,
    @required this.isChecked,
    @required this.onChecked,
    @required this.onLongPress,
    @required this.onMove,
    @required this.onUnsubscribe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enable) {
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(subscription.title),
        ),
        subtitle: Text(subscription.xmlUrl),
        isThreeLine: true,
        trailing: PopupMenuButton<_Action>(
          itemBuilder: (context) => _buildPopupItems(),
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
        ),
        onLongPress: onLongPress,
      );
    }

    return CheckboxListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(subscription.title),
      ),
      subtitle: Text(subscription.xmlUrl),
      isThreeLine: true,
      value: isChecked,
      onChanged: onChecked,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  List<PopupMenuItem<_Action>> _buildPopupItems() {
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
