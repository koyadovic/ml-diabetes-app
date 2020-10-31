import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Entity {
  GlucoseLevel,
  Activity,
  TraitMeasure,
  Feeding,
  InsulinInjection,
  Flag,
}


IconData getIconData(Entity entity) {
  switch (entity) {
    case Entity.GlucoseLevel:
      return FontAwesomeIcons.tint;
    case Entity.Activity:
      return FontAwesomeIcons.dumbbell;
    case Entity.TraitMeasure:
      return FontAwesomeIcons.weight;
    case Entity.Feeding:
      return FontAwesomeIcons.appleAlt;
    case Entity.InsulinInjection:
      return FontAwesomeIcons.syringe;
    case Entity.Flag:
      return FontAwesomeIcons.flag;
  }
  return null;
}


class DiaSmallFaIcon extends StatelessWidget {
  final Entity entity;
  final Color color;

  DiaSmallFaIcon(this.entity, {this.color});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      getIconData(entity),
      color: color,
      size: 18,
    );
  }
}


class DiaMediumFaIcon extends StatelessWidget {
  final Entity entity;
  final Color color;

  DiaMediumFaIcon(this.entity, {this.color});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      getIconData(entity),
      color: color,
      size: 26,
    );
  }
}


class DiaBigFaIcon extends StatelessWidget {
  final Entity entity;
  final Color color;

  DiaBigFaIcon(this.entity, {this.color});

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      getIconData(entity),
      color: color,
      size: 36,
    );
  }
}


class GlucoseLevelIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.GlucoseLevel, color: Colors.red);
}
class GlucoseLevelIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.GlucoseLevel, color: Colors.red);
}
class GlucoseLevelIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.GlucoseLevel, color: Colors.red);
}


class InsulinInjectionIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.InsulinInjection, color: Colors.lightGreen);
}
class InsulinInjectionIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.InsulinInjection, color: Colors.lightGreen);
}
class InsulinInjectionIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.InsulinInjection, color: Colors.lightGreen);
}


class FeedingIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.Feeding, color: Colors.orange);
}
class FeedingIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.Feeding, color: Colors.orange);
}
class FeedingIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.Feeding, color: Colors.orange);
}


class ActivityIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.Activity, color: Colors.blue);
}
class ActivityIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.Activity, color: Colors.blue);
}
class ActivityIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.Activity, color: Colors.blue);
}


class TraitMeasureIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.TraitMeasure, color: Colors.teal);
}
class TraitMeasureIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.TraitMeasure, color: Colors.teal);
}
class TraitMeasureIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.TraitMeasure, color: Colors.teal);
}


class FlagIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.TraitMeasure, color: Colors.blueGrey);
}
class FlagIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.TraitMeasure, color: Colors.blueGrey);
}
class FlagIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.TraitMeasure, color: Colors.blueGrey);
}

