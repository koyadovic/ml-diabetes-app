import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


class ActivityEditorWidget extends StatefulWidget {
  final Activity activityForEdition;
  final Function(bool, [Activity activity]) selfCloseCallback;

  ActivityEditorWidget({this.selfCloseCallback, this.activityForEdition});

  @override
  State<StatefulWidget> createState() {
    return ActivityEditorWidgetState();
  }
}


class ActivityEditorWidgetState extends State<ActivityEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<ActivityType> _activityTypes = [];
  Activity _activity;

  @override
  void initState() {
    if(widget.activityForEdition != null) {
      _activity = widget.activityForEdition;
      _activityTypes = [_activity.activityType];
    } else {
      _activity = Activity(eventDate: DateTime.now());
      _userDataServices.getActivityTypes().then((activityTypes) {
        setState(() {
          _activityTypes = activityTypes;
        });
        if(_activityTypes.length > 0)
          _selectTraitType(_activityTypes[0]);
      });
    }
    super.initState();
  }

  _selectTraitType(ActivityType type) {
    setState(() {
      _activity.activityType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              DropdownButton<ActivityType>(
                isExpanded: true,
                value: _activity.activityType,
                onChanged: (ActivityType newValue) {
                  _selectTraitType(newValue);
                },
                items: _activityTypes.map<DropdownMenuItem<ActivityType>>((ActivityType type) {
                  return DropdownMenuItem<ActivityType>(
                    value: type,
                    child: Text(type.name, style: TextStyle(color: enabled ? Colors.black : Colors.grey)),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              UnitTextField(
                unit: 'm',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                onChange: (value) {
                  setState(() {
                    _activity.minutes = value.toInt();
                  });
                }
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: enabled ? DiaTheme.secondaryColor : Colors.grey),
                onPressed: () => widget.selfCloseCallback(false),
              ),
              IconButton(
                icon: Icon(Icons.done, color: !enabled || !_activity.hasChanged ? Colors.grey : DiaTheme.primaryColor),
                onPressed: !enabled || !_activity.hasChanged ? null : () async {
                  widget.selfCloseCallback(true, _activity);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}