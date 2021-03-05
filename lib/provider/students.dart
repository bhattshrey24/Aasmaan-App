import '../model/SubjectStructure.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../helper/app_DB.dart';
import '../model/StudentStructure.dart';

class Student with ChangeNotifier {
  List<StudentStructure> _list = [];

  List<StudentStructure> get list {
    return [..._list];
  }

  int noOFStudents() {
    return _list.length;
  }

  Future<void> addStudent(
      StudentStructure student, String imagePath, String whocalled) async {
    if (whocalled == 'undo_deleted_student') {
      print('inside whocalled of addStud');
      await AppDB.insert(
        'student_background_details',
        {
          'id': student.studDetailId,
          'name': student.name,
          'age': student.age,
          'class': student.classOfStudent,
          'image': imagePath,
          'address': student.address,
          'fathersName': student.fathersName,
          'fathersOccupation': student.fathersOccupation,
          'mothersName': student.mothersName,
          'mothersOccupation': student.mothersOccupation,
          'no_of_siblings': student.noOFSiblings,
          'name_of_siblings': student.nameOFsiblings,
          'extracurricular': student.extraCurricularInterest,
          'fathersMobileNumber': student.fathersMobileNumber,
          'mothersMobileNumber': student.mothersMobileNumber,
          'review': student.review,
          'no_of_days_present': student.no_of_days_present,
          'lastPresentDate': '${student.lastPresentDate}'
        },
      ).then(
        (studId) {
          if (student.subjects.length != 0) {
            print('Inside THEN OF ADD SUBJECT FORM');
            _subjectadd(student, studId);
          }
          notifyListeners();
        },
      ).then(
        (value) {
          print('INSIDE THEN OF THEN');
          fetchAndSet();
        },
      );
    } else {
      print('inside else of addStud');
      await AppDB.insert(
        'student_background_details',
        {
          'name': student.name,
          'age': student.age,
          'class': student.classOfStudent,
          'image': imagePath,
          'address': student.address,
          'fathersName': student.fathersName,
          'fathersOccupation': student.fathersOccupation,
          'mothersName': student.mothersName,
          'mothersOccupation': student.mothersOccupation,
          'no_of_siblings': student.noOFSiblings,
          'name_of_siblings': student.nameOFsiblings,
          'extracurricular': student.extraCurricularInterest,
          'fathersMobileNumber': student.fathersMobileNumber,
          'mothersMobileNumber': student.mothersMobileNumber,
          'review': student.review,
          'no_of_days_present': 0,
          'lastPresentDate': '${DateTime.now()}'
        },
      ).then(
        (studId) {
          if (student.subjects.length != 0) {
            _subjectadd(student, studId);
            notifyListeners();
            fetchAndSet();
          } else {
            notifyListeners();
            fetchAndSet();
          }
        },
      );
    }
  }

  Future<void> _subjectadd(StudentStructure student, int studId) async {
    for (int i = 0; i < student.subjects.length; i++) {
      print('INSIDE SUBJECTADD LOOP');
      Future.delayed(Duration.zero).then((value) {
        AppDB.insert(
          'student_academic_details',
          {
            'student_id': studId,
            'student_name': student.name,
            'subject_name': student.subjects[i].name,
            ' UT1_scored': student.subjects[i].ut1['scored'],
            'UT1_out_of': student.subjects[i].ut1['out of'],
            'UT2_scored': student.subjects[i].ut2['scored'],
            'UT2_out_of': student.subjects[i].ut2['out of'],
            'UT3_scored': student.subjects[i].ut3['scored'],
            'UT3_out_of': student.subjects[i].ut3['out of'],
            'UT4_scored': student.subjects[i].ut4['scored'],
            'UT4_out_of': student.subjects[i].ut4['out of'],
            'half_yearly_scored': student.subjects[i].halfYearly['scored'],
            'half_yearly_out_of': student.subjects[i].halfYearly['out of'],
            'final_scored': student.subjects[i].finalExam['scored'],
            'final_out_of': student.subjects[i].finalExam['out of']
          },
        ).then((value) => print('SUBJECT ADDED'));
      });
    }
  }

