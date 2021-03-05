import 'package:aashman_app2/model/StudentStructure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/students.dart';

class ReviewEdit extends StatefulWidget {
  final StudentStructure stud;
  ReviewEdit(this.stud);

  @override
  _ReviewEditState createState() => _ReviewEditState();
}

class _ReviewEditState extends State<ReviewEdit> {
  final _reviewEditForm = GlobalKey<FormState>();
  void _saveForm() {
    _reviewEditForm.currentState.save();
    Provider.of<Student>(context, listen: false)
        .editBgDetails(widget.stud, 'reviewEdit');
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
          key: _reviewEditForm,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.stud.review,
                  decoration: InputDecoration(
                      labelText: 'My Reviews on ${widget.stud.name}'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  onSaved: (value) {
                    widget.stud.review = value;
                  },
                ),
                SizedBox(height: 10),
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
