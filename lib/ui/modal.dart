import 'package:flutter/material.dart';
import 'package:tycka/utils/themeUtils.dart';

abstract class TyckaBottomSheet {
  static Future show(BuildContext context,
      {required List<Widget> children, bool dismissible = true}) {
    return showModalBottomSheet(
        backgroundColor: ThemeUtils.isDark(context)
            ? ThemeUtils.backgroundColor(context)
            : Colors.white,
        context: context,
        isScrollControlled: true,
        enableDrag: dismissible,
        isDismissible: dismissible,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        builder: (context) => WillPopScope(
              onWillPop: () => Future.value(dismissible),
              child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [_buttomSheetHandler(context), ...children],
                      ),
                    ),
                  )),
            ));
  }

  static Widget _buttomSheetHandler(BuildContext context) {
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
