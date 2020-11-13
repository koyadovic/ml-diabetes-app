
enum DiaScreen {
  LOGIN,
  SIGNUP,
  USER_DATA,
  FEEDINGS,
  SETTINGS,
}

abstract class ConcreteNavigator {
  void requestScreenChange(DiaScreen screen, {bool andReplaceNavigationHistory: false});
}


class DiaNavigation {
  static final DiaNavigation _instance = DiaNavigation._internal();
  static ConcreteNavigator _navigation;
  
  DiaNavigation._internal();
  
  static setConcreteNavigator(ConcreteNavigator navigation) {
    if (_navigation == null){
      _navigation = navigation;
    } else {
      throw Error();
    }
  }

  static DiaNavigation getInstance() => _instance;

  void requestScreenChange(DiaScreen screen, {bool andReplaceNavigationHistory: false}) => _navigation.requestScreenChange(screen, andReplaceNavigationHistory: andReplaceNavigationHistory);

}
