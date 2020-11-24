import 'package:iDietFit/shared/view/error_handlers.dart';
import 'package:iDietFit/shared/view/utils/editable_status.dart';
import 'package:iDietFit/shared/view/utils/enabled_status.dart';
import 'package:iDietFit/shared/view/utils/font_sizes.dart';
import 'package:iDietFit/shared/view/widgets/dia_fa_icons.dart';
import 'package:iDietFit/shared/view/widgets/search_and_select.dart';
import 'package:iDietFit/shared/view/widgets/unit_text_field.dart';
import 'package:iDietFit/user_data/model/entities/activities.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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

  static const String START = 'start';
  static const String END = 'end';
  String _startOrEndValue = START;

  Activity get activity {
    return widget.activityForEdition;
  }

  @override
  void initState() {
    _externalController = TextEditingController(text: activity.minutes != null ? activity.minutes.toString() : '0');
    activity.addValidationListener(whenValidated);
    handleStartOrEnd(START);
    super.initState();
  }

  @override
  void dispose() {
    activity.removeValidationListener(whenValidated);
    super.dispose();
  }

  void whenValidated() {
    setState(() {
    });
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
            hintText: 'Search for activity'.tr(),
            currentValue: activity.activityType,
            source: APIRestSource<ActivityType>(
              endpoint: '/api/v1/activity-types/',
              queryParameterName: 'search',
              deserializer: ActivityType.fromJson,
              errorHandler: (err) {
                withBackendErrorHandlersOnView(() {
                  throw err;
                });
              }
            ),
            onSelected: (ActivityType value) {
              if(editable)
                _selectActivityType(value);
            },
            renderItem: (SearchAndSelectState state, ActivityType value) => ListTile(
              leading: ActivityIconSmall(),
              title: Text(value.name),
              subtitle: Text(value.mets.toString() + ' METs'),
            ),
          ),
          if(activity.activityType != null)
          Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: START,
                    groupValue: _startOrEndValue,
                    onChanged: handleStartOrEnd,
                  ),
                  GestureDetector(
                    child: Text('Start now'.tr()),
                    onTap: () => handleStartOrEnd(START),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: END,
                    groupValue: _startOrEndValue,
                    onChanged: handleStartOrEnd,
                  ),
                  GestureDetector(
                    child: Text('End now'.tr()),
                    onTap: () => handleStartOrEnd(END),
                  ),
                ],
              ),
            ],
          ),
          if(activity.activityType != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Row(
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
                    recomputeEventDate();
                    setState(() {
                      if(!activity.isValid) activity.validate();
                    });
                  }
                ),
                if(editable)
                ...[
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

  void handleStartOrEnd(String value) {
    _startOrEndValue = value;
    setState(() {
      recomputeEventDate();
    });
  }

  void recomputeEventDate() {
    switch(_startOrEndValue) {
      case START:
        activity.eventDate = DateTime.now().toUtc();
        break;
      case END:
        activity.eventDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().toUtc().millisecondsSinceEpoch - activity.minutes * 60000, isUtc: true).toUtc();
        break;
    }
  }
}
