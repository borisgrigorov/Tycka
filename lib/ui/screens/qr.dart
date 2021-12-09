import 'package:flutter/material.dart';
import 'package:tycka/consts/tests.dart';
import 'package:tycka/consts/vacinnes.dart';
import 'package:tycka/models/certData.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key, required this.certificate}) : super(key: key);
  final certificate;

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.certificate.data.getCertificateType(context)),
          iconTheme: IconThemeData(color: Colors.white),
          brightness: Brightness.dark,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              TyckaUI.primaryColor,
              TyckaUI.secondaryColor,
            ],
            begin: FractionalOffset(0, 0),
          )),
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(25.0), child: buildBody()),
          ),
        ));
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          elevation: 20.0,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: TyckaUI.secondaryColor.withOpacity(0.1),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        width: double.infinity,
                        child: Text(
                            widget.certificate.data.lastName +
                                " " +
                                widget.certificate.data.name,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.black)),
                      ),
                      SizedBox(height: 10.0),
                      QrImage(
                        data: widget.certificate.qrData,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey.shade300, width: 1.0))),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: InkWell(
                      onTap: () => showDetails(),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 25.0,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.showDetails,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: TyckaUI.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 100.0,
        ),
      ],
    );
  }

  void showDetails() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor:
            ThemeUtils.isDark(context) ? TyckaUI.backgroundColor : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        //backgroundColor: ThemeUtils.backgroundColor(context),
        builder: (context) => SafeArea(
            top: false,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    handle(),
                    infoRow(AppLocalizations.of(context)!.name,
                        widget.certificate.data.name),
                    infoRow(AppLocalizations.of(context)!.lastName,
                        widget.certificate.data.lastName),
                    infoRow(AppLocalizations.of(context)!.certtype,
                        widget.certificate.data.getCertificateType(context)),
                    infoRow(AppLocalizations.of(context)!.valid, "",
                        child: widget.certificate.data.isValid
                            ? Icon(
                                Icons.check_rounded,
                                color: TyckaUI.green,
                              )
                            : Icon(
                                Icons.close_rounded,
                                color: TyckaUI.red,
                              )),
                    infoRow(AppLocalizations.of(context)!.birthDate,
                        widget.certificate.data.birthDate),
                    ...certSpecificFields(),
                    infoRow(AppLocalizations.of(context)!.desease, "COVID-19"),
                    infoRow(AppLocalizations.of(context)!.certIssuer,
                        widget.certificate.data.certIssuer),
                    infoRow(AppLocalizations.of(context)!.state,
                        widget.certificate.data.state),
                    infoRow(AppLocalizations.of(context)!.certId,
                        widget.certificate.data.certID),
                  ],
                ),
              ),
            )));
  }

  Widget infoRow(String title, String value, {Widget? child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Container(
        width: double.infinity,
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              title + ": ",
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.left,
            ),
            child != null
                ? child
                : Text(
                    value,
                    style: TextStyle(
                        color: ThemeUtils.isDark(context)
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> certSpecificFields() {
    if (widget.certificate.data.certType == CertType.VAX) {
      return [
        infoRow(
            AppLocalizations.of(context)!.vaccine,
            predefinedVaccineTypes
                .where((element) =>
                    element.code == widget.certificate.data.vaccine)
                .first
                .name),
        infoRow(AppLocalizations.of(context)!.doses,
            widget.certificate.data.doses.toString()),
        infoRow(AppLocalizations.of(context)!.totalDoses,
            widget.certificate.data.totalDoses.toString()),
        infoRow(
            AppLocalizations.of(context)!.vaccine,
            predefinedVaccineProducts
                .where((element) =>
                    element.code == widget.certificate.data.vaccineProduct)
                .first
                .name),
        infoRow(
            AppLocalizations.of(context)!.vaccineManufacture,
            predefinedVaccineManufacturers
                .where((element) =>
                    element.code ==
                    widget.certificate.data.vaccineManufacturer
                        .replaceAll("-", ""))
                .first
                .name),
        infoRow(AppLocalizations.of(context)!.vaccinationDate,
            widget.certificate.data.vaccinationDate.toString()),
      ];
    } else if (widget.certificate.data.certType == CertType.TEST) {
      return [
        infoRow(
            AppLocalizations.of(context)!.testType,
            predefinedTestTypes
                .where((element) =>
                    element.code == widget.certificate.data.testType)
                .first
                .name),
        widget.certificate.data.testName == "null"
            ? SizedBox(height: 0.0)
            : infoRow(AppLocalizations.of(context)!.testName,
                widget.certificate.data.testName),
        infoRow(AppLocalizations.of(context)!.testDate,
            widget.certificate.data.date),
        infoRow(AppLocalizations.of(context)!.testPlace,
            widget.certificate.data.testingCenter),
        infoRow(
            AppLocalizations.of(context)!.result,
            predefinedTestResults
                .where(
                    (element) => element.code == widget.certificate.data.result)
                .first
                .name),
      ];
    } else if (widget.certificate.data.certType == CertType.RECOVERY) {
      return [
        infoRow(AppLocalizations.of(context)!.validFrom,
            widget.certificate.data.validFrom),
        infoRow(AppLocalizations.of(context)!.validFrom,
            widget.certificate.data.validFrom),
        infoRow(AppLocalizations.of(context)!.firstPositive,
            widget.certificate.data.firstPositive),
      ];
    } else {
      return [];
    }
  }

  Widget handle() {
    return Container(
      width: 40,
      height: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
    );
  }
}
