import 'package:Dia/shared/view/utils/theme.dart';
import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:Dia/user_data/model/entities.dart';
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
  double _glucoseLevel;

  @override
  void initState() {
    _glucoseLevel = 0.0;
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
                _glucoseLevel = value;
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
          onPressed: _glucoseLevel == 0.0 ? null : () {
            // TODO save it
            GlucoseLevel glucoseLevel = GlucoseLevel(
              eventDate: DateTime.now(),
              level: _glucoseLevel.toInt(),
            );

            widget.selfCloseCallback(true);
          },
        ),
      ],
    );
  }
}