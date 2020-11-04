import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/communications/view/feedback_requests/single_feedback_request_view.dart';
import 'package:Dia/communications/view/messages/messages_view.dart';
import 'package:Dia/shared/view/error_handlers.dart';
import 'package:Dia/shared/view/screen_widget.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/dia_fa_icons.dart';
import 'package:Dia/shared/view/widgets/several_floating_action_buttons.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:Dia/user_data/view/shared/parent_editor_widget.dart';
import 'package:Dia/user_data/view/summary/view.dart';
import 'package:Dia/user_data/view/shared/activity_editor.dart';
import 'package:Dia/user_data/view/shared/glucose_level_editor.dart';
import 'package:Dia/user_data/view/shared/insulin_injection_editor.dart';
import 'package:Dia/user_data/view/shared/trait_measure_editor.dart';
import 'package:Dia/user_data/view/timeline/view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'graphs/view.dart';


// ignore: must_be_immutable
class UserDataScreenWidget extends DiaRootScreenStatefulWidget {
  UserDataScreenWidgetState _state;
  UserDataServices _userDataServices = UserDataServices();

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
              TraitMeasure traitMeasure = TraitMeasure(eventDate: DateTime.now());
              showWidget(
                ParentEditorWidget(
                  child: TraitMeasureEditorWidget(
                    traitMeasureForEdition: traitMeasure,
                    selfCloseCallback: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: () => hideWidget()),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      await _userDataServices.saveTraitMeasure(traitMeasure);
                      _state.refresh();
                      _state.refreshCommunications();
                      hideWidget();
                    }),
                  ],
                ),
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
              Activity activity = Activity(eventDate: DateTime.now());
              showWidget(
                ParentEditorWidget(
                  child: ActivityEditorWidget(
                    activityForEdition: activity,
                    selfCloseCallback: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: () => hideWidget()),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      await _userDataServices.saveActivity(activity);
                      _state.refresh();
                      _state.refreshCommunications();
                      hideWidget();
                    }),
                  ],
                ),
              );
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
              InsulinInjection insulinInjection = InsulinInjection(eventDate: DateTime.now());
              showWidget(
                ParentEditorWidget(
                  child: InsulinInjectionEditorWidget(
                    insulinInjectionForEdition: insulinInjection,
                    selfCloseCallback: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: hideWidget),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      await _userDataServices.saveInsulinInjection(insulinInjection);
                      _state.refresh();
                      _state.refreshCommunications();
                      hideWidget();
                    }),
                  ],
                ),
              );
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
              GlucoseLevel glucoseLevel = GlucoseLevel(eventDate: DateTime.now());
              showWidget(
                ParentEditorWidget(
                  child: GlucoseLevelEditorWidget(
                    glucoseLevelForEdition: glucoseLevel,
                    selfCloseCallback: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: hideWidget),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      await _userDataServices.saveGlucoseLevel(glucoseLevel);
                      _state.refresh();
                      _state.refreshCommunications();
                      hideWidget();
                    }),
                  ],
                ),
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
}


class UserDataScreenWidgetState extends State<UserDataScreenWidget> with WidgetsBindingObserver {

  Timeline timeline;
  Summary summary;
  Graphs graphs;

  CommunicationsServices _communicationsServices = CommunicationsServices();

  @override
  void initState() {
    refreshCommunications();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // this executes when the state is initialized and also when the app comes
    // to foreground from the background.
    // here we refresh pending messages, feedback requests, etc.
    if (state == AppLifecycleState.resumed) {
      refreshCommunications();
    }
  }

  void refreshCommunications() async {
    Future.delayed(Duration(milliseconds: 500), () async {
      // Messages
      await withBackendErrorHandlers(() async {
        List<Message> messages = await _communicationsServices.getNotDismissedMessages();
        // first we show suggestions
        for(Message message in _communicationsServices.onlySuggestionMessages(messages)) {
          await widget.showWidget(MessagesWidget(message: message, onDismiss: widget.hideWidget));
        }
        // then show simple messages
        for(Message message in _communicationsServices.onlySimpleMessages(messages)) {
          await widget.showWidget(MessagesWidget(message: message, onDismiss: widget.hideWidget));
        }
      });

      bool reloadAgain = false;

      // Feedback Requests
      await withBackendErrorHandlers(() async {
        List<FeedbackRequest> feedbackRequests = await _communicationsServices.getUnattendedFeedbackRequests();
        for(FeedbackRequest request in feedbackRequests) {
          await widget.showWidget(FeedbackRequestWidget(request: request, onFinish: (reload){
            if(reload && !reloadAgain) reloadAgain = true;
            widget.hideWidget();
          }));
        }
      });

      if(reloadAgain)
        refreshCommunications();
    });
  }

  void refresh() {
    Future.delayed(Duration(milliseconds: 500), () async {
      timeline?.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    widget._state = this;

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
