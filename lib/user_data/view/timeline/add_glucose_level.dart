import 'package:Dia/shared/view/widgets/unit_text_field.dart';
import 'package:flutter/material.dart';

class AddGlucoseLevelWidget extends StatefulWidget {
  final Function selfCloseCallback;

  AddGlucoseLevelWidget({this.selfCloseCallback});

  @override
  State<StatefulWidget> createState() {
    return AddGlucoseLevelWidgetState();
  }
}


class AddGlucoseLevelWidgetState extends State<AddGlucoseLevelWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        UnitTextField(
            unit: 'mg/dL',
            min: 0.0, max: 600.0,
            onChange: (value) {
              print('Glucosa!: $value');
            }
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: widget.selfCloseCallback,
        ),
        IconButton(
          icon: Icon(Icons.done),
          onPressed: () {
            // TODO save it
            widget.selfCloseCallback();
          },
        ),

      ],
    );
  }
}