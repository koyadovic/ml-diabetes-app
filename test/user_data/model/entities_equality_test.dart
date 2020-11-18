import 'package:iDietFit/user_data/model/entities/activities.dart';
import 'package:iDietFit/user_data/model/entities/feeding.dart';
import 'package:iDietFit/user_data/model/entities/glucose.dart';
import 'package:iDietFit/user_data/model/entities/insulin.dart';
import 'package:iDietFit/user_data/model/entities/traits.dart';
import 'package:test/test.dart';

void main() {
  test('GlucoseLevel equality', () {
    GlucoseLevel g1 = GlucoseLevel(id: 1, level: 120);
    GlucoseLevel g2 = GlucoseLevel(id: 1, level: 120);
    expect(g1 == g2, true);
    g2.level = 119;
    expect(g1 == g2, false);
  });


  test('Feeding equality', () {
    DateTime now = DateTime.now();
    Feeding f1 = Feeding(id: null, carbFiberGrams: 20, eventDate: now);
    Feeding f2 = Feeding(id: null, carbFiberGrams: 20, eventDate: now);
    expect(f1 == f2, true);
    f2.saltGrams = 1;
    expect(f1 == f2, false);
  });

  test('Activity equality', () {
    DateTime now = DateTime.now();
    ActivityType at1 = ActivityType('Tipo 1', 'tipo-1', 12);
    ActivityType at2 = ActivityType('Tipo 2', 'tipo-2', 12);
    Activity a1 = Activity(id: 1, activityType: at1, minutes: 5, eventDate: now);
    Activity a2 = Activity(id: 1, activityType: at1, minutes: 5, eventDate: now);
    expect(a1 == a2, true);
    a2.activityType = at2;
    expect(a1 == a2, false);
    a2.activityType = at1;
    expect(a1 == a2, true);
    a1.minutes = 4;
    expect(a1 == a2, false);
    a1.minutes = 5;
    expect(a1 == a2, true);
  });

  test('InsulinInjection equality', () {
    DateTime now = DateTime.now();
    InsulinType it1 = InsulinType('Tipo 1', 'tipo-1', ['rapid'], 100, '#000000');
    InsulinType it2 = InsulinType('Tipo 1', 'tipo-1', ['rapid'], 100, '#000000');
    InsulinInjection i1 = InsulinInjection(eventDate: now, units: 0, insulinType: it1);
    InsulinInjection i2 = InsulinInjection(eventDate: now, units: 0, insulinType: it1);
    expect(i1 == i2, true);
    i1.insulinType = it2;
    expect(i1 == i2, true);
    i2.units = 1;
    expect(i1 == i2, false);
    i2.units = 0;
    expect(i1 == i2, true);
  });

  test('TraitMeasure equality', () {
    DateTime now = DateTime.now();
    TraitType tt1 = TraitType('Tipo 1', 'tipo-1', 'cm', []);
    TraitType tt2 = TraitType('Tipo 2', 'tipo-2', 'cm', []);
    TraitMeasure tm1 = TraitMeasure(eventDate: now, traitType: tt1, value: 0);
    TraitMeasure tm2 = TraitMeasure(eventDate: now, traitType: tt1, value: 0);
    expect(tm1 == tm2, true);
    tm1.traitType = tt2;
    expect(tm1 == tm2, false);
    tm1.traitType = tt1;
    expect(tm1 == tm2, true);
    tm1.value = 1;
    expect(tm1 == tm2, false);
  });

}
