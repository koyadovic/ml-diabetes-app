import 'package:Dia/shared/tools/map_tools.dart';
import 'package:test/test.dart';


void main() {
  test('Empty maps should return empty map', () {
    Map<String, dynamic> original = {};
    Map<String, dynamic> newMap = {};
    expect(mapDifferences(original, newMap), {});
  });

  test('Map with changes', () {
    Map<String, dynamic> original = {};
    Map<String, dynamic> newMap = {'k': 'v'};
    expect(mapDifferences(original, newMap), {'k': 'v'});
  });

  test('Identical maps should return empty map', () {
    Map<String, dynamic> original = {'k': 'v'};
    Map<String, dynamic> newMap = {'k': 'v'};
    expect(mapDifferences(original, newMap), {});
  });

  test('Test one level of nesting', () {
    Map<String, dynamic> original = {
      'k': 'v',
      'k2': {'v2': 'v22'}
    };
    Map<String, dynamic> newMap = {
      'k': 'v',
      'k2': {'k2': 'v222'}
    };
    expect(mapDifferences(original, newMap), {
      'k2': {'k2': 'v222'}
    });
  });

  test('More levels of nesting.', () {
    Map<String, dynamic> original = {
      'k': 'v',
      'k2': {
        'k3': {
          'v3': 1
        },
        'k4': 2
      }
    };
    Map<String, dynamic> newMap = {
      'k': 'v',
      'k2': {
        'k3': {
          'v3': 2
        },
        'k4': 2
      }
    };
    expect(mapDifferences(original, newMap), {
      'k2': {
        'k3': {
          'v3': 2
        },
        'k4': 2
      }
    });
  });

}
