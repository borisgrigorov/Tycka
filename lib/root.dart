import 'package:flutter/material.dart';
import 'package:tycka/main.dart';
import 'package:tycka/ui/screens/login.dart';
import 'package:tycka/utils/themeUtils.dart';

enum IsLoggedIn { WAITING, LOGGED_IN, LOGGED_OUT }

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  IsLoggedIn status = IsLoggedIn.WAITING;

  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await tyckaData.preferences.init();
    await tyckaData.preferences.getLanguage();
    tyckaData.preferences.useBiometric =
        tyckaData.preferences.getBiometicSettings();
    if (tyckaData.preferences.language != null) {
      MyApp.of(context)!.setLocale(Locale(tyckaData.preferences.language!));
    }
    await tyckaData.auth.checkIfAvailable();
    await tyckaData.getLoginStatus();
    if (tyckaData.isLoggedIn == true) {
      tyckaData.getPersons();

      setState(() {
        status = IsLoggedIn.LOGGED_IN;
      });
    } else {
      setState(() {
        status = IsLoggedIn.LOGGED_OUT;
      });
    }
  }

  void loginCallback() async {
    await tyckaData.setLoginStatus(true);
    await tyckaData.getPersons();
    setState(() {
      status = IsLoggedIn.LOGGED_IN;
    });
  }

  void logoutCallback() async {
    await tyckaData.logOut();
    tyckaData.preferences.language = null;
    tyckaData.preferences.useBiometric = false;
    await tyckaData.preferences.resetLanguage();
    await tyckaData.preferences.setBiometric(false);
    tyckaData.persons.setList([]);
    setState(() {
      status = IsLoggedIn.LOGGED_OUT;
    });
  }

  bool? auth;

  @override
  Widget build(BuildContext context) {
    if (tyckaData.preferences.useBiometric == false) {
      auth = true;
    }
    if (auth == null && tyckaData.preferences.useBiometric == true) authorize();
    if (status == IsLoggedIn.LOGGED_IN && auth == true) {
      return Home(
        logout: this.logoutCallback,
      );
    } else if (status == IsLoggedIn.LOGGED_OUT) {
      return Login(
        loginCallback: this.loginCallback,
      );
    } else {
      return Scaffold(
        backgroundColor: ThemeUtils.backgroundColor(context),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
        ),
      );
    }
  }

  void authorize() async {
    auth = false;
    while (auth == false) {
      auth = await tyckaData.auth.authenticate(context);
      if (auth == false) {
        await Future.delayed(Duration(seconds: 1));
      }
    }
    setState(() {});
  }
}
