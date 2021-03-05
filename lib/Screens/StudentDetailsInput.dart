import '../provider/students.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; //for 'File' class
import '../model/StudentStructure.dart';
import './AcademicDetails.dart';
import '../provider/students.dart';
import '../model/SubjectStructure.dart';

class StudentDetailsInput extends StatefulWidget {
  static const routeName = 'StudentDetailsInput';

  @override
  _StudentDetailsInputState createState() => _StudentDetailsInputState();
}

class _StudentDetailsInputState extends State<StudentDetailsInput> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> listOfAlreadyAddedStud = [];
  StudentStructure _editedDetails = StudentStructure(
    age: 0,
    name: '',
    classOfStudent: 0,
    address: '',
    studentsImage: null,
    subjects: [],
    extraCurricularInterest: '',
    fathersMobileNumber: 0,
    fathersName: '',
    fathersOccupation: '',
    mothersMobileNumber: 0,
    mothersName: '',
    mothersOccupation: '',
    nameOFsiblings: '',
    noOFSiblings: 0,
    review: '',
  );

  bool isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      List<StudentStructure> listOfStud =
          Provider.of<Student>(context, listen: false).list;

      if (listOfStud.length != 0) {
        for (int i = 0; i < listOfStud.length; i++) {
          listOfAlreadyAddedStud.add(listOfStud[i].name);
        }
      } else {}
    }
    isInit = false;
  }

  final _detailsForm = GlobalKey<FormState>();

  File _storedImage;

  Future<void> _imagePicker(String whocalled) async {
    final picker = ImagePicker();
    PickedFile imagePicked;
    if (whocalled == 'camera') {
      imagePicked =
          await picker.getImage(source: ImageSource.camera, maxWidth: 800);
    } else {
      imagePicked =
          await picker.getImage(source: ImageSource.gallery, maxWidth: 800);
    }

    setState(
      () {
        _storedImage = File(imagePicked.path);
      },
    );
  }

  final _ageFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _mothersNameFocusNode = FocusNode();
  final _fathersOccupationFocusNode = FocusNode();
  final _mothersOccupationFocusNode = FocusNode();
  final _classFocusNode = FocusNode();
  final _noOfSiblingsFocusNode = FocusNode();
  final _namesOfSiblingsFocusNode = FocusNode();
  final _extraCurricularFocusNode = FocusNode();
  final _imageController = TextEditingController();

  final _mothersMobileFocusNode = FocusNode();
  final _fathersMobileFocusNode = FocusNode();
  final _reviewFocusNode = FocusNode();
  @override
  void dispose() {
    _ageFocusNode.dispose();
    _addressFocusNode.dispose();
    _mothersNameFocusNode.dispose();
    _fathersOccupationFocusNode.dispose();
    _mothersOccupationFocusNode.dispose();
    _classFocusNode.dispose();
    _noOfSiblingsFocusNode.dispose();
    _namesOfSiblingsFocusNode.dispose();
    _extraCurricularFocusNode.dispose();
    _imageController.dispose();
    _fathersMobileFocusNode.dispose();
    _mothersMobileFocusNode.dispose();
    _reviewFocusNode.dispose();

    super.dispose();
  }

  void _saveForm() {
    bool validate = _detailsForm.currentState.validate();
    if (!validate) {
      return;
    }

    if (_storedImage == null) {
      FocusScope.of(context).unfocus();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add an image!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      _detailsForm.currentState.save();

      Provider.of<Student>(context, listen: false)
          .addStudent(_editedDetails, _storedImage.path, 'add_new_student')
          .then(
        (value) {
          print('add student complete inside its then function');
          Navigator.pop(context, _editedDetails.name);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Details Input Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
            color: Colors.white,
          )
        ],
      ),
      body: Card(
        margin: EdgeInsets.all(8),
        elevation: 15,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Form(
            key: _detailsForm,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Personal Details',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 200,
                        margin: EdgeInsets.only(right: 10, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 200,
                              height: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.black)),
                              child: _storedImage == null
                                  ? Center(
                                      child: Text('Add An Image'),
                                    )
                                  : Image.file(_storedImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity),
                            ),
                            RaisedButton.icon(
                                elevation: 6,
                                color: Colors.white,
                                icon: Icon(
                                  Icons.camera,
                                ),
                                label: Text('Add an image'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                          'Select From Where You Want To Upload'),
                                      actions: <Widget>[
                                        FlatButton.icon(
                                          onPressed: () {
                                            _imagePicker('camera');
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(
                                            Icons.camera,
                                          ),
                                          label: Text('Camera'),
                                        ),
                                        FlatButton.icon(
                                          onPressed: () {
                                            _imagePicker('gallery');
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(Icons.photo_album),
                                          label: Text('Gallery'),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          textInputAction: TextInputAction.next,
                          controller: _imageController,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_ageFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'PLease enter name of the student';
                            }
                            if (double.tryParse(value) != null) {
                              return 'Enter a valid name';
                            }
                            if (listOfAlreadyAddedStud.contains(value)) {
                              return '$value already exists';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _editedDetails.name = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    initialValue: '0',
                    decoration: InputDecoration(labelText: 'age'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _ageFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_classFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.age = double.parse(value);
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
                    initialValue: '0',
                    decoration: InputDecoration(labelText: 'Class'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _classFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_addressFocusNode);
                    },
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
                      _editedDetails.classOfStudent = double.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration: InputDecoration(labelText: 'Address'),
                    maxLines: 4,
                    focusNode: _addressFocusNode,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) {
                      _editedDetails.address = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration: InputDecoration(labelText: 'Father\'s Name'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_fathersOccupationFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.fathersName = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration:
                        InputDecoration(labelText: 'Father\'s Occupation'),
                    textInputAction: TextInputAction.next,
                    focusNode: _fathersOccupationFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_fathersMobileFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.fathersOccupation = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '0',
                    textInputAction: TextInputAction.done,
                    decoration:
                        InputDecoration(labelText: 'Father\'s mobile number'),
                    focusNode: _fathersMobileFocusNode,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_mothersNameFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.fathersMobileNumber = double.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration: InputDecoration(labelText: 'Mother\'s Name'),
                    textInputAction: TextInputAction.next,
                    focusNode: _mothersNameFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_mothersOccupationFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.mothersName = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration:
                        InputDecoration(labelText: 'Mother\'s Occupation'),
                    textInputAction: TextInputAction.next,
                    focusNode: _mothersOccupationFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_mothersMobileFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.mothersOccupation = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '0',
                    textInputAction: TextInputAction.done,
                    decoration:
                        InputDecoration(labelText: 'Mother\'s mobile number'),
                    focusNode: _mothersMobileFocusNode,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_noOfSiblingsFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.mothersMobileNumber = double.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: '0',
                    decoration:
                        InputDecoration(labelText: 'Number of Siblings'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _noOfSiblingsFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_namesOfSiblingsFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.noOFSiblings = double.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration: InputDecoration(
                        labelText: 'Names of Siblings (if any)'),
                    textInputAction: TextInputAction.next,
                    focusNode: _namesOfSiblingsFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_extraCurricularFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.nameOFsiblings = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText:
                            'Interest in any Extracirricular Activities'),
                    focusNode: _extraCurricularFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_reviewFocusNode);
                    },
                    onSaved: (value) {
                      _editedDetails.extraCurricularInterest = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '',
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'My reviews'),
                    focusNode: _reviewFocusNode,
                    onSaved: (value) {
                      _editedDetails.review = value;
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    child: RaisedButton(
                      elevation: 8,
                      color: Colors.white,
                      child: Text('Add Subject Details'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            AcademicDetailsInput.routeName,
                            arguments: _editedDetails.subjects);
                        // }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
