import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/authentication/view/login/v1_screen.dart';
import 'package:Dia/authentication/view/signup/v1_screen.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/user_data/view/v1_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> implements Messages, Navigation {

  List<DiaScreen> _screens = [];
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
            leading: IconButton(icon: FaIcon(FontAwesomeIcons.home, color: _currentScreen == DiaScreen.USER_DATA ? DiaTheme.primaryColor : Colors.black), onPressed: null),
            title: Text('User Data'),
            onTap: () {
              requestScreenChange(DiaScreen.USER_DATA);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: IconButton(icon: FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.black), onPressed: null),
            onTap: () async {
              final AuthenticationServices authenticationServices = AuthenticationServices();
              await authenticationServices.logout();
              showInformation('See you soon!');
              _screens = [];
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
          backgroundColor: Colors.grey[200],
          title: Text(title, style: TextStyle(color: DiaTheme.primaryColor)),
          actions: _currentScreenWidget.getAppBarActions(),
          bottom: TabBar(
            tabs: _currentScreenWidget.getAppBarTabs()
          ),
        );

        return WillPopScope(
          onWillPop: backScreen,
          child: DefaultTabController(
            length: _currentScreenWidget.getAppBarTabs().length,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: appBar,
              body: _currentScreenWidget,
              drawer: _currentScreenWidget.hasDrawer() ? getDrawer(context) : null,
              floatingActionButton: _currentScreenWidget.getFloatingActionButton(),
            ),
          ),
        );

      } else {
        appBar = AppBar(
          title: Text(title),
          actions: _currentScreenWidget.getAppBarActions(),
        );
      }
    }
    return WillPopScope(
      onWillPop: backScreen,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appBar,
        body: _currentScreenWidget,
        drawer: _currentScreenWidget.hasDrawer() ? getDrawer(context) : null,
        floatingActionButton: _currentScreenWidget.getFloatingActionButton(),
      ),
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
    _screens.add(screen);
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
        throw Error();
    }
  }

  Future<bool> backScreen() async {
    print('backScreen() Screens length: ' + _screens.length.toString());
    if(_screens.length > 1) {
      _screens.removeLast();
      requestScreenChange(_screens.removeLast());
      return false;
    } else {
      return true;
    }
  }

}
