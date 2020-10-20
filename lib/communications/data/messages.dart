import 'package:firebase_messaging/firebase_messaging.dart';

import 'entities.dart';

class MessageSource {
  Function(Message) _onMessageHandler;

  void initialize() {}
  void addMessageHandler(Function(Message) onMessageHandler) {
    _onMessageHandler = onMessageHandler;
  }
  void _messageReceived(Message message) {
    if(_onMessageHandler != null)
      _onMessageHandler(message);
  }
}

MessageSource getMessagesSource() {
  return _FirebaseMessageSource();
}

class _FirebaseMessageSource extends MessageSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initialize() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage $message');
        Message diaMessage = Message(title: message['notification']['title'], subtitle: message['notification']['body'], data: message['data']);
        _messageReceived(diaMessage);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
        Message diaMessage = Message(title: message['notification']['title'], subtitle: message['notification']['body'], data: message['data']);
        _messageReceived(diaMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
        Message diaMessage = Message(title: message['notification']['title'], subtitle: message['notification']['body'], data: message['data']);
        _messageReceived(diaMessage);
      },
      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   Message diaMessage = Message(title: message['notification']['title'], subtitle: message['notification']['body'], data: message['data']);
      //   _messageReceived(diaMessage);
      // },
    );
    /*
    TODO
    Invalid argument(s): Failed to setup background message handler! `onBackgroundMessage`
            should be a TOP-LEVEL OR STATIC FUNCTION and should NOT be tied to a
            class or an anonymous function.
    */

    // TODO iOS
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });
  }
}
