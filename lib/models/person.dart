import 'package:tycka/models/certificate.dart';

class Person {
  String id;
  DateTime lastChanged;
  String firstName;
  String lastName;
  DateTime dateOfBith;
  List<Certificate> certificates = <Certificate>[];

  Person(
      {required this.id,
      required this.lastChanged,
      required this.firstName,
      required this.lastName,
      required this.dateOfBith});

  String getBetterBirthDate() {
    return '${dateOfBith.day}. ${dateOfBith.month}. ${dateOfBith.year}';
  }

  String getName() {
    return '${this.lastName} ${this.firstName}';
  }

  static Person fromJson(Map data) {
    Person person = Person(
        id: data["id"],
        lastChanged: DateTime.parse(data["lastChangeGdc"]),
        firstName: data["givenName"],
        lastName: data["familyName"],
        dateOfBith: DateTime.parse(data["dateOfBirth"]));
    return person;
  }

  bool get isAtLeastOneValid =>
      certificates.any((certificate) => certificate.data.isValid);
}
