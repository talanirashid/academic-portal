/// Centralized configuration for PCSA_DataCenter external file vault on Google Drive.
class DriveVaultConfig {
  DriveVaultConfig._();

  static const String masterFolderUrl =
      'https://drive.google.com/drive/folders/1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7';

  static String get masterFolderId => '1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7';

  // 7-Tier Academic Directory Constants
  static const String dirHssc1Stbb = '01_HSSC_I_Class_11/STBB_Sindh_Board';
  static const String dirHssc1Fbise = '01_HSSC_I_Class_11/FBISE_Federal_Board';
  static const String dirHssc2Stbb = '02_HSSC_II_Class_12/STBB_Sindh_Board';
  static const String dirHssc2Fbise = '02_HSSC_II_Class_12/FBISE_Federal_Board';
  static const String dirMatric = '03_SSC_Matric_Classes_9_10';
  static const String dirPracticalLabs = '04_CS_Practical_Labs';
  static const String dirPastPapers = '05_Board_Past_Papers_and_Model_Blueprints';
  static const String dirCompetitive = '06_Competitive_Prep_and_Screening';
  static const String dirAdminAssets = '07_Institutional_and_Administrative';

  /// Maps directory constants to user-friendly badge names in the UI.
  static String getCategoryBreadcrumb(String directoryConstant) {
    switch (directoryConstant) {
      case dirHssc1Stbb:
        return 'STBB Sindh Board • Class 11th';
      case dirHssc1Fbise:
        return 'FBISE Federal Board • Class 11th';
      case dirHssc2Stbb:
        return 'STBB Sindh Board • Class 12th';
      case dirHssc2Fbise:
        return 'FBISE Federal Board • Class 12th';
      case dirMatric:
        return 'Matric SSC • Class 9th & 10th';
      case dirPracticalLabs:
        return 'CS Practical Lab Manuals';
      case dirPastPapers:
        return 'Board Solved Past Papers';
      case dirCompetitive:
        return 'Competitive & Entry Test Prep';
      case dirAdminAssets:
        return 'Institutional Documents';
      default:
        return 'PCSA DataCenter Vault';
    }
  }
}
