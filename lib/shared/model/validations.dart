
/*
Errors
 */

import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';


class NotImplemented {
}


class ValidationError {
  final String text;
  ValidationError(this.text);
  String toString() => this.text;
}


/*
Main class for use as a template pattern
 */

abstract class WithValidations {
  Map<String, List<String>> validatorResults = {};
  Map<String, List<Validator>> getValidators();

  final List<VoidCallback> validationListeners = [];

  void addValidationListener(VoidCallback callback) {
    validationListeners.add(callback);
  }

  void removeValidationListener(VoidCallback callback) {
    validationListeners.remove(callback);
  }

  void _notifyValidationListeners() {
    for(VoidCallback cb in validationListeners) cb();
  }

  void validate() {
    validatorResults = {};
    Map<String, dynamic> mapInstance = toMapForValidation();
    Map<String, List<Validator>> validators = getValidators();
    for(String k in validators.keys) {
      if(mapInstance.containsKey(k)) {
        dynamic value = mapInstance[k];
        for(Validator validator in validators[k]) {
          try {
            validator.validate(value);
          } on ValidationError catch(err) {
            addPropertyValidationText(k, err.toString());
          }
        }
      }
    }
    _notifyValidationListeners();
  }

  void addPropertyValidationText(String property, String text) {
    if(!validatorResults.containsKey(property)) {
      validatorResults[property] = [];
    }
    validatorResults[property].add(text);
  }

  bool get isValid {
    return validatorResults.keys.length == 0;
  }

  bool isPropertyValid(String property) {
    return !validatorResults.containsKey(property);
  }

  String getPropertyValidationText(String property) {
    if (isPropertyValid(property)) return '';
    return validatorResults[property].join(', ');
  }

  String getFullValidationText({bool includePropertyNames: false}) {
    String text = '';
    for(String k in validatorResults.keys) {
      if(text != '') {
        if(includePropertyNames) {
          text += '\n$k: ${validatorResults[k].join(", ")}';
        } else {
          text += '\n${validatorResults[k].join(", ")}';
        }
      } else {
        if(includePropertyNames) {
          text += '$k: ${validatorResults[k].join(", ")}';
        } else {
          text += '${validatorResults[k].join(", ")}';
        }
      }
    }
    return text;
  }

  Map<String, dynamic> toMapForValidation(){
    throw NotImplemented();
  }
}


/*
Main abstract validator
 */

abstract class Validator {
  validate(dynamic value); // if not valid raise ValidationError
}


/*
Concrete Validator classes to configure how to do the validation
 */

class NotNullValidator extends Validator {
  @override
  validate(value) {
    if(value == null)
      throw ValidationError('Not set yet'.tr());
  }
}


class ZeroOrPositiveNumberValidator extends Validator {
  @override
  validate(value) {
    if(value.runtimeType != double && value.runtimeType != int){
      throw ValidationError('Not a number'.tr());
    }
    if (value < 0) {
      throw ValidationError('Must be zero or greater than zero'.tr());
    }
  }
}


class NotEmptyStringValidator extends Validator {
  @override
  validate(value) {
    if (!(value is String)) {
      throw ValidationError('Cannot be empty'.tr());
    }
    if (value.toString() == '') {
      throw ValidationError('Cannot be empty'.tr());
    }
  }
}


class OneOrGreaterPositiveNumberValidator extends Validator {
  @override
  validate(value) {
    if(value.runtimeType != double && value.runtimeType != int){
      throw ValidationError('Not a number'.tr());
    }
    if (value < 1) {
      throw ValidationError('Must be zero or greater than zero'.tr());
    }
  }
}


class NumberBetweenValidator extends Validator {
  final double minimum;
  final double maximum;

  NumberBetweenValidator(this.minimum, this.maximum);

  @override
  validate(value) {
    if(value.runtimeType != double && value.runtimeType != int){
      throw ValidationError('Not a number'.tr());
    }
    if (!(minimum <= value && value <= maximum)) {
      throw ValidationError('Must be between ${minimum.round()} and ${maximum.round()}');
    }
  }
}


class InValidator<T> extends Validator {
  final List<T> possibilities;

  InValidator(this.possibilities);

  @override
  validate(value) {
    if(value.runtimeType != T)
      throw ValidationError('Not of type'.tr(namedArgs: {'type': T.toString()}));
    if (!possibilities.contains(value)) {
      throw ValidationError('not in'.tr(namedArgs: {'value': value.toString(), 'possibilities': possibilities.join(", ")}));
    }
  }
}

