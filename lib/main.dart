import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tycka/data/data.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/root.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/person.dart';

void main() => runApp(MyApp());

TyckaData tyckaData = TyckaData();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tyčka",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TyckaUI.primaryColor,
        accentColor: TyckaUI.primaryColor,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      home: Root(),
    );
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
                  Colors.blue.shade800,
                  Color(0xFF3983D6),
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
                                  onPressed: () => widget.logout(),
                                  icon: Icon(
                                    Icons.logout,
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
