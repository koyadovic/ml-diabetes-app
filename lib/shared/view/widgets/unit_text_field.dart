import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:flutter/material.dart';

// if not valid throw ValidationError('Message');
typedef ValueProcessor = dynamic Function(dynamic value);


class UnitTextField extends StatefulWidget {
  final String unit;
  final Function(dynamic) onChange;
  final dynamic initialValue;
  final List<ValueProcessor> processors;
  final bool autoFocus;
  final TextEditingController externalController;
  final double unitSize;
  final double valueSize;
  final bool isDouble;

  UnitTextField({
    @required this.unit,
    @required this.onChange,
    this.initialValue,
    this.autoFocus : false,
    this.processors : const [],
    this.externalController,
    this.unitSize : 12.0,
    this.valueSize : 12.0,
    this.isDouble : true,
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
    checkController();

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      List<dynamic> result = parseStringValue(_controller.text);
      if(_focusNode.hasFocus && result[0] == 0.0) {
        _controller.text = '';
      }
      else if (!_focusNode.hasFocus && result[0] == 0.0) {
        _controller.text = widget.isDouble ? '0.0' : '0';
      }
    });

    if(widget.autoFocus) {
      Future.delayed(Duration(milliseconds: 300), () => requestFocus());
    }
  }

  List<dynamic> parseStringValue(String text) {
    bool changed = false;
    if(text.contains(',')) {
      text = text.replaceAll(',', '.');
      changed = true;
    }

    if(text.contains('.')) {
      List<String> parts = text.split('.');
      String natural = parts[0];
      String decimal = parts[1];
      text = natural + '.' + decimal;
      changed = changed || parts.length > 2;
    }
    double numericalValue;
    try {
      numericalValue = text != null && text != '' ? double.parse(text) : 0.0;
    } catch (err) {
      numericalValue = 0.0;
    }

    return [numericalValue, changed];
  }

  double processValue(double value) {
    for (ValueProcessor processor in widget.processors) {
      value = processor(value);
    }
    return value;
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

  void checkController() {
    bool addListener = false;
    if(widget.externalController != null) {
      if(_controller != widget.externalController) {
        _controller = widget.externalController;
        addListener = true;
      }
    } else {
      String def;
      if(widget.isDouble)
        def = '0.0';
      else
        def = '0';
      _controller = TextEditingController(text: (widget.initialValue ?? 0.0) != 0.0 ? double.parse(widget.initialValue) : def);
      addListener = true;
    }

    if(addListener) {
      _controller.addListener(() {
        final text = _controller.text;

        List<dynamic> result = parseStringValue(text);
        double originalParsedValue = result[0];
        bool changed = result[1];

        print('$originalParsedValue $changed');

        double processedValue = processValue(originalParsedValue);

        if (processedValue != _lastValueEmitted) {
          widget.onChange(widget.isDouble ? processedValue : processedValue.round());
          _lastValueEmitted = processedValue;
        }

        String textInController;
        if(widget.isDouble && (changed || originalParsedValue != processedValue)) {
          textInController = processedValue.toString();
          if(textInController.endsWith('.0')) {
            textInController = textInController.replaceAll('.0', '.');
          }
        } else {
          textInController = _controller.text;
        }

        print('Resulting text: $textInController');

        if(mounted)
          setState(() {
            _controller.value = _controller.value.copyWith(
              text: textInController,
              selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
              composing: TextRange.empty,
            );
          });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = EnabledStatus.of(context);
    bool editable = EditableStatus.of(context);

    //double scalingFactor = screenSizeScalingFactor(context);

    double charWidth = (widget.valueSize / 2.0) + 1.0;
    double w = (_controller.text.length.toDouble()) * charWidth;
    w = w < charWidth ? charWidth : w;

    return GestureDetector(
      onTap: () => requestFocus(),
      child: Row(
        children: [
          Container(
            width: 5 + w,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextField(
                focusNode: _focusNode,
                enabled: enabled && editable,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)
                ),
                style: TextStyle(fontSize: widget.valueSize, color: !enabled ? Colors.grey : null),
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, charWidth / 1.2, 0.0, charWidth / 2.0),
              child: Text(
                widget.unit,
                style: TextStyle(fontSize: widget.unitSize, color: Colors.grey)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
