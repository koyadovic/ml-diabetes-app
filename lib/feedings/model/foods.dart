import 'package:Dia/shared/model/validations.dart';
import 'package:Dia/shared/tools/numbers.dart';

class Food extends WithValidations {
  final int id;
  final String name;
  final double carbFactor;
  final double carbFiberFactor;
  final double carbSugarFactor;
  final double proteinFactor;
  final double fatFactor;
  final double alcoholFactor;
  final double saltFactor;
  final double gramsPerUnit;

  Food({this.id, this.name, this.carbFactor, this.carbFiberFactor, this.carbSugarFactor,
    this.proteinFactor, this.fatFactor, this.alcoholFactor, this.saltFactor, this.gramsPerUnit});

  static Food fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      carbFactor: json['carb_factor'],
      carbFiberFactor: json['carb_fiber_factor'],
      carbSugarFactor: json['carb_sugar_factor'],
      proteinFactor: json['protein_factor'],
      fatFactor: json['fat_factor'],
      alcoholFactor: json['alcohol_factor'],
      saltFactor: json['salt_factor'],
      gramsPerUnit: json['grams_per_unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'carb_factor': carbFactor,
      'carb_fiber_factor': carbFiberFactor,
      'carb_sugar_factor': carbSugarFactor,
      'protein_factor': proteinFactor,
      'fat_factor': fatFactor,
      'alcohol_factor': alcoholFactor,
      'salt_factor': saltFactor,
      'grams_per_unit': gramsPerUnit,
    };
  }

  @override
  bool operator == (Object other) {
    return identical(this, other) ||
        other is Food &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            carbFactor == other.carbFactor &&
            carbFiberFactor == other.carbFiberFactor &&
            carbSugarFactor == other.carbSugarFactor &&
            proteinFactor == other.proteinFactor &&
            fatFactor == other.fatFactor &&
            alcoholFactor == other.alcoholFactor &&
            saltFactor == other.saltFactor &&
            gramsPerUnit == other.gramsPerUnit;
  }

  @override
  int get hashCode => (
      name.hashCode ^ carbFactor.hashCode ^ carbFiberFactor.hashCode ^
      carbSugarFactor.hashCode ^ proteinFactor.hashCode ^ fatFactor.hashCode ^
      alcoholFactor.hashCode ^ saltFactor.hashCode ^ gramsPerUnit.hashCode
  );

  String toString() => name;

  /*
  Validations
   */

  @override
  Map<String, dynamic> toMapForValidation() {
    return toJson();
  }

  static Map<String, List<Validator>> validators = {
    'name': [NotNullValidator()],
    'carb_factor': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'carb_fiber_factor': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'carb_sugar_factor': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'protein_factor': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'fat_factor': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'alcohol_factor': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'salt_factor': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'grams_per_unit': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
  };

  @override
  Map<String, List<Validator>> getValidators() {
    return Food.validators;
  }

  @override
  void validate() {
    super.validate();
    validatorResults['global'] = [];
    if((num(carbFactor) + num(carbFiberFactor) + num(carbSugarFactor) + num(proteinFactor) + num(fatFactor) + num(alcoholFactor) + num(saltFactor)) == 0) {
      validatorResults['global'].add('All properties cannot be zero');
    }
    if(num(carbFactor) < num(carbFiberFactor) + num(carbSugarFactor)) {
      validatorResults['global'].add('Carbs are lower than the sum of fiber and sugar. Carbs reference the total so need to be greater');
    }

    if(validatorResults['global'].length == 0) {
      validatorResults.remove('global');
    }
  }

}


class FoodSelection {
  final Food food;
  final double grams;

  FoodSelection({this.food, this.grams});

}