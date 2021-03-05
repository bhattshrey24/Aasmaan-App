import 'package:flutter/material.dart';
import '../model/StudentStructure.dart';
import '../Screens/StudentDetailsDisplay.dart';
import 'package:provider/provider.dart';
import '../provider/students.dart';
import '../editModalScreens/addSubject.dart';

class StudentList extends StatefulWidget {
  final StudentStructure student;
  StudentList({this.student, Key key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  StudentStructure dummyStud;

  @override
  void initState() {
    super.initState();

    dummyStud = widget.student;
  }

  @override
  Widget build(BuildContext context) {
    final stud = Provider.of<Student>(context, listen: false);
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pushNamed(StudentDetailsDisplay.routeName,
                arguments: widget.student.name);
          },
          child: Card(
            margin: EdgeInsets.all(18),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: Hero(
                        tag: widget.student.studDetailId,
                        child: Image.file(
                          widget.student.studentsImage,
                          height: 100,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 90,
                        child: Center(
                          child: Text(
                            widget.student.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Age : ${widget.student.age}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Class : ${widget.student.classOfStudent}',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<Student>(context, listen: false)
                          .deleteStudentDetails(
                              widget.student.studDetailId, widget.student)
                          .then(
                        (value) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Deleted ${widget.student.name} Details!'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor: Colors.red,
                                onPressed: () {
                                  print(
                                      '${widget.student.name} is the name of deleted student');

                                  stud.addStudent(
                                      widget.student,
                                      widget.student.studentsImage.path,
                                      'undo_deleted_student');
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    label: Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
