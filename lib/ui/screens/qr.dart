import 'package:flutter/material.dart';
import 'package:tycka/models/certificate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/utils/themeUtils.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key, required this.certificate}) : super(key: key);
  final Certificate certificate;

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("QR Code"),
          iconTheme: IconThemeData(color: Colors.white),
          brightness: Brightness.dark,
          elevation: 0.0,
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
