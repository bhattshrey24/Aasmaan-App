import 'package:aashman_app2/AppTheme/AppTheme.dart';

import './Screens/StudentDetailsDisplay.dart';
import './GenericWidgets/StudentListTileBuilder.dart';

import './Screens/AcademicDetails.dart';

import './GenericWidgets/searchMethod.dart';

import './Screens/StudentDetailsInput.dart';

import './provider/students.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Student(),
      child: MaterialApp(
        title: 'Aasmaan Teachers App',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (ctx) => HomePage(),
          StudentDetailsInput.routeName: (ctx) => StudentDetailsInput(),
          AcademicDetailsInput.routeName: (ctx) => AcademicDetailsInput(),
          StudentDetailsDisplay.routeName: (ctx) => StudentDetailsDisplay(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String flyingBirdAnimation = 'FlyingBird';
  String cloudAnimation = 'Untitled';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [Color(0xFF89f7fe), Color(0xFF66a6ff)]),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 80,
                      left: 10,
                      child: Container(
                        width: 100,
                        height: 130,
                        child: FlareActor(
                          'assets/animation/New File 1 (5).flr',
                          fit: BoxFit.contain,
                          animation: flyingBirdAnimation,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 130,
                      left: 80,
                      child: Container(
                        width: 80,
                        height: 80,
                        child: FlareActor(
                          'assets/animation/upwingbird.flr',
                          fit: BoxFit.contain,
                          animation: flyingBirdAnimation,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 25,
                      bottom: 85,
                      child: Text(
                        'Aasmaan Teacher\'s',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 80,
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          showSearch(
                              context: context, delegate: SearchMethod());
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 15,
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(
                          Icons.add_circle,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(StudentDetailsInput.routeName)
                              .then(
                            (value1) {
                              print('$value1 is the value returned by pop');
                              Future.delayed(Duration(seconds: 1)).then(
                                (value2) {
                                  if (value1 != null) {
                                    _scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('student $value1 Added !'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 2, child: StudentListTileBuilder()),
            ],
          )),
    );
  }
}
