import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';

class AddActivityWidget extends StatefulWidget {
  /*
  TODO que opcionalmente le puedan ser injectados desde fuera los tipos!
    En este caso que no consulte al backend por ellos. Ya los tiene!

   Esto Se puede aprovechar para pasarle solo [Correr].
   No consultará tipos porque ya los tiene, es 1.
   Además, en el selector no podrá cambiar Correr.
   */
  final Function(bool, [Activity activity]) selfCloseCallback;

  AddActivityWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddActivityWidgetState();
  }
}


class AddActivityWidgetState extends State<AddActivityWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<ActivityType> _activityTypes = [];
  Activity _activity;

  @override
  void initState() {
    super.initState();
    _activity = Activity(eventDate: DateTime.now());

    _userDataServices.getActivityTypes().then((activityTypes) {
      setState(() {
        _activityTypes = activityTypes;
      });
      if(_activityTypes.length > 0)
        _selectTraitType(_activityTypes[0]);
    });
  }

  _selectTraitType(ActivityType type) {
    setState(() {
      _activity.activityType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  DropdownButton<ActivityType>(
                    //isExpanded: true,
                    value: _activity.activityType,
                    onChanged: (ActivityType newValue) {
                      _selectTraitType(newValue);
                    },
                    items: _activityTypes.map<DropdownMenuItem<ActivityType>>((ActivityType type) {
                      return DropdownMenuItem<ActivityType>(
                        value: type,
                        child: Text(
                            type.name
                        ),
                      );
                    }).toList(),
                  ),
                ],
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
                icon: Icon(Icons.close, color: DiaTheme.secondaryColor),
                onPressed: () => widget.selfCloseCallback(false),
              ),
              IconButton(
                icon: Icon(Icons.done, color: DiaTheme.primaryColor),
                onPressed: !_activity.hasChanged ? null : () async {
                  await _userDataServices.saveActivity(_activity);
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