import 'package:tycka/models/certData.dart';

abstract class CertUtils {
  static CertificateData getCertificate(Map data) {
    CertType certType = _getCertType(data[-260][1]);
    String schemaVer = data[-260][1]["ver"].toString();
    String name = data[-260][1]["nam"]["gn"].toString();
    String lastName = data[-260][1]["nam"]["fn"].toString();
    String dob = data[-260][1]["dob"].toString();
    String state = data[1];

    String certId = data[-260][1][_getKey(certType)]["ci"].toString();
    String certIssuer = data[-260][1][_getKey(certType)]["is"].toString();
    String desease = data[-260][1][_getKey(certType)]["tg"].toString();

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
