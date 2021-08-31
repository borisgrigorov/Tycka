import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycka/data/consts.dart';

class TyckaPreferences {
  bool? useBiometric;
  String? language;

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString(TyckaConsts.LANGUAGE_KEY) ?? null;
    return language;
  }

  Future setLanguge(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TyckaConsts.LANGUAGE_KEY, lang);
    return;
  }

  Future resetLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TyckaConsts.LANGUAGE_KEY);
    return;
  }

  Future<bool> getBiometicSettings() async {
    final prefs = await SharedPreferences.getInstance();
    useBiometric = prefs.getBool(TyckaConsts.USE_BIOMETRIC_KEY) ?? false;
    return useBiometric ?? false;
  }

  Future setBiometric(bool use) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(TyckaConsts.USE_BIOMETRIC_KEY, use);
    useBiometric = use;
    return;
  }
}
