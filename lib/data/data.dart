import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tycka/data/certsStatusBloc.dart';
import 'package:tycka/data/consts.dart';
import 'package:tycka/data/validation.dart';
import 'package:tycka/models/certificate.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/models/personsBloc.dart';
import 'package:tycka/models/validationRules.dart';
import 'package:tycka/ui/components.dart';
import 'package:tycka/utils/authStream.dart';
import 'package:tycka/utils/localAuth.dart';
import 'package:tycka/utils/preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;

class TyckaData {
  final uuid = Uuid();
  final secureStorage = FlutterSecureStorage();
  bool? isLoggedIn;
  String? deviceId;
  PersonBloc persons = PersonBloc();
  TyckaLocalAuth auth = TyckaLocalAuth();
  TyckaPreferences preferences = TyckaPreferences();
  CertValidationRules? validationRules;
  AuthStream authStream = AuthStream();

  CertFetchStatus fetchStatus = CertFetchStatus();

  StreamSubscription? _connectionSubscription;
  TyckaData() {
    _connectionSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivity) {
      if (connectivity != ConnectivityResult.none) {
        fetchStatus.setStatus(FETCH_STATUS.ONLINE_FETCHING);
        getPersons();
      }
    });
  }

  Future<String> getJwt(String deviceName, String installationID) async {
    var response = await http.post(
        Uri.parse(TyckaConsts.BASE_UZIS_URL + TyckaConsts.AUTH_ENDPOINT),
        body: json.encode(
            {'deviceName': deviceName, 'installationId': installationID}),
        headers: {
          "Content-Type": "application/json",
        });
    if (response.statusCode != 200) {
      return "err";
    }
    return json.decode(response.body)["accessToken"];
  }

  String getLoginUrl(String accessToken, TyckaLoginTypes provider) {
    String loginProviderText = "";
    if (provider == TyckaLoginTypes.NIA) {
      loginProviderText = "NiaOnly";
    } else {
      loginProviderText = "Alternative";
    }
    return '${TyckaConsts.BASE_NIA_URL}?AccessToken=$accessToken&Type=$loginProviderText&ReturnUrl=tyckaapp://loggedIn';
  }

  Future<List<Person>> getPersons() async {
    var connectivityCheck = await (Connectivity().checkConnectivity());
    List<Person> cachedPeople = [];
    String? cachedPersonsData = await preferences.getCachedPeople();
    if (cachedPersonsData == null &&
        connectivityCheck == ConnectivityResult.none) {
      fetchStatus.setStatus(FETCH_STATUS.OFFLINE_FAILED);
      return [];
    }
    cachedPeople = _decodePeople(cachedPersonsData ?? "[]");
    for (Person x in cachedPeople) {
      x.certificates = _decodeCerts(await preferences.getCerts(x.id) ?? "[]");
    }
    this.persons.setList(cachedPeople);

    if (connectivityCheck == ConnectivityResult.none) {
      fetchStatus.setStatus(FETCH_STATUS.OFFLINE);
      return cachedPeople;
    }
    String accessToken = await this.getAccessToken();
    var response = await http.get(
        Uri.parse('${TyckaConsts.BASE_UZIS_URL}${TyckaConsts.PERSON_ENDPOINT}'),
        headers: {"Authorization": "Bearer $accessToken"});
    if (response.statusCode != 200) {
      //fetchStatus.setStatus(FETCH_STATUS.OFFLINE);
      return cachedPeople;
    }
    List<Person> newPersons = _decodePeople(response.body);
    await preferences.setCachedPeople(response.body);
    for (Person x in newPersons) {
      String certData = await getCertificates(x.id);
      x.certificates = _decodeCerts(certData);
      await preferences.saveCerts(x.id, certData);
    }
    persons.setList(newPersons);
    fetchStatus.setStatus(FETCH_STATUS.ONLINE_FETCHED);
    return this.persons.state;
  }

  List<Person> _decodePeople(String text) {
    var data = json.decode(text);
    List<Person> newPersons = [];
    for (final x in data) {
      Person person = Person.fromJson(x);
      newPersons.add(person);
    }
    return newPersons;
  }

  List<Certificate> _decodeCerts(String text) {
    List<Certificate> certs = [];
    var certData = json.decode(text);
    for (final x in certData) {
      Certificate c = Certificate.fromJson(x);
      certs.add(c);
    }
    return certs;
  }

  Future<String> getCertificates(personId) async {
    String accessToken = await this.getAccessToken();
    var response = await http.get(
        Uri.parse(
            '${TyckaConsts.BASE_UZIS_URL}${TyckaConsts.PERSON_ENDPOINT}/$personId/dgc'),
        headers: {"Authorization": "Bearer $accessToken"});
    CertValidationRules? rules = await getValidationRules();
    if (rules != null) {
      this.validationRules = rules;
    }
    return response.body;
  }

  Future<String> getDeviceId() async {
    String key = TyckaConsts.SECURE_STORAGE_KEY;
    String? deviceId = await secureStorage.read(key: key);
    if (deviceId == null) {
      deviceId = uuid.v4().toUpperCase();
      await secureStorage.write(key: "installationId", value: deviceId);
    }
    this.deviceId = deviceId;
    return deviceId;
  }

  Future getLoginStatus() async {
    String isLoggedIn = await secureStorage.read(key: "isLoggedIn") ?? "false";
    if (isLoggedIn == "true") {
      this.isLoggedIn = true;
      await this.getDeviceId();
    } else {
      this.isLoggedIn = false;
    }
    return;
  }

  Future logOut() async {
    await this.setLoginStatus(false);
    await secureStorage.write(key: "installationId", value: null);
  }

  Future setLoginStatus(bool loggedIn) async {
    await secureStorage.write(
        key: "isLoggedIn", value: loggedIn ? "true" : "false");
    this.isLoggedIn = loggedIn;
  }

  Future<String> registerNewDevice(TyckaLoginTypes provider) async {
    this.deviceId = await getDeviceId();
    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
    String accessToken = await getJwt(
        '${TyckaConsts.DEVICE_NAME} - ${deviceInfo.model}',
        this.deviceId ?? "");
    return getLoginUrl(accessToken, provider);
  }

  Future<String> getAccessToken() async {
    return await getJwt(TyckaConsts.DEVICE_NAME, this.deviceId ?? "");
  }

  Future<bool> removePerson(String personId) async {
    String accessToken = await this.getAccessToken();
    var response = await http.delete(
        Uri.parse(
            '${TyckaConsts.BASE_UZIS_URL}${TyckaConsts.PERSON_ENDPOINT}/$personId'),
        headers: {"Authorization": "Bearer $accessToken"});
    if (response.statusCode != 200) {
      return false;
    }
    persons.removePersonById(personId);
    return true;
  }

  void login(TyckaLoginTypes provider) async {
    String loginUrl = await registerNewDevice(provider);
    try {
      customTabs.launch(loginUrl,
          customTabsOption: customTabs.CustomTabsOption(
            animation: customTabs.CustomTabsSystemAnimation.slideIn(),
            toolbarColor: TyckaUI.primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
          ));
    } catch (e) {
      try {
        launch(loginUrl);
      } catch (e) {
        Clipboard.setData(ClipboardData(text: loginUrl));
        throw loginUrl;
      }
    }
  }
}
