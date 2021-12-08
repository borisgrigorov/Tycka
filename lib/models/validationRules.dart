class CertValidationRules {
  List<TestValidity> testsValidity;

  int recoveryFrom;
  int recoveryTo;

  List<VaccionationValidity> vaccinesValidity;

  factory CertValidationRules.fromJson(Map<String, dynamic> data) {
    List<TestValidity> testsValidity = [];
    for (final x in data["platnostiTestu"]) {
      testsValidity.add(TestValidity(x["typeOfTest"], x["platnostHod"]));
    }
    List<VaccionationValidity> vaccinesValidity = [];
    for (final x in data["platnostiVakcinace"]) {
      vaccinesValidity.add(VaccionationValidity(
          vaccineCode: x["vaccineMedicinalProduct"],
          oneDoseVaccineValidFromDays: x["jednodavkovaOdolnostDenOd"] ?? 0,
          troDoseVaccineValidFromDays: x["dvoudavkovaOdolnostDenOd"] ?? 0,
          oneDoseVaccineFirstDoseValidFromDays:
              x["prvniDavkouOdolnostDenDo"] ?? 0,
          validForDays: x["odolnostMesicDo"] ?? 0));
    }

    return CertValidationRules(
        recoveryFrom: data["ochranaLhutaDenOd"],
        recoveryTo: data["ochranaLhutaDenDo"],
        testsValidity: testsValidity,
        vaccinesValidity: vaccinesValidity);
  }

  CertValidationRules(
      {required this.testsValidity,
      required this.recoveryFrom,
      required this.recoveryTo,
      required this.vaccinesValidity});
}

class TestValidity {
  String testCode;
  int validForHours;

  TestValidity(this.testCode, this.validForHours);
}

class VaccionationValidity {
  String? vaccineCode;
  int oneDoseVaccineValidFromDays;
  int troDoseVaccineValidFromDays;
  int oneDoseVaccineFirstDoseValidFromDays;

  int validForDays;

  VaccionationValidity(
      {required this.vaccineCode,
      required this.oneDoseVaccineFirstDoseValidFromDays,
      required this.oneDoseVaccineValidFromDays,
      required this.troDoseVaccineValidFromDays,
      required this.validForDays});
}