  Future<void> fetchAndSet() async {
    print('inside fetch and set');
    final dbList = await AppDB.getData('student_background_details');

    final academicDetailList = await AppDB.getData('student_academic_details');

    print('${dbList.length} is length of db list');
    print('${academicDetailList.length} is length of academicDetail list');
    print('$academicDetailList is the list');

    _list = dbList.map((student) {
      print('inserting element in _list');

      return StudentStructure(
        studDetailId: student['id'],
        name: student['name'],
        age: student['age'],
        classOfStudent: student['class'],
        address: student['address'],
        fathersName: student['fathersName'],
        fathersOccupation: student['fathersOccupation'],
        mothersName: student['mothersName'],
        mothersOccupation: student['mothersOccupation'],
        noOFSiblings: student['no_of_siblings'],
        nameOFsiblings: student['name_of_siblings'],
        extraCurricularInterest: student['extracurricular'],
        fathersMobileNumber: student['fathersMobileNumber'],
        mothersMobileNumber: student['mothersMobileNumber'],
        studentsImage: File(
          student['image'],
        ),
        review: student['review'],
        lastPresentDate: DateTime.parse(student['lastPresentDate']),
        subjects: addSubjectList(student['id'], academicDetailList),
        no_of_days_present: student['no_of_days_present'],
      );
    }).toList();
    print('object added');
    print('inside fetch and set and added student structure object');

    notifyListeners();
  }

  List<SubjectStructure> addSubjectList(
      int studentID, List<Map<String, dynamic>> academicDetailList) {
    List<SubjectStructure> dummy = [];

    if (academicDetailList.length == 0) {
      print('inside if of add student list ');
      return [];
    } else {
      for (int i = 0; i < academicDetailList.length; i++) {
        print('inside add subject list function for loop');
        if (academicDetailList[i]['student_id'] == studentID) {
          dummy.add(
            SubjectStructure(
              studentId: academicDetailList[i]['student_id'],
              subjectId: academicDetailList[i]['id'],
              name: academicDetailList[i]['subject_name'],
              ut1: {
                'scored': academicDetailList[i]['UT1_scored'],
                'out of': academicDetailList[i]['UT1_out_of']
              },
              ut2: {
                'scored': academicDetailList[i]['UT2_scored'],
                'out of': academicDetailList[i]['UT2_out_of']
              },
              ut3: {
                'scored': academicDetailList[i]['UT3_scored'],
                'out of': academicDetailList[i]['UT4_out_of']
              },
              ut4: {
                'scored': academicDetailList[i]['UT4_scored'],
                'out of': academicDetailList[i]['UT4_out_of']
              },
              halfYearly: {
                'scored': academicDetailList[i]['half_yearly_scored'],
                'out of': academicDetailList[i]['half_yearly_out_of']
              },
              finalExam: {
                'scored': academicDetailList[i]['final_scored'],
                'out of': academicDetailList[i]['final_out_of']
              },
            ),
          );
        }
      }
      return dummy;
    }
  }

  Future<StudentStructure> deleteStudentDetails(
      int studentID, StudentStructure stud) async {
    print('$studentID is the id of student whos data we want to delete');
    final db = await AppDB.database();
    if (studentID != null) {
      await db.delete('student_background_details',
          where: 'id = ?', whereArgs: [studentID]);
      await db.delete('student_academic_details',
          where: 'student_id = ?', whereArgs: [studentID]);

      _list.remove(stud);
      notifyListeners();
      return stud;
    } else {}
  }

  void editBgDetails(StudentStructure student, String whocalled) {
    int i = _list
        .indexWhere((element) => element.studDetailId == student.studDetailId);
    if (whocalled == 'reviewEdit') {
      _list[i].review = student.review;
    } else {
      _list[i].address = student.address;
      _list[i].age = student.age;
      _list[i].classOfStudent = student.classOfStudent;
      _list[i].fathersName = student.fathersName;
      _list[i].fathersOccupation = student.fathersOccupation;
      _list[i].fathersMobileNumber = student.fathersMobileNumber;
      _list[i].mothersName = student.mothersName;
      _list[i].mothersOccupation = student.mothersOccupation;
      _list[i].mothersMobileNumber = student.mothersMobileNumber;
      _list[i].noOFSiblings = student.noOFSiblings;
      _list[i].nameOFsiblings = student.nameOFsiblings;
      _list[i].extraCurricularInterest = student.extraCurricularInterest;
    }

    notifyListeners();
    AppDB.updateBgDetails(student, whocalled);
  }

  Future<void> deleteSubject({int subId, StudentStructure stud}) async {
    final db = await AppDB.database();
    stud.subjects.removeWhere((element) => element.subjectId == subId);
    await db.delete('student_academic_details',
        where: 'id = ?', whereArgs: [subId]).then((value) {
      print('id of subject deleted $value');
    });
  }

  Future<void> studPicUpdate({String picPath, int studId}) async {
    print('inside studPicUpdate');
    final db = await AppDB.database();

    await db.rawUpdate(
        'UPDATE student_background_details SET image = ? WHERE id = ?',
        [picPath, studId]).then(
      (value) => print('Done with pic update'),
    );
    notifyListeners();
  }
}
