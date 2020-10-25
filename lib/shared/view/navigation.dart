
enum DiaScreen {
  LOGIN,
  SIGNUP,
  USER_DATA,
  SETTINGS,
}

abstract class Navigation {
  void requestScreenChange(DiaScreen screen);
}
