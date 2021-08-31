import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tycka/data/data.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/root.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/person.dart';
import 'package:tycka/ui/screens/settings.dart';
import 'package:tycka/ui/themes.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(MyApp());

TyckaData tyckaData = TyckaData();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        themeCollection: themeCollection,
        defaultThemeId: 0,
        builder: (context, theme) {
          return MaterialApp(
            title: "Tyčka",
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: Root(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale("en", ""), Locale("cs", "")],
          );
        });
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.logout}) : super(key: key);
  final void Function() logout;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TyckaUI.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  TyckaUI.primaryColor,
                  TyckaUI.secondaryColor,
                ],
                begin: FractionalOffset(0, 0),
              )),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tyčka",
                            style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w200),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Settings(
                                                  logout: widget.logout,
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.menu_rounded,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: tyckaData.persons.length,
                          itemBuilder: (context, index) {
                            Person p = tyckaData.persons[index];
                            return TyckaUI.listTileBackground(
                              context,
                              child: Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  tileColor:
                                      ThemeUtils.backgroundColor(context),
                                  leading: TyckaUI.userAvatar(context),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  title: Text(p.getName()),
                                  subtitle: Text(
                                    '${p.getBetterBirthDate()}',
                                  ),
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PersonOverview(person: p))),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            TyckaUI.loading(_isLoading),
          ],
        ),
      ),
    );
  }
}
