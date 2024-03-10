import 'package:flutter/material.dart';
import 'package:medcs_dashboard/models/day_sales_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<DaySales> createSampleData() {
      return [
        DaySales('Mon', 20),
        DaySales('Tue', 30),
        DaySales('Wed', 40),
        DaySales('Thu', 50),
        DaySales('Fri', 60),
        DaySales('Sat', 70),
        DaySales('Sun', 80),
      ];
    }

    return SizedBox(
      height: size.height * 0.26,
      width: size.width * 0.32,
      child: SfCartesianChart(
        series: [
          BarSeries<DaySales, String>(
            dataSource: createSampleData(),
            xValueMapper: (DaySales sales, _) => sales.day,
            yValueMapper: (DaySales sales, _) => sales.sales,
          )
        ],
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(),
      ),
    );
  }
}
