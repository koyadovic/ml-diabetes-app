import 'package:Dia/shared/view/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
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

    /*
    Usa communication services para traerse mensajes.
    Si existen mensajes, crea el overlay para verlos.
    El widget de communications tendrá que ofrecer pasarle un callback para cuando
    to do sea finalizado y se puedan recargar los mensajes
     */
  }

  OverlayEntry _overlayEntry;

  void showWidgetCallback(Widget w, WidgetPosition position) {
    print('!!!! showWidgetCallback()');
    this._overlayEntry = this._createOverlayEntry(w, position);
    Overlay.of(context).insert(this._overlayEntry);
  }

  void hideWidgetCallback() {
    print('!!!! hideWidgetCallback()');
    try {
      this._overlayEntry?.remove();
    } catch (e) {}
    this._overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(Widget w, WidgetPosition position) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    MainAxisAlignment alignment;
    switch(position) {
      case WidgetPosition.TOP:
        alignment = MainAxisAlignment.start;
        break;
      case WidgetPosition.CENTER:
        alignment = MainAxisAlignment.center;
        break;
      case WidgetPosition.BOTTOM:
        alignment = MainAxisAlignment.end;
        break;
      default:
        alignment = MainAxisAlignment.center;
    }

    return OverlayEntry(
      builder: (context) => Positioned(
        height: size.height,
        width: size.width,
        child: Container(
          color: Colors.black26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: alignment,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 36.0, 12.0, 12.0),
                child: Dialog(
                  elevation: 2.0,
                  child: w
                )
              )
            ],
          ),
        ),
      )
    );
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
            leading: IconButton(icon: DiaMediumFaIcon(FontAwesomeIcons.home, color: _currentScreen == DiaScreen.USER_DATA ? DiaTheme.primaryColor : Colors.black), onPressed: null),
            title: Text('User Data'),
            onTap: () {
              requestScreenChange(DiaScreen.USER_DATA);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: IconButton(icon: DiaMediumFaIcon(FontAwesomeIcons.signOutAlt, color: Colors.black), onPressed: null),
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
          _currentScreenWidget = UserDataScreenWidget(this.showWidgetCallback, this.hideWidgetCallback);
        });
        break;

      case DiaScreen.LOGIN:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = LoginScreenWidget(this.showWidgetCallback, this.hideWidgetCallback);
        });
        break;

      case DiaScreen.SIGNUP:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = SignupScreenWidget(this.showWidgetCallback, this.hideWidgetCallback);
        });
        break;

      case DiaScreen.SETTINGS:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = UserDataScreenWidget(this.showWidgetCallback, this.hideWidgetCallback);  // TODO
        });
        break;

      default:
        throw Error();
    }
  }

  Future<bool> backScreen() async {
    if(this._overlayEntry != null) {
      // if overlay is currently opened, ignore back button.
      // users must attend the current opened dialog
      return false;
    } else {
      if(_screens.length > 1) {
        _screens.removeLast();
        requestScreenChange(_screens.removeLast());
        return false;
      } else {
        return true;
      }
    }
  }

}
