import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tycka/consts/tests.dart';
import 'package:tycka/consts/vacinnes.dart';
import 'package:tycka/main.dart';
import 'package:tycka/models/validationRules.dart';
import 'package:tycka/utils/timeUtils.dart';

enum CertType { VAX, TEST, RECOVERY, UNKNOWN }

class CertificateData {
  String schemaVersion;
  String name;
  String lastName;
  String birthDate;
  CertType certType;
  String desease;
  String state;
  String certIssuer;
  String certID;

  CertificateData(
      {required this.schemaVersion,
      required this.name,
      required this.lastName,
      required this.birthDate,
      required this.certType,
      required this.desease,
      required this.state,
      required this.certIssuer,
      required this.certID});

  String getCertificateType(BuildContext context) {
    switch (certType) {
      case CertType.VAX:
        return AppLocalizations.of(context)!.vaccination;
      case CertType.TEST:
        return AppLocalizations.of(context)!.test;
      case CertType.RECOVERY:
        return AppLocalizations.of(context)!.recovery;
      default:
        return "UNKNOWN";
    }
  }

  bool get isValid => false;
}

class VaccinationCert extends CertificateData {
  String vaccine;
  String vaccineProduct;
  String vaccineManufacturer;
  int doses;
  int totalDoses;
  String vaccinationDate;

  VaccinationCert(
      {required String schemaVersion,
      required String name,
      required String lastName,
      required String birthDate,
      required CertType certType,
      required String desease,
      required String state,
      required String certIssuer,
      required String certID,
      required this.vaccine,
      required this.vaccineProduct,
      required this.vaccineManufacturer,
      required this.doses,
      required this.totalDoses,
      required this.vaccinationDate})
      : super(
            schemaVersion: schemaVersion,
            name: name,
            lastName: lastName,
            birthDate: birthDate,
            certType: certType,
            desease: desease,
            state: state,
            certIssuer: certIssuer,
            certID: certID);

  bool get isValid => _isValid();

  bool _isValid() {
    if (tyckaData.validationRules == null) {
      return false;
    } else {
      DateTime from = DateTime.parse(vaccinationDate);
      int difference = TimeUtils.getHoursBetween(from, DateTime.now());
      List<VaccionationValidity> vaccineValidity = tyckaData
          .validationRules!.vaccinesValidity
          .where((element) => element.vaccineCode == this.vaccineProduct)
          .toList();
      if (vaccineValidity.isEmpty) {
        return false;
      }
      if (totalDoses == 2 &&
          doses == totalDoses &&
          difference >= vaccineValidity[0].twoDoseVaccineValidFromDays) {
        return true;
      } else if (totalDoses == 1 &&
          difference >= vaccineValidity[0].oneDoseVaccineValidFromDays) {
        return true;
      } else if (doses == 1 &&
          totalDoses == 2 &&
          difference >=
              vaccineValidity[0].twoDoseVaccineFirstDoseValidFromDays) {
        return true;
      } else {
        return false;
      }
    }
  }

  String getDate() {
    DateTime date = DateTime.parse(this.vaccinationDate);
    return '${date.day}. ${date.month}. ${date.year}';
  }
}

class TestCert extends CertificateData {
  String testType;
  String testName;
  String date;
  String result;
  String testingCenter;

  TestCert(
      {required String schemaVersion,
      required String name,
      required String lastName,
      required String birthDate,
      required CertType certType,
      required String desease,
      required String state,
      required String certIssuer,
      required String certID,
      required this.testType,
      required this.testName,
      required this.date,
      required this.result,
      required this.testingCenter})
      : super(
            schemaVersion: schemaVersion,
            name: name,
            lastName: lastName,
            birthDate: birthDate,
            certType: certType,
            desease: desease,
            state: state,
            certIssuer: certIssuer,
            certID: certID);

  bool get isValid => _isValid();

  bool _isValid() {
    if (tyckaData.validationRules == null) {
      return false;
    } else {
      DateTime from = DateTime.parse(date);
      int difference = TimeUtils.getHoursBetween(from, DateTime.now());
      List<TestValidity> test = tyckaData.validationRules!.testsValidity
          .where((element) => element.testCode == this.testType)
          .toList();
      if (test.isEmpty) {
        return false;
      }
      if (difference <= test[0].validForHours && !this.isPositive()) {
        return true;
      } else {
        return false;
      }
    }
  }

  String getExpireTime(BuildContext context) {
    if (DateTime.parse(this.date).isBefore(DateTime.now())) {
      return AppLocalizations.of(context)!.expired;
    } else {
      int hours =
          TimeUtils.getHoursBetween(DateTime.parse(this.date), DateTime.now());
      return hours.toString() + "h";
    }
  }

  bool isPositive() {
    List<TestResult> test = predefinedTestResults
        .where((element) => element.code == this.result)
        .toList();
    if (test.isEmpty) {
      return false;
    } else {
      if (test[0].name == "Positive") {
        return true;
      } else {
        return false;
      }
    }
  }

  String getDate() {
    DateTime date = DateTime.parse(this.date);
    return '${date.day}. ${date.month}. ${date.year} ${date.hour}:${date.minute < 10 ? "0" : ""}${date.minute}';
  }
}

class RecoveryCert extends CertificateData {
  String firtsPositive;
  String validFrom;
  String validUntil;

  RecoveryCert({
    required this.firtsPositive,
    required this.validFrom,
    required this.validUntil,
    required String schemaVersion,
    required String name,
    required String lastName,
    required String birthDate,
    required CertType certType,
    required String desease,
    required String state,
    required String certIssuer,
    required String certID,
  }) : super(
            schemaVersion: schemaVersion,
            name: name,
            lastName: lastName,
            birthDate: birthDate,
            certType: certType,
            desease: desease,
            state: state,
            certIssuer: certIssuer,
            certID: certID);

  bool get isValid => _isValid();

  bool _isValid() {
    if (tyckaData.validationRules == null) {
      return false;
    } else {
      DateTime from = DateTime.parse(validFrom);
      int difference = TimeUtils.getDaysBetween(from, DateTime.now());
      if (difference <= tyckaData.validationRules!.recoveryTo &&
          difference >= tyckaData.validationRules!.recoveryFrom) {
        return true;
      } else {
        return false;
      }
    }
  }

  String getFrom() {
    DateTime date = DateTime.parse(this.validFrom);
    return '${date.day}. ${date.month}. ${date.year}';
  }

  String getTo() {
    DateTime date = DateTime.parse(this.validUntil);
    return '${date.day}. ${date.month}. ${date.year}';
  }
}
