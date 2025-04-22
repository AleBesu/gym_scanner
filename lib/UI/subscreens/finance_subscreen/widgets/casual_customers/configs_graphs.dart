import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/casual_user_payment_statitics_provider.dart';
import 'package:gym_scanner/UI/Providers/year_selected_provider.dart';
import 'package:gym_scanner/core/Date/get/get_day_of_year_number.dart';
import 'package:gym_scanner/core/Date/get/get_middle_of_month.dart';
import 'package:gym_scanner/core/Date/get/month_of_year_list.dart';

import 'package:gym_scanner/core/Date/time_inverval.dart';

abstract class ConfigsGraphs {
  static Future<LineChartData> getConfig(BuildContext context, WidgetRef ref,
      {TimeInverval timeInterval = TimeInverval.week,
      required List<FlSpot> coordenatesValuesList}) async {
    DateTime _startDate =
        await ref.read(casualUserPaymentStatiticsProvider.notifier).startDate;
    int daysSinceInitYear = ref.watch(yearSelectedIndexProvider) == 0
        ? _startDate.toUtc().difference(DateTime(_startDate.year)).inDays
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
        return await _getMonthConfig(
          context,
          ref,
          daysSinceInitYear: daysSinceInitYear,
          spotsList: coordenatesValuesList,
          startDate: _startDate,
        );

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
                return LineTooltipItem(
                    ' ${diasDeLaSemana[touchedSpot.x.toInt() - lastMondayIndex]} \n${touchedSpot.y.toInt().toString()} clientes',
                    const TextStyle(color: Colors.white));
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
                    stops: const [
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
    required int daysSinceInitYear,
    required List<FlSpot> spotsList,
    required DateTime startDate,
  }) async {
    Size size = MediaQuery.of(context).size;

    double intervalY = _calculateIntervalY(spotsList,
        firstInterval: 2, secontInterval: 10, thirdInvertal: 25);

    double minX = DateTime.utc(DateTime.now().year, DateTime.now().month)
        .difference(DateTime.utc(DateTime.now().year))
        .inDays
        .toDouble();

    double maxX = DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 0)
        .difference(DateTime.utc(DateTime.now().year))
        .inDays
        .toDouble();
    // double maxX = (DateTime(DateTime.now().year, DateTime.now().month)
    //             .difference(DateTime(DateTime.now().year))
    //             .inDays
    //             .toDouble() +
    //         DateTime(DateTime.now().year, DateTime.now().month + 1)
    //             .difference(DateTime(DateTime.now().year, DateTime.now().month))
    //             .inDays
    //             .toDouble()) -
    //     1;

