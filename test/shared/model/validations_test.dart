import 'package:iDietFit/shared/model/validations.dart';
import 'package:test/test.dart';


void main() {
  test('NotNullValidator', () {
    expect(() => NotNullValidator().validate(null), throwsA(TypeMatcher<ValidationError>()));
    expect(() => NotNullValidator().validate(1), returnsNormally);
    expect(() => NotNullValidator().validate(''), returnsNormally);
    expect(() => NotNullValidator().validate(0), returnsNormally);
  });

  test('ZeroOrPositiveNumberValidator', () {
    expect(() => ZeroOrPositiveNumberValidator().validate(-1), throwsA(TypeMatcher<ValidationError>()));
    expect(() => ZeroOrPositiveNumberValidator().validate(-0.001), throwsA(TypeMatcher<ValidationError>()));
    expect(() => ZeroOrPositiveNumberValidator().validate(1), returnsNormally);
    expect(() => ZeroOrPositiveNumberValidator().validate(0), returnsNormally);
    expect(() => ZeroOrPositiveNumberValidator().validate(2000.0), returnsNormally);
  });

  test('OneOrGreaterPositiveNumberValidator', () {
    expect(() => OneOrGreaterPositiveNumberValidator().validate(-1), throwsA(TypeMatcher<ValidationError>()));
    expect(() => OneOrGreaterPositiveNumberValidator().validate(-0.001), throwsA(TypeMatcher<ValidationError>()));
    expect(() => OneOrGreaterPositiveNumberValidator().validate(0.0), throwsA(TypeMatcher<ValidationError>()));
    expect(() => OneOrGreaterPositiveNumberValidator().validate(1), returnsNormally);
    expect(() => OneOrGreaterPositiveNumberValidator().validate(0.1), throwsA(TypeMatcher<ValidationError>()));
    expect(() => OneOrGreaterPositiveNumberValidator().validate(2000.0), returnsNormally);
  });

  test('NumberBetweenValidator', () {
    expect(() => NumberBetweenValidator(0, 1).validate(-1), throwsA(TypeMatcher<ValidationError>()));
    expect(() => NumberBetweenValidator(0, 1).validate(0), returnsNormally);
    expect(() => NumberBetweenValidator(0, 1).validate(1), returnsNormally);
    expect(() => NumberBetweenValidator(0, 1).validate(2), throwsA(TypeMatcher<ValidationError>()));

    expect(() => NumberBetweenValidator(-10, 10).validate(-10.5), throwsA(TypeMatcher<ValidationError>()));
    expect(() => NumberBetweenValidator(-10, 10).validate(-1), returnsNormally);
    expect(() => NumberBetweenValidator(-10, 10).validate(4), returnsNormally);
    expect(() => NumberBetweenValidator(-10, 10).validate(10.2), throwsA(TypeMatcher<ValidationError>()));
  });

  test('InValidator', () {
    expect(() => InValidator<String>(['Yes', 'No']).validate('Maybe'), throwsA(TypeMatcher<ValidationError>()));
    expect(() => InValidator<String>(['Yes', 'No']).validate('No'), returnsNormally);
    expect(() => InValidator<String>(['Yes', 'No']).validate('Yes'), returnsNormally);
    expect(() => InValidator<String>(['Yes', 'No']).validate(null), throwsA(TypeMatcher<ValidationError>()));
    expect(() => InValidator<String>(['Yes', 'No']).validate(1), throwsA(TypeMatcher<ValidationError>()));
    expect(() => InValidator<String>(['Yes', 'No']).validate(0), throwsA(TypeMatcher<ValidationError>()));
  });

}