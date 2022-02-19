import 'dart:io';
import 'dart:typed_data';

import 'package:dart_base45/dart_base45.dart';
import 'package:cbor/cbor.dart';

decodeCbor(String data) {
  if (data.substring(0, 4) == "HC1:") {
    String b45data = data.substring(4);
    Uint8List zlibdata = Base45.decode(b45data);
    var cbordata = zlib.decode(zlibdata);
    Cbor cbortag = Cbor();
    cbortag.decodeFromList(cbordata);

    List? decoded = cbortag.getDecodedData();
    Cbor cbortag2 = Cbor();
    cbortag2.decodeFromBuffer(decoded![0][2]);
    final decodedData = cbortag2.getDecodedData()![0];
    //print(decodedData[-260][1]["nam"]["gn"]);
    return decodedData;
  } else {
    return null;
  }
}
