import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/several_floating_action_buttons.dart';
import 'package:Dia/user_data/view/summary/view.dart';
import 'package:Dia/user_data/view/timeline/add_glucose_level.dart';
import 'package:Dia/user_data/view/timeline/add_trait_measure.dart';
import 'package:Dia/user_data/view/timeline/view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'graphs/view.dart';


// ignore: must_be_immutable
class UserDataScreenWidget extends DiaRootScreenStatefulWidget {
  UserDataScreenWidgetState _state;

  UserDataScreenWidget(ShowWidgetCallback showWidgetCallback, HideWidgetCallback hideWidgetCallback) : super(showWidget: showWidgetCallback, hideWidget: hideWidgetCallback);

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
      Tab(icon: IconButton(icon: FaIcon(FontAwesomeIcons.home, size: 18, color: DiaTheme.primaryColor), onPressed: null)),
      Tab(icon: IconButton(icon: FaIcon(FontAwesomeIcons.fileMedicalAlt, size: 18, color: DiaTheme.primaryColor), onPressed: null)),
      Tab(icon: IconButton(icon: FaIcon(FontAwesomeIcons.chartLine, size: 18, color: DiaTheme.primaryColor), onPressed: null)),
    ];
  }

  @override
  Widget getFloatingActionButton() {
    SeveralFloatingActionButton severalFloatingActionButton;
    severalFloatingActionButton = SeveralFloatingActionButton(
      color: DiaTheme.primaryColor,
      backgroundColor: Colors.grey[100],
      floatingActionButtons: [
        FloatingActionButton(
          heroTag: 'traits',
          onPressed: null,
          tooltip: 'Add Trait Measure',
          backgroundColor: Colors.grey[100],
          child: IconButton(
            icon: TraitMeasureIconSmall(),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              showWidget(
                  AddTraitMeasureWidget(selfCloseCallback: (bool reload) {
                    if(reload) {
                      _refresh();
                    }
                    hideWidget();
                  }),
              );
            },
          ),
        ),
        FloatingActionButton(
          heroTag: 'activity',
          onPressed: null,
          tooltip: 'Add Activity',
          backgroundColor: Colors.grey[100],
          child: IconButton(
            icon: ActivityIconSmall(),
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
          backgroundColor: Colors.grey[100],
          child: IconButton(
            icon: FeedingIconSmall(),
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
          backgroundColor: Colors.grey[100],
          child: IconButton(
            icon: InsulinInjectionIconSmall(),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
            },
          ),
        ),
        FloatingActionButton(
          heroTag: 'glucose',
          onPressed: null,
          tooltip: 'Add Glucose',
          backgroundColor: Colors.grey[100],
          child: IconButton(
            icon: GlucoseLevelIconSmall(),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              showWidget(
                AddGlucoseLevelWidget(selfCloseCallback: (bool reload) {
                  if(reload) {
                    _refresh();
                  }
                  hideWidget();
                }),
              );
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

  void _refresh() {
    _state?.refresh();
  }
}


class UserDataScreenWidgetState extends State<UserDataScreenWidget> {

  Timeline timeline;
  Summary summary;
  Graphs graphs;

  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    timeline?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    timeline = Timeline(widget);
    summary = Summary(widget);
    graphs = Graphs(widget);

    return TabBarView(
      children: [
        timeline,
        summary,
        graphs,
      ],
    );
  }

}
