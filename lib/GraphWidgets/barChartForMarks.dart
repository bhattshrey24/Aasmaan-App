import '../model/SubjectStructure.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartForMarks extends StatelessWidget {
  final List<SubjectStructure> studSubjectDetails;
  final String type;
  BarChartForMarks(this.studSubjectDetails, this.type);

  num _marksAllocating(int i) {
    num dummy;
    if (type == 'ut1') {
      dummy = studSubjectDetails[i].ut1['scored'];
    } else if (type == 'ut2') {
      dummy = studSubjectDetails[i].ut2['scored'];
    } else if (type == 'ut3') {
      dummy = studSubjectDetails[i].ut3['scored'];
    } else if (type == 'ut4') {
      dummy = studSubjectDetails[i].ut4['scored'];
    } else if (type == 'halfYearly') {
      dummy = studSubjectDetails[i].halfYearly['scored'];
    } else if (type == 'finalExam') {
      dummy = studSubjectDetails[i].finalExam['scored'];
    }
    return dummy;
  }

  List<charts.Series<Table, String>> _inputDataForGraph() {
    List<Table> data = [];
    for (int i = 0; i < studSubjectDetails.length; i++) {
      data.add(
        new Table(studSubjectDetails[i].name, _marksAllocating(i)),
      );
    }

    return [
      new charts.Series<Table, String>(
          id: 'Marks',
          colorFn: (_, __) => charts.Color(r: 0, g: 223, b: 255, a: 80),
          domainFn: (Table subject, _) => subject.subjectName,
          measureFn: (Table subject, _) => subject.marks,
          data: data,
          insideLabelStyleAccessorFn: (Table subject, _) =>
              charts.TextStyleSpec(
                  fontSize: 15, color: charts.MaterialPalette.black),
          outsideLabelStyleAccessorFn: (Table subject, _) =>
              charts.TextStyleSpec(
                  fontSize: 15, color: charts.MaterialPalette.black),
          labelAccessorFn: (Table subject, _) => '${subject.marks}/100'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _inputDataForGraph(),
      animate: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          minimumPaddingBetweenLabelsPx: 0,
          labelStyle: new charts.TextStyleSpec(
              fontSize: 20, color: charts.MaterialPalette.black),
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.black),
        ),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
              fontSize: 18, color: charts.MaterialPalette.black),
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.black),
        ),
      ),
    );
  }
}

class Table {
  final String subjectName;
  final num marks;
  Table(this.subjectName, this.marks);
}
