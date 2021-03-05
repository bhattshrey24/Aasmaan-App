import './studentList.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/students.dart';

class StudentListTileBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => FutureBuilder(
        future: Provider.of<Student>(context, listen: false).fetchAndSet(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Student>(
                child: Center(
                    child: Text(
                  'Add Students',
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                )),
                builder: (ctx, studentDetails, ch) =>
                    studentDetails.list.length <= 0
                        ? ch
                        : ListView.builder(
                            itemBuilder: (ctx, index) {
                              return StudentList(
                                student: studentDetails.list[index],
                                key: ValueKey(
                                    studentDetails.list[index].studDetailId),
                              );
                            },
                            itemCount: studentDetails.noOFStudents(),
                          ),
              ),
      ),
    );
  }
}
