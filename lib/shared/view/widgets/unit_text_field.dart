import 'package:flutter/material.dart';

// if not valid throw ValidationError('Message');
typedef ValueProcessor = double Function(double value);


class UnitTextField extends StatefulWidget {
  final String unit;
  final Function(double) onChange;
  final double initialValue;
  final List<ValueProcessor> processors;
  final bool enabled;
  final bool autoFocus;
  final Color colorEnabled;
  final Color colorDisabled;
  final double unitWidth;
  final TextEditingController externalController;
  UnitTextFieldState state;

  UnitTextField({
    @required this.unit,
    @required this.onChange,
    this.initialValue,
    this.autoFocus : false,
    this.processors : const [],
    this.enabled : true,
    this.colorEnabled: Colors.black,
    this.colorDisabled: Colors.grey,
    this.unitWidth: 55,
    this.externalController,
  });

  @override
  State<StatefulWidget> createState() {
    state = UnitTextFieldState();
    return state;
  }
}

class UnitTextFieldState extends State<UnitTextField> {
  TextEditingController _controller;
  double _lastValueEmitted;
  FocusNode _focusNode;

  void setValue(double value) {
    _controller.text = value.toString();
  }

  @override
  void initState() {
    widget.state = this;

    super.initState();
    _focusNode = FocusNode();
    _controller = widget.externalController ?? TextEditingController(text: (widget.initialValue ?? 0.0) != 0.0 ? approximateDouble(widget.initialValue) : '0');
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

    if(widget.autoFocus) {
      Future.delayed(Duration(milliseconds: 300), () => requestFocus());
    }
  }

  double processStringValue(String text) {
    double numericalValue = text != null && text != '' ? double.parse(text) : 0.0;
    return processValue(numericalValue);
  }

  double processValue(double value) {
    for (ValueProcessor processor in widget.processors) {
      value = processor(value);
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
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void requestFocus() {
    if(widget.enabled)
      _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    double w = (_controller.text.length.toDouble()) * 17.5;
    w = w < 13 ? 13 : w;

    Color fontColor = widget.enabled ? widget.colorEnabled : widget.colorDisabled;

    return GestureDetector(
      onTap: () => requestFocus(),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            WidgetSpan(
              child: SizedBox(
                width: w,
                //height: 38,
                child: TextField(
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)
                  ),
                  style: TextStyle(fontSize: 30, color: fontColor, fontWeight: FontWeight.w300),
                  keyboardType: TextInputType.number,
                  controller: _controller,
                ),
              )
            ),
            WidgetSpan(
              child: Container(
                width: widget.unitWidth,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Text(
                    widget.unit,
                    style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
