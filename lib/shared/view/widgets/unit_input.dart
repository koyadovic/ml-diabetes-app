import 'package:flutter/material.dart';

class UnitInput extends StatefulWidget {
  final String unit;
  final Function(double) onChange;
  final double initialValue;
  final double min;
  final double max;

  UnitInput(this.unit, {@required this.onChange, this.initialValue, this.min, this.max});

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
      final text = _controller.text;
      double numericalValue = text != null && text != '' ? double.parse(text) : 0.0;
      if(widget.min != null && numericalValue < widget.min) {
        String parsedText;
        if(widget.min == widget.min.toInt()) {
          parsedText = widget.min.toInt().toString();
        } else {
          parsedText = widget.min.toString();
        }
        _controller.text = parsedText;
        return;
      }
      if(widget.max != null && numericalValue > widget.max) {
        String parsedText;
        if(widget.max == widget.max.toInt()) {
          parsedText = widget.max.toInt().toString();
        } else {
          parsedText = widget.max.toString();
        }
        _controller.text = parsedText;
        return;
      }

      widget.onChange(text != null && text != '' ? double.parse(text) : 0.0);

      _controller.value = _controller.value.copyWith(
        text: text,
        selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = (_controller.text.length.toDouble()) * 17;
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
                  keyboardType: TextInputType.number,
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
