abstract class MessagesHandler {
  Future<void> showBriefMessage(String message);
  Future<void> showDialogMessage(String message);
}


class DiaMessages {
  static final DiaMessages _instance = DiaMessages._internal();
  static MessagesHandler _messagesHandler;

  DiaMessages._internal();

  static setMessagesHandler(MessagesHandler handler) {
    if (_messagesHandler == null){
      _messagesHandler = handler;
    } else {
      throw Error();
    }
  }

  static DiaMessages getInstance() => _instance;

  String _lastBriefMessage;
  String _lastDialogMessage;

  Future<void> showBriefMessage(String message) async {
    if(message == _lastBriefMessage) return;
    _lastBriefMessage = message;
    await _messagesHandler.showBriefMessage(message);
  }

  Future<void> showDialogMessage(String message) async {
    if(message == _lastDialogMessage) return;
    _lastDialogMessage = message;
    await _messagesHandler.showDialogMessage(message);
  }

}
