import 'package:Dia/shared/model/api_rest_repository.dart';
import 'package:Dia/shared/view/dia_screen_widget.dart';
import 'package:Dia/user_data/view/v1/user_data_screen.dart';
import 'package:flutter/material.dart';

import 'authentication/view/v1/login_screen.dart';

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

enum DiaScreen {
  AUTHENTICATE,
  USER_DATA,
  SETTINGS,
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
  ApiRestRepository _repository;

  @override
  void initState() {
    super.initState();

    _repository = ApiRestRepository();
    _repository.initialize().then((_) {
      if (!_repository.isAuthenticated()) {
        changeCurrentScreen(DiaScreen.AUTHENTICATE);
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
          _currentScreenWidget = UserDataScreenWidget();
        });
        break;

      case DiaScreen.AUTHENTICATE:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = LoginScreenWidget();
        });
        break;

      case DiaScreen.SETTINGS:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget();  // TODO
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
