import 'package:aashman_app2/helper/app_DB.dart';
import 'package:aashman_app2/model/StudentStructure.dart';
import 'package:aashman_app2/model/SubjectStructure.dart';
import 'package:aashman_app2/provider/students.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AddSubject extends StatefulWidget {
  StudentStructure student;

  AddSubject(this.student);

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  // SubjectStructure studSubject;
  List<String> listOfAlreadyAddedSub = [];
  Map<String, num> _outOhCheck = {
    'ut1': 0,
    'ut2': 0,
    'ut3': 0,
    'ut4': 0,
    'halfYearly': 0,
    'final': 0,
  };
  SubjectStructure studSubject = SubjectStructure(
    name: '',
    finalExam: {'scored': 0, 'out of': 0},
    halfYearly: {'scored': 0, 'out of': 0},
    ut1: {'scored': 0, 'out of': 0},
    ut2: {'scored': 0, 'out of': 0},
    ut3: {'scored': 0, 'out of': 0},
    ut4: {'scored': 0, 'out of': 0},
  );

  final _addSubjectForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.student.subjects.length != 0) {
      for (int i = 0; i < widget.student.subjects.length; i++) {
        listOfAlreadyAddedSub.add(widget.student.subjects[i].name);
      }
    } else {}
  }

  void _save() {
    _addSubjectForm.currentState.save();

    bool validate = _addSubjectForm.currentState.validate();
    if (!validate) {
      return;
    }
    _addSubjectForm.currentState.save();
    studSubject.studentId = widget.student.studDetailId;

    print('is the name of subject ${studSubject.name}');
    print('name of student ${widget.student.name}');

    AppDB.addNewSubject(studSubject, widget.student.name).then(
      (value) {
        print('inside of then of addSubject and id of new subject is $value');
        print(
            'inside of then of addSubject and studentid of new subject is ${studSubject.studentId}');

        FocusScope.of(context).unfocus();
        Navigator.pop(context, studSubject.name);
        studSubject.subjectId = value;
        widget.student.subjects.add(studSubject);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Form(
          key: _addSubjectForm,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: '',
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Name of the subject'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'PLease enter name of the subject';
                    }
                    if (double.tryParse(value) != null) {
                      return 'Enter a valid name';
                    }
                    if (listOfAlreadyAddedSub.contains(value)) {
                      return 'Subject $value already exists';
                    } else
                      return null;
                  },
                  onSaved: (value) {
                    studSubject.name = value;
                  },
                ),
                Row(
                  children: <Widget>[
                    Text('UT1 : '),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'marks scored'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          }
                          if (_outOhCheck['ut1'] < double.parse(value)) {
                            return 'scored is more than total';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut1['scored'] = double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'out of'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut1['out of'] = double.parse(value);
                          _outOhCheck['ut1'] = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('UT2 : '),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'marks scored'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          }
                          if (_outOhCheck['ut2'] < double.parse(value)) {
                            return 'scored is more than total';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut2['scored'] = double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'out of'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut2['out of'] = double.parse(value);
                          _outOhCheck['ut2'] = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('UT3 : '),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'marks scored'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          }
                          if (_outOhCheck['ut3'] < double.parse(value)) {
                            return 'scored is more than total';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut3['scored'] = double.parse(value);
                          _outOhCheck['ut3'] = double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'out of'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut3['out of'] = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('UT4 : '),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'marks scored'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          }
                          if (_outOhCheck['ut4'] < double.parse(value)) {
                            return 'scored is more than total';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut4['scored'] = double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'out of'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.ut4['out of'] = double.parse(value);
                          _outOhCheck['ut4'] = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Half Yearly '),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'marks scored'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          }
                          if (_outOhCheck['halfYearly'] < double.parse(value)) {
                            return 'scored is more than total';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.halfYearly['scored'] =
                              double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'out of'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.halfYearly['out of'] =
                              double.parse(value);
                          _outOhCheck['halfYearly'] = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Final : '),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'marks scored'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          }
                          if (_outOhCheck['final'] < double.parse(value)) {
                            return 'scored is more than total';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.finalExam['scored'] = double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: '0',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'out of'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'PLease enter marks';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          studSubject.finalExam['out of'] = double.parse(value);
                          _outOhCheck['final'] = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    elevation: 8,
                    onPressed: _save,
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.black),
                    ),
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
