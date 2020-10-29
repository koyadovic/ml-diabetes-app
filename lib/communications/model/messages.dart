import 'entities.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  final dynamic data = message['data'] ?? message;
  final dynamic notification = message['notification'] ?? message;
  print('myBackgroundMessageHandler data: $data');
  print('myBackgroundMessageHandler notification: $notification');
}


class MessageSource {
  Function(Message) _onMessageHandler;

  Future<void> initialize() async {}
  void addMessageHandler(Function(Message) onMessageHandler) {
    _onMessageHandler = onMessageHandler;
  }

  void _messageReceived(Message message) {
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Future<void> initialize() async {
    await _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var data = message['data'] ?? message;
        print("onMessage: $data");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        var data = message['data'] ?? message;
        print("onLaunch: $data");
      },
      onResume: (Map<String, dynamic> message) async {
        var data = message['data'] ?? message;
        print("onResume: $data");
      },
    );
  }


}

Message convertFirebaseMessage(Map<String, dynamic> firebaseMessage) {
  String title = firebaseMessage['notification']['title'];
  if(title == null) title = firebaseMessage['data']['title'];
  String subtitle = firebaseMessage['notification']['body'];
  if(subtitle == null) subtitle = firebaseMessage['data']['body'];
  firebaseMessage['data'].remove('title');
  firebaseMessage['data'].remove('body');
  return Message(title: title, text: subtitle, payload: firebaseMessage['data']);
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  Message diaMessage = convertFirebaseMessage(message);
  print('backgroundMessageHandler() $diaMessage');
}
