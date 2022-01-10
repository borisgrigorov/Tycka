import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tycka/main.dart';
import 'package:tycka/models/certData.dart';
import 'package:tycka/models/certificate.dart';
import 'package:tycka/ui/modal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tycka/ui/screens/downloadCert.dart';
import 'package:tycka/ui/screens/exportImage.dart';

abstract class QRMenu {
  static void showQrCodeMenu(BuildContext context, Certificate certicate) {
    TyckaBottomSheet.show(context, dismissible: true, children: [
      ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(AppLocalizations.of(context)!.download + " PDF"),
          leading: Icon(Icons.download_rounded),
          onTap: () => _downloadPdf(context, certicate.data)),
      ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(AppLocalizations.of(context)!.exportAsImage),
          leading: Icon(Icons.share),
          onTap: () => _exportAsImage(context, certicate)),
    ]);
  }

  static _exportAsImage(BuildContext context, Certificate cert) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      Navigator.of(context).pop();
      TyckaBottomSheet.show(context, children: [
        ExportCertToImage(
          cert: cert,
        )
      ]);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.storagePermissionDenied),
        duration: Duration(seconds: 3),
      ));
    }
  }

  static _downloadPdf(BuildContext context, CertificateData certicate) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      Directory downloads =
          await Directory('/storage/emulated/0/Download').create();
      String accessToken = await tyckaData.getAccessToken();
      final taskId = await FlutterDownloader.enqueue(
          url: certicate.getPdfDownloadUrl,
          savedDir: downloads.path,
          openFileFromNotification: true,
          showNotification: true,
          headers: {"Authorization": "Bearer $accessToken"},
          fileName:
              '${certicate.getCertificateType(context)}_${certicate.lastName}_${certicate.name}.pdf');
      Navigator.of(context).pop();
      showDownloadingCert(context, taskId);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.storagePermissionDenied),
        duration: Duration(seconds: 3),
      ));
    }
  }

  static void showDownloadingCert(BuildContext context, String? taskId) {
    TyckaBottomSheet.show(context, dismissible: true, children: [
      DownloadingCert(taskId: taskId ?? "0"),
    ]);
  }
}

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  print("Downloading $id: ${status.value} ($progress%)");
}
