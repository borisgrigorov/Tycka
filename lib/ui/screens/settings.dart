import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:tycka/main.dart';
import 'package:tycka/ui/screens/persons.dart';
import 'package:tycka/ui/themes.dart';
import 'package:tycka/utils/preferences.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.logout}) : super(key: key);
  final void Function() logout;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        elevation: 0.0,
      ),
      backgroundColor: ThemeUtils.backgroundColor(context),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Text(AppLocalizations.of(context)!.perons),
                leading: Icon(Icons.person_rounded),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PersonsSettings())),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Text(AppLocalizations.of(context)!.darkTheme),
                trailing: Switch(
                  activeColor: Theme.of(context).accentColor,
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) => _setDarkTheme(context),
                ),
                leading: Icon(Icons.bedtime_rounded),
                onTap: () => _setDarkTheme(context),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Text(AppLocalizations.of(context)!.language),
                leading: Icon(Icons.language),
                onTap: () => showLanguagesDialog(),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Text(AppLocalizations.of(context)!.logout),
                leading: Icon(Icons.logout_rounded),
                onTap: () {
                  widget.logout();
                  Navigator.of(context).pop();
                },
              ),
            ],
          )),
    );
  }

  void _setDarkTheme(BuildContext context) {
    DynamicTheme.of(context)?.setTheme(
        ThemeUtils.isDark(context) ? AppThemes.Light : AppThemes.Dark);
  }

  void setLanguage(String locale) async {
    await TyckaPreferences.setLanguge(locale);
    MyApp.of(context)!.setLocale(Locale(locale));
  }

  void showLanguagesDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.language),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: Text("Czech"),
                      onTap: () => setLanguage("cs")),
                  ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: Text("English"),
                      onTap: () => setLanguage("en")),
                ],
              ),
            ));
  }
}
