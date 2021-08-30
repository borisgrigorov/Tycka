import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:tycka/data/consts.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/tyckaDialog.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tycka/main.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;

class Login extends StatefulWidget {
  const Login({Key? key, required this.loginCallback}) : super(key: key);
  final void Function() loginCallback;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription? _intentDataStreamSubscription;
  void initState() {
    super.initState();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value == "tyckaapp://loggedIn") {
        check(context);
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value == "tyckaapp://loggedIn") {
        check(context);
      }
    });
  }

  void check(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    widget.loginCallback();
  }

  void dispose() {
    _intentDataStreamSubscription?.cancel();
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
                    "Vítejte v aplikaci Tyčka!",
                    style: TextStyle(fontSize: 28.0),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text("Zvolte metodu přihlášení"),
                  SizedBox(
                    height: 10.0,
                  ),
                  TyckaUI.button(context,
                      onPressed: () => login(TyckaLoginTypes.NIA),
                      text: "eIdentita"),
                  TyckaUI.button(context,
                      onPressed: () => login(TyckaLoginTypes.SMS),
                      text: "Jednorázový SMS kód"),
                ],
              ),
            ),
          ),
          TyckaUI.loading(_isLoading)
        ],
      ),
    );
  }

  void login(TyckaLoginTypes provider) async {
    setState(() {
      _isLoading = true;
    });
    String loginUrl = await tyckaData.registerNewDevice(provider);
    try {
      customTabs.launch(loginUrl,
          customTabsOption: customTabs.CustomTabsOption(
            animation: customTabs.CustomTabsSystemAnimation.slideIn(),
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
          ));
    } catch (e) {
      try {
        launch(loginUrl);
      } catch (e) {
        Clipboard.setData(ClipboardData(text: loginUrl));
        await TyckaDialog.show(context, "Nepovedlo se otevřít přihlášení.",
            "Odkaz byl zkopírován do schránky, prosím, otevřete jej v prohlížeči,");
      }
    }
  }
}
