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


}
