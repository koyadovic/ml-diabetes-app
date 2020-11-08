import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:flutter/material.dart';

// if not valid throw ValidationError('Message');
typedef ValueProcessor = double Function(double value);


class UnitTextField extends StatefulWidget {
  final String unit;
  final Function(double) onChange;
  final double initialValue;
  final List<ValueProcessor> processors;
  final bool autoFocus;
  final Color colorEnabled;
  final Color colorDisabled;
  final double unitWidth;
  final TextEditingController externalController;

  UnitTextField({
    @required this.unit,
    @required this.onChange,
    this.initialValue,
    this.autoFocus : false,
    this.processors : const [],
    this.colorEnabled: Colors.black,
    this.colorDisabled: Colors.grey,
    this.unitWidth: 55,
    this.externalController,
  });

  @override
  State<StatefulWidget> createState() {
    return UnitTextFieldState();
  }
}

class UnitTextFieldState extends State<UnitTextField> {
  TextEditingController _controller;
  double _lastValueEmitted;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

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
    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);
    if(enabled && editable)
      _focusNode.requestFocus();
  }

  TextEditingController updateController() {
    if(widget.externalController == null) {

    } else {
      _controller = widget.externalController;
    }
  }

  void checkController() {
    bool addListener = false;
    if(widget.externalController != null) {
      if(_controller != widget.externalController) {
        _controller = widget.externalController;
        addListener = true;
      }
    } else {
      _controller = TextEditingController(text: (widget.initialValue ?? 0.0) != 0.0 ? approximateDouble(widget.initialValue) : '0');
      addListener = true;
    }

    if(addListener) {
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
  }

  @override
  Widget build(BuildContext context) {
    checkController();

    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);

    double scalingFactor = screenSizeScalingFactor(context);

    double w = (_controller.text.length.toDouble()) * 17.5 * scalingFactor;
    w = w < 13 * scalingFactor ? 13 * scalingFactor : w;

    Color fontColor = enabled ? widget.colorEnabled : widget.colorDisabled;

    return GestureDetector(
      onTap: () => requestFocus(),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            WidgetSpan(
              child: SizedBox(
                width: w,
                child: TextField(
                  focusNode: _focusNode,
                  enabled: enabled && editable,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)
                  ),
                  style: TextStyle(fontSize: bigSize(context), color: fontColor, fontWeight: FontWeight.w300),
                  keyboardType: TextInputType.number,
                  controller: _controller,
                ),
              )
            ),
            WidgetSpan(
              child: Container(
                width: widget.unitWidth,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0 / scalingFactor),
                  child: Text(
                    widget.unit,
                    style: TextStyle(fontSize: smallSize(context), color: Colors.grey, fontWeight: FontWeight.w600)
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
