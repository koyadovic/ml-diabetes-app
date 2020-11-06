import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/model/api_rest_backend.dart';


class CommunicationsServices {
  ApiRestBackend _backend;

  CommunicationsServices() {
    _backend = ApiRestBackend();
  }

  Future<List<Message>> getNotDismissedMessages() async {
    String url = '/api/v1/communications/messages/';
    dynamic contents = await _backend.get(url);

    List<Message> messages = [];
    for(var content in contents) {
      messages.add(Message.fromJson(content));
    }
    //return [];
    return messages;
  }

  List<Message> onlySimpleMessages(List<Message> messages) {
    return messages.where((message) => ['information', 'warning', 'error'].indexOf(message.type) != -1).toList();
  }

  List<Message> onlySuggestionMessages(List<Message> messages) {
    return messages.where((message) => message.type == 'suggestions').toList();
  }

  Future<void> dismissMessage(Message message) async {
    String url = '/api/v1/communications/messages/${message.id.toString()}/dismiss/';
    await _backend.post(url, {});
  }

  Future<List<FeedbackRequest>> getUnattendedFeedbackRequests() async {
    String url = '/api/v1/communications/feedbacks/';
    dynamic contents = await _backend.get(url);

    List<FeedbackRequest> requests = [];
    for(var content in contents) {
      requests.add(FeedbackRequest.fromJson(content));
    }
    return requests;
  }

  Future<void> attendFeedbackRequest(FeedbackRequest feedbackRequest, String answer) async {
    String url = '/api/v1/communications/feedbacks/${feedbackRequest.id.toString()}/attend/';
    await _backend.post(url, {'answer': answer});
  }

  Future<void> ignoreFeedbackRequest(FeedbackRequest feedbackRequest) async {
    String url = '/api/v1/communications/feedbacks/${feedbackRequest.id.toString()}/ignore/';
    await _backend.post(url, {});
  }

}
