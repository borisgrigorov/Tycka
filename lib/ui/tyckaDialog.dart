import 'package:flutter/material.dart';

abstract class TyckaDialog {
  static Future<void> show(
      BuildContext context, String title, String description,
      {bool dismissible = true}) async {
    return await showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (context) => AlertDialog(
              title: Text(title, style: TextStyle(fontSize: 16.0)),
              content: Text(description, style: TextStyle(fontSize: 13.0)),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
