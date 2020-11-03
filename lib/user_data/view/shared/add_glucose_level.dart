import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:flutter/material.dart';

class AddGlucoseLevelWidget extends StatefulWidget {
  final Function(bool, [GlucoseLevel glucoseLevel]) selfCloseCallback;

  AddGlucoseLevelWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddGlucoseLevelWidgetState();
  }
}


class AddGlucoseLevelWidgetState extends State<AddGlucoseLevelWidget> {
  UserDataServices _userDataServices = UserDataServices();
  GlucoseLevel _glucoseLevel;

  @override
  void initState() {
    _glucoseLevel = GlucoseLevel(eventDate: DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          UnitTextField(
              unit: 'mg/dL',
              processors: [
                    (value) => value < 0.0 ? 0.0 : value,
                    (value) => value > 600 ? 600.0 : value,
              ],
              autoFocus: true,
              onChange: (value) {
                setState(() {
                  _glucoseLevel.level = value.toInt();
                });
              }
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: DiaTheme.secondaryColor),
            onPressed: () => widget.selfCloseCallback(false),
          ),
          IconButton(
            icon: Icon(Icons.done, color: !_glucoseLevel.hasChanged ? Colors.grey : DiaTheme.primaryColor),
            onPressed: !_glucoseLevel.hasChanged ? null : () async {
              await _userDataServices.saveGlucoseLevel(_glucoseLevel);
              widget.selfCloseCallback(true, _glucoseLevel);
            },
          ),
        ],
      ),
    );
  }
}