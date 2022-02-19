import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:tycka/main.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/modal.dart';
import 'package:tycka/ui/screens/aboutApp.dart';
import 'package:tycka/ui/screens/persons.dart';
import 'package:tycka/ui/themes.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tycka/utils/timeUtils.dart';

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
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: ThemeUtils.backgroundColor(context),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        title: Text(AppLocalizations.of(context)!.persons),
                        leading: Icon(Icons.person_rounded),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PersonsSettings())),
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        title: Text(AppLocalizations.of(context)!.darkTheme),
                        trailing: Switch(
                          activeColor: TyckaUI.secondaryColor,
                          value:
                              Theme.of(context).brightness == Brightness.dark,
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
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        title: Text(AppLocalizations.of(context)!.aboutApp),
                        leading: Icon(Icons.info_rounded),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => AboutApp())),
                      ),
                      Text(
                        AppLocalizations.of(context)!.rulesDownloaded +
                            " " +
                            TimeUtils.getBetterDate(tyckaData.preferences
                                .getValidationRulesDownloadDate()),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        AppLocalizations.of(context)!.certsDownloaded +
                            " " +
                            TimeUtils.getBetterDate(
                                tyckaData.preferences.getCertsDownloaded()),
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void _setDarkTheme(BuildContext context) {
    DynamicTheme.of(context)?.setTheme(
        ThemeUtils.isDark(context) ? AppThemes.Light : AppThemes.Dark);
  }

  void setLanguage(String locale) async {
    await tyckaData.preferences.setLanguge(locale);
    Navigator.of(context).pop();
    MyApp.of(context)!.setLocale(Locale(locale));
  }

  void showLanguagesDialog() {
    TyckaBottomSheet.show(
      context,
      children: [
        ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Czech"),
            leading: Icon(Icons.language),
            onTap: () => setLanguage("cs")),
        ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("English"),
            leading: Icon(Icons.language),
            onTap: () => setLanguage("en")),
      ],
    );
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
          activeColor: TyckaUI.secondaryColor,
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
