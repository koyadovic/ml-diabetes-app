import 'package:Dia/shared/view/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'shared/view/utils/theme.dart';
import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/authentication/view/login/screen.dart';
import 'package:Dia/authentication/view/signup/screen.dart';
import 'package:Dia/communications/model/messages.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/user_data/view/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


void main() {
  runApp(DiaApp());
}

class DiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dia',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: DiaTheme.primarySwatch,
        primaryColor: DiaTheme.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(title: 'Dia'),
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: translationApp.supportedLocales(),
    );
  }
}


class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> implements MessagesHandler, ConcreteNavigator {

  final MessageSource messageSource = getMessagesSource();

  List<DiaScreen> _screens = [];
  DiaScreen _currentScreen;
  DiaRootScreenStatefulWidget _currentScreenWidget;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ApiRestBackend _backend;

  @override
  void initState() {
    super.initState();

    // TODO this will be defined from the backend
    // TODO we need to get the value from settings BC and set it globally
    // TODO maybe settings will need to expose some kind of observable/observer pattern to change here the most
    //   recent setting value
    Intl.defaultLocale = 'es';

    DiaMessages.setMessagesHandler(this);
    DiaNavigation.setConcreteNavigator(this);

    messageSource.initialize();
    _backend = ApiRestBackend();
    _backend.initialize().then((_) {
      if (!_backend.isAuthenticated()) {
        requestScreenChange(DiaScreen.LOGIN);
      } else {
        requestScreenChange(DiaScreen.USER_DATA);
      }
    });

  }

  Future<void> showWidget(Widget widget) async {
    print('!!!! showWidget()');
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return WillPopScope(
          onWillPop: () {},
          child: Dialog(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            child: widget
          ),
        );
      }
    );
  }

  Future<void> hideWidget() async {
    print('!!!! hideWidget()');
    Navigator.pop(context);
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
              color: Colors.grey[200],
            ),
          ),
          ListTile(
            selected: _currentScreen == DiaScreen.USER_DATA,
            leading: IconButton(icon: FaIcon(FontAwesomeIcons.home, size: 18, color: _currentScreen == DiaScreen.USER_DATA ? DiaTheme.primaryColor : Colors.black), onPressed: null),
            title: Text('User Data'),
            onTap: () {
              requestScreenChange(DiaScreen.USER_DATA);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: IconButton(icon: FaIcon(FontAwesomeIcons.signOutAlt, size: 18, color: Colors.black), onPressed: null),
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
          actionsIconTheme: IconThemeData(
              color: DiaTheme.primaryColor
          ),
          iconTheme: IconThemeData(
              color: DiaTheme.primaryColor
          ),
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
    if(_currentScreen == DiaScreen.LOGIN || screen == DiaScreen.LOGIN) {
      _screens = [];
    }
    _screens.add(screen);
    switch (screen) {
      case DiaScreen.USER_DATA:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget(this.showWidget, this.hideWidget);
        });
        break;

      case DiaScreen.LOGIN:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = LoginScreenWidget(this.showWidget, this.hideWidget);
        });
        break;

      case DiaScreen.SIGNUP:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = SignupScreenWidget(this.showWidget, this.hideWidget);
        });
        break;

      case DiaScreen.SETTINGS:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget(this.showWidget, this.hideWidget);  // TODO
        });
        break;

      default:
        throw Error();
    }
  }

  Future<bool> backScreen() async {
    if(_screens.length > 1) {
      _screens.removeLast();
      requestScreenChange(_screens.removeLast());
      return false;
    } else {
      return true;
    }
  }

}
