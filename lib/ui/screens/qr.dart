import 'package:flutter/material.dart';
import 'package:tycka/data/decode.dart';
import 'package:tycka/models/certificate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key, required this.certificate}) : super(key: key);
  final Certificate certificate;

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    try {
      decodeCbor(widget.certificate.qrData);
    } catch (e) {
      print(e);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.qrCode),
          iconTheme: IconThemeData(color: Colors.white),
          brightness: Brightness.dark,
          elevation: 0.0,
          backgroundColor: TyckaUI.primaryColor,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: ThemeUtils.isDark(context)
              ? TyckaUI.backgroundColor
              : Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: QrImage(
                    data: widget.certificate.qrData,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
