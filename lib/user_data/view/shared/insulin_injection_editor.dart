import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
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
  TextEditingController _externalController;
  List<InsulinType> _insulinTypes = [];
  InsulinInjection _insulinInjection;

  @override
  void initState() {
    initialize();
    _externalController = TextEditingController(text: _insulinInjection.units.toString());
    super.initState();
  }

  void initialize() {
    if(widget.insulinInjectionForEdition != null) {
      _insulinInjection = widget.insulinInjectionForEdition;
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
  }

  _selectInsulinType(InsulinType type) {
    setState(() {
      _insulinInjection.insulinType = type;
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
            value: _insulinInjection.insulinType,
            onChanged: !enabled ? null : (InsulinType newValue) {
              if(editable)
                _selectInsulinType(newValue);
            },
            items: _insulinTypes.map<DropdownMenuItem<InsulinType>>((InsulinType type) {
              return DropdownMenuItem<InsulinType>(
                value: type,
                child: Text(type.name, style: TextStyle(color: enabled ? Colors.black : Colors.grey)),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UnitTextField(
                externalController: _externalController,
                initialValue: _insulinInjection.units != null ? _insulinInjection.units.toDouble() : 0.0,
                unit: 'u',
                processors: [
                  (value) => value < 0.0 ? 0.0 : value,
                  (value) => value > 100.0 ? 100.0 : value,
                ],
                onChange: (value) {
                  setState(() {
                    _insulinInjection.units = value.toInt();
                  });
                }
              ),
              if(editable)
                ...[
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: enabled ? DiaTheme.secondaryColor : Colors.grey),
                    onPressed: !enabled ? null : () {
                      setState(() {
                        _insulinInjection.reset();
                        _externalController.text = _insulinInjection.units.toString();
                      });
                      widget.selfCloseCallback(false);
                    },
                  ),
                ]
            ],
          ),
        ],
      ),
    );
  }
}