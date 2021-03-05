import 'package:aashman_app2/model/StudentStructure.dart';
import 'package:aashman_app2/provider/students.dart';
import 'package:flutter/material.dart';
import '../model/SubjectStructure.dart';
import 'package:provider/provider.dart';

class DeleteSubject extends StatefulWidget {
  final StudentStructure student;
  DeleteSubject(this.student);

  @override
  _DeleteSubjectState createState() => _DeleteSubjectState();
}

class _DeleteSubjectState extends State<DeleteSubject> {
  var currentSelectedSubject;
  List<String> listOfSubjects = [];
  int selectedSubjectID;
  SubjectStructure selectedStudSubject;
  @override
  void initState() {
    super.initState();

    if (widget.student.subjects.length == 0) {
    } else {
      currentSelectedSubject = widget.student.subjects[0].name;
      selectedSubjectID = widget.student.subjects[0].subjectId;
      for (int i = 0; i < widget.student.subjects.length; i++) {
        listOfSubjects.add(widget.student.subjects[i].name);
      }
    }
    print('${listOfSubjects.length} is length of list of subjects');
    print(
        '${widget.student.subjects.length} is length of widget.student.subjects ');
  }

  final _deleteSubjectForm = GlobalKey<FormState>();

  void onPressedDelete() {
    selectedStudSubject = widget.student.subjects
        .firstWhere((element) => element.name == currentSelectedSubject);
    selectedSubjectID = selectedStudSubject.subjectId;
    Provider.of<Student>(context, listen: false)
        .deleteSubject(stud: widget.student, subId: selectedSubjectID)
        .then((value) {
      print('inside of then of deleteSubject');
      FocusScope.of(context).unfocus();

      Navigator.pop(context, currentSelectedSubject);
    });
  }

  void displayListOfSub() {
    for (int i = 0; i < listOfSubjects.length; i++) {
      print('${listOfSubjects[i]}  $i object listOfSubjects');
    }
    for (int i = 0; i < widget.student.subjects.length; i++) {
      print(
          '${widget.student.subjects[i].name}  $i object  widget.student.subjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    displayListOfSub();
    print('${listOfSubjects.length} is length of list of subjects');
    print(
        '${widget.student.subjects.length} is length of widget.student.subjects ');

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: listOfSubjects.length == 0
            ? FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  height: 100,
                  child: Column(
                    children: [
                      Center(
                        child: Card(
                            color: Color.fromRGBO(255, 254, 229, 1),
                            elevation: 10,
                            child: Text(
                              'Subject List Is Empty , First add some ',
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                      FlatButton.icon(
                        onPressed: null,
                        label: Text('Delete Subject'),
                        icon: Icon(Icons.delete),
                      )
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    elevation: 20,
                    items: listOfSubjects.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem));
                    }).toList(),
                    onChanged: (String valSelected) {
                      setState(
                        () {
                          currentSelectedSubject = valSelected;
                        },
                      );
                    },
                    value: currentSelectedSubject,
                  ),
                  FlatButton.icon(
                    onPressed: onPressedDelete,
                    icon: Icon(Icons.delete),
                    label: Text('Delete subject'),
                  ),
                ],
              ),
      ),
    );
  }
}
