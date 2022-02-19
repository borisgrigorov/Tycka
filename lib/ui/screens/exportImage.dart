import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tycka/models/certificate.dart';
import 'package:tycka/ui/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;

class ExportCertToImage extends StatefulWidget {
  const ExportCertToImage({Key? key, required this.cert}) : super(key: key);

  final Certificate cert;

  @override
  _ExportCertToImageState createState() => _ExportCertToImageState();
}

class _ExportCertToImageState extends State<ExportCertToImage> {
  bool _showName = true;
  bool _showBirthday = true;
  ScreenshotController screenshotController = ScreenshotController();
  bool exported = false;
  String? exportPath;
  @override
  Widget build(BuildContext context) {
    return exported
        ? exportedWidget()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Screenshot(
                  controller: screenshotController,
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
                                  SizedBox(height: _showName ? 10.0 : 0.0),
                                  _showName
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: TyckaUI.secondaryColor
                                                .withOpacity(0.1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          width: double.infinity,
                                          child: Text(
                                              widget.cert.data.lastName +
                                                  " " +
                                                  widget.cert.data.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Colors.black)),
                                        )
                                      : SizedBox(
                                          height: 0.0,
                                        ),
                                  SizedBox(height: 10.0),
                                  _showBirthday
                                      ? Text(widget.cert.data.birthDate,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black))
                                      : SizedBox(
                                          height: 0.0,
                                        ),
                                  SizedBox(height: _showBirthday ? 10.0 : 0.0),
                                  QrImage(
                                    data: widget.cert.qrData,
                                  ),
                                ],
                              ),
                            ),
                          ])),
                ),
              ),
              SwitchListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  value: _showName,
                  title: Text(AppLocalizations.of(context)!.showName),
                  activeColor: TyckaUI.secondaryColor,
                  onChanged: (value) => setState(() {
                        _showName = value;
                        if (value == false) {
                          _showBirthday = false;
                        }
                      })),
              SwitchListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  value: _showBirthday,
                  title: Text(AppLocalizations.of(context)!.showBirthday),
                  activeColor: TyckaUI.secondaryColor,
                  onChanged: (value) => setState(
                      () => _showBirthday = (_showName) ? value : false)),
              TyckaUI.button(context,
                  onPressed: () => export(),
                  text: AppLocalizations.of(context)!.export)
            ],
          );
  }

  void export() async {
    ui.Image? image =
        await screenshotController.captureAsUiImage(pixelRatio: 4);
    ByteData? byteData =
        await image?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    var status = await Permission.storage.request();
    if (status.isGranted) {
      Directory downloads =
          await Directory('/storage/emulated/0/Download').create();
      File file = File(
          '${downloads.path}/${widget.cert.data.getCertificateType(context)}_${widget.cert.data.lastName}_${widget.cert.data.name}.png');
      await file.writeAsBytes(pngBytes);
      exportPath = file.path;
      setState(() {
        exported = true;
      });
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.storagePermissionDenied),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Widget exportedWidget() {
    return Column(
      children: [
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(AppLocalizations.of(context)!.exported),
          leading: Icon(Icons.download_done_rounded),
        ),
        Divider(),
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(AppLocalizations.of(context)!.open),
          leading: Icon(Icons.visibility_rounded),
          onTap: () => OpenFile.open(exportPath),
        ),
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(AppLocalizations.of(context)!.share),
          leading: Icon(Icons.share_rounded),
          onTap: () {
            try {
              Share.shareFiles([exportPath!]);
            } catch (e) {}
          },
        ),
      ],
    );
  }
}
