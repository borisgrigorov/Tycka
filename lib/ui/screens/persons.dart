import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tycka/data/consts.dart';
import 'package:tycka/main.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/models/personsBloc.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/loginModal.dart';
import 'package:tycka/ui/modal.dart';
import 'package:tycka/ui/tyckaDialog.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonsSettings extends StatefulWidget {
  const PersonsSettings({Key? key}) : super(key: key);

  @override
  _PersonSettingsState createState() => _PersonSettingsState();
}

class _PersonSettingsState extends State<PersonsSettings> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [body(), TyckaUI.loading(_isLoading)],
    );
  }

  Widget body() {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.persons),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tyckaLoginModal(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        color: Theme.of(context).primaryColor,
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: ThemeUtils.backgroundColor(context),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<PersonBloc, List<Person>>(
                    bloc: tyckaData.persons,
                    builder: (context, data) {
                      if (data.isEmpty) return empty();
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          title: Text(data[index].getName()),
                          subtitle: Text(data[index].getBetterBirthDate()),
                          leading: TyckaUI.userAvatar(context, data[index]),
                          onTap: () {
                            TyckaBottomSheet.show(context, children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: TyckaUI.userAvatar(context, data[index]),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                data[index].getName(),
                                style: TextStyle(fontSize: 22.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                data[index].getBetterBirthDate(),
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TyckaUI.button(context,
                                  color: TyckaUI.red,
                                  elevation: 0.0, onPressed: () async {
                                if (tyckaData.connectivityResult ==
                                    ConnectivityResult.none) {
                                  TyckaDialog.show(
                                    context,
                                    AppLocalizations.of(context)!.noInternet,
                                    "",
                                  );
                                  return;
                                }
                                await tyckaData.removePerson(data[index].id);
                                Navigator.of(context).pop();
                              }, text: AppLocalizations.of(context)!.remove),
                            ]);
                          },
                        ),
                      );
                    })),
          ),
        ),
      ),
    );
  }

  void login(TyckaLoginTypes provider) async {
    setState(() {
      _isLoading = true;
    });
    try {
      tyckaData.login(provider);
    } catch (e) {
      TyckaDialog.show(context, AppLocalizations.of(context)!.openBrowserFailed,
          AppLocalizations.of(context)!.linkWasCopiedOpenInBrowser);
    }
  }

  Widget empty() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noOneAdded,
        style: TextStyle(
          color: ThemeUtils.isDark(context)
              ? Colors.grey.shade300
              : Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
