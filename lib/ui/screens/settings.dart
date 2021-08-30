import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:tycka/ui/screens/persons.dart';
import 'package:tycka/ui/themes.dart';
import 'package:tycka/utils/themeUtils.dart';

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
        title: Text("Nastavení"),
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
                title: Text("Osoby"),
                leading: Icon(Icons.person_rounded),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PersonsSettings())),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Text("Tmavý režim"),
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
                title: Text("Odhlásit se"),
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
}