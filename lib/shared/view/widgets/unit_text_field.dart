import 'package:Dia/shared/view/utils/editable_status.dart';
import 'package:Dia/shared/view/utils/enabled_status.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:flutter/material.dart';

// if not valid throw ValidationError('Message');
typedef ValueProcessor = dynamic Function(dynamic value);


// class UnitTextField extends StatefulWidget {
//   final String unit;
//   final Function(dynamic) onChange;
//   final dynamic initialValue;
//   final List<ValueProcessor> processors;
//   final bool autoFocus;
//   final TextEditingController externalController;
//   final double unitSize;
//   final double valueSize;
//
//   UnitTextField({
//     @required this.unit,
//     @required this.onChange,
//     this.initialValue,
//     this.autoFocus : false,
//     this.processors : const [],
//     this.externalController,
//     this.unitSize : 12.0,
//     this.valueSize : 12.0,
//   });
//
//   @override
//   State<StatefulWidget> createState() {
//     return UnitTextFieldState();
//   }
// }
//
// class UnitTextFieldState extends State<UnitTextField> {
//   TextEditingController _controller;
//   double _lastValueEmitted;
//   FocusNode _focusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//
//     if(widget.autoFocus) {
//       Future.delayed(Duration(milliseconds: 300), () => requestFocus());
//     }
//   }
//
//   double processStringValue(String text) {
//     double numericalValue = text != null && text != '' ? double.parse(text) : 0.0;
//     return processValue(numericalValue);
//   }
//
//   double processValue(double value) {
//     for (ValueProcessor processor in widget.processors) {
//       value = processor(value);
//     }
//     return value;
//   }
//
//   String approximateDouble(double v) {
//     return v.toString();
//     // if (v.toInt() == v) {
//     //   return v.toInt().toString();
//     // }
//     // return v.toString();
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   void requestFocus() {
//     bool enabled = EnabledStatus.of(context);
//     bool editable = EditableStatus.of(context);
//     if(enabled && editable)
//       _focusNode.requestFocus();
//   }
//
//   TextEditingController updateController() {
//     if(widget.externalController == null) {
//
//     } else {
//       _controller = widget.externalController;
//     }
//   }
//
//   void checkController() {
//     bool addListener = false;
//     if(widget.externalController != null) {
//       if(_controller != widget.externalController) {
//         _controller = widget.externalController;
//         addListener = true;
//       }
//     } else {
//       _controller = TextEditingController(text: (widget.initialValue ?? 0.0) != 0.0 ? approximateDouble(widget.initialValue) : '0');
//       addListener = true;
//     }
//
//     if(addListener) {
//       _controller.addListener(() {
//         final text = _controller.text;
//         double numericalValue = processStringValue(text);
//
//         if (numericalValue != _lastValueEmitted) {
//           widget.onChange(numericalValue);
//           _lastValueEmitted = numericalValue;
//         }
//
//         _controller.value = _controller.value.copyWith(
//           text: approximateDouble(numericalValue),
//           selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
//           composing: TextRange.empty,
//         );
//         setState(() {});
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     checkController();
//
//     bool enabled = EnabledStatus.of(context);
//     bool editable = EditableStatus.of(context);
//
//     double scalingFactor = screenSizeScalingFactor(context);
//
//     double w = (_controller.text.length.toDouble()) * 20 * scalingFactor;
//     w = w < 13 * scalingFactor ? 13 * scalingFactor : w;
//
//     return GestureDetector(
//       onTap: () => requestFocus(),
//       child: Text.rich(
//         TextSpan(
//           children: <InlineSpan>[
//             WidgetSpan(
//               child: SizedBox(
//                 width: w,
//                 child: TextField(
//                   focusNode: _focusNode,
//                   enabled: enabled && editable,
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)
//                   ),
//                   style: TextStyle(fontSize: widget.valueSize, color: !enabled ? Colors.grey : null),
//                   keyboardType: TextInputType.number,
//                   controller: _controller,
//                 ),
//               )
//             ),
//             WidgetSpan(
//               child: Container(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7.5 / scalingFactor),
//                   child: Text(
//                     widget.unit,
//                     style: TextStyle(fontSize: widget.unitSize, color: Colors.grey)
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }



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
    _focusNode = FocusNode();

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
          print('Emitting $processedValue');
          widget.onChange(widget.isDouble ? processedValue : processedValue.round());
          _lastValueEmitted = processedValue;
        }

        String textInController;
        if(changed || originalParsedValue != processedValue) {
          textInController = processedValue.toString();
          if(textInController.endsWith('.0')) {
            textInController = textInController.replaceAll('.0', '.');
          }
        } else {
          textInController = _controller.text;
        }

        _controller.value = _controller.value.copyWith(
          text: textInController,
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

    double charWidth = (widget.valueSize / 2.0) + 1.0;
    double w = (_controller.text.length.toDouble()) * charWidth * scalingFactor;
    w = w < charWidth ? charWidth : w;

    return GestureDetector(
      onTap: () => requestFocus(),
      child: Row(
        children: [
          Container(
            width: 20 + w,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
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
