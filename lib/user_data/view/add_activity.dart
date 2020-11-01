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
  final Function(bool) selfCloseCallback;

  AddActivityWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddActivityWidgetState();
  }
}


class AddActivityWidgetState extends State<AddActivityWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<ActivityType> _activityTypes = [];
  ActivityType _selectedActivityType;
  int _minutes;

  @override
  void initState() {
    super.initState();
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
      _selectedActivityType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 0.0),
              child: Column(
                children: [
                  DropdownButton<ActivityType>(
                    //isExpanded: true,
                    value: _selectedActivityType,
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
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UnitTextField(
                unit: 'm',
                min: 0.0, max: 600.0,
                onChange: (value) {
                  setState(() {
                    _minutes = value.toInt();
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
              onPressed: () async {
                await _userDataServices.saveActivity(_selectedActivityType, _minutes);
                widget.selfCloseCallback(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}