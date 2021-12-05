import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:tycka/main.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/screens/persons.dart';
import 'package:tycka/ui/themes.dart';
import 'package:tycka/utils/localAuth.dart';
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
        backgroundColor: TyckaUI.primaryColor,
      ),
      backgroundColor: ThemeUtils.backgroundColor(context),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Text(AppLocalizations.of(context)!.persons),
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
              appLock(),
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
                  logOut();
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
    await tyckaData.preferences.setLanguge(locale);
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

  void logOut() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.reallyLogout),
              actions: [
                TextButton(
                    onPressed: () {
                      widget.logout();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.logout)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.cancel))
              ],
            ));
  }

  Widget appLock() {
    if (tyckaData.auth.isAvailable) {
      return ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(AppLocalizations.of(context)!.useBiometric),
        leading: Icon(Icons.fingerprint_rounded),
        trailing: Switch(
          value: tyckaData.preferences.useBiometric!,
          activeColor: Theme.of(context).accentColor,
          onChanged: (value) => setAppLock(value),
        ),
        onTap: () => setAppLock(!tyckaData.preferences.useBiometric!),
      );
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  Future setAppLock(bool enabled) async {
    if (enabled == true) {
      bool auth = await tyckaData.auth.authenticate(context);
      if (!auth) {
        return;
      }
    }
    await tyckaData.preferences.setBiometric(enabled);
    setState(() {});
  }
}
