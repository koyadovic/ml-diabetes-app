import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/src/widgets/framework.dart';


class CommunicationsViewModel extends DiaViewModel {
  final CommunicationsServices _services = CommunicationsServices();
  List<Message> _messages;
  List<FeedbackRequest> _feedbackRequests;

  CommunicationsViewModel(State<StatefulWidget> state) : super(state);

  List<Message> get simpleMessages {
    if(_messages == null) {
      refreshMessages();
      return [];
    }
    return _messages.where(
            (message) => ['information', 'warning', 'error'].indexOf(message.type) != -1
    ).toList();
  }

  List<Message> get suggestions {
    if(_messages == null) {
      refreshMessages();
      return [];
    }
    return _messages.where((message) => message.type == 'suggestions').toList();
  }

  List<FeedbackRequest> get feedbackRequests {
    if(_feedbackRequests == null) {
      refreshFeedbackRequests();
      return [];
    }
    return _feedbackRequests;
  }

  Future<void> refreshMessages() async {
    List<Message> messages = await _services.getNotDismissedMessages();
    _messages = messages;
    notifyChanges();
  }

  Future<void> refreshFeedbackRequests() async {
    _feedbackRequests = await _services.getUnattendedFeedbackRequests();
    notifyChanges();
  }

}

