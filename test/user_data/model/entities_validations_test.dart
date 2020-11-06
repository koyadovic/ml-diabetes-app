import 'package:Dia/user_data/model/entities/glucose.dart';
import 'package:test/test.dart';


void main() {
  test('GlucoseLevel validations', () {
    GlucoseLevel g = GlucoseLevel(id: 1, level: null);
    g.validate();
    expect(g.isValid, false);
    g.level = 120;
    g.validate();
    expect(g.isValid, true);
  });
}
