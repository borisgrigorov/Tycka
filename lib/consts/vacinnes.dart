final List<VaccineType> predefinedVaccineTypes = [
  VaccineType("1119305005", "SARS-CoV2 antigen vaccine"),
  VaccineType("1119349007", "SARS-CoV2 mRNA vaccine"),
  VaccineType("J07BX03", "covid-19 vaccine")
];

final List<VaccineProduct> predefinedVaccineProducts = [
  VaccineProduct("EU/1/20/1528", "Comirnaty"),
  VaccineProduct("EU/1/20/1507", "COVID-19 Vaccine Moderna"),
  VaccineProduct("EU/1/21/1529", "Vaxzevria"),
  VaccineProduct("EU/1/20/1525", "COVID-19 Vaccine Janssen"),
  VaccineProduct("CVnCoV", "CVnCoV"),
  VaccineProduct("NVXCoV2373", "NVXCoV2373"),
  VaccineProduct("Sputnik-V", "Sputnik V"),
  VaccineProduct("Convidecia", "Convidecia"),
  VaccineProduct("EpiVacCorona", "EpiVacCorona"),
  VaccineProduct("BBIBP-CorV", "BBIBPCorV"),
  VaccineProduct(
      "InactivatedSARS-CoV-2-Vero-Cel", "Inactivated SARSCoV-2 (Vero Cell)"),
  VaccineProduct("CoronaVac", "CoronaVac"),
  VaccineProduct("Covaxin", "Covaxin"),
];

final List<VaccineManufacturer> predefinedVaccineManufacturers = [
  VaccineManufacturer("ORG100001699", "AstraZenecaAB"),
  VaccineManufacturer("ORG100030215", "Biontech Manufacturing GmbH"),
  VaccineManufacturer("ORG100001417", "Janssen-Cilag International"),
  VaccineManufacturer("ORG100031184", "Moderna Biotech Spain S.L."),
  VaccineManufacturer("ORG100006270", "Curevac AG"),
  VaccineManufacturer("ORG100013793", "CanSino Biologics"),
  VaccineManufacturer(
      "ORG100020693", "China Sinopharm International Corp. - Beijing location"),
  VaccineManufacturer("ORG100010771",
      "Sinopharm Weiqida Europe Pharmaceutical s.r.o. - Prague location"),
  VaccineManufacturer("ORG100024420",
      "Sinopharm Zhijun (Shenzhen) Pharmaceutical Co. Ltd. - Shenzhen location"),
  VaccineManufacturer("ORG100032020", "Novavax CZ AS"),
  VaccineManufacturer(
      "GamaleyaResearchInstitute", "Gamaleya Research Institute"),
  VaccineManufacturer("VectorInstitute", "Vector Institute"),
  VaccineManufacturer("SinovacBiotech", "Sinovac Biotech"),
  VaccineManufacturer("BharatBiotech", "Bharat Biotech")
];

class VaccineType {
  String code;
  String name;
  VaccineType(this.code, this.name);
}

class VaccineProduct {
  String code;
  String name;
  VaccineProduct(this.code, this.name);
}

class VaccineManufacturer {
  String code;
  String name;
  VaccineManufacturer(this.code, this.name);
}
