import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/authentication/view/login/v1_screen.dart';
import 'package:Dia/authentication/view/signup/v1_screen.dart';
import 'package:Dia/main/view/theme.dart';
import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/user_data/view/v1_screen.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> implements Messages, Navigation {

  DiaScreen _currentScreen;
  DiaRootScreenStatefulWidget _currentScreenWidget;
  ApiRestBackend _backend;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _backend = ApiRestBackend();
    _backend.initialize().then((_) {
      if (!_backend.isAuthenticated()) {
        requestScreenChange(DiaScreen.LOGIN);
      } else {
        requestScreenChange(DiaScreen.USER_DATA);
      }
    });
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
              requestScreenChange(DiaScreen.USER_DATA);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              final AuthenticationServices authenticationServices = AuthenticationServices();
              await authenticationServices.logout();
              showInformation('See you soon!');
              requestScreenChange(DiaScreen.LOGIN);
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

      if(_currentScreenWidget.getAppBarTabs() != null) {
        appBar = AppBar(
          title: Text(title),
          actions: _currentScreenWidget.getAppBarActions(),
          bottom: TabBar(
            tabs: _currentScreenWidget.getAppBarTabs()
          ),
        );

        return DefaultTabController(
          length: _currentScreenWidget.getAppBarTabs().length,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: appBar,
            body: _currentScreenWidget,
            drawer: _currentScreenWidget.hasDrawer() ? getDrawer(context) : null,
            floatingActionButton: _currentScreenWidget.getFloatingActionButton(),
          ),
        );

      } else {
        appBar = AppBar(
          title: Text(title),
          actions: _currentScreenWidget.getAppBarActions(),
        );
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: _currentScreenWidget,
      drawer: _currentScreenWidget.hasDrawer() ? getDrawer(context) : null,
      floatingActionButton: _currentScreenWidget.getFloatingActionButton(),
    );

  }

  @override
  Future<void> showInformation(String message) async {
    int seconds = ((message.split(' ').length / 2.0) + 1.0).ceil();
    Duration duration = Duration(seconds: seconds);
    SnackBar bar = SnackBar(content: Text('$message'), duration: duration);
    _scaffoldKey.currentState.showSnackBar(bar);
    return;
  }

  @override
  void requestScreenChange(DiaScreen screen) {
    if(screen == _currentScreen) return;

    switch (screen) {
      case DiaScreen.USER_DATA:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget(this, this);
        });
        break;

      case DiaScreen.LOGIN:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = LoginScreenWidget(this, this);
        });
        break;

      case DiaScreen.SIGNUP:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = SignupScreenWidget(this, this);
        });
        break;

      case DiaScreen.SETTINGS:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget(this, this);  // TODO
        });
        break;

      default:
        return null;
    }
  }

}
