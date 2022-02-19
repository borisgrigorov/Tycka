import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tycka/data/consts.dart';
import 'package:tycka/main.dart';
import 'package:tycka/models/validationRules.dart';

Future<CertValidationRules?> getValidationRules() async {
  var response = await http.get(
    Uri.parse(TyckaConsts.VALIDATION_RULES_URL),
  );
  if (response.statusCode != 200) {
    return null;
  }

  final data = json.decode(response.body)?["pravidla"]?[0];
  if (data != null) {
    await tyckaData.preferences.setValidationRules(response.body);
    await tyckaData.preferences
        .setValidationRulesDownloadDate(DateTime.now().millisecondsSinceEpoch);
    return CertValidationRules.fromJson(data);
  }
  return null;
}

Future<CertValidationRules?> getValidationRulesFromCache() async {
  String? text = tyckaData.preferences.getValidationRules();

  if (text == null) {
    return null;
  }

  final data = json.decode(text)?["pravidla"]?[0];
  if (data != null) {
    return CertValidationRules.fromJson(data);
  }
  return null;
}
