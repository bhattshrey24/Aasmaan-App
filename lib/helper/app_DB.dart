import 'package:aashman_app2/model/StudentStructure.dart';
import 'package:aashman_app2/provider/students.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path1;
import 'dart:async';
import 'package:path_provider/path_provider.dart' as path2;
import 'dart:io' as io;
import '../model/SubjectStructure.dart';

class AppDB {
  static sql.Database _db;

  static Future<sql.Database> database() async {

    if (_db != null) {
      return _db;
    }
    _db = await AppDB._initDB();
    return _db;
  } 

  static _initDB() async {
    io.Directory documentsDirectory = await path2
        .getApplicationDocumentsDirectory(); 
    var pathOFDB = path1.join(documentsDirectory.path, 'student41.db');
    var db =
        await sql.openDatabase(pathOFDB, version: 1, onCreate: AppDB._createDB);
    return db;
  }

  static _createDB(sql.Database db, int newVersion) async {
  
    await db.execute(
        'CREATE TABLE student_background_details(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age INT,class INT,image TEXT,address  TEXT,fathersName TEXT,fathersOccupation TEXT,fathersMobileNumber INT,mothersName TEXT,mothersOccupation TEXT,mothersMobileNumber INT,no_of_siblings INT,name_of_siblings TEXT,extracurricular TEXT,review TEXT,no_of_days_present INT,lastPresentDate TEXT)');
    print('inside createDB');
   
    await db.execute(
        'CREATE TABLE student_academic_details(id INTEGER PRIMARY KEY AUTOINCREMENT,student_id INTEGER,student_name TEXT,subject_name TEXT,UT1_scored INT,UT1_out_of INT,UT2_scored INT,UT2_out_of INT,UT3_scored INT,UT3_out_of INT,UT4_scored INT,UT4_out_of INT,half_yearly_scored INT,half_yearly_out_of INT,final_scored INT,final_out_of INT)');
    print('inside createDB');
  }

  static Future<int> insert(String tableName, Map<String, Object> data) async {
   
    print('inside insert');
    final db = await AppDB.database();

    return db.insert(tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm
            .replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String tableName) async {
    print('inside getdata');
   
    final db = await AppDB
        .database(); 
    return db.query(tableName); 
  }

  
  static Future<void> updateBgDetails(
      StudentStructure student, String whocalled) async {
    final db = await AppDB.database();
  
    if (whocalled == 'reviewEdit') {
      Map<String, dynamic> data = {'review': student.review};
      db.update('student_background_details', data,
          where: 'id = ?',
          whereArgs: [student.studDetailId],
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    } else {
      Map<String, dynamic> data = {
        'address': student.address,
        'age': student.age,
        'class': student.classOfStudent,
        'fathersName': student.fathersName,
        'fathersOccupation': student.fathersOccupation,
        'fathersMobileNumber': student.fathersMobileNumber,
        'mothersName': student.mothersName,
        'mothersOccupation': student.mothersOccupation,
        'mothersMobileNumber': student.mothersMobileNumber,
        'no_of_siblings': student.noOFSiblings,
        'name_of_siblings': student.nameOFsiblings,
        'extracurricular': student.extraCurricularInterest
      };
      db.update('student_background_details', data,
          where: 'id = ?',
          whereArgs: [student.studDetailId],
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<void> editAcademicDetails(
      {String whocalled, StudentStructure student}) async {
    final db = await AppDB.database();
    print('inside editAcademicDetails');
    int i = 0;
    if (whocalled == 'ut') {
      print('inside if of editAcademicDetails');

      for (int i = 0; i < student.subjects.length; i++) {
        var data = {
          'UT1_scored': student.subjects[i].ut1['scored'],
          'UT1_out_of': student.subjects[i].ut1['scored'],
          'UT2_scored': student.subjects[i].ut2['scored'],
          'UT2_out_of': student.subjects[i].ut2['scored'],
          'UT3_scored': student.subjects[i].ut3['scored'],
          'UT3_out_of': student.subjects[i].ut3['scored'],
          'UT4_scored': student.subjects[i].ut4['scored'],
          'UT4_out_of': student.subjects[i].ut4['scored'],
        };
        db.update('student_academic_details', data,
            where: 'id = ?',
            whereArgs: [student.subjects[i].subjectId],
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      }
    } else if (whocalled == 'sem') {
      print('inside else if of editAcademicDetails');

      for (int i = 0; i < student.subjects.length; i++) {
        var data = {
          'half_yearly_scored': student.subjects[i].halfYearly['scored'],
          'half_yearly_out_of': student.subjects[i].halfYearly['scored'],
          'final_scored': student.subjects[i].finalExam['scored'],
          'final_out_of': student.subjects[i].finalExam['scored']
        };
        db.update('student_academic_details', data,
            where: 'id = ?',
            whereArgs: [student.subjects[i].subjectId],
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      }
    }
  }

  static Future<int> addNewSubject(
      SubjectStructure studentSubject, String studentName) async {
    print('inside addNewSubject');
    final db = await AppDB.database();
    var data = {
      'student_id': studentSubject.studentId,
      'student_name': studentName,
      'subject_name': studentSubject.name,
      'UT1_scored': studentSubject.ut1['scored'],
      'UT1_out_of': studentSubject.ut1['out of'],
      'UT2_scored': studentSubject.ut2['scored'],
      'UT2_out_of': studentSubject.ut2['out of'],
      'UT3_scored': studentSubject.ut3['scored'],
      'UT3_out_of': studentSubject.ut3['out of'],
      'UT4_scored': studentSubject.ut4['scored'],
      'UT4_out_of': studentSubject.ut4['out of'],
      'half_yearly_scored': studentSubject.halfYearly['scored'],
      'half_yearly_out_of': studentSubject.halfYearly['out of'],
      'final_scored': studentSubject.finalExam['scored'],
      'final_out_of': studentSubject.finalExam['out of'],
    };
    print('addNewSubject complete');

    return await db.insert('student_academic_details', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> dateUpdate(
      {int noOfDaysPresent,
      String lastStoredDate,
      int studId,
      String whoCalled}) async {
    final db = await AppDB.database();
    if (whoCalled == 'attendanceEdit') {
      print('inside if of date update');
      await db.rawUpdate(
          'UPDATE student_background_details SET no_of_days_present = ? WHERE id = ?',
          [noOfDaysPresent, studId]);
    } else {
      print('inside else of date update');

      await db.rawUpdate(
          'UPDATE student_background_details SET no_of_days_present = ?, lastPresentDate = ? WHERE id = ?',
          [noOfDaysPresent, lastStoredDate, studId]);
    }
  }


}
