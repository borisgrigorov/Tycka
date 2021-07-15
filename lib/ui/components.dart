import 'package:flutter/material.dart';

abstract class TyckaUI {
  static final Color primaryColor = Colors.blue.shade800;

  static ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        primary: Theme.of(context).primaryColor);
  }

  static Widget button(
    BuildContext context, {
    required void Function() onPressed,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50.0,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 16.0),
          ),
          style: _buttonStyle(context),
        ),
      ),
    );
  }

  static Widget loading(bool isLoading) {
    if (isLoading) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white.withOpacity(0.8),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  static Widget userAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }

  static Widget certificateIcon(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.description,
        color: Colors.white,
      ),
    );
  }

  static Widget listTileBackground(BuildContext context,
      {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: child,
    );
  }
}
