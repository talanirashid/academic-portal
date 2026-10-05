import 'dart:convert';

/// Secure Data Vault and Obfuscated Google Drive Configuration.
class DriveVaultConfig {
  DriveVaultConfig._();

  // Obfuscated Base64 representation of Master Folder ID: '1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7'
  static const String _obfuscatedVaultToken = 'MXZwSXo3MF9MdXNqWW1TTk1PYnpKUVhHZUVjSzAzaE83';

  /// Decodes and returns the master Google Drive DataCenter Folder ID
  static String get masterFolderId {
    return utf8.decode(base64.decode(_obfuscatedVaultToken));
  }

  /// Master Folder URL for administrative browser launch
  static String get masterFolderUrl {
    return 'https://drive.google.com/drive/folders/$masterFolderId';
  }

  // --- ACADEMIC DIRECTORY CONSTANTS ---
  static const String dirC09 = '01_SSC_I_Class_09/Computer_Science';
  static const String dirC10 = '02_SSC_II_Class_10/Computer_Science';
  static const String dirC11 = '03_HSSC_I_Class_11/Computer_Science';
  static const String dirC12 = '04_HSSC_II_Class_12/Computer_Science';
  static const String dirPracticalLabs = '05_CS_Practical_Labs';
  static const String dirPastPapers = '06_Board_Past_Papers_and_Model_Blueprints/Computer_Science';
  static const String dirCompetitive = '07_Competitive_Prep_and_Screening/Computer_Science';
  static const String dirAdminAssets = '08_Institutional_and_Administrative';

  // --- STBB OFFICIAL TEXTBOOK UNITS (VERIFIED) ---
  static const List<String> stbbClass11Units = [
    'Unit 01: Computer Systems',
    'Unit 02: Computational Thinking & Algorithm',
    'Unit 03: Programming Fundamentals',
    'Unit 04: Data and Analysis',
    'Unit 05: Application and Impacts of Computing',
    'Unit 06: Digital Literacy',
  ];

  static const List<String> stbbClass12Units = [
    'Unit 01: Computer Systems',
    'Unit 02: Computational Thinking & Algorithms',
    'Unit 03: Programming Fundamentals',
    'Unit 04: Data and Analysis',
    'Unit 05: Application and Impacts of Computing',
    'Unit 06: Entrepreneurship in the Digital Age',
  ];

  // --- FBISE OFFICIAL TEXTBOOK UNITS ---
  static const List<String> fbiseClass11Units = [
    'Unit 01: Overview of Computer System',
    'Unit 02: Computer Memory',
    'Unit 03: Central Processing Unit',
    'Unit 04: Inside System Unit',
    'Unit 05: Network Communication',
    'Unit 06: Wireless Communications',
  ];

  static const List<String> fbiseClass12Units = [
    'Unit 01: Operating System',
    'Unit 02: System Development Life Cycle',
    'Unit 03: Object Oriented Programming',
    'Unit 04: Control Structures',
    'Unit 05: Arrays and Strings',
    'Unit 06: Functions',
    'Unit 07: Pointers',
    'Unit 08: Objects and Classes',
    'Unit 09: File Handling',
    'Unit 10: Database Fundamentals',
  ];
}
