import 'package:tycka/data/certUtils.dart';
import 'package:tycka/data/decode.dart';
import 'package:tycka/models/certData.dart';

class Certificate {
  String id;
  String qrData;
  CertificateData data;

  Certificate({required this.id, required this.qrData, required this.data});

  static Certificate fromJson(Map data) {
    Certificate certificate = Certificate(
        id: data["id"],
        qrData: data["qrData"],
        data: CertUtils.getCertificate(decodeCbor(data["qrData"])));
    return certificate;
  }
}
