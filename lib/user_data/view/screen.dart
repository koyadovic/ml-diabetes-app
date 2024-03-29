import 'package:iDietFit/authentication/controller/services.dart';
import 'package:iDietFit/communications/controller/services.dart';
import 'package:iDietFit/communications/model/entities.dart';
import 'package:iDietFit/communications/view/feedback_requests/single_feedback_request_view.dart';
import 'package:iDietFit/communications/view/messages/messages_view.dart';
import 'package:iDietFit/shared/services/storage.dart';
import 'package:iDietFit/shared/view/error_handlers.dart';
import 'package:iDietFit/shared/view/screen_widget.dart';
import 'package:iDietFit/shared/view/theme.dart';
import 'package:iDietFit/shared/view/messages.dart';
import 'package:iDietFit/shared/view/utils/navigation.dart';
import 'package:iDietFit/shared/view/widgets/dia_fa_icons.dart';
import 'package:iDietFit/shared/view/widgets/several_floating_action_buttons.dart';
import 'package:iDietFit/user_data/controller/services.dart';
import 'package:iDietFit/user_data/model/entities/activities.dart';
import 'package:iDietFit/user_data/model/entities/glucose.dart';
import 'package:iDietFit/user_data/model/entities/insulin.dart';
import 'package:iDietFit/user_data/model/entities/traits.dart';
import 'package:iDietFit/user_data/view/shared/parent_editor_widget.dart';
import 'package:iDietFit/user_data/view/summary/view.dart';
import 'package:iDietFit/user_data/view/shared/activity_editor.dart';
import 'package:iDietFit/user_data/view/shared/glucose_level_editor.dart';
import 'package:iDietFit/user_data/view/shared/insulin_injection_editor.dart';
import 'package:iDietFit/user_data/view/shared/trait_measure_editor.dart';
import 'package:iDietFit/user_data/view/timeline/view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart';
import 'graphs/view.dart';


