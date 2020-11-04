import 'package:flutter/material.dart';

class EditableStatus extends InheritedWidget {
  const EditableStatus({
    Key key,
    @required this.isEditable,
    @required Widget child,
  }) : assert(isEditable != null),
        assert(child != null),
        super(key: key, child: child);

  final bool isEditable;

  static bool of(BuildContext context) {
    EditableStatus status = context.dependOnInheritedWidgetOfExactType<EditableStatus>();
    return status?.isEditable ?? true;
  }

  @override
  bool updateShouldNotify(EditableStatus old) => isEditable != old.isEditable;
}
