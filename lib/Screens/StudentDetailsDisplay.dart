import '../GraphWidgets/barChartForMarks.dart';
import 'package:flutter/material.dart';
import '../provider/students.dart';
import '../model/StudentStructure.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../helper/app_DB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../GraphWidgets/pieChartForAttendance.dart';
import '../editModalScreens/backGroundEdit.dart';
import '../editModalScreens/attendanceEdit.dart';
import '../editModalScreens/reviewEdit.dart';
import '../editModalScreens/utEdit2.dart';
import '../editModalScreens/semEdit2.dart';
import '../editModalScreens/DeleteSubject.dart';
import '../editModalScreens/addSubject.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StudentDetailsDisplay extends StatefulWidget {
  static const routeName = 'StudentDetailsDisplay';

  @override
  _StudentDetailsDisplayState createState() => _StudentDetailsDisplayState();
}

class _StudentDetailsDisplayState extends State<StudentDetailsDisplay> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<String> _listOFUt = ['UT 1', 'UT 2', 'UT 3', 'UT 4'];
  List<String> _listOFSem = ['Half Yearly', 'Final Exam'];
  String _selectedUtBarChart = 'ut1';
  String _selectedSemBarChart = 'halfYearly';
  String _currentSelectedUt = 'UT 1';
  String _currentSelectedSem = 'Half Yearly';
  StudentStructure stud;
  SharedPreferences sharedPref;

  Future<void> _cbseMaterialSiteCall() async {
    const url = 'https://ncert.nic.in/textbook.php';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  var _isInit = true;

  @override
  void initState() {
    print('inside init');
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
      print('inside pref check');

      DateTime todaysDate = DateTime.now();
      String todaysFormattedDate = DateFormat('yyyy-MM-dd').format(todaysDate);
      String storedDateString = pref.getString('todaysDate');

      if (storedDateString == '') {
        pref.setInt('totalDays', 1);
        pref.setString('todaysDate', todaysFormattedDate);
      } else {
        DateTime storedDate = DateTime.parse(pref.getString('todaysDate'));
        print('stored Date is : $storedDate');
        String formattedStoredDate =
            DateFormat('yyyy-MM-dd').format(storedDate);
        if ((todaysDate.weekday == DateTime.sunday) &&
            !((storedDate.weekday == todaysDate.weekday) &&
                (storedDate.month == todaysDate.month))) {
          pref.setInt('totalDays', pref.getInt('totalDays') + 1);
          pref.setString('todaysDate', formattedStoredDate);
        }
      }
    }
    sharedPref = pref;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      List<StudentStructure> studentList =
          Provider.of<Student>(context, listen: false).list;

      String argName = ModalRoute.of(context).settings.arguments as String;
      stud = studentList.firstWhere((element) => element.name == argName);
    }
    _isInit = false;
  }

  void _attendanceUpdate(String whoCalled) {
    DateTime todaysDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(todaysDate);
    if (sharedPref != null) {
      if (sharedPref.getString('todaysDate') != '') {
        int storedTotalDays = sharedPref.getInt('totalDays');
        DateTime storedTodaysDate =
            DateTime.parse(sharedPref.getString('todaysDate'));

        if (whoCalled == 'Present') {
          print('stored total days is $storedTotalDays');
          if (storedTotalDays > stud.no_of_days_present) {
            print('inside if block of attendance -present');

            print('stored no of present days is ${stud.no_of_days_present}');

            stud.no_of_days_present += 1;
            stud.lastPresentDate = DateTime.now();
            AppDB.dateUpdate(
                    studId: stud.studDetailId,
                    lastStoredDate: '${DateTime.now()}',
                    noOfDaysPresent: stud.no_of_days_present,
                    whoCalled: 'studentDetailsDisplay')
                .then(
              (value) {
                print('inside Then of date Update Call');
                setState(() {});
              },
            );
          } else {
            print('Exceeding no of total Days');
          }
        } else {
          if ((storedTodaysDate.weekday != todaysDate.weekday) &&
              (storedTodaysDate.month != todaysDate.month)) {
            setState(() {
              sharedPref.setInt(
                  'totalDays', sharedPref.getInt('totalDays') + 1);
              sharedPref.setString('todaysDate', '$todaysDate');
            });
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Already marked todays Date to total classes'),
              duration: Duration(seconds: 1),
            ));
            print('already added todaysDate to sharedpref');
          }
        }
      } else {
        setState(() {
          stud.no_of_days_present += 1;
          sharedPref.setString('todaysDate', formattedDate);
          sharedPref.setInt('totalDays', 1);
          AppDB.dateUpdate(
              studId: stud.studDetailId,
              lastStoredDate: '${DateTime.now()}',
              noOfDaysPresent: stud.no_of_days_present,
              whoCalled: 'studentDetailsDisplay');
        });
      }
    }
  }

  void openModalSheetForEdit(BuildContext ctx, String whocalled) {
    if (whocalled == 'backgroundEdit') {
      showModalBottomSheet(
          isScrollControlled: true,
          context: ctx,
          builder: (_) {
            return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: BackgroundEdit(stud),
            );
          }).then(
        (value) => setState(() {}),
      );
    }
    if (whocalled == 'AttendanceEdit') {
      showModalBottomSheet(
          isScrollControlled: true,
          context: ctx,
          builder: (_) {
            return GestureDetector(
              child: AttendanceEdit(stud),
              onTap: () {},
              behavior: HitTestBehavior.opaque,
            );
          }).then((value) => setState(() {}));
    }
    if (whocalled == 'reviewEdit') {
      showModalBottomSheet(
          isScrollControlled: true,
          context: ctx,
          builder: (_) {
            return GestureDetector(
              child: ReviewEdit(stud),
              onTap: () {},
              behavior: HitTestBehavior.opaque,
            );
          }).then((value) => setState(() {}));
    }
    if (whocalled == 'utEdit') {
      showModalBottomSheet(
          isScrollControlled: true,
          context: ctx,
          builder: (_) {
            return GestureDetector(
              child: UtEdit2(stud, _selectedUtBarChart),
              onTap: () {},
              behavior: HitTestBehavior.opaque,
            );
          }).then((value) => setState(() {}));
    }
    if (whocalled == 'semEdit') {
      showModalBottomSheet(
          isScrollControlled: true,
          context: ctx,
          builder: (_) {
            return GestureDetector(
              child: SemEdit2(stud, _selectedSemBarChart),
              onTap: () {},
              behavior: HitTestBehavior.opaque,
            );
          }).then((value) => setState(() {}));
    }
    if (whocalled == 'addSubject') {
      showModalBottomSheet(
          isScrollControlled: true,
          context: ctx,
          builder: (_) {
            return GestureDetector(
              child: AddSubject(stud),
              onTap: () {},
              behavior: HitTestBehavior.opaque,
            );
          }).then(
        (value) => setState(() {
          if (value != null) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Subject \'$value\' Added!'),
              duration: Duration(seconds: 1),
            ));
          }
        }),
      );
    }
    if (whocalled == 'deleteSubject') {
      showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return GestureDetector(
              child: Container(height: 190, child: DeleteSubject(stud)),
              onTap: () {},
              behavior: HitTestBehavior.opaque,
            );
          }).then((value) => setState(() {
            if (value != null) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Subject \'$value\' Deleted!'),
                duration: Duration(seconds: 1),
              ));
            }
          }));
    }
  }

  String attandanceImplementation(String whocalled) {
    if (whocalled == 'noOfDaysPresent') {
      return '${stud.no_of_days_present}';
    } else {
      if (sharedPref == null) {
        return '0';
      } else {
        int totalDays = sharedPref.getInt('totalDays');

        return '$totalDays';
      }
    }
  }

  int valueForpieChart(String whocalled) {
    if (sharedPref != null) {
      if (whocalled == 'Present') {
        return stud.no_of_days_present;
      } else {
        return sharedPref.getInt('totalDays');
      }
    } else {
      return 0;
    }
  }

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
        Provider.of<Student>(context, listen: false)
            .studPicUpdate(picPath: imagePicked.path, studId: stud.studDetailId)
            .then((value) => stud.studentsImage = File(imagePicked.path));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Color(0xFF89f7fe), Color(0xFF66a6ff)],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 80,
                        left: 5,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 30,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: 210,
                          child: Text(
                            '${stud.name} Details',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: FlatButton.icon(
                          textColor: Colors.white,
                          icon: Icon(
                            Icons.book,
                            size: 35,
                          ),
                          onPressed: _cbseMaterialSiteCall,
                          label: Text('Cbse material'),
                        ),
                      )
                    ],
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                elevation: 5,
                                child: Container(
                                  height: 300,
                                  width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Hero(
                                        tag: stud.studDetailId,
                                        child: Image.file(
                                          stud.studentsImage,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 2,
                                child: FlatButton.icon(
                                  color: Colors.black45,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
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
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 180,
                            width: double.infinity,
                            child: Card(
                              elevation: 5,
                              margin: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            RaisedButton(
                                              elevation: 4,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              onPressed: () {
                                                _attendanceUpdate('Present');
                                              },
                                              child: Text('Present'),
                                            ),
                                            SizedBox(width: 3),
                                            RaisedButton(
                                              elevation: 4,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              onPressed: () {
                                                _attendanceUpdate('Absent');
                                              },
                                              child: Text(
                                                'Absent',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${attandanceImplementation('noOfDaysPresent')}/',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${attandanceImplementation('totalDays')}',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      FlatButton.icon(
                                        onPressed: () {
                                          openModalSheetForEdit(
                                              context, 'AttendanceEdit');
                                        },
                                        icon: Icon(Icons.edit),
                                        label: Text('Edit'),
                                      ),
                                      // SizedBox(height: 5)
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: PieChartForAttendance(
                                      valueForpieChart('Present'),
                                      valueForpieChart('Absent'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${stud.name}\'s Background Details',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              FlatButton.icon(
                                  onPressed: () {
                                    openModalSheetForEdit(
                                        context, 'backgroundEdit');
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color),
                                  ))
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 200,
                            child: Card(
                                margin: EdgeInsets.all(5),
                                elevation: 4,
                                color: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: [
                                        Color(0xFF89f7fe),
                                        Color(0xFF66a6ff)
                                      ],
                                    ),
                                  ),
                                  child: ListView(
                                    children: <Widget>[
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                          'Address: ${stud.address}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text('Age: ${stud.age}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Class: ${stud.classOfStudent}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Father\'s Name: ${stud.fathersName}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Father\'s Occupation: ${stud.fathersOccupation}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Father\'s Mobile Number: ${stud.fathersMobileNumber}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Mother\'s Name: ${stud.mothersName}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Mother\'s Occupation: ${stud.mothersOccupation}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Mother\'s Mobile Number: ${stud.mothersMobileNumber}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Father\'s Name: ${stud.fathersName}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Number Of Siblings: ${stud.noOFSiblings}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Name Of Siblings: ${stud.nameOFsiblings}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Card(
                                        elevation: 8,
                                        child: Text(
                                            'Extracurricular Interest: ${stud.extraCurricularInterest}',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                width: 125,
                                child: Text(
                                  'My views on',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                width: 160,
                                child: Text(
                                  '${stud.name}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  openModalSheetForEdit(context, 'reviewEdit');
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                label: Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: Theme.of(context).iconTheme.color),
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 150,
                            width: double.infinity,
                            child: Card(
                              margin: EdgeInsets.all(5),
                              elevation: 4,
                              child: stud.review == ''
                                  ? Center(
                                      child: Text(
                                      'Add views on ${stud.name}',
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 20),
                                    ))
                                  : SingleChildScrollView(
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${stud.review}',
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    )),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SizedBox(width: 0.2,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.black38,
                                  style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  elevation: 20,
                                  items: _listOFUt
                                      .map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                        value: dropDownStringItem,
                                        child: Text(
                                          dropDownStringItem,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                        ));
                                  }).toList(),
                                  onChanged: (String valSelected) {
                                    setState(
                                      () {
                                        if (valSelected == 'UT 1') {
                                          _selectedUtBarChart = 'ut1';
                                          _currentSelectedUt = valSelected;
                                        } else if (valSelected == 'UT 2') {
                                          _selectedUtBarChart = 'ut2';
                                          _currentSelectedUt = valSelected;
                                        } else if (valSelected == 'UT 3') {
                                          _selectedUtBarChart = 'ut3';
                                          _currentSelectedUt = valSelected;
                                        } else if (valSelected == 'UT 4') {
                                          _selectedUtBarChart = 'ut4';
                                          _currentSelectedUt = valSelected;
                                        }
                                      },
                                    );
                                  },
                                  value: _currentSelectedUt,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    openModalSheetForEdit(context, 'utEdit');
                                  }),
                              IconButton(
                                  //color: Color.fromRGBO(255, 254, 229, 1),
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    openModalSheetForEdit(
                                        context, 'addSubject');
                                  }),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    openModalSheetForEdit(
                                        context, 'deleteSubject');
                                  })
                            ],
                          ),
                          Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                child: BarChartForMarks(
                                    stud.subjects, _selectedUtBarChart),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // si
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.black38,
                                  style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  elevation: 20,
                                  items: _listOFSem.map((String choice) {
                                    return DropdownMenuItem<String>(
                                      value: choice,
                                      child: Text(
                                        choice,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String valSelected) {
                                    setState(
                                      () {
                                        if (valSelected == 'Half Yearly') {
                                          _selectedSemBarChart = 'halfYearly';
                                          _currentSelectedSem = valSelected;
                                        } else if (valSelected ==
                                            'Final Exam') {
                                          _selectedSemBarChart = 'finalExam';
                                          _currentSelectedSem = valSelected;
                                        }
                                      },
                                    );
                                  },
                                  value: _currentSelectedSem,
                                ),
                              ),
                              FlatButton.icon(
                                  onPressed: () {
                                    openModalSheetForEdit(context, 'semEdit');
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ))
                            ],
                          ),
                          Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                child: BarChartForMarks(
                                    stud.subjects, _selectedSemBarChart),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
