import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:gym_scanner/core/Date/time_inverval.dart';

abstract class ConfigsGraphs {
  static LineChartData getConfig(BuildContext context,
      {TimeInverval timeInterval = TimeInverval.week,
      required List<FlSpot> coordenatesValuesList}) {
    switch (timeInterval) {
      case TimeInverval.week:
        return _getWeekConfig(context, spotsList: coordenatesValuesList);

      case TimeInverval.month:
        return _getMonthConfig(context, spotsList: coordenatesValuesList);

      case TimeInverval.year:
        return _getYearConfig(context, spotsList: coordenatesValuesList);

      default:
        throw ("introduce un Time Invertal Valido");
    }
  }

  static LineChartData _getWeekConfig(BuildContext context,
      {required List<FlSpot> spotsList}) {
    Size size = MediaQuery.of(context).size;

    return LineChartData(
        lineTouchData:
            const LineTouchData(touchTooltipData: LineTouchTooltipData()),
        lineBarsData: [
          LineChartBarData(
              color: spotsList.length <= 1 ||
                      spotsList.last.y >= spotsList[spotsList.length - 2].y
                  ? Colors.green
                  : Colors.red,
              spots: spotsList.length < 7
                  ? spotsList.sublist(0, spotsList.length)
                  : spotsList.sublist(0, 7))
        ],
        minY: 0,
        maxY: 80,
        minX: 0,
        maxX: 6,
        gridData: FlGridData(
          verticalInterval: 1,
          horizontalInterval: 5,
          getDrawingVerticalLine: (value) {
            return const FlLine(
                color: Colors.white10, dashArray: [5, 5], strokeWidth: 1);
          },
          getDrawingHorizontalLine: (value) {
            return const FlLine(
                color: Colors.white10, dashArray: [5, 5], strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    maxIncluded: false,
                    getTitlesWidget: (value, meta) {
                      switch (value) {
                        case 0:
                          return const Text("L");
                        case 1:
                          return const Text("M");
                        case 2:
                          return const Text("M");
                        case 3:
                          return const Text("J");
                        case 4:
                          return const Text("V");
                        case 5:
                          return const Text("S");

                        case 6:
                          return const Text("D");

                        default:
                          return const Text("data");
                      }
                    },
                    interval: 1,
                    showTitles: true,
                    reservedSize: size.height * 0.03)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    interval: 10,
                    reservedSize: size.width * 0.08,
                    showTitles: true)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(
              showTitles: false,
            )),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }

  static LineChartData _getMonthConfig(BuildContext context,
      {required List<FlSpot> spotsList}) {
    Size size = MediaQuery.of(context).size;

    return LineChartData(
        lineBarsData: [
          LineChartBarData(
              color: spotsList.length <= 1 ||
                      spotsList.last.y >= spotsList[spotsList.length - 2].y
                  ? Colors.green
                  : Colors.red,
              spots: spotsList.length < 31
                  ? spotsList.sublist(0, spotsList.length)
                  : spotsList.sublist(0, 31))
        ],
        minY: 0,
        maxY: 80,
        minX: 0,
        maxX: 30,
        gridData: FlGridData(
          verticalInterval: 7,
          horizontalInterval: 5,
          getDrawingVerticalLine: (value) {
            return const FlLine(
                color: Colors.white10, dashArray: [5, 5], strokeWidth: 1);
          },
          getDrawingHorizontalLine: (value) {
            return const FlLine(
                color: Colors.white10, dashArray: [5, 5], strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      return Text("${(value + 1).toInt()}");
                    },
                    maxIncluded: false,
                    interval: 7,
                    showTitles: true,
                    reservedSize: size.height * 0.03)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    interval: 10,
                    reservedSize: size.width * 0.1,
                    showTitles: true)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }

  static LineChartData _getYearConfig(BuildContext context,
      {required List<FlSpot> spotsList}) {
    Size size = MediaQuery.of(context).size;

    return LineChartData(
        lineBarsData: [
          LineChartBarData(
              color: spotsList.length <= 1 ||
                      spotsList.last.y >= spotsList[spotsList.length - 2].y
                  ? Colors.green
                  : Colors.red,
              spots: spotsList.length < 36
                  ? spotsList.sublist(0, spotsList.length)
                  : spotsList.sublist(0, 36))
        ],
        minY: 0,
        maxY: 80,
        minX: 0,
        maxX: 36,
        gridData: FlGridData(
          verticalInterval: 1,
          horizontalInterval: 5,
          getDrawingVerticalLine: (value) {
            return const FlLine(
                color: Colors.white10, dashArray: [5, 5], strokeWidth: 1);
          },
          getDrawingHorizontalLine: (value) {
            return const FlLine(
                color: Colors.white10, dashArray: [5, 5], strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      switch (value) {
                        case 0:
                          return const Text("E");
                        case 3:
                          return const Text("F");
                        case 6:
                          return const Text("M");
                        case 9:
                          return const Text("A");
                        case 12:
                          return const Text("M");
                        case 15:
                          return const Text("J");

                        case 18:
                          return const Text("J");

                        case 21:
                          return const Text("A");
                        case 24:
                          return const Text("S");
                        case 27:
                          return const Text("O");
                        case 30:
                          return const Text("N");
                        case 33:
                          return const Text("D");

                        default:
                          return const Text("w");
                      }
                    },
                    maxIncluded: false,
                    interval: 3,
                    showTitles: true,
                    reservedSize: size.height * 0.03)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    interval: 10,
                    reservedSize: size.width * 0.08,
                    showTitles: true)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }
}
