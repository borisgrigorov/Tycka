import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tycka/data/consts.dart';
import 'package:tycka/main.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/ui/tyckaDialog.dart';
import 'package:tycka/utils/themeUtils.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;
import 'package:url_launcher/url_launcher.dart';
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
                child: Column(
                  children: [
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      title: Text(AppLocalizations.of(context)!.add),
                      leading: Icon(Icons.add_rounded),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: ThemeUtils.isDark(context)
                                ? TyckaUI.backgroundColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            )),
                            builder: (context) => Container(
                                  height: 240,
                                  color: ThemeUtils.backgroundColor(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .chooseLoginType,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        TyckaUI.button(context,
                                            onPressed: () =>
                                                login(TyckaLoginTypes.NIA),
                                            text: "eIdentita"),
                                        TyckaUI.button(context,
                                            onPressed: () =>
                                                login(TyckaLoginTypes.SMS),
                                            text: AppLocalizations.of(context)!
                                                .oneTimeSMS),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                    ),
                    Divider(
                      color: ThemeUtils.isDark(context)
                          ? Colors.white70
                          : Colors.black,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tyckaData.persons.length,
                        itemBuilder: (context, index) => ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          title: Text(tyckaData.persons[index].getName()),
                          subtitle: Text(
                              tyckaData.persons[index].getBetterBirthDate()),
                          leading: Icon(Icons.person_rounded),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void login(TyckaLoginTypes provider) async {
    setState(() {
      _isLoading = true;
    });
    String loginUrl = await tyckaData.registerNewDevice(provider);
    try {
      customTabs.launch(loginUrl,
          customTabsOption: customTabs.CustomTabsOption(
            animation: customTabs.CustomTabsSystemAnimation.slideIn(),
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
          ));
    } catch (e) {
      try {
        launch(loginUrl);
      } catch (e) {
        Clipboard.setData(ClipboardData(text: loginUrl));
        await TyckaDialog.show(
            context,
            AppLocalizations.of(context)!.openBrowserFailed,
            AppLocalizations.of(context)!.linkWasCopiedOpenInBrowser);
      }
    }
  }
}
