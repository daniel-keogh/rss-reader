import 'package:flutter/material.dart';

import 'package:rssreader/screens/sources/dialog_text_field.dart';

Future<String> showRenameDialog(
  BuildContext context,
  String currentCategory,
) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      String result = '';

      return AlertDialog(
        title: Text('Rename Category'),
        content: DialogTextField(
          initialValue: currentCategory,
          placeholder: currentCategory,
          autoFocus: true,
          onChanged: (value) {
            result = value;
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: const Text('SAVE'),
            onPressed: () {
              Navigator.pop(
                context,
                result.trim().length != 0 && result != currentCategory
                    ? result
                    : null,
              );
            },
          )
        ],
      );
    },
  );
}
