import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class DiaDateField extends StatelessWidget {
  final format = DateFormat.yMMMMd();
  final DateTime initialValue;
  final DateFormat customFormat;
  final Function(DateTime) onChanged;

  DiaDateField({this.customFormat, this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DateTimeField(
          initialValue: initialValue ?? DateTime.now(),
          format: customFormat ?? format,
          onChanged: onChanged,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          },
        ),
      ]
    );
  }
}

class DiaTimeField extends StatelessWidget {
  final format = DateFormat("HH:mm");
  final DateFormat customFormat;
  final Function(DateTime) onChanged;
  final DateTime initialValue;

  DiaTimeField({this.customFormat, this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        initialValue: initialValue ?? DateTime.now(),
        format: customFormat ?? format,
        onChanged: onChanged,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}


// class DiaDateTimeField extends StatelessWidget {
//   // TODO take formats from settings
//   final format = DateFormat("yyyy-MM-dd HH:mm");
//   final DateFormat customFormat;
//   final Function(DateTime) onChanged;
//
//   DiaDateTimeField({this.customFormat, this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       Text('Basic date & time field (${format.pattern})'),
//       DateTimeField(
//         format: format,
//         onShowPicker: (context, currentValue) async {
//           final date = await showDatePicker(
//               context: context,
//               firstDate: DateTime(1900),
//               initialDate: currentValue ?? DateTime.now(),
//               lastDate: DateTime(2100));
//           if (date != null) {
//             final time = await showTimePicker(
//               context: context,
//               initialTime:
//               TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
//             );
//             return DateTimeField.combine(date, time);
//           } else {
//             return currentValue;
//           }
//         },
//       ),
//     ]);
//   }
// }