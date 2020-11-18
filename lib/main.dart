import 'package:Dia/settings/controller/services.dart';
import 'package:Dia/settings/view/screen.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/utils/unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'communications/model/entities.dart';
import 'communications/view/messages/simple/simple_message.dart';
import 'feedings/view/screen.dart';
import 'shared/view/theme.dart';
import 'package:Dia/authentication/controller/services.dart';
import 'package:Dia/authentication/view/login/screen.dart';
import 'package:Dia/authentication/view/signup/screen.dart';
import 'package:Dia/communications/model/messages.dart';
import 'package:Dia/shared/view/theme.dart';
import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/user_data/view/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:easy_localization/easy_localization.dart';


Future<List<int>> loadTZDatabase() async {
  var byteData = await rootBundle.load('assets/db/2020d_all.tzf');
  return byteData.buffer.asUint8List();
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadTZDatabase().then((rawData) {
    tz.initializeDatabase(rawData);
    tz.initializeTimeZones();
  });
  runApp(
      EasyLocalization(
          supportedLocales: [Locale('en'), Locale('es')],
          path: 'assets/translations',
          saveLocale: true,
          child: DiaApp()
      )
  );
}

class DiaApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DiaAppState();
  }
}

class DiaAppState extends State<DiaApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: DiaTheme.primarySwatch,
        primaryColor: DiaTheme.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Dia',
      home: MainScreen(title: 'Dia'),
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
  SettingsServices settingServices = SettingsServices();
  final MessageSource messageSource = getMessagesSource();

  List<DiaScreen> _screens = [];
  DiaScreen _currentScreen;
  DiaRootScreenStatefulWidget _currentScreenWidget;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ApiRestBackend _backend;

  final SettingsServices settingsServices = SettingsServices();

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  void setLanguage(String lang) {
    context.locale = Locale(lang);
    Intl.defaultLocale = lang;
    Future.delayed(Duration(milliseconds: 200), () {
      rebuildAllChildren(context);
    });
  }

  @override
  void initState() {
    super.initState();

    settingsServices.addLanguageChangeListener(() async {
      String lang = await settingsServices.getLanguage();
      setLanguage(lang);
    });

    DiaMessages.setMessagesHandler(this);
    DiaNavigation.setConcreteNavigator(this);

    messageSource.initialize();
    _backend = ApiRestBackend();
    _backend.initialize().then((_) {
      if (!_backend.isAuthenticated()) {
        requestScreenChange(DiaScreen.LOGIN);
      } else {
        // this follows language changes, set the locale and rebuild all the widgets to
        // apply new translations to whole app.
        settingsServices.getLanguage().then(setLanguage);
        requestScreenChange(DiaScreen.USER_DATA);
      }
    });
  }

  Future<dynamic> showWidget(Widget widget) async {
    unFocus(context);
    return await showDialog(
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
    Navigator.pop(context);
    unFocus(context);
  }

  ListTile buildDrawerItem(DiaScreen diaScreen, String text, IconData iconData, Function onTap) {
    return ListTile(
      selected: _currentScreen == diaScreen,
      leading: IconButton(icon: FaIcon(iconData, size: 18, color: _currentScreen == diaScreen ? DiaTheme.primaryColor : Colors.black), onPressed: null),
      title: Text(text),
      onTap: onTap,
    );
  }

  Drawer getDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png', width: 100),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
          ),
          buildDrawerItem(DiaScreen.USER_DATA, 'User Data', FontAwesomeIcons.home, () {
            requestScreenChange(DiaScreen.USER_DATA);
            Navigator.pop(context);
          }),
          buildDrawerItem(DiaScreen.SETTINGS, 'Settings', FontAwesomeIcons.wrench, () {
            requestScreenChange(DiaScreen.SETTINGS);
            Navigator.pop(context);
          }),
          buildDrawerItem(DiaScreen.LOGIN, 'Logout', FontAwesomeIcons.signOutAlt, () async {
            final AuthenticationServices authenticationServices = AuthenticationServices();
            await authenticationServices.logout();
            showBriefMessage('See you soon!'.tr());
            _screens = [];
            requestScreenChange(DiaScreen.LOGIN);
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentScreenWidget == null)
      return Center(child: CircularProgressIndicator());

    AppBar appBar;
    IconThemeData actionsIconTheme = IconThemeData(color: DiaTheme.primaryColor);
    IconThemeData iconTheme = IconThemeData(color: DiaTheme.primaryColor);
    Color backgroundColor = Colors.grey[200];
    List<Widget> appBarActions = _currentScreenWidget.getAppBarActions();
    PreferredSizeWidget appBarBottom = _currentScreenWidget.getAppBarTabs() != null ? TabBar(tabs: _currentScreenWidget.getAppBarTabs()) : null;

    String title = '';
    if (_currentScreenWidget.hasAppBar()) {
      title = _currentScreenWidget.getAppBarTitle();
      if (title == null || title == '')
        title = widget.title;
    }

    appBar = AppBar(
      actionsIconTheme: actionsIconTheme,
      iconTheme: iconTheme,
      backgroundColor: backgroundColor,
      title: Text(title, style: TextStyle(color: DiaTheme.primaryColor, fontSize: mediumSize(context))),
      actions: appBarActions,
      bottom: appBarBottom,
    );

    Scaffold scaffold = Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: _currentScreenWidget,
      drawer: _currentScreenWidget.hasDrawer() ? getDrawer(context) : null,
      floatingActionButton: _currentScreenWidget.getFloatingActionButton(),
    );

    if (_currentScreenWidget.hasAppBar() && _currentScreenWidget.getAppBarTabs() != null) {
      return WillPopScope(
        onWillPop: backScreen,
        child: DefaultTabController(
          length: _currentScreenWidget.getAppBarTabs().length,
          child: scaffold,
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: backScreen,
        child: scaffold,
      );
    }
  }

  @override
  Future<void> showBriefMessage(String message) async {
    int seconds = ((message.split(' ').length / 2.0) + 1.0).ceil();
    Duration duration = Duration(seconds: seconds);
    SnackBar bar = SnackBar(content: Text('$message'), duration: duration);
    _scaffoldKey.currentState.showSnackBar(bar);
    return;
  }

  @override
  Future<void> showDialogMessage(String message) async {
    Message messageInstance = Message(type: Message.TYPE_INFORMATION, title: 'Information'.tr(), text: message);
    showWidget(SimpleMessageWidget(
      messageInstance,
      () {
        hideWidget();
      }
    ));
    return;
  }

  @override
  void requestScreenChange(DiaScreen screen, {bool andReplaceNavigationHistory: false}) async {
    unFocus(context);
    if(screen == _currentScreen) return;
    if(_currentScreen == DiaScreen.LOGIN || screen == DiaScreen.LOGIN) {
      _screens = [];
    }

    if(_currentScreen == DiaScreen.LOGIN && (screen != DiaScreen.LOGIN && screen != DiaScreen.SIGNUP)) {
      String lang = await settingsServices.getLanguage();
      setLanguage(lang);
      await Future.delayed(Duration(milliseconds: 300), () {});
      DiaMessages.getInstance().showBriefMessage('Welcome!'.tr());
    }

    if(andReplaceNavigationHistory) {
      _screens = [screen];
    } else {
      _screens.add(screen);
    }

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
          _currentScreenWidget = SettingsScreenWidget(this.showWidget, this.hideWidget);
        });
        break;

      case DiaScreen.FEEDINGS:
        this.setState(() {
          _currentScreen = screen;
          _currentScreenWidget = FeedingsScreenWidget(this.showWidget, this.hideWidget);
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
