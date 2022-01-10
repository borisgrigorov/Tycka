import 'package:flutter/material.dart';
import 'package:tycka/data/consts.dart';
import 'package:tycka/main.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/modal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void tyckaLoginModal(BuildContext context, {void Function()? callback}) {
  TyckaBottomSheet.show(
    context,
    children: [
      Text(
        AppLocalizations.of(context)!.chooseLoginType,
        style: TextStyle(fontSize: 16.0),
      ),
      SizedBox(
        height: 20.0,
      ),
      TyckaUI.button(context, onPressed: () {
        callback?.call();
        tyckaData.login(TyckaLoginTypes.NIA);
      }, text: "eIdentita"),
      TyckaUI.button(context, onPressed: () {
        callback?.call();
        tyckaData.login(TyckaLoginTypes.SMS);
      }, text: AppLocalizations.of(context)!.oneTimeSMS),
    ],
  );
}
