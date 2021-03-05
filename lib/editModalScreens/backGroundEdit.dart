import '../model/StudentStructure.dart';
import '../provider/students.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundEdit extends StatefulWidget {
  final StudentStructure stud;
  BackgroundEdit(this.stud);

  @override
  _BackgroundEditState createState() => _BackgroundEditState();
}

class _BackgroundEditState extends State<BackgroundEdit> {
  final _bgDetailsEditForm = GlobalKey<FormState>();
  void _saveForm() {
    bool validate = _bgDetailsEditForm.currentState.validate();
    if (!validate) {
      return;
    }
    _bgDetailsEditForm.currentState.save();

    Provider.of<Student>(context, listen: false)
        .editBgDetails(widget.stud, 'backGroundEdit');
    FocusScope.of(context).unfocus();

    Navigator.of(context).pop();
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
          key: _bgDetailsEditForm,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: '${widget.stud.age}',
                  decoration: InputDecoration(labelText: 'age'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    widget.stud.age = double.parse(value);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter age of the student';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid age';
                    } else
                      return null;
                  },
                ),
                TextFormField(
                  initialValue: '${widget.stud.classOfStudent}',
                  decoration: InputDecoration(labelText: 'Class'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter class of the student';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid class';
                    } else
                      return null;
                  },
                  onSaved: (value) {
                    widget.stud.classOfStudent = double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: widget.stud.address,
                  decoration: InputDecoration(labelText: 'Address'),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'PLease enter name of the student';
                    } else
                      return null;
                  },
                  onSaved: (value) {
                    widget.stud.address = value;
                  },
                ),
                TextFormField(
                  initialValue: widget.stud.fathersName,
                  decoration: InputDecoration(labelText: 'Father\'s Name'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    widget.stud.fathersName = value;
                  },
                ),
                TextFormField(
                  initialValue: widget.stud.fathersOccupation,
                  decoration:
                      InputDecoration(labelText: 'Father\'s Occupation'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    widget.stud.fathersOccupation = value;
                  },
                ),
                TextFormField(
                  initialValue: '${widget.stud.fathersMobileNumber}',
                  textInputAction: TextInputAction.done,
                  decoration:
                      InputDecoration(labelText: 'Father\'s mobile number'),
                  onSaved: (value) {
                    widget.stud.fathersMobileNumber = double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: widget.stud.mothersName,
                  decoration: InputDecoration(labelText: 'Mother\'s Name'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    widget.stud.mothersName = value;
                  },
                ),
                TextFormField(
                  initialValue: widget.stud.mothersOccupation,
                  decoration:
                      InputDecoration(labelText: 'Mother\'s Occupation'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    widget.stud.mothersOccupation = value;
                  },
                ),
                TextFormField(
                  initialValue: '${widget.stud.mothersMobileNumber}',
                  textInputAction: TextInputAction.done,
                  decoration:
                      InputDecoration(labelText: 'Mother\'s mobile number'),
                  onSaved: (value) {
                    widget.stud.mothersMobileNumber = double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: '${widget.stud.noOFSiblings}',
                  decoration: InputDecoration(labelText: 'Number of Siblings'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    widget.stud.noOFSiblings = double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: widget.stud.nameOFsiblings,
                  decoration:
                      InputDecoration(labelText: 'Names of Siblings (if any)'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    widget.stud.nameOFsiblings = value;
                  },
                ),
                TextFormField(
                  initialValue: widget.stud.extraCurricularInterest,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      labelText: 'Interest in any Extracirricular Activities'),
                  onSaved: (value) {
                    widget.stud.extraCurricularInterest = value;
                  },
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    elevation: 8,
                    onPressed: _saveForm,
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
