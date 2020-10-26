import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/navigation.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/several_floating_action_buttons.dart';
import 'package:Dia/user_data/view/timeline/v1_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// ignore: must_be_immutable
class UserDataScreenWidget extends DiaRootScreenStatefulWidget {
  UserDataScreenWidgetState _state;

  UserDataScreenWidget(Navigation navigation, Messages messages) : super(navigation, messages);

  @override
  bool hasAppBar() {
    return true;
  }

  @override
  List<Widget> getAppBarActions() {
    return [];
  }

  @override
  List<Tab> getAppBarTabs() {
    return [
      Tab(icon: IconButton(icon: FaIcon(FontAwesomeIcons.home, color: DiaTheme.primaryColor), onPressed: null)),
    ];
  }

  @override
  Widget getFloatingActionButton() {
    SeveralFloatingActionButton severalFloatingActionButton;
    severalFloatingActionButton = SeveralFloatingActionButton(
      color: DiaTheme.primaryColor,
      floatingActionButtons: [
        FloatingActionButton(
          heroTag: 'activity',
          onPressed: null,
          tooltip: 'Add Activity',
          backgroundColor: DiaTheme.primaryColor,
          child: IconButton(icon: FaIcon(FontAwesomeIcons.dumbbell, color: Colors.white),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              print('Inside');
            },
          ),
        ),
        FloatingActionButton(
          heroTag: 'traits',
          onPressed: null,
          tooltip: 'Add Trait Measure',
          backgroundColor: DiaTheme.primaryColor,
          child: IconButton(icon: FaIcon(FontAwesomeIcons.weight, color: Colors.white),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              print('Inside');
            },
          ),
        ),
        FloatingActionButton(
          heroTag: 'feeding',
          onPressed: null,
          tooltip: 'Add Feeding',
          backgroundColor: DiaTheme.primaryColor,
          child: IconButton(icon: FaIcon(FontAwesomeIcons.pizzaSlice, color: Colors.white),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              print('Inside');
            },
          ),
        ),
        FloatingActionButton(
          heroTag: 'insulin',
          onPressed: null,
          tooltip: 'Add Insulin Injection',
          backgroundColor: DiaTheme.primaryColor,
          child: IconButton(icon: FaIcon(FontAwesomeIcons.syringe, color: Colors.white),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              print('Inside');
            },
          ),
        ),
        FloatingActionButton(
          heroTag: 'glucose',
          onPressed: null,
          tooltip: 'Add Glucose',
          backgroundColor: DiaTheme.primaryColor,
          child: IconButton(icon: FaIcon(FontAwesomeIcons.tint, color: Colors.white),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              print('Inside');
            },
          ),
        ),

      ]
    );
    return severalFloatingActionButton;
  }

  @override
  bool hasDrawer() {
    return true;
  }

  @override
  String getAppBarTitle() {
    return 'User Data';
  }

  @override
  State<StatefulWidget> createState() {
    _state = UserDataScreenWidgetState();
    return _state;
  }

}


class UserDataScreenWidgetState extends State<UserDataScreenWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Timeline(widget.navigation, widget.messages),
      ],
    );
  }

}
