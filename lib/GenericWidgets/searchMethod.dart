import '../Screens/StudentDetailsDisplay.dart';

import '../provider/students.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchMethod extends SearchDelegate<String> {
  // no setState is required beacuse searchDelegate manages it
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      primaryColor: Colors.white,
      canvasColor: Colors.white,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final student = Provider.of<Student>(context, listen: false);

    List<String> dummyList = (student.list
            .where((element) => element.name.startsWith(query))
            .toList())
        .map((stud) => stud.name)
        .toList();

    final suggestionList = dummyList;

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (ctx, index) {
        return ListTileTheme(
          iconColor: Colors.white,
          child: ListTile(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).popAndPushNamed(
                  StudentDetailsDisplay.routeName,
                  arguments: suggestionList[index]);
            },
            leading: Icon(Icons.people),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
