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
        print(message);
        Message diaMessage = Message(title: 'title', subtitle: 'subtitle', data: message);
        _messageReceived(diaMessage);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
        Message diaMessage = Message(title: 'title', subtitle: 'subtitle', data: message);
        _messageReceived(diaMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
        Message diaMessage = Message(title: 'title', subtitle: 'subtitle', data: message);
        _messageReceived(diaMessage);
      },
    );

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
