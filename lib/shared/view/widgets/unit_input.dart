import 'package:flutter/material.dart';

class UnitInput extends StatefulWidget {
  final String unit;

  UnitInput(this.unit);

  @override
  State<StatefulWidget> createState() {
    return UnitInputState();
  }
}

class UnitInputState extends State<UnitInput> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = (_controller.text.length.toDouble()) * 18;
    w = w < 26 ? 26 : w;

    return Text.rich(
        TextSpan(
          children: <InlineSpan>[
            WidgetSpan(
              child: SizedBox(
                width: w,
                height: 38,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)
                  ),
                  style: TextStyle(fontSize: 30),
                  controller: _controller,
                ),
              )
            ),
            TextSpan(
              text: widget.unit,
              style: TextStyle(fontSize: 14, color: Colors.grey)
            ),
          ],
        )
    );
  }
}
