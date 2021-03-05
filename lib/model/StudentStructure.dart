import 'dart:io';
import './SubjectStructure.dart';
import 'package:flutter/material.dart';

class StudentStructure {
  num studDetailId;
  String name;
  num age;
  num classOfStudent;
  String address;
  String fathersName;
  String fathersOccupation;
  String mothersName;
  String mothersOccupation;
  num noOFSiblings;
  String
      nameOFsiblings; 
  String extraCurricularInterest;
  File studentsImage;

  String review;
  num fathersMobileNumber;
  num mothersMobileNumber;


  List<SubjectStructure> subjects;
  int no_of_days_present;
  DateTime lastPresentDate;

  StudentStructure(
      {@required this.name,
      @required this.age,
      @required this.address,
      @required this.classOfStudent,
      this.extraCurricularInterest = '',
      this.fathersName = '',
      this.fathersOccupation = '',
      this.mothersName = '',
      this.mothersOccupation = '',
      this.nameOFsiblings = '',
      this.noOFSiblings = 0,
      this.studentsImage,
      this.subjects,
      this.fathersMobileNumber,
      this.mothersMobileNumber,
      this.review,
      this.studDetailId,
      this.no_of_days_present,
      this.lastPresentDate});
}
