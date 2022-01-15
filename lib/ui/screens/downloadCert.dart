import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class DownloadingCert extends StatefulWidget {
  const DownloadingCert({Key? key, required this.taskId}) : super(key: key);
  final String taskId;

  @override
  _DownloadingCertState createState() => _DownloadingCertState();
}

class _DownloadingCertState extends State<DownloadingCert> {
  Timer? timer;
  DownloadTask? task;

  DownloadTaskStatus? _status;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      List? tasks = await FlutterDownloader.loadTasks();
      if (tasks != null && tasks.isNotEmpty) {
        _status =
            tasks.firstWhere((task) => task.taskId == widget.taskId)?.status;
        task = tasks.firstWhere((task) => task.taskId == widget.taskId);
        setState(() {});
        if (_status == DownloadTaskStatus.canceled ||
            _status == DownloadTaskStatus.complete ||
            _status == DownloadTaskStatus.failed) {
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_status == null ||
        _status == DownloadTaskStatus.running ||
        _status == DownloadTaskStatus.enqueued) {
      return ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text(AppLocalizations.of(context)!.downloading),
        leading: SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            strokeWidth: 1.0,
          ),
        ),
      );
    } else if (_status == DownloadTaskStatus.complete) {
      return Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(AppLocalizations.of(context)!.downloaded),
            leading: Icon(Icons.download_done_rounded),
          ),
          Divider(),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(AppLocalizations.of(context)!.open),
            leading: Icon(Icons.visibility_rounded),
            onTap: () => FlutterDownloader.open(taskId: widget.taskId),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(AppLocalizations.of(context)!.share),
            leading: Icon(Icons.share_rounded),
            onTap: () {
              try {
                Share.shareFiles([
                  '${task?.savedDir}/${task?.filename}',
                ]);
              } catch (e) {}
            },
          ),
        ],
      );
    } else {
      return ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text(AppLocalizations.of(context)!.downloadFailed),
        leading: Icon(Icons.error_rounded),
      );
    }
  }
}
