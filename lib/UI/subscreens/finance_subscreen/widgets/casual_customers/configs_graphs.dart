import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/casual_user_payment_statitics_provider.dart';
import 'package:gym_scanner/UI/Providers/year_selected_provider.dart';

import 'package:gym_scanner/core/Date/time_inverval.dart';

abstract class ConfigsGraphs {
  static Future<LineChartData> getConfig(BuildContext context, WidgetRef ref,
      {TimeInverval timeInterval = TimeInverval.week,
      required List<FlSpot> coordenatesValuesList}) async {
    DateTime _startDate =
        await ref.read(casualUserPaymentStatiticsProvider.notifier).startDate;
    int daysSinceInitYear = ref.watch(yearSelectedIndexProvider) == 0
        ? _startDate.difference(DateTime(_startDate.year)).inDays
        : 0;

    coordenatesValuesList = coordenatesValuesList.map(
      (spot) {
        return FlSpot(spot.x + daysSinceInitYear, spot.y);
      },
    ).toList();

    switch (timeInterval) {
      case TimeInverval.week:
        return _getWeekConfig(
          context,
          spotsList: coordenatesValuesList,
        );

      case TimeInverval.month:
        return await _getMonthConfig(context, ref,
            spotsList: coordenatesValuesList, startDate: _startDate);

      case TimeInverval.year:
        return _getYearConfig(context,
            spotsList: coordenatesValuesList, startDate: _startDate);

      default:
        throw ("introduce un Time Invertal Valido");
    }
  }

  static LineChartData _getWeekConfig(
    BuildContext context, {
    required List<FlSpot> spotsList,
  }) {
    Size size = MediaQuery.of(context).size;

    double intervalY = _calculateIntervalY(spotsList,
        firstInterval: 2, secontInterval: 10, thirdInvertal: 25);
    int lastMondayIndex = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - DateTime.monday))
        .difference(DateTime(DateTime.now().year))
        .inDays;
    int lastDayWeek = lastMondayIndex + 6;
