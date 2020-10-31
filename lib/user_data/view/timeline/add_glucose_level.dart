import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/controller/services.dart';
import 'package:flutter/material.dart';

class AddGlucoseLevelWidget extends StatefulWidget {
  final Function(bool) selfCloseCallback;

  AddGlucoseLevelWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddGlucoseLevelWidgetState();
  }
}


class AddGlucoseLevelWidgetState extends State<AddGlucoseLevelWidget> {
  int _glucoseLevel;
  UserDataServices _userDataServices = UserDataServices();

  @override
  void initState() {
    _glucoseLevel = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        UnitTextField(
            unit: 'mg/dL',
            min: 0.0, max: 600.0,
            autoFocus: true,
            onChange: (value) {
              setState(() {
                _glucoseLevel = value.toInt();
              });
            }
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.close, color: DiaTheme.secondaryColor),
          onPressed: () => widget.selfCloseCallback(false),
        ),
        IconButton(
          icon: Icon(Icons.done, color: _glucoseLevel == 0.0 ? Colors.grey : DiaTheme.primaryColor),
          onPressed: _glucoseLevel == 0.0 ? null : () async {
            await _userDataServices.saveGlucoseLevel(_glucoseLevel);
            widget.selfCloseCallback(true);
          },
        ),
      ],
    );
  }
}