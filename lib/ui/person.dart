import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tycka/data/certUtils.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/screens/qr.dart';
import 'package:tycka/utils/themeUtils.dart';

class PersonOverview extends StatefulWidget {
  const PersonOverview({Key? key, required this.person}) : super(key: key);
  final Person person;
  @override
  _PersonOverviewState createState() => _PersonOverviewState();
}

class _PersonOverviewState extends State<PersonOverview> {
  late Person person;

  @override
  void initState() {
    super.initState();
    person = widget.person;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(person.getName()),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: ThemeUtils.backgroundColor(context),
      body: Container(
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
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: ThemeUtils.backgroundColor(context),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(20.0), child: buildCerts()),
            ),
          )),
    );
  }

  Widget buildCerts() {
    return ListView.builder(
        itemCount: person.certificates.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(
                person.certificates[index].data.getCertificateType(context)),
            subtitle: Text(
              CertUtils.getSubtitle(context, person.certificates[index].data),
              overflow: TextOverflow.ellipsis,
            ),
            leading: TyckaUI.certificateIcon(context),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      QRCode(certificate: person.certificates[index]),
                ))));
  }
}
