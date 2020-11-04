import 'package:flutter/material.dart';

class EnabledStatus extends InheritedWidget {
  const EnabledStatus({
    Key key,
    @required this.isEnabled,
    @required Widget child,
  }) : assert(isEnabled != null),
        assert(child != null),
        super(key: key, child: child);

  final bool isEnabled;

  static bool of(BuildContext context) {
    EnabledStatus status = context.dependOnInheritedWidgetOfExactType<EnabledStatus>();
    return status?.isEnabled ?? true;
  }

  @override
  bool updateShouldNotify(EnabledStatus old) => isEnabled != old.isEnabled;
}
