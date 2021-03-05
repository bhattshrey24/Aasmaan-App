class SubjectStructure {
  num studentId;
  num subjectId;
  String name;
  Map<String, num> ut1;
  Map<String, num> ut2;
  Map<String, num> ut3;
  Map<String, num> ut4;
  Map<String, num> halfYearly;
  Map<String, num> finalExam;
  SubjectStructure(
      {this.name,
      this.finalExam,
      this.halfYearly,
      this.ut1,
      this.ut3,
      this.ut2,
      this.ut4,
      this.subjectId,
      this.studentId});
}
