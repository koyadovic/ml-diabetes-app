import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';


Future<void> withBackendErrorHandlers(Function function) async {
  try {
    await function();
  } on NotLoggedIn catch (err) {
    DiaNavigation.getInstance().requestScreenChange(DiaScreen.LOGIN);
  } on BackendUnavailable catch (err) {
    DiaMessages.getInstance().showInformation('Dia Services are unavailable. Try again later.');
  } on BackendCriticalError catch (err) {
    DiaMessages.getInstance().showInformation('Unexpected Error. Try again later.');
  }
}
