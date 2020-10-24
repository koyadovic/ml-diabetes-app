import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/authentication/view/login/v1_screen.dart';
import 'package:Dia/authentication/view/signup/v1_screen.dart';
import 'package:Dia/main/view/theme.dart';
import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:Dia/user_data/view/v1_screen.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  DiaScreen _currentScreen;
  DiaScreenStatefulWidget _currentScreenWidget;
  ApiRestBackend _backend;

  @override
  void initState() {
    super.initState();

    _backend = ApiRestBackend();
    _backend.initialize().then((_) {
      if (!_backend.isAuthenticated()) {
        changeCurrentScreen(DiaScreen.LOGIN);
      } else {
        changeCurrentScreen(DiaScreen.USER_DATA);
      }
    });
  }

  void changeCurrentScreen(DiaScreen screen) {
    if(screen == _currentScreen) return;

    switch (screen) {
      case DiaScreen.USER_DATA:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget(changeCurrentScreen);
        });
        break;

      case DiaScreen.LOGIN:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = LoginScreenWidget(changeCurrentScreen);
        });
        break;

      case DiaScreen.SIGNUP:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = SignupScreenWidget(changeCurrentScreen);
        });
        break;

      case DiaScreen.SETTINGS:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget(changeCurrentScreen);  // TODO
        });
        break;

      default:
        return null;
    }
  }

  Drawer getDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: DiaTheme.primaryColor,
            ),
          ),
          ListTile(
            selected: _currentScreen == DiaScreen.USER_DATA,
            title: Text('User Data'),
            onTap: () {
              changeCurrentScreen(DiaScreen.USER_DATA);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              final AuthenticationServices authenticationServices = AuthenticationServices();
              await authenticationServices.logout();
              changeCurrentScreen(DiaScreen.LOGIN);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentScreenWidget == null)
      return Center(child: CircularProgressIndicator());

    AppBar appBar;
    if (_currentScreenWidget.hasAppBar()) {
      String title = _currentScreenWidget.getAppBarTitle();
      if(title == null || title == '')
        title = widget.title;

      appBar = AppBar(
        title: Text(title),
        actions: _currentScreenWidget.getAppBarActions(),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: _currentScreenWidget,
      drawer: _currentScreenWidget.hasDrawer() ? getDrawer(context) : null,
      floatingActionButton: _currentScreenWidget.getFloatingActionButton(),
    );
  }
}