// ignore: must_be_immutable
class UserDataScreenWidget extends DiaRootScreenStatefulWidget {
  UserDataScreenWidgetState _state;
  UserDataServices _userDataServices = UserDataServices();
  AuthenticationServices _authenticationServices = AuthenticationServices();

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
      // Tab(icon: IconButton(icon: FaIcon(FontAwesomeIcons.fileMedicalAlt, size: 18, color: DiaTheme.primaryColor), onPressed: null)),
      // Tab(icon: IconButton(icon: FaIcon(FontAwesomeIcons.chartLine, size: 18, color: DiaTheme.primaryColor), onPressed: null)),
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
            icon: TraitMeasureIconMedium(),
            onPressed: () async {
              severalFloatingActionButton.state.toggle();
              TraitMeasure traitMeasure;
              List<TraitType> traitTypes = await _userDataServices.getTraitTypes();
              if(traitTypes.length > 0) {
                traitMeasure = TraitMeasure(eventDate: DateTime.now(), value: traitTypes[0].getDefaultValue(), traitType: traitTypes[0]);
              } else {
                traitMeasure = TraitMeasure(eventDate: DateTime.now(), value: '0');
              }
              showWidget(
                ParentEditorWidget(
                  child: TraitMeasureEditorWidget(
                    traitTypes: traitTypes,
                    traitMeasureForEdition: traitMeasure,
                    onFinish: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: () => hideWidget()),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      traitMeasure.validate();
                      if(traitMeasure.hasChanged && traitMeasure.isValid) {
                        withBackendErrorHandlersOnView(() async {
                          await _userDataServices.saveTraitMeasure(traitMeasure);
                          _state.refreshTabChildren();
                          _state.refreshCommunications();
                          DiaMessages.getInstance().showBriefMessage('Saved!'.tr());
                        });
                        hideWidget();
                      }
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
            icon: ActivityIconMedium(),
            onPressed: () async {
              severalFloatingActionButton.state.toggle();
              Activity activity = Activity(eventDate: DateTime.now(), minutes: 0);
              showWidget(
                ParentEditorWidget(
                  child: ActivityEditorWidget(
                    activityForEdition: activity,
                    onFinish: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: () => hideWidget()),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      activity.validate();
                      if (activity.hasChanged && activity.isValid) {
                        withBackendErrorHandlersOnView(() async {
                          await _userDataServices.saveActivity(activity);
                          _state.refreshTabChildren();
                          _state.refreshCommunications();
                          DiaMessages.getInstance().showBriefMessage('Saved!'.tr());
                        });
                        hideWidget();
                      }
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
            icon: FeedingIconMedium(),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              DiaNavigation.getInstance().requestScreenChange(DiaScreen.FEEDINGS);
            },
          ),
        ),

        if(_authenticationServices.haveIAnyRole([
          AuthenticationServices.ROLE_DIABETIC,
          AuthenticationServices.ROLE_DIABETIC_PREMIUM,
        ]))
        FloatingActionButton(
          heroTag: 'insulin',
          onPressed: null,
          tooltip: 'Add Insulin Injection',
          backgroundColor: Colors.grey[100],
          child: IconButton(
            icon: InsulinInjectionIconMedium(),
            onPressed: () async {
              severalFloatingActionButton.state.toggle();

              InsulinInjection insulinInjection;
              List<InsulinType> insulinTypes = await _userDataServices.getMyInsulinTypes();
              if(insulinTypes.length > 0) {
                insulinInjection = InsulinInjection(eventDate: DateTime.now(), units: 0, insulinType: insulinTypes[0]);
              } else {
                insulinInjection = InsulinInjection(eventDate: DateTime.now(), units: 0);
              }

              showWidget(
                ParentEditorWidget(
                  child: InsulinInjectionEditorWidget(
                    insulinTypes: insulinTypes,
                    insulinInjectionForEdition: insulinInjection,
                    onFinish: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: hideWidget),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      insulinInjection.validate();
                      if(insulinInjection.hasChanged && insulinInjection.isValid) {
                        withBackendErrorHandlersOnView(() async {
                          await _userDataServices.saveInsulinInjection(insulinInjection);
                          _state.refreshTabChildren();
                          _state.refreshCommunications();
                          DiaMessages.getInstance().showBriefMessage('Saved!'.tr());
                        });
                        hideWidget();
                      }
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        if(_authenticationServices.haveIAnyRole([
          AuthenticationServices.ROLE_DIABETIC,
          AuthenticationServices.ROLE_DIABETIC_PREMIUM,
        ]))
        FloatingActionButton(
          heroTag: 'glucose',
          onPressed: null,
          tooltip: 'Add Glucose',
          backgroundColor: Colors.grey[100],
          child: IconButton(
            icon: GlucoseLevelIconMedium(),
            onPressed: (){
              severalFloatingActionButton.state.toggle();
              GlucoseLevel glucoseLevel = GlucoseLevel(eventDate: DateTime.now(), level: 0);
              showWidget(
                ParentEditorWidget(
                  child: GlucoseLevelEditorWidget(
                    glucoseLevelForEdition: glucoseLevel,
                    onFinish: hideWidget,
                  ),
                  actionButtons: [
                    FlatButton(child: Text('Cancel'), onPressed: hideWidget),
                    FlatButton(child: Text('Save'), onPressed: () async {
                      glucoseLevel.validate();

                      if(glucoseLevel.hasChanged && glucoseLevel.isValid) {
                        withBackendErrorHandlersOnView(() async {
                          await _userDataServices.saveGlucoseLevel(glucoseLevel);
                          _state.refreshTabChildren();
                          _state.refreshCommunications();
                          DiaMessages.getInstance().showBriefMessage('Saved!'.tr());
                        });
                        hideWidget();
                      }
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
    return 'User Data'.tr();
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

  List<Message> nonImmediatelyMessages = [];

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
      if(!_refreshingCommunications)
        refreshCommunications();
    }
  }

  bool _refreshingCommunications = false;

  Future<void> refreshCommunications() async {
    if(_refreshingCommunications) return;
    _refreshingCommunications = true;

    Storage storage = getLocalStorage();
    bool initialSettingsReview = await storage.get('initial-settings-review', false);
    if(!initialSettingsReview) {
      await DiaMessages.getInstance().showDialogMessage('We need you to take a first look at the settings before continuing'.tr());
      await storage.set('initial-settings-review', true);
      DiaNavigation.getInstance().requestScreenChange(DiaScreen.SETTINGS, andReplaceNavigationHistory: true);
    } else {
      Future.delayed(Duration(milliseconds: 500), () async {
        bool reloadAgain = false;
        // Messages
        await withBackendErrorHandlersOnView(() async {
          List<Message> messages = await _communicationsServices.getNotDismissedMessages();
          setState(() {
            nonImmediatelyMessages = messages.where((m) => !m.attendImmediately).toList();
          });

          // only show immediately urgent messages and ephemeral
          List<Message> urgentMessages = messages.where((m) => m.attendImmediately).toList();
          bool andRefresh = await showMessages(urgentMessages);

          if(andRefresh || urgentMessages.length > 0) {
            refreshTabChildren();
            reloadAgain = true;
          }
        });

        // Feedback Requests
        if(!reloadAgain) {
          await withBackendErrorHandlersOnView(() async {
            List<FeedbackRequest> feedbackRequests = await _communicationsServices.getUnattendedFeedbackRequests();
            for(FeedbackRequest request in feedbackRequests) {
              await widget.showWidget(FeedbackRequestWidget(request: request, onFinish: (reload){
                if(reload) reloadAgain = true;
                widget.hideWidget();
              }));
            }
          });
        }

        _refreshingCommunications = false;

        if(reloadAgain)
          refreshCommunications();
      });
    }
  }

  Future<bool> showMessages(List<Message> messages) async {
    bool needRefresh = false;
    for(Message message in messages) {
      if(!message.ephemeral) {
        // dismiss it
        await _communicationsServices.dismissMessage(message);
      } else {
        needRefresh = needRefresh || await widget.showWidget(
            MessagesWidget(message: message, onFinish: (refresh) {
              widget.hideWidget(refresh);
            })
        );
      }
    }
    return needRefresh;
  }

  void refreshTabChildren() {
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

    bool hasNotUrgentMessages = nonImmediatelyMessages.length > 0;
    // this is for tests only
    //hasNotUrgentMessages = true;
    double notUrgentMessagesHeight = 80;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, hasNotUrgentMessages ? notUrgentMessagesHeight : 0.0, 0.0, 0.0),
          child: TabBarView(
            children: [
              timeline,
              // summary,
              // graphs,
            ],
          ),
        ),
        if(hasNotUrgentMessages)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              bool refresh = await showMessages(nonImmediatelyMessages);

              if(refresh) {
                refreshTabChildren();
                refreshCommunications();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFCFCFC),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
              ),
              child: ListTile(
                title: Text('You have pending messages to be reviewed'.tr(), style: TextStyle(color: DiaTheme.primaryColor)),
                subtitle: Text('Press here to attend them'.tr(), style: TextStyle(color: Colors.grey)),
                leading: Badge(
                  badgeColor: DiaTheme.secondaryColor,
                  badgeContent: Text(nonImmediatelyMessages.length.toString(), style: TextStyle(color: Colors.white)),
                  child: Icon(Icons.message, color: DiaTheme.primaryColor),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
