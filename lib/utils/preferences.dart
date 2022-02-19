import 'package:hive_flutter/hive_flutter.dart';
import 'package:tycka/data/consts.dart';

class TyckaPreferences {
  bool? useBiometric;
  String? language;
  late Box box;

  Future init() async {
    await Hive.initFlutter();
    box = await Hive.openBox("tyckaData");
  }

  Future<String?> getLanguage() async {
    language = box.get(TyckaConsts.LANGUAGE_KEY);
    return language;
  }

  Future setLanguge(String lang) async {
    await box.put(TyckaConsts.LANGUAGE_KEY, lang);
    return;
  }

  Future resetLanguage() async {
    await box.delete(TyckaConsts.LANGUAGE_KEY);
    return;
  }

  bool getBiometicSettings() {
    useBiometric = box.get(TyckaConsts.USE_BIOMETRIC_KEY) ?? false;
    return useBiometric ?? false;
  }

  Future setBiometric(bool use) async {
    await box.put(TyckaConsts.USE_BIOMETRIC_KEY, use);
    useBiometric = use;
    return;
  }

  Future setCachedPeople(String data) async {
    await box.put("people", data);
  }

  String? getCachedPeople() {
    return box.get("people");
  }

  Future removeCachedPerson(String uid) async {
    await box.delete("certs-" + uid);
  }

  Future saveCerts(String uid, String text) async {
    await box.put("certs-" + uid, text);
  }

  String? getCerts(String uid) {
    return box.get("certs-" + uid);
  }

  Future setValidationRules(String text) async {
    await box.put("validationRules", text);
  }

  String? getValidationRules() {
    return box.get("validationRules");
  }
}
