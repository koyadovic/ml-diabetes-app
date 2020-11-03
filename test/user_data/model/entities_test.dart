import 'package:Dia/user_data/model/entities.dart';
import 'package:test/test.dart';


void main() {
  test('Empty maps should return empty map', () {
    /*
    int id, DateTime eventDate, String entityType, this.level
     */
    GlucoseLevel g = GlucoseLevel(id: 1, level: 120);
    g.level = 90;
    expect(g.changesToJson(), {'level': 90});
  });
}
