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
}

class VaccinationCert extends CertificateData {
  String vaccine;
  String vaccineProduct;
  String vaccineManufacturer;
  int doses;
  int totalDoses;
  DateTime vaccinationDate;

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
}

class TestCert extends CertificateData {
  String testType;
  String testName;
  DateTime date;
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
}

class RecoveryCert extends CertificateData {
  DateTime firtsPositive;
  DateTime validFrom;
  DateTime validUntil;

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
}
