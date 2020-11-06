import 'package:Dia/communications/model/entities.dart';
import 'package:flutter/material.dart';


class SimpleMessageWidget extends StatelessWidget {
  final Message message;
  final Function onFinished;

  SimpleMessageWidget(this.message, this.onFinished);

  @override
  Widget build(BuildContext context) {
    Icon leading;
    switch(message.type) {
      case 'information':
        leading = Icon(Icons.info);
        break;
      case 'warning':
        leading = Icon(Icons.warning);
        break;
      case 'error':
        leading = Icon(Icons.error);
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        ListTile(
          leading: leading,
          title: Text(message.title),
          subtitle: Text(message.text),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: onFinished,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}