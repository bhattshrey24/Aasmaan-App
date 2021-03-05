import 'package:aashman_app2/helper/app_DB.dart';
import 'package:aashman_app2/model/StudentStructure.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceEdit extends StatefulWidget {
  final StudentStructure stud;
  AttendanceEdit(this.stud);

  @override
  _AttendanceEditState createState() => _AttendanceEditState();
}

class _AttendanceEditState extends State<AttendanceEdit> {
  int totalDays = 0;
  int daysPresent;
  final _attendanceEditForm = GlobalKey<FormState>();
  SharedPreferences sharedPref;
  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  void getSharedPref() async {
    print('inside getSharedpeff');
    final pref = await SharedPreferences.getInstance();

    if (!pref.containsKey('totalDays')) {
      pref.setInt('totalDays', 0);
    }
    if (!pref.containsKey('todaysDate')) {
      pref.setString('todaysDate', '');
    }
    if (pref != null) {
      totalDays = pref.getInt('totalDays');
    }

    setState(() {
      sharedPref = pref;
      totalDays = pref.getInt('totalDays');
    });
  }

  void _onSave() {
    bool validate = _attendanceEditForm.currentState.validate();
    if (!validate) {
      return;
    }
    if (sharedPref != null) {
      _attendanceEditForm.currentState.save();
      sharedPref.setInt('totalDays', totalDays);
      print(
          '${widget.stud.no_of_days_present} no of days present in attendance edit');
      AppDB.dateUpdate(
              studId: widget.stud.studDetailId,
              noOfDaysPresent: widget.stud.no_of_days_present,
              whoCalled: 'attendanceEdit')
          .then((value) {
        Navigator.of(context).pop();
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sharedPref != null) {
      print('$totalDays is the total number of days stored');
    }
    return Card(
      elevation: 8,
      child: Padding(
          padding: EdgeInsets.only(
              top: 8,
              left: 8,
              right: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Form(
            key: _attendanceEditForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: '${widget.stud.no_of_days_present}',
                    decoration:
                        InputDecoration(labelText: 'Number Of Days Present'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Number Of Days Present ${widget.stud.name} Was Present';
                      } else
                        return null;
                    },
                    onChanged: (value) {
                      daysPresent = double.parse(value).toInt();
                    },
                    onSaved: (value) {
                      widget.stud.no_of_days_present =
                          double.parse(value).toInt();
                    },
                  ),
                  sharedPref == null
                      ? Container()
                      : TextFormField(
                          initialValue: '$totalDays',
                          decoration:
                              InputDecoration(labelText: 'Total Classes'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Total Classes';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            totalDays = double.parse(value).toInt();
                          },
                        ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      elevation: 8,
                      onPressed: _onSave,
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
          )),
    );
  }
}
