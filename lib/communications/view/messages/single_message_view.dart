import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final Function onDismiss;

  MessageWidget({@required this.message, @required this.onDismiss});

  @override
  State<StatefulWidget> createState() {
    return MessageWidgetState();
  }
}

class MessageWidgetState extends State<MessageWidget> {
  CommunicationsServices _services = CommunicationsServices();

  bool get isSimple {
    return ['information', 'warning', 'error'].indexOf(widget.message.type) != -1;
  }
  bool get isSuggestion {
    return widget.message.type == 'suggestions';
  }

  dismissMessage() async {
    await _services.dismissMessage(widget.message);
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    if(isSimple)
      return _SimpleMessageWidget(widget.message, dismissMessage);

    if(isSuggestion)
      return _SuggestionsMessageWidget(widget.message, dismissMessage);

  }
}

class _SimpleMessageWidget extends StatelessWidget {
  final Message message;
  final Function onFinished;

  _SimpleMessageWidget(this.message, this.onFinished);

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

// TODO queda terminarlo.
class _SuggestionsMessageWidget extends StatefulWidget {
  final Message message;
  final Function onFinished;

  _SuggestionsMessageWidget(this.message, this.onFinished);

  @override
  State<StatefulWidget> createState() {
    return _SuggestionsMessageWidgetState();
  }
}

class _SuggestionsMessageWidgetState extends State<_SuggestionsMessageWidget> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
