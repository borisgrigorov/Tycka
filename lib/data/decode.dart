import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_base45/dart_base45.dart';
import 'package:cbor/cbor.dart';
import 'package:typed_data/typed_data.dart';

decodeCbor(String data) {
  if (data.substring(0, 4) == "HC1:") {
    print(data);
    var decoded = _decodeData(data.substring(4));
    Cbor cbortag = Cbor();
    cbortag.decodeFromList(decoded);
    print(cbortag.getDecodedData());
    try {
      List? cborData = cbortag.getDecodedData();

      print("CBOR DATA");
      print(cborData);
      print(utf8.decode(cborData as List<int>));
    } catch (e) {
      print("ERROR WHILE DECODING CBOR");
      print(e);
    }
    //Map dgc = {"tag": cborData["tag"]};
    return;
  } else {
    return null;
  }
}

List<int> _decodeData(String data) {
  Uint8List bytes = Base45.decode(data);
  print("Bytes");
  print(bytes.toString());
  List<int> decoded = zlib.decode(bytes);
  print("Zlib decoded");
  print(decoded);
  return decoded;
}
