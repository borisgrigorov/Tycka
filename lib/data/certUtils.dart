import 'package:tycka/models/certData.dart';

abstract class CertUtils {
  static CertificateData getCertificate(Map data) {
    CertType certType = _getCertType(data[-260][1]);
    String schemaVer = data[-260][1]["ver"].toString();
    String name = data[-260][1]["nam"]["gn"].toString();
    String lastName = data[-260][1]["nam"]["fn"].toString();
    String dob = data[-260][1]["dob"].toString();
    String state = data[1];
    String certId = data[-260][1][_getKey(certType)][0]["ci"].toString();
    String certIssuer = data[-260][1][_getKey(certType)][0]["is"].toString();
    String desease = data[-260][1][_getKey(certType)][0]["tg"].toString();

    if (certType == CertType.VAX) {
      String vaccine = data[-260][1][_getKey(certType)][0]["vp"].toString();
      String vaccineProduct =
          data[-260][1][_getKey(certType)][0]["mp"].toString();
      String vaccineManufacturer =
          data[-260][1][_getKey(certType)][0]["ma"].toString();
      int doses = data[-260][1][_getKey(certType)][0]["dn"];
      int totalDoses = data[-260][1][_getKey(certType)][0]["sd"];
      String vaccinationDate =
          data[-260][1][_getKey(certType)][0]["dt"].toString();
      return VaccinationCert(
          doses: doses,
          totalDoses: totalDoses,
          vaccine: vaccine,
          vaccineProduct: vaccineProduct,
          vaccineManufacturer: vaccineManufacturer,
          vaccinationDate: vaccinationDate,
          certType: certType,
          birthDate: dob,
          lastName: lastName,
          name: name,
          state: state,
          schemaVersion: schemaVer,
          certID: certId,
          certIssuer: certIssuer,
          desease: desease);
    } else if (certType == CertType.TEST) {
      String result = data[-260][1][_getKey(certType)][0]["tr"].toString();
      String testDate = data[-260][1][_getKey(certType)][0]["sc"].toString();
      String testType = data[-260][1][_getKey(certType)][0]["tt"].toString();
      String testName = data[-260][1][_getKey(certType)][0]["nm"].toString();
      String testingCenter =
          data[-260][1][_getKey(certType)][0]["tc"].toString();
      return TestCert(
          result: result,
          date: testDate,
          testType: testType,
          testName: testName,
          testingCenter: testingCenter,
          certType: certType,
          birthDate: dob,
          lastName: lastName,
          name: name,
          state: state,
          schemaVersion: schemaVer,
          certID: certId,
          certIssuer: certIssuer,
          desease: desease);
    } else if (certType == CertType.RECOVERY) {
      String firstPositive =
          data[-260][1][_getKey(certType)][0]["fr"].toString();
      String validFrom = data[-260][1][_getKey(certType)][0]["df"].toString();
      String validUntil = data[-260][1][_getKey(certType)][0]["du"].toString();
      return RecoveryCert(
          validFrom: validFrom,
          validUntil: validUntil,
          firtsPositive: firstPositive,
          certType: certType,
          birthDate: dob,
          lastName: lastName,
          name: name,
          state: state,
          schemaVersion: schemaVer,
          certID: certId,
          certIssuer: certIssuer,
          desease: desease);
    } else {
      return CertificateData(
          certType: certType,
          birthDate: dob,
          lastName: lastName,
          name: name,
          state: state,
          schemaVersion: schemaVer,
          certID: certId,
          certIssuer: certIssuer,
          desease: desease);
    }
  }

  static _getCertType(Map data) {
    if (data.containsKey("v")) {
      return CertType.VAX;
    } else if (data.containsKey("t")) {
      return CertType.TEST;
    } else if (data.containsKey("e")) {
      return CertType.RECOVERY;
    } else {
      return CertType.UNKNOWN;
    }
  }

  static _getKey(CertType type) {
    switch (type) {
      case CertType.VAX:
        return "v";
      case CertType.TEST:
        return "t";
      case CertType.RECOVERY:
        return "r";
      case CertType.UNKNOWN:
        return "v";
    }
  }
}
