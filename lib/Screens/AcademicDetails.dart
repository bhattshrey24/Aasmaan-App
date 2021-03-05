import '../model/SubjectStructure.dart';
import 'package:flutter/material.dart';

class AcademicDetailsInput extends StatefulWidget {
  static const routeName = 'AcademicDetailsInput';
  @override
  _AcademicDetailsInputState createState() => _AcademicDetailsInputState();
}

class _AcademicDetailsInputState extends State<AcademicDetailsInput> {
  List<SubjectStructure> _subjectInput2;
  Map<String, num> _outOhCheck = {
    'ut1': 0,
    'ut2': 0,
    'ut3': 0,
    'ut4': 0,
    'halfYearly': 0,
    'final': 0,
  };
  final _academicForm = GlobalKey<FormState>();
  List<String> alreadyAddedSubjects = [];
  bool isInit = true;
  SubjectStructure _subjectInitialValue = SubjectStructure(
    name: '',
    finalExam: {'scored': 0, 'out of': 0},
    halfYearly: {'scored': 0, 'out of': 0},
    ut1: {'scored': 0, 'out of': 0},
    ut2: {'scored': 0, 'out of': 0},
    ut3: {'scored': 0, 'out of': 0},
    ut4: {'scored': 0, 'out of': 0},
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final _subjectInput =
          ModalRoute.of(context).settings.arguments as List<SubjectStructure>;
      _subjectInput2 = _subjectInput;

      if (_subjectInput2.length != 0) {
        for (int i = 0; i < _subjectInput2.length; i++) {
          alreadyAddedSubjects.add(_subjectInput2[i].name);
        }
      } else {}
    }
    isInit = false;
  }

  void _saveAcademicForm() {
    _academicForm.currentState.save();

    bool validate = _academicForm.currentState.validate();
    if (!validate) {
      return;
    }

    _academicForm.currentState.save();
    _subjectInput2.add(_subjectInitialValue);

    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Academic Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveAcademicForm,
            color: Colors.white,
          )
        ],
      ),
      body: Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Form(
            key: _academicForm,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Subject 1'),
                  TextFormField(
                    initialValue: '',
                    textInputAction: TextInputAction.next,
                    decoration:
                        InputDecoration(labelText: 'Name of the subject'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'PLease enter name of the student';
                      }
                      if (double.tryParse(value) != null) {
                        return 'Enter a valid name';
                      }
                      if (alreadyAddedSubjects.contains(value)) {
                        return '$value already added';
                      } else
                        return null;
                    },
                    onSaved: (value) {
                      _subjectInitialValue.name = value;
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
                          decoration:
                              InputDecoration(labelText: 'marks scored'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            }
                            if (_outOhCheck['ut1'] < double.parse(value)) {
                              return 'scored is more than total';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut1['scored'] =
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
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'out of'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut1['out of'] =
                                double.parse(value);
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
                          decoration:
                              InputDecoration(labelText: 'marks scored'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            }
                            if (_outOhCheck['ut2'] < double.parse(value)) {
                              return 'scored is more than total';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut2['scored'] =
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
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut2['out of'] =
                                double.parse(value);
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
                          decoration:
                              InputDecoration(labelText: 'marks scored'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            }
                            if (_outOhCheck['ut3'] < double.parse(value)) {
                              return 'scored is more than total';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut3['scored'] =
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
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'out of'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut3['out of'] =
                                double.parse(value);
                            _outOhCheck['ut3'] = double.parse(value);
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
                          decoration:
                              InputDecoration(labelText: 'marks scored'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            }
                            if (_outOhCheck['ut4'] < double.parse(value)) {
                              return 'scored is more than total';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut4['scored'] =
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
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.ut4['out of'] =
                                double.parse(value);
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
                          decoration:
                              InputDecoration(labelText: 'marks scored'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            }
                            if (_outOhCheck['halfYearly'] <
                                double.parse(value)) {
                              return 'scored is more than total';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.halfYearly['scored'] =
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
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.halfYearly['out of'] =
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
                          decoration:
                              InputDecoration(labelText: 'marks scored'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            }
                            if (_outOhCheck['final'] < double.parse(value)) {
                              return 'scored is more than total';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.finalExam['scored'] =
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
                              return 'Please enter marks';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid marks';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _subjectInitialValue.finalExam['out of'] =
                                double.parse(value);
                            _outOhCheck['final'] = double.parse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
