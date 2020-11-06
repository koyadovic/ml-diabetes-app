
/*
Errors
 */

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
            if(!validatorResults.containsKey(k)) {
              validatorResults[k] = [];
            }
            validatorResults[k].add(err.toString());
          }
        }
      }
    }
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
      throw ValidationError('Property is null');
  }
}


class ZeroOrPositiveNumberValidator extends Validator {
  @override
  validate(value) {
    if(value.runtimeType != double && value.runtimeType != int){
      throw ValidationError('Property is not a number');
    }
    if (value < 0) {
      throw ValidationError('Number must be zero or greater than zero');
    }
  }
}


class OneOrGreaterPositiveNumberValidator extends Validator {
  @override
  validate(value) {
    if(value.runtimeType != double && value.runtimeType != int){
      throw ValidationError('Property is not a number');
    }
    if (value < 1) {
      throw ValidationError('Number must be zero or greater than zero');
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
      throw ValidationError('Property is not a number');
    }
    if (!(minimum <= value && value <= maximum)) {
      throw ValidationError('Number must be between $minimum and $maximum');
    }
  }
}


class InValidator<T> extends Validator {
  final List<T> possibilities;

  InValidator(this.possibilities);

  @override
  validate(value) {
    if(value.runtimeType != T)
      throw ValidationError('Property is not of type $T');
    if (!possibilities.contains(value)) {
      throw ValidationError('Value $value not in ${possibilities.join(", ")}');
    }
  }
}

