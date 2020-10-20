import 'package:Dia/shared/data/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'entities.dart';

class MessageSource {
  Function(Message) _onMessageHandler;

  Future<void> initialize() async {}
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

/*
 * FIREBASE MESSAGING
 */
class _FirebaseMessageSource extends MessageSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Future<void> initialize() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage $message');
        Message diaMessage = convertFirebaseMessage(message);
        _messageReceived(diaMessage);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
        Message diaMessage = convertFirebaseMessage(message);
        _messageReceived(diaMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
        Message diaMessage = convertFirebaseMessage(message);
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

    // Storage storage = getLocalStorage();
    // List<dynamic> messages = await storage.get('pending-messages');
    // if (messages != null) {
    //
    //   List<Message> diaMessages = List<Message>.from(
    //       messages.map((message) => convertFirebaseMessage(message))
    //   );
    //
    //   diaMessages.forEach((diaMessage) {
    //     _messageReceived(diaMessage);
    //   });
    // }
    // await storage.set('pending-messages', []);
  }

  Message convertFirebaseMessage(Map<String, dynamic> firebaseMessage) {
    return Message(
        title: firebaseMessage['notification']['title'],
        subtitle: firebaseMessage['notification']['body'],
        data: firebaseMessage['data']
    );
  }

}
