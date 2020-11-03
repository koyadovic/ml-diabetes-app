import 'package:Dia/user_data/model/entities.dart';
import 'package:test/test.dart';


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
    InsulinType it1 = InsulinType('Tipo 1', 'tipo-1', ['rapid'], 100);
    InsulinType it2 = InsulinType('Tipo 2', 'tipo-2', ['rapid'], 100);

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
}
