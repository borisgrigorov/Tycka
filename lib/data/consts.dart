abstract class TyckaConsts {
  static const String DEVICE_NAME = "Tyčka";
  static const String BASE_UZIS_URL = "https://ocko.uzis.cz/api/v2/";
  static const String BASE_NIA_URL = "https://ocko.uzis.cz/Account/Prihlaseni";
  static const String AUTH_ENDPOINT = "auth/login";
  static const String PERSON_ENDPOINT = "person";
  static const String SECURE_STORAGE_KEY = "installationId";
  static const String LANGUAGE_KEY = "language";
  static const String USE_BIOMETRIC_KEY = "useBiometric";
  static const String DOWNLOAD_PDF_URL = "OckovaciCertifikatPdfByCertikatCislo";
}

enum TyckaLoginTypes { NIA, SMS }
