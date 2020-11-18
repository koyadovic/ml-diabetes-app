import 'package:iDietFit/user_data/model/entities/activities.dart';
import 'package:iDietFit/user_data/model/entities/feeding.dart';
import 'package:iDietFit/user_data/model/entities/flags.dart';
import 'package:iDietFit/user_data/model/entities/glucose.dart';
import 'package:iDietFit/user_data/model/entities/insulin.dart';
import 'package:iDietFit/user_data/model/entities/traits.dart';
import 'package:test/test.dart';


void main() {
  test('GlucoseLevel validations', () {
    GlucoseLevel g = GlucoseLevel(id: 1, level: null);
    g.validate();
    expect(g.isValid, false);
    g.level = 120;
    g.validate();
    expect(g.isValid, true);
    g.level = 0;
    g.validate();
    expect(g.isValid, false);
  });

  test('Activity validations', () {
    ActivityType at = ActivityType.fromJson({'name': 'Running', 'slug': 'running', 'METs': 5.0});
    Activity a = Activity(activityType: null, minutes: null);
    a.validate();
    expect(a.isValid, false);
    a.activityType = at;
    a.validate();
    expect(a.isValid, false);
    a.activityType = null;
    a.minutes = 10;
    a.validate();
    expect(a.isValid, false);
    a.activityType = at;
    a.validate();
    expect(a.isValid, true);
  });

  test('InsulinInjection validations', () {
    InsulinType it = InsulinType.fromJson({
      'name': 'Rapid',
      'slug': 'rapid',
      'categories': ['rapid'],
      'u_per_ml': 100,
      'color': '#000000',
    });

    InsulinInjection i = InsulinInjection(id: 1);
    i.validate();
    expect(i.isValid, false);
    i.units = 12;
    i.validate();
    expect(i.isValid, false);
    i.insulinType = it;
    i.validate();
    expect(i.isValid, true);
  });

  test('Feeding validations', () {
    Feeding f = Feeding(id: 1);
    f.validate();
    expect(f.isValid, false);
    f.carbGrams = 0;
    f.carbSugarGrams = 0;
    f.carbFiberGrams = 0;
    f.proteinGrams = 0;
    f.fatGrams = 0;
    f.saltGrams = 0;
    f.alcoholGrams = 0;
    f.validate();
    expect(f.isValid, false);
    f.carbGrams = 1;
    f.validate();
    expect(f.isValid, true);
  });

  test('TraitMeasure validations', () {
    TraitType tt = TraitType.fromJson({
      'name': 'Name',
      'slug': 'slug',
      'unit': 'unit',
      'options': ['1', '2', '3'],
    });
    TraitMeasure t = TraitMeasure();
    t.validate();
    expect(t.isValid, false);
    t.value = 13;
    t.validate();
    expect(t.isValid, false);
    t.traitType = tt;
    t.validate();
    expect(t.isValid, true);
  });

  test('Flag validations', () {
    Flag f = Flag(type: 'whatever');
    f.validate();
    expect(f.isValid, false);
    f = Flag(type: Flag.TYPE_HYPOGLYCEMIA);
    f.validate();
    expect(f.isValid, true);
    f = Flag(type: Flag.TYPE_INSULIN_TIME_CHANGE);
    f.validate();
    expect(f.isValid, true);
  });


}
