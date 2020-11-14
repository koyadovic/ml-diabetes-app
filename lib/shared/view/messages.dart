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

  Future<void> showBriefMessage(String message) async {
    await _messagesHandler.showBriefMessage(message);
  }

  Future<void> showDialogMessage(String message) async {
    await _messagesHandler.showDialogMessage(message);
  }

}
