import 'package:flutter/material.dart';
import 'package:tycka/data/data.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/root.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/login.dart';
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
        primaryColor: Colors.blue[800],
        accentColor: Colors.blue[800],
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
      appBar: AppBar(
        title: Text("Tyčka"),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        elevation: 0.0,
        actions: [
          IconButton(onPressed: () => widget.logout(), icon: Icon(Icons.logout))
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Device ID: ${tyckaData.deviceId}'),
                Text('Is logged In: ${tyckaData.isLoggedIn}'),
                Expanded(
                  child: ListView.builder(
                      itemCount: tyckaData.persons.length,
                      itemBuilder: (context, index) {
                        Person p = tyckaData.persons[index];
                        return ListTile(
                          leading: TyckaUI.userAvatar(context),
                          title: Text(p.getName()),
                          subtitle: Text(
                            '${p.getBetterBirthDate()}',
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PersonOverview(person: p))),
                        );
                      }),
                )
              ],
            ),
          ),
          TyckaUI.loading(_isLoading),
        ],
      ),
    );
  }
}
