import 'package:flutter/material.dart';

class UnitTextField extends StatefulWidget {
  final String unit;
  final Function(double) onChange;
  final double initialValue;
  final double min;
  final double max;
  final bool enabled;

  UnitTextField({@required this.unit, @required this.onChange, this.initialValue, this.min, this.max, this.enabled : true});

  @override
  State<StatefulWidget> createState() {
    return UnitTextFieldState();
  }
}

class UnitTextFieldState extends State<UnitTextField> {
  TextEditingController _controller;
  double _lastValueEmitted;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: (widget.initialValue ?? 0.0) != 0.0 ? approximateDouble(widget.initialValue) : '0');
    _controller.addListener(() {
      final text = _controller.text;
      double numericalValue = processStringValue(text);

      if (numericalValue != _lastValueEmitted) {
        widget.onChange(numericalValue);
        _lastValueEmitted = numericalValue;
      }

      _controller.value = _controller.value.copyWith(
        text: approximateDouble(numericalValue),
        selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      setState(() {});
    });
  }

  double processStringValue(String text) {
    double numericalValue = text != null && text != '' ? double.parse(text) : 0.0;
    return processValue(numericalValue);
  }

  double processValue(double value) {
    if(widget.min != null && value < widget.min) {
      return widget.min;
    }
    if(widget.max != null && value > widget.max) {
      return widget.max;
    }
    return value;
  }

  String approximateDouble(double v) {
    if (v.toInt() == v) {
      return v.toInt().toString();
    }
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    double w = (_controller.text.length.toDouble()) * 17.5;
    w = w < 13 ? 13 : w;

    return Text.rich(
      TextSpan(
        //style: TextStyle(color: widget.enabled ? Colors.black : Colors.grey),
        children: <InlineSpan>[
          WidgetSpan(
            child: SizedBox(
              width: w,
              height: 38,
              child: TextField(
                enabled: widget.enabled,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)
                ),
                style: TextStyle(fontSize: 30, color: widget.enabled ? Colors.black : Colors.grey, fontWeight: FontWeight.w300),
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            )
          ),
          TextSpan(
            text: widget.unit,
            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)
          ),
        ],
      )
    );
  }
}
