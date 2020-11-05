/*
TYPES!
 */

class UserDataValueObject {
  final String name;
  final String slug;
  UserDataValueObject(this.name, this.slug);
}

/*
Core Entities!
 */

class UserDataEntity {
  final int id;
  final String entityType;
  DateTime eventDate;

  UserDataEntity(this.id, this.eventDate, this.entityType);
}
