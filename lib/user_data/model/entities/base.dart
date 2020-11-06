/*
TYPES!
 */

import 'package:Dia/shared/model/validations.dart';

abstract class UserDataValueObject {
  final String name;
  final String slug;
  UserDataValueObject(this.name, this.slug);
}

/*
Core Entities!
 */

abstract class UserDataEntity extends WithValidations {
  final int id;
  final String entityType;
  DateTime eventDate;

  UserDataEntity(this.id, this.eventDate, this.entityType);
}
