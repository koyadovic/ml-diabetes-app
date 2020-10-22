import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
import 'entities.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<DiaMessage> didReceiveLocalNotificationSubject = BehaviorSubject<DiaMessage>();
final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');
const MethodChannel platform2 = MethodChannel('plugins.flutter.io/firebase_messaging');
const MethodChannel platform3 = MethodChannel('plugins.flutter.io/firebase_messaging_background');


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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Future<void> initialize() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        DiaMessage diaMessage = convertFirebaseMessage(message);
        print('onMessage() message received $diaMessage');
        _messageReceived(diaMessage);
      },
      onLaunch: (Map<String, dynamic> message) async {
        DiaMessage diaMessage = convertFirebaseMessage(message);
        print('onLaunch() message received $diaMessage');
        _messageReceived(diaMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        DiaMessage diaMessage = convertFirebaseMessage(message);
        print('onResume() message received $diaMessage');
        _messageReceived(diaMessage);
      },
      onBackgroundMessage: backgroundMessageHandler,
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
