import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tycka/models/validationRules.dart';

Future<CertValidationRules?> getValidationRules() async {
  var response = await http.get(
    Uri.parse(
        "https://dgcverify.mzcr.cz/api/v1/verify/NactiPravidlaPlatnostiDgc"),
  );
  if (response.statusCode != 200) {
    return null;
  }

  final data = json.decode(response.body)?["pravidla"]?[0];
  if (data != null) {
    return CertValidationRules.fromJson(data);
  }
  return null;
}
