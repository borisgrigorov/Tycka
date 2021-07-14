class Certificate {
  String id;
  String qrData;

  Certificate({required this.id, required this.qrData});

  static Certificate fromJson(Map data) {
    Certificate certificate =
        Certificate(id: data["id"], qrData: data["qrData"]);
    return certificate;
  }
}
