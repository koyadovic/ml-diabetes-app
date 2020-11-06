import 'package:Dia/user_data/model/entities/activities.dart';
import 'package:Dia/user_data/model/entities/feeding.dart';
import 'package:Dia/user_data/model/entities/glucose.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
import 'package:Dia/user_data/model/entities/traits.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';


void main() {
  test('GlucoseLevel changes', () {
    GlucoseLevel g = GlucoseLevel(id: 1, level: 120);
    g.level = 90;
    expect(g.changesToJson(), {'level': 90});
  });

  test('Feeding changes', () {
    Feeding f = Feeding(id: 1, carbFiberGrams: 20);
    DateTime now = DateTime.now();
    f.carbFiberGrams = 30;
    f.carbGrams = 5;
    f.eventDate = now;

    expect(f.changesToJson(), {
      'carb_fiber_g': 30,
      'carb_g': 5,
      'event_date': now.microsecondsSinceEpoch / 1000000.0,
    });
  });

  test('InsulinInjection changes', () {
    InsulinType it1 = InsulinType('Tipo 1', 'tipo-1', ['rapid'], 100, '#000000');
    InsulinType it2 = InsulinType('Tipo 2', 'tipo-2', ['rapid'], 100, '#000000');

    InsulinInjection i = InsulinInjection(id: 1, insulinType: it1, units: 4);
    i.insulinType = it2;
    i.units = 5;
    expect(i.changesToJson(), {
      'units': 5,
      'insulin_type': it2.toJson()
    });
  });

  test('TraitMeasure changes', () {
    TraitType tt1 = TraitType('Tipo 1', 'tipo-1', 'cm', []);
    TraitType tt2 = TraitType('Tipo 2', 'tipo-2', 'm', []);

    TraitMeasure tm = TraitMeasure(id: 1, traitType: tt1, value: 40);
    tm.traitType = tt2;
    expect(tm.changesToJson(), {
      'trait_type': tt2.toJson()
    });
    tm.value = 41;
    tm.traitType = tt1;
    expect(tm.changesToJson(), {
      'value': 41,
    });
  });

  test('Activity changes', () {
    ActivityType at1 = ActivityType('Tipo 1', 'tipo-1', 12);
    ActivityType at2 = ActivityType('Tipo 2', 'tipo-2', 10);

    Activity a = Activity(id: 1, activityType: at1, minutes: 10);
    expect(a.changesToJson(), {});
    a.minutes = 5;
    expect(a.changesToJson(), {
      'minutes': 5
    });
    a.minutes = 10;
    a.activityType = at2;
    expect(a.changesToJson(), {
      'activity_type': at2.toJson()
    });
    a.minutes = 9;
    expect(a.changesToJson(), {
      'minutes': 9,
      'activity_type': at2.toJson()
    });
  });

  test('Test insulin types equality', () {
    InsulinType it1 = InsulinType('Tipo 1', 'tipo-1', ['rapid'], 100, '#000000');
    InsulinType it2 = InsulinType('Tipo 1', 'tipo-1', ['rapid'], 100, '#000000');
    expect(true, it1 == it2);
    InsulinType it3 = InsulinType.fromJson({
      'name': 'Tipo 1',
      'slug': 'tipo-1',
      'categories': ['rapid'],
      'u_per_ml': 100,
    });
    expect(true, it1 == it3);
    expect(true, it2 == it3);
  });

  test('Insulin injection reset', () {
    InsulinType it = InsulinType('Aspart', 'aspart', ['rapid-insulin'], 100, '#000000');
    InsulinInjection i = InsulinInjection(eventDate: DateTime.now(), units: 0, insulinType: it);
    i.units = 12;
    expect(i.changesToJson(), {'units': 12});
    i.reset();
    expect(i.changesToJson(), {});
  });

  test('List equality', () {
    Function eq = const ListEquality().equals;
    expect(eq([1,2], [1,2]), true);
    expect(eq([2], [1]), false);
    expect(eq([], []), true);
    expect(eq(['rapid'], ['rapid']), true);
    expect(eq([1], ['1']), false);
  });

  test('Trait measure reset', () {
    TraitType tt = TraitType('Tipo 1', 'tipo-1', 'cm', []);
    TraitMeasure tm = TraitMeasure(eventDate: DateTime.now(), traitType: tt, value: 0);
    tm.value = 1;
    expect(tm.changesToJson(), {'value': 1});
    tm.reset();
    expect(tm.changesToJson(), {});
  });

  test('Activity reset', () {
    ActivityType at = ActivityType('Tipo 1', 'tipo-1', 12);
    Activity a = Activity(eventDate: DateTime.now(), activityType: at, minutes: 0);
    a.minutes = 1;
    expect(a.changesToJson(), {'minutes': 1});
    a.reset();
    expect(a.changesToJson(), {});
  });


}
