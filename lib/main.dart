import 'dart:async';

import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:tycka/data/certsStatusBloc.dart';
import 'package:tycka/data/data.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/models/personsBloc.dart';
import 'package:tycka/root.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/loginModal.dart';
import 'package:tycka/ui/person.dart';
import 'package:tycka/ui/screens/qrMenu.dart';
import 'package:tycka/ui/screens/settings.dart';
import 'package:tycka/ui/themes.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  FlutterDownloader.registerCallback(downloadCallback);
  runApp(MyApp());
}

TyckaData tyckaData = TyckaData();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

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
            locale: _locale,
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

  StreamSubscription? _newLogin;
  StreamSubscription? _snackbarSubscription;

  @override
  void initState() {
    super.initState();
    _newLogin = tyckaData.authStream.stream.listen((_) {
      tyckaData.getPersons();
      setState(() {
        _isLoading = false;
      });
    });
    _snackbarSubscription = tyckaData.fetchStatus.stream
        .listen((status) => showStatusSnackbar(status));
    Future.delayed(Duration(seconds: 1),
        () => showStatusSnackbar(tyckaData.fetchStatus.state));
  }

  void showStatusSnackbar(FETCH_STATUS status) {
    String text = "";
    IconData icon = Icons.download_rounded;
    bool progress = true;
    switch (status) {
      case FETCH_STATUS.OFFLINE:
        text = AppLocalizations.of(context)!.usingOfflineData;
        icon = Icons.cloud_off_rounded;
        progress = false;
        break;
      case FETCH_STATUS.OFFLINE_FAILED:
        text = AppLocalizations.of(context)!.cannotUseOfflinedata;
        progress = false;
        icon = Icons.error_rounded;
        break;
      case FETCH_STATUS.ONLINE_FAILED:
        text = AppLocalizations.of(context)!.cannotRetrieveCert;
        progress = false;
        icon = Icons.error_rounded;
        break;
      case FETCH_STATUS.ONLINE_FETCHED:
        text = AppLocalizations.of(context)!.fetchedNewestCert;
        progress = false;
        icon = Icons.done_rounded;
        break;
      case FETCH_STATUS.ONLINE_FETCHING:
        text = AppLocalizations.of(context)!.fetchingNewestCerts;
        progress = true;
        icon = Icons.download_rounded;
        break;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ThemeUtils.backgroundColor(context).withOpacity(0.8),
      elevation: 8.0,
      padding: EdgeInsets.all(15.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              progress
                  ? Container(
                      height: 30.0,
                      width: 30.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      ),
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              Icon(
                icon,
                key: ValueKey(icon.hashCode.toString()),
              )
            ],
          ),
          SizedBox(width: 15.0),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ThemeUtils.isDark(context) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _newLogin?.cancel();
    _snackbarSubscription?.cancel();
    super.dispose();
  }

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
                      child: RefreshIndicator(
                        onRefresh: () {
                          tyckaData.getPersons();
                          return Future.value();
                        },
                        child: BlocBuilder<PersonBloc, List<Person>>(
                            bloc: tyckaData.persons,
                            builder: (context, data) {
                              if (data.isEmpty) return showEmpty();
                              return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    Person p = data[index];
                                    final _parentKey = GlobalKey();
                                    return TyckaUI.listTileBackground(
                                      context,
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: ListTile(
                                          key: _parentKey,
                                          tileColor: ThemeUtils.backgroundColor(
                                              context),
                                          leading:
                                              TyckaUI.userAvatar(context, p),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          title: Text(p.getName()),
                                          subtitle: Text(
                                            '${p.getBetterBirthDate()}',
                                          ),
                                          onTap: () => Navigator.of(context)
                                              .push(MorpheusPageRoute(
                                            builder: (context) =>
                                                PersonOverview(person: p),
                                            parentKey: _parentKey,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            transitionColor:
                                                ThemeUtils.backgroundColor(
                                                    context),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                          )),
                                        ),
                                      ),
                                    );
                                  });
                            }),
                      ),
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

  Widget showEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.noOneAdded,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            TyckaUI.button(context, elevation: 0.0, onPressed: () {
              tyckaLoginModal(context, callback: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
              });
            }, text: AppLocalizations.of(context)!.login)
          ],
        ),
      ),
    );
  }
}
