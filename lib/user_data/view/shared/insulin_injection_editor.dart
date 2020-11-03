import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';

class InsulinInjectionEditorWidget extends StatefulWidget {
  final InsulinInjection insulinInjectionForEdition;
  final Function(bool, [InsulinInjection insulinInjection]) selfCloseCallback;

  InsulinInjectionEditorWidget({this.selfCloseCallback, this.insulinInjectionForEdition});

  @override
  State<StatefulWidget> createState() {
    return InsulinInjectionEditorWidgetState();
  }
}


class InsulinInjectionEditorWidgetState extends State<InsulinInjectionEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  List<InsulinType> _insulinTypes = [];
  InsulinInjection _insulinInjection;

  @override
  void initState() {
    if(widget.insulinInjectionForEdition != null) {
      _insulinInjection = InsulinInjection.fromJson(widget.insulinInjectionForEdition.toJson());
      _insulinTypes = [_insulinInjection.insulinType];
    } else {
      _insulinInjection = InsulinInjection(eventDate: DateTime.now());
      _userDataServices.getInsulinTypes().then((insulinTypes) {
        setState(() {
          _insulinTypes = insulinTypes;
        });
        if(_insulinTypes.length > 0)
          _selectInsulinType(_insulinTypes[0]);
      });
    }
    super.initState();
  }

  _selectInsulinType(InsulinType type) {
    print(type.toJson().toString());
    setState(() {
      _insulinInjection.insulinType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              DropdownButton<InsulinType>(
                isExpanded: true,
                value: _insulinInjection.insulinType,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              UnitTextField(
                unit: 'u',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 250 ? 250.0 : value,
                ],
                onChange: (value) {
                  setState(() {
                    _insulinInjection.units = value.toInt();
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
                onPressed: !_insulinInjection.hasChanged ? null : () async {
                  widget.selfCloseCallback(true, _insulinInjection);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}