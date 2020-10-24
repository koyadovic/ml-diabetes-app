import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/screens.dart';
import 'package:Dia/user_data/view/v1/user_data_screen.dart';
import 'package:flutter/material.dart';

import 'authentication/view/login/v1/screen.dart';
import 'authentication/view/signup/v1/screen.dart';

void main() {
  runApp(DiaApp());
}

class DiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MasterPage(title: 'Dia'),
    );
  }
}


class MasterPage extends StatefulWidget {
  MasterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {

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
              color: Colors.blue,
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
