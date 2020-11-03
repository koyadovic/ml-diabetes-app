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
      return _SuggestionsGroupMessageWidget(widget.message, dismissMessage);

    return SizedBox.shrink();
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

class _SuggestionsGroupMessageWidget extends StatefulWidget {
  final Message message;
  final Function onFinished;

  _SuggestionsGroupMessageWidget(this.message, this.onFinished);

  @override
  State<StatefulWidget> createState() {
    return _SuggestionsGroupMessageWidgetState();
  }
}

class _SuggestionsGroupMessageWidgetState extends State<_SuggestionsGroupMessageWidget> {
  List<Suggestion> _suggestions = [];

  @override
  void initState() {
    _suggestions = widget.message.payload['suggestions'].map((Map<String, dynamic> serializedSuggestion) => Suggestion.fromJson(serializedSuggestion));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ..._suggestions.map((suggestion) => _SuggestionWidget(suggestion)).toList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                print('Done');
              },
            ),
          ],
        )
      ],
    );
  }
}


class _SuggestionWidget extends StatefulWidget {
  final Suggestion suggestion;

  _SuggestionWidget(this.suggestion);

  @override
  State<StatefulWidget> createState() {
    return _SuggestionWidgetState();
  }
}


class _SuggestionWidgetState extends State<_SuggestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.suggestion.details),
        // TODO show generic entry widget about the entity.
        //  A click must go to the editor defined in user data
      ],
    );
  }
}
