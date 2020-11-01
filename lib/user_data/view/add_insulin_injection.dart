import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';

class AddInsulinInjectionWidget extends StatefulWidget {
  /*
  TODO que opcionalmente le puedan ser injectados desde fuera los tipos!
    En este caso que no consulte al backend por ellos. Ya los tiene!

   Esto Se puede aprovechar para pasarle solo [Altura].
   No consultará tipos porque ya los tiene, es 1.
   Además, en el selector no podrá cambiar Altura.
   */
  final Function(bool) selfCloseCallback;

  AddInsulinInjectionWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddInsulinInjectionWidgetState();
  }
}


class AddInsulinInjectionWidgetState extends State<AddInsulinInjectionWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<InsulinType> _insulinTypes = [];
  InsulinType _selectedInsulinType;
  int _units;

  @override
  void initState() {
    super.initState();
    _userDataServices.getInsulinTypes().then((insulinTypes) {
      setState(() {
        _insulinTypes = insulinTypes;
      });
      if(_insulinTypes.length > 0)
        _selectInsulinType(_insulinTypes[0]);
    });
  }

  _selectInsulinType(InsulinType type) {
    setState(() {
      _selectedInsulinType = type;
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
                  DropdownButton<InsulinType>(
                    //isExpanded: true,
                    value: _selectedInsulinType,
                    onChanged: (InsulinType newValue) {
                      _selectInsulinType(newValue);
                    },
                    items: _insulinTypes.map<DropdownMenuItem<InsulinType>>((InsulinType type) {
                      return DropdownMenuItem<InsulinType>(
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
                unit: 'u',
                min: 0.0, max: 250.0,
                onChange: (value) {
                  setState(() {
                    _units = value.toInt();
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
                await _userDataServices.saveInsulinInjection(_selectedInsulinType, _units);
                widget.selfCloseCallback(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}