/*hya una posicion de mas en la primera semana del mes el primer lunes aparece como menos dos y deberia ser menos 3





*/

    print(spotsList
        .where(
          (spot) => spot.x >= lastMondayIndex && spot.x <= lastDayWeek,
        )
        .toList());
    return LineChartData(
        borderData: FlBorderData(border: Border.all(color: Colors.white)),
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (touchedSpot) {
                return LineTooltipItem(touchedSpot.y.toInt().toString(),
                    const TextStyle(color: Colors.green));
              },
            ).toList();
          },
        )),
        lineBarsData: [
          LineChartBarData(
            belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.0,
                      0.5,
                      1.0
                    ],
                    colors: [
                      if (spotsList.length <= 1 ||
                          spotsList.last.y >=
                              spotsList[spotsList.length - 2].y) ...[
                        Colors.green.withOpacity(0.5),
                        Colors.green.withOpacity(0.25),
                        Colors.green.withOpacity(0.1)
                      ],
                      if (spotsList.length > 1 &&
                          spotsList.last.y <
                              spotsList[spotsList.length - 2].y) ...[
                        Colors.red.withOpacity(0.5),
                        Colors.red.withOpacity(0.25),
                        Colors.red.withOpacity(0.1)
                      ]
                    ])),
            color: spotsList.length <= 1 ||
                    spotsList.last.y >= spotsList[spotsList.length - 2].y
                ? Colors.green
                : Colors.red,
            spots: spotsList
                .where(
                  (spot) => spot.x >= lastMondayIndex && spot.x <= lastDayWeek,
                )
                .toList(),
          )
        ],
        minY: 0,
        // maxY: _roundIntervalY(spotsList, intervalY),
        minX: lastMondayIndex.toDouble(),
        maxX: lastDayWeek.toDouble(),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: intervalY / 2,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
                color: Colors.white10, strokeWidth: 2, dashArray: [5, 2]);
          },
        ),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      int weekDay = value.toInt() - lastMondayIndex;

                      switch (weekDay) {
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
                          return const Text("vacio");
                      }
                    },
                    interval: 1,
                    showTitles: true,
                    reservedSize: size.height * 0.03)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    interval: intervalY,
                    reservedSize: size.width * 0.09,
                    showTitles: true)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(
              showTitles: false,
            )),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }

  static Future<LineChartData> _getMonthConfig(
    BuildContext context,
    WidgetRef ref, {
    required List<FlSpot> spotsList,
    required DateTime startDate,
  }) async {
    Size size = MediaQuery.of(context).size;

    double intervalY = _calculateIntervalY(spotsList,
        firstInterval: 2, secontInterval: 10, thirdInvertal: 25);

    double minX = DateTime(DateTime.now().year, DateTime.now().month)
        .difference(DateTime(DateTime.now().year))
        .inDays
        .toDouble();
    double maxX = DateTime(DateTime.now().year, DateTime.now().month)
            .difference(DateTime(DateTime.now().year))
            .inDays
            .toDouble() +
        DateTime(DateTime.now().year, DateTime.now().month + 1)
            .difference(DateTime(DateTime.now().year, DateTime.now().month))
            .inDays
            .toDouble() -
        1;

    print(spotsList
        .where(
          (element) => element.x >= minX && element.x <= maxX,
        )
        .toList());

    return LineChartData(
        borderData: FlBorderData(border: Border.all(color: Colors.white)),
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (touchedSpot) {
                return LineTooltipItem(touchedSpot.y.toInt().toString(),
                    const TextStyle(color: Colors.green));
              },
            ).toList();
          },
        )),
        lineBarsData: [
          LineChartBarData(
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.0,
                        0.5,
                        1.0
                      ],
                      colors: [
                        if (spotsList.length <= 1 ||
                            spotsList.last.y >=
                                spotsList[spotsList.length - 2].y) ...[
                          Colors.green.withOpacity(0.5),
                          Colors.green.withOpacity(0.25),
                          Colors.green.withOpacity(0.1)
                        ],
                        if (spotsList.length > 1 &&
                            spotsList.last.y <
                                spotsList[spotsList.length - 2].y) ...[
                          Colors.red.withOpacity(0.5),
                          Colors.red.withOpacity(0.25),
                          Colors.red.withOpacity(0.1)
                        ]
                      ])),
              color: spotsList.length <= 1 ||
                      spotsList.last.y >= spotsList[spotsList.length - 2].y
                  ? Colors.green
                  : Colors.red,
              spots: spotsList
                  .where(
                    (element) => element.x >= minX && element.x <= maxX,
                  )
                  .toList())
        ],
        minY: 0,

        /*esto divide valor maximo de la spot list al interval para ver cuantas veces a ocurrido el intervalo,
  y luego le suma uno para encontrar el intervalo mas proximo despues del actual 
  ejemplo el intervalo es 25 y el mayor valor es 77 
  1- 77 / 25 = 3.08 ~ 3  
  2- 3 +1 =4
  3- 4 * 25 = 100

  el valor del intervalo mas proximo es 100
        */
        // maxY: _roundIntervalY(spotsList, intervalY),
        minX: minX,
        maxX: maxX,
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: intervalY,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
                color: Colors.white10, strokeWidth: 2, dashArray: [5, 2]);
          },
        ),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      return Text("${(value - minX + 1).toInt()}");
                    },
                    minIncluded: false,
                    interval: 2,
                    showTitles: true,
                    reservedSize: size.height * 0.07)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    interval: intervalY,
                    reservedSize: size.width * 0.1,
                    showTitles: true)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }

  static LineChartData _getYearConfig(BuildContext context,
      {required List<FlSpot> spotsList, required DateTime startDate}) {
    Size size = MediaQuery.of(context).size;
    if (spotsList.length >= 2) {
      spotsList = _calculateMonthlyAverage(spotsList, 15);
    }
    double intervalY = _calculateIntervalY(spotsList,
        firstInterval: 2, secontInterval: 10, thirdInvertal: 25);
    return LineChartData(
        borderData: FlBorderData(border: Border.all(color: Colors.white)),
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (touchedSpot) {
                return LineTooltipItem(touchedSpot.y.toInt().toString(),
                    const TextStyle(color: Colors.green));
              },
            ).toList();
          },
        )),
        lineBarsData: [
          LineChartBarData(
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.0,
                        0.5,
                        1.0
                      ],
                      colors: [
                        if (spotsList.length <= 1 ||
                            spotsList.last.y >=
                                spotsList[spotsList.length - 2].y) ...[
                          Colors.green.withOpacity(0.5),
                          Colors.green.withOpacity(0.25),
                          Colors.green.withOpacity(0.1)
                        ],
                        if (spotsList.length > 1 &&
                            spotsList.last.y <
                                spotsList[spotsList.length - 2].y) ...[
                          Colors.red.withOpacity(0.5),
                          Colors.red.withOpacity(0.25),
                          Colors.red.withOpacity(0.1)
                        ]
                      ])),
              color: spotsList.length <= 1 ||
                      spotsList.last.y >= spotsList[spotsList.length - 2].y
                  ? Colors.green
                  : Colors.red,
              // spots: spotsList.length < 36
              //     ? spotsList.sublist(0, spotsList.length)
              //     : spotsList.sublist(0, 36)

              spots: spotsList)
        ],
        minY: 0,
        // maxY: _roundIntervalY(spotsList, intervalY),
        minX: 0,
        maxX: 365,
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: spotsList
                      .reduce(
                        (a, b) => a.y > a.y ? a : b,
                      )
                      .y <
                  15
              ? 1
              : 5,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
                color: Colors.white10, strokeWidth: 2, dashArray: [5, 2]);
          },
        ),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      switch (value) {
                        case 0: // Enero
                          return const Text("E");
                        case 31: // Febrero
                          return const Text("F");
                        case 59: // Marzo
                          return const Text("M");
                        case 90: // Abril
                          return const Text("A");
                        case 120: // Mayo
                          return const Text("M");
                        case 151: // Junio
                          return const Text("J");
                        case 181: // Julio
                          return const Text("J");
                        case 212: // Agosto
                          return const Text("A");
                        case 243: // Septiembre
                          return const Text("S");
                        case 273: // Octubre
                          return const Text("O");
                        case 304: // Noviembre
                          return const Text("N");
                        case 334: // Diciembre
                          return const Text("D");

                        default:
                          return const Text("");
                      }
                    },
                    maxIncluded: false,
                    interval: 1,
                    showTitles: true,
                    reservedSize: size.height * 0.03)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    interval: intervalY,
                    reservedSize: size.width * 0.08,
                    showTitles: true)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))));
  }

  static List<FlSpot> _calculateMonthlyAverage(
      List<FlSpot> listToCalculate, int interval) {
    interval =
        listToCalculate.length < interval ? listToCalculate.length : interval;

    List<FlSpot> newList = [];

    int count = 1;
    for (int i = 0; i < listToCalculate.length; i += interval) {
      final lastIndex = (i + interval) > listToCalculate.length - 1
          ? listToCalculate.length - 1
          : i + interval - 1;
      double averagedSpotY = 0;
      // listToCalculate.sublist(i, lastIndex).map((e) {
      //   averagedSpotY += e.y;
      // });
      for (int y = i; y <= lastIndex; y++) {
        averagedSpotY += listToCalculate[y].y;
      }

      averagedSpotY /= (lastIndex - i + 1);
      count++;
      newList.add(FlSpot(
          listToCalculate[i].x.toDouble(), averagedSpotY.toInt().toDouble()));
    }

    return newList;
  }

  static double _calculateIntervalY(List<FlSpot> spotsList,
      {required int firstInterval,
      required int secontInterval,
      required int thirdInvertal}) {
    final largestValueY = spotsList
        .reduce(
          (a, b) => a.y > b.y ? a : b,
        )
        .y;

    return (largestValueY <= 20
            ? firstInterval
            : largestValueY > 20 && largestValueY < 100
                ? secontInterval
                : thirdInvertal)
        .toDouble();
  }

  static double _roundIntervalY(List<FlSpot> spotsList, double intervalY) {
    return ((spotsList
                        .reduce(
                          (a, b) => a.y > b.y ? a : b,
                        )
                        .y /
                    intervalY)
                .toInt() +
            1) *
        intervalY;
  }
}
