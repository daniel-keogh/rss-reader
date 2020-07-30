import 'package:flutter/material.dart';

class DialogTextField extends StatefulWidget {
  final String initialValue;
  final String placeholder;
  final bool autoFocus;
  final Function onChanged;

  const DialogTextField({
    Key key,
    @required this.initialValue,
    @required this.placeholder,
    @required this.autoFocus,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _DialogTextFieldState createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            autofocus: widget.autoFocus,
            autocorrect: true,
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.placeholder,
            ),
            onChanged: widget.onChanged,
          ),
        )
      ],
    );
  }
}
