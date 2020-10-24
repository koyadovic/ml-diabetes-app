import 'package:Dia/shared/view/dia_screen_widget.dart';
import 'package:Dia/user_data/view/v1/main.dart';
import 'package:flutter/material.dart';

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

  DiaScreenStatefulWidget _currentScreen;

  @override
  void initState() {
    super.initState();
  }

  Drawer getDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentScreen = UserDataScreenWidget();

    AppBar appBar;
    if (_currentScreen.hasAppBar()) {
      String title = _currentScreen.getAppBarTitle();
      if(title == null || title == '')
        title = widget.title;

      appBar = AppBar(
        title: Text(title),
        actions: _currentScreen.getAppBarActions(),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: _currentScreen,
      drawer: _currentScreen.hasDrawer() ? getDrawer(context) : null,
      floatingActionButton: _currentScreen.getFloatingActionButton(),
    );
  }
}
