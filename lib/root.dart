import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tycka/main.dart';
import 'package:tycka/ui/login.dart';

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
    bool internet = false;
    while (!internet) {
      var connectivityCheck = await (Connectivity().checkConnectivity());
      if (connectivityCheck == ConnectivityResult.none) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Bez připojení k internetu"),
                  content: Text(
                      "Pro pokračování musíte být k připojeni k internetu."),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Future.delayed(Duration(seconds: 1));
                          load();
                        },
                        child: Text("Zkusit znovu"))
                  ],
                ));
        return;
      } else {
        internet = true;
      }
    }
    await tyckaData.getLoginStatus();
    if (tyckaData.isLoggedIn == true) {
      await tyckaData.getPersons();
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
    tyckaData.persons = [];
    setState(() {
      status = IsLoggedIn.LOGGED_OUT;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (status == IsLoggedIn.LOGGED_IN) {
      return Home(
        logout: this.logoutCallback,
      );
    } else if (status == IsLoggedIn.LOGGED_OUT) {
      return Login(
        loginCallback: this.loginCallback,
      );
    } else {
      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white.withOpacity(0.8),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
        ),
      );
    }
  }
}
