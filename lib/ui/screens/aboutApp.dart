import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.aboutApp,
          style: TextStyle(
              color: ThemeUtils.isDark(context) ? Colors.white : Colors.black),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: ThemeUtils.isDark(context) ? Colors.white : Colors.black),
        brightness: Brightness.dark,
        elevation: 0.0,
      ),
      backgroundColor: ThemeUtils.backgroundColor(context),
      body: body(context),
      extendBodyBehindAppBar: true,
    );
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ListView(
        children: [
          Center(
            child: Image.asset(
              "assets/icon/icon.png",
              height: 190.0,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Center(
            child: Text(
              "Tyčka",
              style: GoogleFonts.openSans(
                  fontSize: 45.0, fontWeight: FontWeight.w200),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: GestureDetector(
              child: Text(
                "Boris Grigorov",
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () => launch("https://github.com/borisgrigorov"),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    AppLocalizations.of(context)!.version +
                        ": " +
                        snapshot.data!.version,
                    style: TextStyle(fontSize: 15.0),
                  );
                } else {
                  return Text("...", style: TextStyle(fontSize: 15.0));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
