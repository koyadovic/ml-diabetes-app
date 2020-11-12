import 'package:flutter/material.dart';

void unFocus(BuildContext c) {
  FocusScope.of(c).requestFocus(FocusNode());
}
