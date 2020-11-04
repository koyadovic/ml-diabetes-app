import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/communications/view/messages/simple/simple_message.dart';
import 'package:Dia/communications/view/messages/suggestions/suggestions_group.dart';
import 'package:flutter/material.dart';


class MessagesWidget extends StatefulWidget {
  final Message message;
  final Function onDismiss;

  MessagesWidget({@required this.message, @required this.onDismiss});

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

  dismissMessage() async {
    await _services.dismissMessage(widget.message);
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    if(isSimple)
      return SimpleMessageWidget(widget.message, dismissMessage);

    if(isSuggestion)
      return SuggestionsGroupMessageWidget(widget.message, dismissMessage);

    return SizedBox.shrink();
  }
}
