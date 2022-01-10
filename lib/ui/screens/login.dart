import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tycka/data/consts.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/tyckaDialog.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:tycka/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.loginCallback}) : super(key: key);
  final void Function() loginCallback;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription? _authSubscription;
  void initState() {
    super.initState();
    _authSubscription = tyckaData.authStream.stream.listen((event) {
      check(context);
    });
  }

  void check(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    widget.loginCallback();
  }

  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeUtils.backgroundColor(context),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon/icon.png",
                    height: 150.0,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!.welcomeInTycka,
                    style: TextStyle(fontSize: 28.0),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(AppLocalizations.of(context)!.chooseLoginType),
                  SizedBox(
                    height: 10.0,
                  ),
                  TyckaUI.button(context,
                      onPressed: () => login(TyckaLoginTypes.NIA),
                      text: "eIdentita"),
                  TyckaUI.button(context,
                      onPressed: () => login(TyckaLoginTypes.SMS),
                      text: AppLocalizations.of(context)!.oneTimeSMS),
                ],
              ),
            ),
          ),
          TyckaUI.loading(_isLoading)
        ],
      ),
    );
  }

  void login(TyckaLoginTypes provider) {
    setState(() {
      _isLoading = true;
    });
    try {
      tyckaData.login(provider);
    } catch (e) {
      TyckaDialog.show(context, AppLocalizations.of(context)!.openBrowserFailed,
          AppLocalizations.of(context)!.linkWasCopiedOpenInBrowser);
    }
  }
}
