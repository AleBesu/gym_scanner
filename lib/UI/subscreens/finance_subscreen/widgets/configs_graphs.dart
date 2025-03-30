import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/casual_user_payment_provider.dart';
import 'package:gym_scanner/core/Date/time_inverval.dart';

List<FlSpot> _getSelectedValueTime(
    WidgetRef ref, List<List<List<List<int>>>> regitersData,
    {required TimeInverval actualTimeInterval,
    int actualWeek = 0,
    int actualMonth = 0,
    int actualYear = 0}) {
  final casualUserPaymentsPro = ref.watch(casualUserPaymentProvider);

  switch (actualTimeInterval) {
    case TimeInverval.week:
      regitersData[actualYear][actualMonth][actualWeek];

    case TimeInverval.month:
      regitersData[actualYear][actualMonth];

    case TimeInverval.year:
      regitersData[actualYear];

    default:
  }

  return [];
}

abstract class ConfigsGraphs {
  static LineChartData getConfig(BuildContext context,
      {TimeInverval timeInterval = TimeInverval.week,
      required List<FlSpot> coordenatesValuesList}) {
    // List<LineChartData> configList = [
    //   _getWeekConfig(context),
    //   _getMonthConfig(context),
    //   _getYearConfig(context)
    // ];

    switch (timeInterval) {
      case TimeInverval.week:
        return _getWeekConfig(context, spotsList: coordenatesValuesList);

      case TimeInverval.month:
        return _getMonthConfig(context);

      case TimeInverval.year:
        return _getYearConfig(context);

      default:
        throw ("introduce un Time Invertal Valido");
    }

    // if (indexToSelect >= configList.length || indexToSelect < 0) {
    //   throw ("indexToSelect should be indexToSelect >= configList.length || indexToSelect < 0 ");
    // }

    // return configList[indexToSelect];
  }

  static LineChartData _getWeekConfig(BuildContext context,
      {required List<FlSpot> spotsList}) {
    Size size = MediaQuery.of(context).size;

    return LineChartData(
        lineTouchData: const LineTouchData(),
        lineBarsData: [LineChartBarData(spots: spotsList)],
        minY: 0,
        maxY: 80,
        minX: 0,
        maxX: 7,
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
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }

  static LineChartData _getMonthConfig(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LineChartData(
        lineBarsData: [
          LineChartBarData(spots: [const FlSpot(1, 4), const FlSpot(2, 5)])
        ],
        minY: 0,
        maxY: 80,
        minX: 1,
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

  static LineChartData _getYearConfig(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LineChartData(
        lineBarsData: [
          LineChartBarData(spots: [const FlSpot(1, 4), const FlSpot(2, 5)])
        ],
        minY: 0,
        maxY: 80,
        minX: 1,
        maxX: 12,
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
                        case 1:
                          return const Text("E");
                        case 2:
                          return const Text("F");
                        case 3:
                          return const Text("M");
                        case 4:
                          return const Text("A");
                        case 5:
                          return const Text("M");
                        case 6:
                          return const Text("J");

                        case 7:
                          return const Text("J");

                        case 8:
                          return const Text("A");
                        case 9:
                          return const Text("S");
                        case 10:
                          return const Text("O");
                        case 11:
                          return const Text("N");
                        case 12:
                          return const Text("D");

                        default:
                          return const Text("without Data");
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
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }
}
