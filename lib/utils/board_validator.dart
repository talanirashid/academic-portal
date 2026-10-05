enum AcademicGrade {
  class9('9th', 'Class 9th (SSC-I)'),
  class10('10th', 'Class 10th (SSC-II)'),
  class11('11th', 'Class 11th (HSSC-I)'),
  class12('12th', 'Class 12th (HSSC-II)');

  final String id;
  final String label;
  const AcademicGrade(this.id, this.label);
}

class BoardJurisdictionGuard {
  static const List<String> matricOnlyBoards = ['bsek_karachi'];
  static const List<String> interOnlyBoards = ['biek_karachi'];

  static List<AcademicGrade> getAllowedGrades(String boardId) {
    if (matricOnlyBoards.contains(boardId)) {
      return [AcademicGrade.class9, AcademicGrade.class10];
    } else if (interOnlyBoards.contains(boardId)) {
      return [AcademicGrade.class11, AcademicGrade.class12];
    }
    return AcademicGrade.values;
  }

  /// Evaluates current selection. If currentGrade is illegal under targetBoardId,
  /// returns a safe, compliant fallback grade automatically.
  static AcademicGrade sanitizeGradeSelection({
    required String targetBoardId,
    required AcademicGrade? currentGrade,
  }) {
    final allowed = getAllowedGrades(targetBoardId);
    if (currentGrade != null && allowed.contains(currentGrade)) {
      return currentGrade;
    }
    return allowed.first;
  }
}
