import 'dart:async';

import 'package:Dia/shared/model/api_rest_backend.dart';

import 'entities.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class MessageSource {
  // Function(Message) _onMessageWhenForegroundHandler;
  // Function(Message) _onMessageFromNotificationBarHandler;

  Future<void> initialize() async {}

  // void onMessageWhenForeground(Function(Message) onMessageHandler) {
  //   _onMessageWhenForegroundHandler = onMessageHandler;
  // }
  //
  // void onMessageFromNotificationBar(Function(Message) onMessageHandler) {
  //   _onMessageFromNotificationBarHandler = onMessageHandler;
  // }
  //
  // void _messageWhenForeground(Message message) {
  //   print("_messageWhenForeground: $message");
  //   if(_onMessageWhenForegroundHandler != null)
  //     _onMessageWhenForegroundHandler(message);
  // }
  //
  // void _messageFromNotificationBar(Message message) {
  //   print("_messageFromNotificationBar: $message");
  //   if(_onMessageFromNotificationBarHandler != null)
  //     _onMessageFromNotificationBarHandler(message);
  // }

}

MessageSource getMessagesSource() {
  return _FirebaseMessageSource();
}

/*
 * FIREBASE MESSAGING
 */
class _FirebaseMessageSource extends MessageSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  ApiRestBackend _backend = ApiRestBackend();
  Timer _waitUntilAuthenticated;

  @override
  Future<void> initialize() async {
    await _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var data = message['data'] ?? message;
        // print('onMessage $data');
        return convertFirebaseMessage(data);
      },
      onLaunch: (Map<String, dynamic> message) async {
        var data = message['data'] ?? message;
        // print('onLaunch $data');
        return convertFirebaseMessage(data);
      },
      onResume: (Map<String, dynamic> message) async {
        var data = message['data'] ?? message;
        // print('onResume $data');
        return convertFirebaseMessage(data);
      },
    );

    if(_waitUntilAuthenticated == null) {
      _waitUntilAuthenticated = Timer.periodic(Duration(seconds: 2), (Timer t) async {
        if (_backend.isAuthenticated()) {
          String token = await _firebaseMessaging.getToken();
          if(token != null && token != '') {
            await _backend.post('/api/v1/communications/receiver-details/', {'token': token});
            _waitUntilAuthenticated.cancel();
          }
        }
      });
    }
  }

  Message convertFirebaseMessage(Map<String, dynamic> firebaseMessage) {
    // print('convertFirebaseMessage');
    return Message(
        title: firebaseMessage['title'],
        text: firebaseMessage['body'],
        type: firebaseMessage['type'],
        payload: firebaseMessage['payload']
    );
  }

}
