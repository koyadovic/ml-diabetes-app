import 'package:Dia/shared/view/utils/font_sizes.dart';
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
      return FontAwesomeIcons.fontAwesomeFlag;
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
      size: 20 * screenSizeScalingFactor(context),
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
      size: 26 * screenSizeScalingFactor(context),
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
      size: 36 * screenSizeScalingFactor(context),
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
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.InsulinInjection, color: Colors.indigo);
}
class InsulinInjectionIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.InsulinInjection, color: Colors.indigo);
}
class InsulinInjectionIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.InsulinInjection, color: Colors.indigo);
}


class FeedingIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.Feeding, color: Colors.lightGreen);
}
class FeedingIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.Feeding, color: Colors.lightGreen);
}
class FeedingIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.Feeding, color: Colors.lightGreen);
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
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.TraitMeasure, color: Colors.grey);
}
class TraitMeasureIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.TraitMeasure, color: Colors.grey);
}
class TraitMeasureIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.TraitMeasure, color: Colors.grey);
}


class FlagIconSmall extends StatelessWidget {
  Widget build(BuildContext context) => DiaSmallFaIcon(Entity.Flag, color: Colors.orange);
}
class FlagIconMedium extends StatelessWidget {
  Widget build(BuildContext context) => DiaMediumFaIcon(Entity.Flag, color: Colors.orange);
}
class FlagIconBig extends StatelessWidget {
  Widget build(BuildContext context) => DiaBigFaIcon(Entity.Flag, color: Colors.orange);
}
