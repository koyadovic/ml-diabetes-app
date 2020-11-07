import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
import 'package:flutter/material.dart';


class InsulinInjectionEditorWidget extends StatefulWidget {
  final InsulinInjection insulinInjectionForEdition;
  final Function() onFinish;
  final List<InsulinType> insulinTypes;

  InsulinInjectionEditorWidget({this.onFinish, this.insulinInjectionForEdition, this.insulinTypes});

  @override
  State<StatefulWidget> createState() {
    return InsulinInjectionEditorWidgetState();
  }
}


class InsulinInjectionEditorWidgetState extends State<InsulinInjectionEditorWidget> {
  UserDataServices _userDataServices = UserDataServices();
  TextEditingController _externalController;
  List<InsulinType> _insulinTypes = [];

  InsulinInjection get insulinInjection {
    return widget.insulinInjectionForEdition;
  }

  @override
  void initState() {
    if(widget.insulinTypes == null) {
      _userDataServices.getInsulinTypes().then((insulinTypes) {
        setState(() {
          _insulinTypes = insulinTypes;
        });
        if(_insulinTypes.length > 0)
          _selectInsulinType(_insulinTypes[0]);
      });
    } else {
      setState(() {
        _insulinTypes = widget.insulinTypes;
      });
      print(insulinInjection.toJson().toString());
    }
    _externalController = TextEditingController(text: insulinInjection.units.toString());
    super.initState();
  }

  _selectInsulinType(InsulinType type) {
    insulinInjection.insulinType = type;
    setState(() {
      insulinInjection.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Column(
        children: [
          DropdownButton<InsulinType>(
            isExpanded: true,
            isDense: true,
            value: insulinInjection.insulinType,
            onChanged: !enabled ? null : (InsulinType newValue) {
              if(editable)
                _selectInsulinType(newValue);
            },
            items: editable ? _insulinTypes.map<DropdownMenuItem<InsulinType>>((InsulinType type) {
              return DropdownMenuItem<InsulinType>(
                value: type,
                child: Text(type.name, style: TextStyle(color: enabled ? Colors.black : Colors.grey)),
              );
            }).toList() : [
              DropdownMenuItem<InsulinType>(
                value: insulinInjection.insulinType,
                child: Text(insulinInjection.insulinType.name, style: TextStyle(color: enabled ? Colors.black : Colors.grey)),
              )
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UnitTextField(
                externalController: _externalController,
                initialValue: insulinInjection.units != null ? insulinInjection.units.toDouble() : 0.0,
                unit: 'u',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 100.0 ? 100.0 : value,
                ],
                onChange: (value) {
                  insulinInjection.units = value.toInt();
                  setState(() {
                    insulinInjection.validate();
                  });
                }
              ),
              if(editable)
              ...[
                Spacer(),
                if(insulinInjection.units != null && insulinInjection.units != 0)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: !enabled ? null : () {
                    insulinInjection.units = 0;
                    _externalController.text = insulinInjection.units.toString();
                    setState(() {
                      insulinInjection.validate();
                    });
                  },
                ),
              ]
            ],
          ),
          if(!insulinInjection.isValid)
            Column(
              children: [
                Text(insulinInjection.getFullValidationText(includePropertyNames: false), style: TextStyle(color: enabled ? Colors.red : Colors.grey)),
              ],
            )
        ],
      ),
    );
  }
}