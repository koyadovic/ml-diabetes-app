import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/widgets/search_and_select.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/model/entities/activities.dart';
import 'package:flutter/material.dart';


class ActivityEditorWidget extends StatefulWidget {
  final Activity activityForEdition;
  final Function() onFinish;

  ActivityEditorWidget({this.onFinish, this.activityForEdition});

  @override
  State<StatefulWidget> createState() {
    return ActivityEditorWidgetState();
  }
}


class ActivityEditorWidgetState extends State<ActivityEditorWidget> {
  TextEditingController _externalController;

  Activity get activity {
    return widget.activityForEdition;
  }

  @override
  void initState() {
    _externalController = TextEditingController(text: activity.minutes.toString());
    activity.addValidationListener(() {
      setState(() {
      });
    });
    super.initState();
  }

  _selectActivityType(ActivityType type) {
    activity.activityType = type;
    setState(() {
      if(!activity.isValid) activity.validate();
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
          SearchAndSelect<ActivityType>(
            hintText: 'Search for activity',
            currentValue: activity.activityType,
            source: APIRestSource<ActivityType>(
              endpoint: '/api/v1/activity-types/',
              queryParameterName: 'search',
              deserializer: ActivityType.fromJson,
            ),
            onSelected: (ActivityType value) {
              if(editable)
                _selectActivityType(value);
            },
            renderItem: (ActivityType value) => ListTile( // TODO change this
              leading: Icon(Icons.directions_run),
              title: Text(value.name),
              subtitle: Text(value.mets.toString() + ' METs'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UnitTextField(
                valueSize: bigSize(context),
                unitSize: verySmallSize(context),
                externalController: _externalController,
                unit: 'm',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 600 ? 600.0 : value,
                ],
                onChange: (value) {
                  activity.minutes = value.toInt();
                  setState(() {
                    if(!activity.isValid) activity.validate();
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
                      if(!activity.isValid) activity.validate();
                    });
                  }
                ),
              ]
            ],
          ),
          if(!activity.isValid)
            Column(
              children: [
                Text(activity.getFullValidationText(includePropertyNames: false), style: TextStyle(color: enabled ? Colors.red : Colors.grey)),
              ],
            )
        ],
      ),
    );
  }
}