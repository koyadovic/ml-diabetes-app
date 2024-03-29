
import 'package:iDietFit/shared/model/validations.dart';
import 'package:iDietFit/shared/tools/map_tools.dart';
import 'package:iDietFit/shared/tools/numbers.dart';
import 'base.dart';

class Feeding extends UserDataEntity {
  double carbGrams;
  double carbSugarGrams;
  double carbFiberGrams;
  double proteinGrams;
  double fatGrams;
  double alcoholGrams;
  double saltGrams;

  Map<String, dynamic> _original;

  Feeding({int id, DateTime eventDate, String entityType,
    this.carbGrams, this.carbSugarGrams, this.carbFiberGrams,
    this.proteinGrams, this.fatGrams, this.alcoholGrams, this.saltGrams
  }) : super(id, eventDate, entityType) {
    _original = toJson();
  }

  double get kCal {
    return ((carbGrams - carbFiberGrams + proteinGrams) * 4) + (fatGrams * 9) + (alcoholGrams * 7);
  }

  static Feeding fromJson(Map<String, dynamic> json) {
    return Feeding(
      id: json['id'],
      eventDate: json['event_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch((json['event_date'] * 1000000.0).round(), isUtc: true).toUtc(),
      entityType: json['entity_type'] != null ? json['entity_type'] : 'Feeding',
      carbGrams: json['carb_g'],
      carbSugarGrams: json['carb_sugar_g'],
      carbFiberGrams: json['carb_fiber_g'],
      proteinGrams: json['protein_g'],
      fatGrams: json['fat_g'],
      alcoholGrams: json['alcohol_g'],
      saltGrams: json['salt_g'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_date': eventDate != null ? eventDate.toUtc().microsecondsSinceEpoch.toDouble() / 1000000.0 : null,
      'entity_type': entityType,
      'carb_g': carbGrams,
      'carb_sugar_g': carbSugarGrams,
      'carb_fiber_g': carbFiberGrams,
      'protein_g': proteinGrams,
      'fat_g': fatGrams,
      'alcohol_g': alcoholGrams,
      'salt_g': saltGrams,
    };
  }

  Map<String, dynamic> changesToJson() {
    return mapDifferences(_original, toJson());
  }

  bool get hasChanged {
    return changesToJson().keys.length > 0;
  }

  Feeding clone() {
    return Feeding.fromJson(toJson());
  }

  void reset() {
    Feeding original = Feeding.fromJson(_original);
    this.eventDate = original.eventDate;
    this.carbGrams = original.carbGrams;
    this.carbSugarGrams = original.carbSugarGrams;
    this.carbFiberGrams = original.carbFiberGrams;
    this.proteinGrams = original.proteinGrams;
    this.fatGrams = original.fatGrams;
    this.alcoholGrams = original.alcoholGrams;
    this.saltGrams = original.saltGrams;
  }

  /*
  Validations
   */

  @override
  Map<String, dynamic> toMapForValidation() {
    return {
      'carbGrams': carbGrams,
      'carbSugarGrams': carbSugarGrams,
      'carbFiberGrams': carbFiberGrams,
      'proteinGrams': proteinGrams,
      'fatGrams': fatGrams,
      'alcoholGrams': alcoholGrams,
      'saltGrams': saltGrams,
    };
  }

  static Map<String, List<Validator>> validators = {
    'carbGrams': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'carbSugarGrams': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'carbFiberGrams': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'proteinGrams': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'fatGrams': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'alcoholGrams': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
    'saltGrams': [NotNullValidator(), ZeroOrPositiveNumberValidator()],
  };

  @override
  Map<String, List<Validator>> getValidators() {
    return Feeding.validators;
  }

  @override
  void validate() {
    super.validate();
    if((num(carbGrams) + num(carbSugarGrams) + num(carbFiberGrams) + num(proteinGrams) + num(fatGrams) + num(alcoholGrams) + num(saltGrams)) == 0) {
      validatorResults['global'] = ['All properties are zero'];
    }
  }

  bool operator == (o) => o is Feeding && o.id == id && o.eventDate == eventDate &&
      o.carbGrams == carbGrams && o.carbSugarGrams == carbSugarGrams && o.carbFiberGrams == carbFiberGrams &&
      o.proteinGrams == proteinGrams && o.fatGrams == fatGrams && o.alcoholGrams == alcoholGrams && o.saltGrams == saltGrams;

  int get hashCode => id.hashCode ^ eventDate.hashCode ^ carbGrams.hashCode ^ carbSugarGrams.hashCode ^
    carbFiberGrams.hashCode ^ proteinGrams.hashCode ^ fatGrams.hashCode ^ alcoholGrams.hashCode ^ saltGrams.hashCode;
}
