import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tycka/ui/tyckaDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TyckaLocalAuth {
  bool _isAvailable = false;

  bool get isAvailable => _isAvailable;

  Future<bool> checkIfAvailable() async {
    bool canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
    this._isAvailable = canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<bool> authenticate(BuildContext context) async {
    try {
      bool didAuthenticate = await LocalAuthentication().authenticate(
          localizedReason: AppLocalizations.of(context)!.fingerprintToContinue,
          biometricOnly: true,
          sensitiveTransaction: true,
          stickyAuth: true);
      return didAuthenticate;
    } on PlatformException catch (e) {
      await _showDialog(context, e.message ?? "");
      return false;
    }
  }

  Future _showDialog(BuildContext context, String message) async {
    await TyckaDialog.show(
        context, AppLocalizations.of(context)!.authFailed, message);
  }
}
