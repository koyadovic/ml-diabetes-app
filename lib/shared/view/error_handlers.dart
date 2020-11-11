import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:easy_localization/easy_localization.dart';


Future<void> withBackendErrorHandlersOnView(Function function, {bool unauthorizedToLogin: true}) async {
  try {
    await function();
  } on NotLoggedIn catch (err) {
    DiaNavigation.getInstance().requestScreenChange(DiaScreen.LOGIN);
  } on BackendUnavailable catch (err) {
    DiaMessages.getInstance().showInformation('Dia Services are unavailable. Try again later.'.tr());
  } on BackendCriticalError catch (err) {
    DiaMessages.getInstance().showInformation('Unexpected Error. Try again later.'.tr());
  } on BackendUnauthorized catch (e) {
    if(unauthorizedToLogin) {
      DiaMessages.getInstance().showInformation('We need you to authenticate again.');
      DiaNavigation.getInstance().requestScreenChange(DiaScreen.LOGIN);
    } else {
      throw e;
    }
  }
}
