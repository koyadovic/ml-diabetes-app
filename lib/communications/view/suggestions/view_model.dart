import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/src/widgets/framework.dart';


class SuggestionsViewModel extends DiaViewModel {
  final CommunicationsServices _services = CommunicationsServices();
  List<Message> _messages;

  SuggestionsViewModel(State<StatefulWidget> state) : super(state);

  List<Message> get messages {
    if(_messages == null) {
      refreshMessages();
      return [];
    }
    return _messages;
  }

  Future<void> refreshMessages() async {
    List<Message> messages = await _services.getNotDismissedMessages();
    _messages = messages.where((message) => message.type == 'suggestions').toList();
    notifyChanges();
  }

}
