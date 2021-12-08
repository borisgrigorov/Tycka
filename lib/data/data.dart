import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tycka/data/consts.dart';
import 'package:tycka/data/validation.dart';
import 'package:tycka/models/certificate.dart';
import 'package:tycka/models/person.dart';
import 'package:tycka/models/validationRules.dart';
import 'package:tycka/utils/localAuth.dart';
import 'package:tycka/utils/preferences.dart';
import 'package:uuid/uuid.dart';

class TyckaData {
  final uuid = Uuid();
  final secureStorage = FlutterSecureStorage();
  bool? isLoggedIn;
  String? deviceId;
  List<Person> persons = <Person>[];
  TyckaLocalAuth auth = TyckaLocalAuth();
  TyckaPreferences preferences = TyckaPreferences();
  CertValidationRules? validationRules;

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
    String accessToken = await this.getAccessToken();
    var response = await http.get(
        Uri.parse('${TyckaConsts.BASE_UZIS_URL}${TyckaConsts.PERSON_ENDPOINT}'),
        headers: {"Authorization": "Bearer $accessToken"});
    var data = json.decode(response.body);
    for (final x in data) {
      Person person = Person.fromJson(x);
      var certData = json.decode(await this.getCertificates(person.id));
      for (final x in certData) {
        Certificate c = Certificate.fromJson(x);
        person.certificates.add(c);
      }
      this.persons.add(person);
    }
    return this.persons;
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
    String accessToken =
        await getJwt(TyckaConsts.DEVICE_NAME, this.deviceId ?? "");
    return getLoginUrl(accessToken, provider);
  }

  Future<String> getAccessToken() async {
    return await getJwt(TyckaConsts.DEVICE_NAME, this.deviceId ?? "");
  }
}
