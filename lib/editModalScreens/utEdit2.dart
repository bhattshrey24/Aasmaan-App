import 'package:aashman_app2/model/StudentStructure.dart';

import 'package:flutter/material.dart';
import '../helper/app_DB.dart';

class UtEdit2 extends StatefulWidget {
  StudentStructure stud;
  String selectedUt;
  UtEdit2(this.stud, this.selectedUt);

  @override
  _UtEdit2State createState() => _UtEdit2State();
}

class _UtEdit2State extends State<UtEdit2> {
  String _selectedUt;
  bool _isInit = true;
  var data = [];

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      if (widget.selectedUt == 'ut1') {
        _selectedUt = 'UT1';
        for (int i = 0; i < widget.stud.subjects.length; i++) {
          data.add({
            'subjectId': widget.stud.subjects[i].subjectId,
            'subjectName': widget.stud.subjects[i].name,
            'scored': widget.stud.subjects[i].ut1['scored'],
            'out of': widget.stud.subjects[i].ut1['out of']
          });
        }
      }
      if (widget.selectedUt == 'ut2') {
        _selectedUt = 'UT2';
        for (int i = 0; i < widget.stud.subjects.length; i++) {
          data.add({
            'subjectId': widget.stud.subjects[i].subjectId,
            'subjectName': widget.stud.subjects[i].name,
            'scored': widget.stud.subjects[i].ut2['scored'],
            'out of': widget.stud.subjects[i].ut2['out of']
          });
        }
      }
      if (widget.selectedUt == 'ut3') {
        _selectedUt = 'UT3';
        for (int i = 0; i < widget.stud.subjects.length; i++) {
          data.add({
            'subjectId': widget.stud.subjects[i].subjectId,
            'subjectName': widget.stud.subjects[i].name,
            'scored': widget.stud.subjects[i].ut3['scored'],
            'out of': widget.stud.subjects[i].ut3['out of']
          });
        }
      }
      if (widget.selectedUt == 'ut4') {
        _selectedUt = 'UT4';
        for (int i = 0; i < widget.stud.subjects.length; i++) {
          data.add({
            'subjectId': widget.stud.subjects[i].subjectId,
            'subjectName': widget.stud.subjects[i].name,
            'scored': widget.stud.subjects[i].ut4['scored'],
            'out of': widget.stud.subjects[i].ut4['out of']
          });
        }
      }
    }
    _isInit = false;
  }

  void _saveForm() {
    _utEditForm2.currentState.save();
    bool validate = _utEditForm2.currentState.validate();
    if (!validate) {
      return;
    }
    print('inside save form');
    _utEditForm2.currentState.save();
    print('${widget.stud.subjects.length} is length of subjects list');
    for (int i = 0; i < widget.stud.subjects.length; i++) {
      if (widget.selectedUt == 'ut1') {
        widget.stud.subjects[i].ut1['scored'] = data[i]['scored'];
        widget.stud.subjects[i].ut1['out of'] = data[i]['out of'];
      }
      if (widget.selectedUt == 'ut2') {
        print('inside ut2');
        widget.stud.subjects[i].ut2['scored'] = data[i]['scored'];
        widget.stud.subjects[i].ut2['out of'] = data[i]['out of'];
      }
      if (widget.selectedUt == 'ut3') {
        widget.stud.subjects[i].ut3['scored'] = data[i]['scored'];
        widget.stud.subjects[i].ut3['out of'] = data[i]['out of'];
      }
      if (widget.selectedUt == 'ut4') {
        widget.stud.subjects[i].ut4['scored'] = data[i]['scored'];
        widget.stud.subjects[i].ut4['out of'] = data[i]['out of'];
      }
    }

    print(data);
    AppDB.editAcademicDetails(student: widget.stud, whocalled: 'ut');

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
            initialValue: '${data[i]['scored']}',
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Scored'),
            validator: (value) {
              if (value.isEmpty) {
                return 'PLease enter';
              }
              if (data[i]['out of'] > double.parse(value)) {
                return 'error';
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
            initialValue: '${data[i]['out of']}',
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Out OF'),
            validator: (value) {
              if (value.isEmpty) {
                return 'PLease enter';
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

    dummy.add(Text('$_selectedUt'));
    for (int i = 0; i < widget.stud.subjects.length; i++) {
      dummy.add(subjectWidget(i, widget.stud.subjects[i].name));
    }
    dummy.add(Align(
      alignment: Alignment.bottomRight,
      child: RaisedButton(
        elevation: 5,
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
            child: Column(children: listOFWidgets() //[

                ),
          ),
        ),
      ),
    );
  }
}
