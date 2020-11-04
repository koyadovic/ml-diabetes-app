import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';


class ActivityEditorWidget extends StatefulWidget {
  final Activity activityForEdition;
  final Function() selfCloseCallback;
  final List<ActivityType> activityTypes;

  ActivityEditorWidget({this.selfCloseCallback, this.activityForEdition, this.activityTypes});

  @override
  State<StatefulWidget> createState() {
    return ActivityEditorWidgetState();
  }
}


class ActivityEditorWidgetState extends State<ActivityEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  TextEditingController _externalController;
  List<ActivityType> _activityTypes = [];
  Activity _activity;

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
    _externalController = TextEditingController(text: _activity.minutes.toString());
    super.initState();
  }

  _selectActivityType(ActivityType type) {
    setState(() {
      _activity.activityType = type;
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
                value: _activity.activityType,
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
                  setState(() {
                    _activity.minutes = value.toInt();
                  });
                }
              ),
              if(editable)
              ...[
                Spacer(),
                IconButton(
                    icon: Icon(Icons.close, color: enabled ? DiaTheme.secondaryColor : Colors.grey),
                    onPressed: () {
                      setState(() {
                        _activity.reset();
                        _externalController.text = _activity.minutes.toString();
                      });
                      widget.selfCloseCallback();
                    }
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}