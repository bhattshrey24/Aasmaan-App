import 'package:aashman_app2/helper/app_DB.dart';
import 'package:aashman_app2/model/StudentStructure.dart';

import 'package:flutter/material.dart';

class SemEdit2 extends StatefulWidget {
  final StudentStructure stud;
  final String selectedSem;
  SemEdit2(this.stud, this.selectedSem);

  @override
  _SemEdit2State createState() => _SemEdit2State();
}

class _SemEdit2State extends State<SemEdit2> {
  String _selectedSem;
  bool _isInit = true;
  var data = [];

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      if (widget.selectedSem == 'halfYearly') {
        _selectedSem = 'Half Yearly';
        for (int i = 0; i < widget.stud.subjects.length; i++) {
          data.add({
            'subjectId': widget.stud.subjects[i].subjectId,
            'subjectName': widget.stud.subjects[i].name,
            'scored': widget.stud.subjects[i].halfYearly['scored'],
            'out of': widget.stud.subjects[i].halfYearly['out of']
          });
        }
      }
      if (widget.selectedSem == 'finalExam') {
        _selectedSem = 'Final Exam';
        for (int i = 0; i < widget.stud.subjects.length; i++) {
          data.add({
            'subjectId': widget.stud.subjects[i].subjectId,
            'subjectName': widget.stud.subjects[i].name,
            'scored': widget.stud.subjects[i].finalExam['scored'],
            'out of': widget.stud.subjects[i].finalExam['out of']
          });
        }
      }
    }
    _isInit = false;
  }

  void _saveForm() {
    bool validate = _utEditForm2.currentState.validate();
    if (!validate) {
      return;
    }
    print('inside save form');
    _utEditForm2.currentState.save();
    print(data);
    for (int i = 0; i < widget.stud.subjects.length; i++) {
      if (widget.selectedSem == 'halfYearly') {
        widget.stud.subjects[i].halfYearly['scored'] = data[i]['scored'];
        widget.stud.subjects[i].halfYearly['out of'] = data[i]['out of'];
      }
      if (widget.selectedSem == 'finalExam') {
        widget.stud.subjects[i].finalExam['scored'] = data[i]['scored'];
        widget.stud.subjects[i].finalExam['out of'] = data[i]['out of'];
      }
    }

    AppDB.editAcademicDetails(student: widget.stud, whocalled: 'sem');
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  Widget subjectWidget(int i, String subjectName) {
    return Row(
      children: [
        Text(
          '$subjectName',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
            initialValue:
                data[i]['scored'] == null ? '0' : '${data[i]['scored']}',
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Scored'),
            validator: (value) {
              if (value.isEmpty) {
                return 'PLease enter marks';
              } else
                return null;
            },
            onSaved: (value) {
              data[i]['scored'] = double.parse(value);
            },
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
            initialValue:
                data[i]['out of'] == null ? '0' : '${data[i]['out of']}',
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Out OF'),
            validator: (value) {
              if (value.isEmpty) {
                return 'PLease enter marks';
              } else
                return null;
            },
            onSaved: (value) {
              data[i]['out of'] = double.parse(value);
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  List<Widget> listOFWidgets() {
    List<Widget> dummy = [];
    dummy.add(Text('$_selectedSem'));
    for (int i = 0; i < widget.stud.subjects.length; i++) {
      dummy.add(subjectWidget(i, widget.stud.subjects[i].name));
    }
    dummy.add(Align(
      alignment: Alignment.bottomRight,
      child: RaisedButton(
        elevation: 8,
        child: Text(
          'Done',
          style: TextStyle(color: Colors.black),
        ),
        color: Colors.white,
        onPressed: _saveForm,
      ),
    ));
    return dummy;
  }

  final _utEditForm2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print('inside build');
    return Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.only(
              top: 8,
              left: 8,
              right: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: SingleChildScrollView(
            child: Form(
              key: _utEditForm2,
              child: Column(children: listOFWidgets()),
            ),
          ),
        ));
  }
}
