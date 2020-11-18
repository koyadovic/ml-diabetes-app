import 'package:iDietFit/communications/controller/services.dart';
import 'package:iDietFit/communications/model/entities.dart';
import 'package:iDietFit/communications/view/messages/simple/simple_message.dart';
import 'package:iDietFit/communications/view/messages/suggestions/suggestions_group.dart';
import 'package:flutter/material.dart';


class MessagesWidget extends StatefulWidget {
  final Message message;
  final Function(bool) onFinish;

  MessagesWidget({@required this.message, @required this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return MessagesWidgetState();
  }
}


class MessagesWidgetState extends State<MessagesWidget> {
  CommunicationsServices _services = CommunicationsServices();

  bool get isSimple {
    return ['information', 'warning', 'error'].indexOf(widget.message.type) != -1;
  }
  bool get isSuggestion {
    return widget.message.type == 'suggestions';
  }

  void dismissMessage() async {
    await _services.dismissMessage(widget.message);
    widget.onFinish(true);
  }

  void closeMessage() async {
    if(widget.message.attendImmediately) throw 'Cannot close a message that must be attended immediately';
    widget.onFinish(false);
  }

  @override
  Widget build(BuildContext context) {
    if(isSimple)
      return SimpleMessageWidget(widget.message, dismissMessage, closeMessage);

    if(isSuggestion)
      return SuggestionsGroupMessageWidget(widget.message, dismissMessage, closeMessage);

    return SizedBox.shrink();
  }
}
