import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/several_floating_action_buttons.dart';
import 'package:Dia/user_data/view/summary/view.dart';
import 'package:Dia/user_data/view/shared/add_activity.dart';
import 'package:Dia/user_data/view/shared/add_glucose_level.dart';
import 'package:Dia/user_data/view/shared/add_insulin_injection.dart';
import 'package:Dia/user_data/view/shared/add_trait_measure.dart';
import 'package:Dia/user_data/view/timeline/view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'graphs/view.dart';


// ignore: must_be_immutable
class UserDataScreenWidget extends DiaRootScreenStatefulWidget {
  UserDataScreenWidgetState _state;

  UserDataScreenWidget(ShowWidget showWidget, HideWidget hideWidget) : super(showWidget: showWidget, hideWidget: hideWidget);

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
              showWidget(AddTraitMeasureWidget(selfCloseCallback: (bool reload) {
                if(reload) _refresh();
                hideWidget();
              }));
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
              showWidget(AddActivityWidget(selfCloseCallback: (bool reload) {
                if(reload) _refresh();
                hideWidget();
              }));
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
              showWidget(AddInsulinInjectionWidget(selfCloseCallback: (bool reload) {
                if(reload) _refresh();
                hideWidget();
              }));
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
              showWidget(AddGlucoseLevelWidget(selfCloseCallback: (bool reload) {
                if(reload) _refresh();
                hideWidget();
              }));
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
    /*
    TODO get unattended feedback requests
    TODO get not dismissed messages
    TODO in messages will be suggestions

    Hay que pensar cómo encerramos to.do en communications
    Quizá podamos llamar aquí directamente a services y proveer con los datos
    A los widgets expuestos en communications. Estos si no le son provisto datos
    los recuperan ellos.
    Tiene que ser 1 único widget a través del cual atender to.do lo que uno tiene
    Si no, no se puede cerrar.
     */

    Future.delayed(Duration(seconds: 1), () async {
      await widget.showWidget(ListView(
        children: [
          Text('lalala1'),
          FlatButton(child: Text('Close'), onPressed: widget.hideWidget)
        ],
      ));
      await widget.showWidget(ListView(
        children: [
          Text('lalala2'),
          FlatButton(child: Text('Close'), onPressed: widget.hideWidget)
        ],
      ));
    });


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
