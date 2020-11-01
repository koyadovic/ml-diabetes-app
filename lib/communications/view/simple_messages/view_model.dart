import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/src/widgets/framework.dart';

class SimpleMessagesViewModel extends DiaViewModel {
  final CommunicationsServices _services = CommunicationsServices();
  List<Message> _messages;

  SimpleMessagesViewModel(State<StatefulWidget> state) : super(state);

  List<Message> get messages {
    if(_messages == null) {
      refreshMessages();
      return [];
    }
    return _messages;
  }
  
  Future<void> refreshMessages() async {
    List<Message> messages = await _services.getNotDismissedMessages();
    _messages = messages.where(
      (message) => ['information', 'warning', 'error'].indexOf(message.type) != -1
    ).toList();
    notifyChanges();
  }
    
}

