import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';

class AddTraitMeasureWidget extends StatefulWidget {
  final Function(bool) selfCloseCallback;

  AddTraitMeasureWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddTraitMeasureWidgetState();
  }
}


class AddTraitMeasureWidgetState extends State<AddTraitMeasureWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<TraitType> _traitTypes = [];
  TraitType _selectedTraitType;

  @override
  void initState() {
    super.initState();
    _userDataServices.getTraitTypes().then((traitTypes) {
      setState(() {
        _traitTypes = traitTypes;
      });
      if(_traitTypes.length > 0)
        _selectTraitType(_traitTypes[0]);
    });
  }

  _selectTraitType(TraitType type) {
    setState(() {
      _selectedTraitType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<TraitType>(
              elevation: 999999,
              value: _selectedTraitType,
              onChanged: (TraitType newValue) {
                _selectTraitType(newValue);
              },
              items: _traitTypes.map<DropdownMenuItem<TraitType>>((TraitType type) {
                return DropdownMenuItem<TraitType>(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UnitTextField(
                unit: 'mg/dL',
                min: 0.0, max: 600.0,
                onChange: (value) {
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
                // TODO save it
                widget.selfCloseCallback(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}