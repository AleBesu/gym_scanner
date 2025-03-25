import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<int> _moneyQuantityList = [
  0,
  100,
  200,
  300,
  400,
  500,
  600,
  700,
  800,
  900,
  1000,
  1100
];

class GraphFinances extends StatelessWidget {
  const GraphFinances({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
            isSelected: const [true, false, false],
            children: const [Text("D"), Text("M"), Text("A")]),
        Expanded(
          child: LineChart(
            LineChartData(
                minY: 0,
                maxY: 9,
                minX: 0,
                maxX: 6,
                gridData: const FlGridData(horizontalInterval: 1),
                titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(interval: 1, showTitles: true)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)))),
          ),
        ),
      ],
    );
  }
}