    return LineChartData(
        borderData: FlBorderData(border: Border.all(color: Colors.white)),
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (touchedSpot) {
                return LineTooltipItem(
                    "${touchedSpot.x.toInt() - minX.toInt() + 1} de ${_getNameOfCurrentMonth(touchedSpot.x.toInt(), yearSelectedNumber: 2025)} \n  ${touchedSpot.y.toInt()} Clientes",
                    const TextStyle(color: Colors.white));
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
                      stops: const [
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
                    interval: 7,
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

  static String _getNameOfCurrentMonth(int selectedDay,
      {required int yearSelectedNumber}) {
    return monthOfYearInSpanishList[
        DateTime(yearSelectedNumber).add(Duration(days: selectedDay)).month -
            1];
  }

  static int _getCurrentMonthWithDayOfYear(int currentDayOfYear) {
    return DateTime(DateTime.now().year)
        .add(Duration(days: currentDayOfYear - 1))
        .month;
  }

  static LineChartData _getYearConfig(BuildContext context,
      {required List<FlSpot> spotsList, required DateTime startDate}) {
    Size size = MediaQuery.of(context).size;
    final averagedFlSpotList = _calculateMonthlyAverage(spotsList);
    double intervalY = _calculateIntervalY(spotsList,
        firstInterval: 2, secontInterval: 10, thirdInvertal: 25);
    return LineChartData(
        borderData: FlBorderData(border: Border.all(color: Colors.white)),
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (touchedSpot) {
                return LineTooltipItem(
                    '${dayOfYearToDateTime(_getTimeIntervaSinceAPositionUntilAnother(spotsList, touchedSpot.x.toInt())[0] + 1).day} de ${monthOfYearInSpanishList[_getCurrentMonthWithDayOfYear(touchedSpot.x.toInt()) - 1]}  a \n'
                    '${dayOfYearToDateTime(_getTimeIntervaSinceAPositionUntilAnother(spotsList, touchedSpot.x.toInt())[1] + 1).day} de ${monthOfYearInSpanishList[_getCurrentMonthWithDayOfYear(_getTimeIntervaSinceAPositionUntilAnother(spotsList, touchedSpot.x.toInt())[1]) - 1]}\n'
                    'Clientes\n'
                    'Promedio: ${touchedSpot.y.toInt()} \n'
                    'Total ${_getTotalOfCustomerInATime(spotsList, touchedSpot.x.toInt())}',
                    const TextStyle(
                      color: Colors.white,
                    ));
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
                      stops: const [
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
              spots: spotsList.length > 1 ? averagedFlSpotList : spotsList)
        ],
        minY: 0,
        // maxY: _roundIntervalY(spotsList, intervalY),
        minX: 0,
        maxX: 364,
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
                        case 0: // Enero (1 de enero)
                          return const Text("E");
                        case 31: // Febrero (1 de febrero)
                          return const Text("F");
                        case 59: // Marzo (1 de marzo)
                          return const Text("M");
                        case 90: // Abril (1 de abril)
                          return const Text("A");
                        case 120: // Mayo (1 de mayo)
                          return const Text("M");
                        case 151: // Junio (1 de junio)
                          return const Text("J");
                        case 181: // Julio (1 de julio)
                          return const Text("J");
                        case 212: // Agosto (1 de agosto)
                          return const Text("A");
                        case 243: // Septiembre (1 de septiembre)
                          return const Text("S");
                        case 273: // Octubre (1 de octubre)
                          return const Text("O");
                        case 304: // Noviembre (1 de noviembre)
                          return const Text("N");
                        case 334: // Diciembre (1 de diciembre)
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

  static List<int> _getTimeIntervaSinceAPositionUntilAnother(
      List<FlSpot> flSpotList, int x) {
    int firstDayOfMonth = getDayOfYearNumber(DateTime.utc(
      2025,
      _getCurrentMonthWithDayOfYear(x),
    ));

    int middleOfCurrentMonthDayOfYear = getDayOfYearNumber(
        getMiddleOfMonth(DateTime.utc(2025, _getCurrentMonthWithDayOfYear(x))));
    int lastDayOfCurrentMonthDayOfYear = getDayOfYearNumber(getLastDayOfMonth(
        getMiddleOfMonth(
            DateTime.utc(2025, _getCurrentMonthWithDayOfYear(x)))));

    int nextPointX = x == middleOfCurrentMonthDayOfYear ||
            x <= middleOfCurrentMonthDayOfYear && x == flSpotList.last.x
        ? middleOfCurrentMonthDayOfYear
        : lastDayOfCurrentMonthDayOfYear;

    return [x, nextPointX];
  }

  static List<FlSpot> _calculateMonthlyAverage(List<FlSpot> listToCalculate) {
    // interval =
    //     listToCalculate.length < interval ? listToCalculate.length : interval;
    if (listToCalculate.length <= 1) {
      return listToCalculate;
    }

    List<FlSpot> newList = [];

    //iterate through the spot list
    for (int x = listToCalculate.first.x.toInt();
        x <= listToCalculate.last.x;
        x++) {
      //this variables divide the month based on dayOfYear number x (or too coordente x of Fl spot of)
      int firstDayOfMonth = getDayOfYearNumber(DateTime.utc(
        2025,
        _getCurrentMonthWithDayOfYear(x),
      ));

      int middleOfCurrentMonthDayOfYear = getDayOfYearNumber(
          getMiddleOfMonth(DateTime(2025, _getCurrentMonthWithDayOfYear(x))));
      int lastDayOfCurrentMonthDayOfYear = getDayOfYearNumber(getLastDayOfMonth(
          getMiddleOfMonth(DateTime(2025, _getCurrentMonthWithDayOfYear(x)))));
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

      // this for calculate for first half ofMonth Average
      if (x == middleOfCurrentMonthDayOfYear ||
          x <= middleOfCurrentMonthDayOfYear && x == listToCalculate.last.x) {
        List<FlSpot> listToAverage = listToCalculate
            .where(
              (spot) =>
                  spot.x >= firstDayOfMonth &&
                  spot.x <= middleOfCurrentMonthDayOfYear,
            )
            .toList();
        final spotAveraged = listToAverage.reduce(
          (a, b) => FlSpot(a.x, a.y + b.y),
        );

        newList.add(FlSpot(spotAveraged.x,
            (spotAveraged.y / listToAverage.length).toInt().toDouble()));
      }

      // this for calculate for second half ofMonth Average
      if (x == lastDayOfCurrentMonthDayOfYear ||
          x > middleOfCurrentMonthDayOfYear && x == listToCalculate.last.x) {
        List<FlSpot> listToAverage = listToCalculate
            .where(
              (spot) =>
                  spot.x > middleOfCurrentMonthDayOfYear &&
                  spot.x <= lastDayOfCurrentMonthDayOfYear,
            )
            .toList();

        final spotAveraged = listToAverage.reduce(
          (a, b) => FlSpot(a.x, a.y + b.y),
        );

        newList.add(FlSpot(spotAveraged.x,
            (spotAveraged.y / listToAverage.length).toInt().toDouble()));
      }
    }
    // return averaged list
    return newList;
  }

  static int _getTotalOfCustomerInATime(
      List<FlSpot> listToCalculate, int positionX) {
    //!refactorizate this!!!!!!!!!!!!!!!!!!!!!!!!!
    // interval =
    //     listToCalculate.length < interval ? listToCalculate.length : interval;
    if (listToCalculate.length <= 1) {
      return listToCalculate.first.y.toInt();
    }

    List<FlSpot> newList = [];

    //iterate through the spot list
    for (int x = listToCalculate.first.x.toInt();
        x <= listToCalculate.last.x.toInt();
        x++) {
      //this variables divide the month based on dayOfYear number x (or too coordente x of Fl spot of)
      int firstDayOfMonth = getDayOfYearNumber(DateTime.utc(
        2025,
        _getCurrentMonthWithDayOfYear(x),
      ));

      int middleOfCurrentMonthDayOfYear = getDayOfYearNumber(
          getMiddleOfMonth(DateTime(2025, _getCurrentMonthWithDayOfYear(x))));
      int lastDayOfCurrentMonthDayOfYear = getDayOfYearNumber(getLastDayOfMonth(
          getMiddleOfMonth(DateTime(2025, _getCurrentMonthWithDayOfYear(x)))));
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

      // this for calculate for first half ofMonth Average
      if (x == middleOfCurrentMonthDayOfYear ||
          x <= middleOfCurrentMonthDayOfYear && x == listToCalculate.last.x) {
        List<FlSpot> listToAverage = listToCalculate
            .where(
              (spot) =>
                  spot.x >= firstDayOfMonth &&
                  spot.x <= middleOfCurrentMonthDayOfYear,
            )
            .toList();
        final spotAveraged = listToAverage.reduce(
          (a, b) => FlSpot(a.x, a.y + b.y),
        );

        newList
            .add(FlSpot(spotAveraged.x, (spotAveraged.y).toInt().toDouble()));
      }

      // this for calculate for second half ofMonth Average
      if (x == lastDayOfCurrentMonthDayOfYear ||
          x > middleOfCurrentMonthDayOfYear && x == listToCalculate.last.x) {
        List<FlSpot> listToAverage = listToCalculate
            .where(
              (spot) =>
                  spot.x > middleOfCurrentMonthDayOfYear &&
                  spot.x <= lastDayOfCurrentMonthDayOfYear,
            )
            .toList();

        final spotAveraged = listToAverage.reduce(
          (a, b) => FlSpot(a.x, a.y + b.y),
        );

        newList
            .add(FlSpot(spotAveraged.x, (spotAveraged.y).toInt().toDouble()));
      }
    }
    // return averaged list
    return newList
        .firstWhere(
          (spot) {
            return spot.x == positionX;
          },
        )
        .y
        .toInt();
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
