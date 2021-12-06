import 'package:flutter/material.dart';
import 'package:tycka/utils/themeUtils.dart';

abstract class TyckaUI {
  static final Color primaryColor = Colors.blue.shade800;
  static final Color secondaryColor = Color(0xFF3983D6);
  //static final Color backgroundColor = Colors.black;
  static final Color backgroundColor = Color(0xFF0b0d1c);

  static ButtonStyle _buttonStyle(
      BuildContext context, Color color, double elevation) {
    return ElevatedButton.styleFrom(
        elevation: elevation,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        primary: color);
  }

  static Widget button(BuildContext context,
      {required void Function() onPressed,
      required String text,
      Color? color,
      Color? textColor,
      double elevation = 4.0}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50.0,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 16.0, color: textColor ?? Colors.white),
          ),
          style: _buttonStyle(
              context, color ?? Theme.of(context).primaryColor, elevation),
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
        Icons.person_rounded,
        color: Colors.white,
      ),
    );
  }

  static Widget certificateIcon(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.qr_code_rounded,
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
                color: ThemeUtils.isDark(context)
                    ? Colors.black.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: child,
    );
  }
}
