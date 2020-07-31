import 'package:flutter/material.dart';

import 'package:rssreader/screens/sources/dialog_text_field.dart';

Future<String> showCategoryDialog({
  BuildContext context,
  Iterable<String> categories,
  String currentCategory,
}) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      String result = currentCategory;
      String newCategory = '';

      return AlertDialog(
        title: const Text('Select Category'),
        contentPadding: EdgeInsets.only(top: 20.0),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RadioListTile(
                  title: DialogTextField(
                    onChanged: (value) {
                      newCategory = value;
                      setState(() => result = value);
                    },
                    initialValue: '',
                    placeholder: 'New Category',
                    autoFocus: false,
                  ),
                  value: newCategory,
                  groupValue: result,
                  onChanged: (value) {
                    setState(() => result = value);
                  },
                ),
                for (final category in categories)
                  RadioListTile(
                    title: Text(category),
                    value: category,
                    groupValue: result,
                    onChanged: (value) {
                      setState(() => result = value);
                    },
                  ),
              ],
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(null),
          ),
          FlatButton(
            child: const Text('SAVE'),
            onPressed: () => Navigator.of(context).pop(
              result != currentCategory ? result : null,
            ),
          ),
        ],
      );
    },
  );
}
