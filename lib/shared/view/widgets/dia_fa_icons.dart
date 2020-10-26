import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DiaSmallFaIcon extends StatelessWidget {
  final IconData _iconData;
  final Color color;

  DiaSmallFaIcon(this._iconData, {this.color});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      _iconData,
      color: color,
      size: 18,
    );
  }
}


class DiaMediumFaIcon extends StatelessWidget {
  final IconData _iconData;
  final Color color;

  DiaMediumFaIcon(this._iconData, {this.color});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      _iconData,
      color: color,
      size: 26,
    );
  }
}


class DiaBigFaIcon extends StatelessWidget {
  final IconData _iconData;
  final Color color;

  DiaBigFaIcon(this._iconData, {this.color});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      _iconData,
      color: color,
      size: 36,
    );
  }
}
