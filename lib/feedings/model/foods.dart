import 'package:Dia/shared/model/validations.dart';
import 'package:Dia/shared/tools/numbers.dart';

class Food extends WithValidations {
  final int id;
  String name;
  double carbFactor;
  double carbFiberFactor;
  double carbSugarFactor;
  double proteinFactor;
  double fatFactor;
  double alcoholFactor;
  double saltFactor;
  double gramsPerUnit;
  final Map<String, dynamic> metadata;

  Food({this.id, this.name, this.carbFactor, this.carbFiberFactor, this.carbSugarFactor,
    this.proteinFactor, this.fatFactor, this.alcoholFactor, this.saltFactor,
    this.gramsPerUnit, this.metadata});

  bool get isFiberIncludedInCarbs => this.metadata['fiber_included_in_carbs'] ?? false;
  void fiberIsIncludedInCarbs() {
    this.metadata['fiber_included_in_carbs'] = true;
  }

  bool get isFiberSpecifiedSeparately => !this.isFiberIncludedInCarbs;
  void fiberIsSpecifiedSeparately() {
    this.metadata['fiber_included_in_carbs'] = false;
  }

  void setQuantityGrams(double quantity) {
    this.metadata['quantity'] = quantity;
  }

  double getQuantityGrams(){
    return this.metadata['quantity'] ?? 100.0;
  }

  static Food newFood() {
    Food food = Food(
      id: null,
      name: '',
      carbFactor: 0.0,
      carbFiberFactor: 0.0,
      carbSugarFactor: 0.0,
      proteinFactor: 0.0,
      fatFactor: 0.0,
      alcoholFactor: 0.0,
      saltFactor: 0.0,
      gramsPerUnit: 0.0,
      metadata: {},
    );
    food.fiberIsSpecifiedSeparately();
    food.setQuantityGrams(100.0);
    return food;
  }

  static Food fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> metadata = Map<String, dynamic>.from(json['metadata']);
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
      metadata: metadata,
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
      'metadata': metadata,
    };
  }

  Food clone() {
    return Food.fromJson(toJson());
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
  double _grams;

  FoodSelection({this.food, double grams}) {
    _grams = grams ?? 0.0;
  }

  double get carbGrams => food.carbFactor * _grams;
  double get carbFiberGrams => food.carbFiberFactor * _grams;
  double get carbSugarGrams => food.carbSugarFactor * _grams;
  double get proteinGrams => food.proteinFactor * _grams;
  double get fatGrams => food.fatFactor * _grams;
  double get alcoholGrams => food.alcoholFactor * _grams;
  double get saltGrams => food.saltFactor * _grams;
  
  double get kcal {
    return ((carbGrams - carbFiberGrams) * 4.0) +
        (proteinGrams * 4.0) + (fatGrams * 9.0) + (alcoholGrams * 7.0);
  }

  bool get hasGramsPerUnit => food.gramsPerUnit != null && food.gramsPerUnit > 0;
  int get units => _grams ~/ food.gramsPerUnit;

  void setUnits(int units) {
    _grams = units.toDouble() * food.gramsPerUnit;
  }

  double get grams => _grams;

  void setGrams(double grams) {
    _grams = grams;
  }
}
