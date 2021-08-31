import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycka/data/consts.dart';

abstract class TyckaPreferences {
  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TyckaConsts.LANGUAGE_KEY);
  }

  static Future setLanguge(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TyckaConsts.LANGUAGE_KEY, lang);
    return;
  }

  static Future resetLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TyckaConsts.LANGUAGE_KEY);
    return;
  }
}
