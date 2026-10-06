import 'package:flutter/material.dart';

enum BoardStream {
  stbb,
  fbise,
}

extension BoardStreamExtension on BoardStream {
  String get displayName {
    switch (this) {
      case BoardStream.stbb:
        return 'Sindh Textbook Board (STBB)';
      case BoardStream.fbise:
        return 'Federal Board (FBISE)';
    }
  }

  String get shortCode {
    switch (this) {
      case BoardStream.stbb:
        return 'STBB';
      case BoardStream.fbise:
        return 'FBISE';
    }
  }

  Color get badgeColor {
    switch (this) {
      case BoardStream.stbb:
        return const Color(0xFF004D26); // Emerald National Green
      case BoardStream.fbise:
        return const Color(0xFF0284C7); // Cyan/Slate Accent
    }
  }

  String get rootDataCenterPath {
    switch (this) {
      case BoardStream.stbb:
        return 'Sindh_Board';
      case BoardStream.fbise:
        return 'Federal_Board';
    }
  }

  static BoardStream parse(String value) {
    final clean = value.trim().toLowerCase();
    if (clean.contains('sindh') || clean.contains('stbb')) {
      return BoardStream.stbb;
    }
    return BoardStream.fbise;
  }
}

enum AcademicClass {
  class09,
  class10,
  class11,
  class12,
}

extension AcademicClassExtension on AcademicClass {
  String get folderName {
    switch (this) {
      case AcademicClass.class09:
        return 'Class_09';
      case AcademicClass.class10:
        return 'Class_10';
      case AcademicClass.class11:
        return 'Class_11';
      case AcademicClass.class12:
        return 'Class_12';
    }
  }

  String get uiLabel {
    switch (this) {
      case AcademicClass.class09:
        return 'Class 9 (SSC-I)';
      case AcademicClass.class10:
        return 'Class 10 (SSC-II)';
      case AcademicClass.class11:
        return 'Class 11 (HSSC-I / 1st Year)';
      case AcademicClass.class12:
        return 'Class 12 (HSSC-II / 2nd Year)';
    }
  }

  String get codeKey {
    switch (this) {
      case AcademicClass.class09:
        return 'class_09';
      case AcademicClass.class10:
        return 'class_10';
      case AcademicClass.class11:
        return 'class_11';
      case AcademicClass.class12:
        return 'class_12';
    }
  }

  static AcademicClass parse(String value) {
    final clean = value.trim().toLowerCase();
    if (clean.contains('9')) return AcademicClass.class09;
    if (clean.contains('10')) return AcademicClass.class10;
    if (clean.contains('12')) return AcademicClass.class12;
    return AcademicClass.class11;
  }
}
