/// Supported Academic Classes (Locked to match main platform landing cards)
enum AcademicClass {
  class9('9th', 'Class 9th (SSC-I)', 9),
  class10('10th', 'Class 10th (SSC-II)', 10),
  class11('11th', 'Class 11th (HSSC-I)', 11),
  class12('12th', 'Class 12th (HSSC-II)', 12);

  final String id;
  final String label;
  final int order;
  const AcademicClass(this.id, this.label, this.order);
}

/// Curriculum Origin Stream
enum CurriculumStream {
  federal('Federal National Curriculum (FBISE)'),
  sindh('Sindh Textbook Board Curriculum (STBB)');

  final String label;
  const CurriculumStream(this.label);
}

/// Individual Educational Boards
class AcademicBoard {
  final String id;
  final String shortCode;
  final String fullName;
  final CurriculumStream stream;
  final List<AcademicClass> permittedClasses;
  final String division;

  const AcademicBoard({
    required this.id,
    required this.shortCode,
    required this.fullName,
    required this.stream,
    required this.permittedClasses,
    required this.division,
  });

  static const List<AcademicBoard> registry = [
    // Federal Board
    AcademicBoard(
      id: 'fbise_islamabad',
      shortCode: 'FBISE',
      fullName: 'Federal Board of Intermediate & Secondary Education, Islamabad',
      stream: CurriculumStream.federal,
      permittedClasses: AcademicClass.values,
      division: 'Federal Territory',
    ),
    // Sindh - Karachi Matric & Inter Separation
    AcademicBoard(
      id: 'bsek_karachi',
      shortCode: 'BSEK Karachi',
      fullName: 'Board of Secondary Education, Karachi (Matric 9th/10th)',
      stream: CurriculumStream.sindh,
      permittedClasses: [AcademicClass.class9, AcademicClass.class10],
      division: 'Karachi',
    ),
    AcademicBoard(
      id: 'biek_karachi',
      shortCode: 'BIEK Karachi',
      fullName: 'Board of Intermediate Education, Karachi (Inter 11th/12th)',
      stream: CurriculumStream.sindh,
      permittedClasses: [AcademicClass.class11, AcademicClass.class12],
      division: 'Karachi',
    ),
    // Sindh - Regional Composite Boards (SSC & HSSC)
    AcademicBoard(
      id: 'bise_hyderabad',
      shortCode: 'BISE Hyderabad',
      fullName: 'Board of Intermediate & Secondary Education, Hyderabad',
      stream: CurriculumStream.sindh,
      permittedClasses: AcademicClass.values,
      division: 'Hyderabad',
    ),
    AcademicBoard(
      id: 'bise_sukkur',
      shortCode: 'BISE Sukkur',
      fullName: 'Board of Intermediate & Secondary Education, Sukkur',
      stream: CurriculumStream.sindh,
      permittedClasses: AcademicClass.values,
      division: 'Sukkur',
    ),
    AcademicBoard(
      id: 'bise_larkana',
      shortCode: 'BISE Larkana',
      fullName: 'Board of Intermediate & Secondary Education, Larkana',
      stream: CurriculumStream.sindh,
      permittedClasses: AcademicClass.values,
      division: 'Larkana',
    ),
    AcademicBoard(
      id: 'bise_mirpurkhas',
      shortCode: 'BISE Mirpurkhas',
      fullName: 'Board of Intermediate & Secondary Education, Mirpurkhas',
      stream: CurriculumStream.sindh,
      permittedClasses: AcademicClass.values,
      division: 'Mirpurkhas',
    ),
    AcademicBoard(
      id: 'bise_sba',
      shortCode: 'BISE SBA (Nawabshah)',
      fullName: 'Board of Intermediate & Secondary Education, Shaheed Benazirabad',
      stream: CurriculumStream.sindh,
      permittedClasses: AcademicClass.values,
      division: 'Shaheed Benazirabad',
    ),
  ];

  static AcademicBoard findById(String id) {
    return registry.firstWhere(
      (b) => b.id == id,
      orElse: () => registry.first,
    );
  }
}
