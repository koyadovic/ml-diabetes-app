import 'entities.dart';


class MessageSource {
  Function(DiaMessage) _onMessageHandler;

  Future<void> initialize() async {}
  void addMessageHandler(Function(DiaMessage) onMessageHandler) {
    _onMessageHandler = onMessageHandler;
  }
  void _messageReceived(DiaMessage message) {
    print('_messageReceived in MessageSource: $message');
    if(_onMessageHandler != null)
      _onMessageHandler(message);
  }
}

MessageSource getMessagesSource() {
  return _FirebaseMessageSource();
}

/*
 * FIREBASE MESSAGING
 */
class _FirebaseMessageSource extends MessageSource {

  @override
  Future<void> initialize() async {
  }


}

DiaMessage convertFirebaseMessage(Map<String, dynamic> firebaseMessage) {
  String title = firebaseMessage['notification']['title'];
  if(title == null) title = firebaseMessage['data']['title'];
  String subtitle = firebaseMessage['notification']['body'];
  if(subtitle == null) subtitle = firebaseMessage['data']['body'];
  firebaseMessage['data'].remove('title');
  firebaseMessage['data'].remove('body');
  return DiaMessage(title: title, subtitle: subtitle, data: firebaseMessage['data']);
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  DiaMessage diaMessage = convertFirebaseMessage(message);
  print('backgroundMessageHandler() $diaMessage');
}
