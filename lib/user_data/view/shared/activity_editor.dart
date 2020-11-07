import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities/activities.dart';
import 'package:flutter/material.dart';


class ActivityEditorWidget extends StatefulWidget {
  final Activity activityForEdition;
  final Function() onFinish;
  final List<ActivityType> activityTypes;

  ActivityEditorWidget({this.onFinish, this.activityForEdition, this.activityTypes});

  @override
  State<StatefulWidget> createState() {
    return ActivityEditorWidgetState();
  }
}


class ActivityEditorWidgetState extends State<ActivityEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  TextEditingController _externalController;
  List<ActivityType> _activityTypes = [];

  Activity get activity {
    return widget.activityForEdition;
  }

  @override
  void initState() {
    if(widget.activityTypes == null) {
      _userDataServices.getActivityTypes().then((activityTypes) {
        setState(() {
          _activityTypes = activityTypes;
        });
        if(_activityTypes.length > 0)
          _selectActivityType(_activityTypes[0]);
      });
    } else {
      setState(() {
        _activityTypes = widget.activityTypes;
      });
    }
    _externalController = TextEditingController(text: activity.minutes.toString());
    super.initState();
  }

  _selectActivityType(ActivityType type) {
    activity.activityType = type;
    setState(() {
      activity.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              DropdownButton<ActivityType>(
                isExpanded: true,
                value: activity.activityType,
                onChanged: (ActivityType newValue) {
                  if(editable)
                    _selectActivityType(newValue);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UnitTextField(
                externalController: _externalController,
                unit: 'm',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                onChange: (value) {
                  activity.minutes = value.toInt();
                  setState(() {
                    activity.validate();
                  });
                }
              ),
              if(editable)
              ...[
                Spacer(),
                if(activity.minutes != null && activity.minutes != 0)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    activity.minutes = 0;
                    _externalController.text = activity.minutes.toString();
                    setState(() {
                      activity.validate();
                    });
                  }
                ),
              ]
            ],
          ),
          if(!activity.isValid)
            Column(
              children: [
                Text(activity.getFullValidationText(includePropertyNames: false), style: TextStyle(color: Colors.red)),
              ],
            )
        ],
      ),
    );
  }
}