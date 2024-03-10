import 'package:flutter/material.dart';
import 'package:medcs_dashboard/models/sales_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.27,
      width: size.width * 0.34,
      child: SfCircularChart(
        series: <CircularSeries>[
          PieSeries<SalesData, String>(
            dataSource: _createSampleData(),
            xValueMapper: (SalesData sales, _) => sales.category,
            yValueMapper: (SalesData sales, _) => sales.sales,
            dataLabelMapper: (SalesData sales, _) =>
                '${sales.category}: ${sales.sales}',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }

  List<SalesData> _createSampleData() {
    return [
      SalesData('Basic', 20),
      SalesData('Family', 30),
      SalesData('Beauty', 15),
      SalesData('Supplements', 25),
      SalesData('Health', 40),
      SalesData('Lifestyle', 35),
    ];
  }
}
