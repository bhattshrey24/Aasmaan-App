import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PieChartForAttendance extends StatelessWidget {
  final num present;
  final num absent;

  PieChartForAttendance(this.present, this.absent);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 500,
      child: (charts.PieChart(
        _createSampleData(),
        animate: true,
        layoutConfig: charts.LayoutConfig(
          bottomMarginSpec: charts.MarginSpec.fixedPixel(20),
          rightMarginSpec: charts.MarginSpec.fixedPixel(10),
          topMarginSpec: charts.MarginSpec.fixedPixel(0),
          leftMarginSpec: charts.MarginSpec.fixedPixel(0),
        ),
        animationDuration: Duration(seconds: 1, milliseconds: 5),
        behaviors: [new charts.DatumLegend()],
      )),
    );
  }

  List<charts.Series<PieChartInput, String>> _createSampleData() {
    PieChartInput instanceForPresent;
    PieChartInput instanceForAbsent;

    if ((present == 0) && (absent == 0) || ((present == 0) && (absent == 1))) {
      instanceForPresent = PieChartInput('Present', 0, Colors.blue[200]);
      instanceForAbsent = PieChartInput('Absent', 100, Colors.blue[100]);
    } else {
      instanceForPresent =
          PieChartInput('Present', (present / absent) * 100, Colors.blue[200]);
      instanceForAbsent = PieChartInput(
          'Absent', (100 - ((present / absent) * 100)), Colors.blue[100]);
    }
    final data = [instanceForPresent, instanceForAbsent];

    return [
      new charts.Series<PieChartInput, String>(
        id: 'pieGraph',
        colorFn: (PieChartInput ob, __) =>
            charts.ColorUtil.fromDartColor(ob.colorVal),
        domainFn: (PieChartInput ob, _) => ob.type,
        measureFn: (PieChartInput ob, _) => ob.percentage,
        data: data,
        insideLabelStyleAccessorFn: (PieChartInput ob, _) =>
            new charts.TextStyleSpec(fontSize: 5),
        outsideLabelStyleAccessorFn: (PieChartInput ob, _) =>
            new charts.TextStyleSpec(fontSize: 5),
      )
    ];
  }
}

class PieChartInput {
  final String type;
  final num percentage;
  final Color colorVal;

  PieChartInput(this.type, this.percentage, this.colorVal);
}
