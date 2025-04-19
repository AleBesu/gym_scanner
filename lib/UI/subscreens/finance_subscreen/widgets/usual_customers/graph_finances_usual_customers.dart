// import 'dart:ffi';

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/usual_user_payment_provider.dart';
import 'package:gym_scanner/domain/customer_entity.dart';

class GraphFinancesUsualCustomers extends ConsumerStatefulWidget {
  const GraphFinancesUsualCustomers({super.key});

  @override
  ConsumerState<GraphFinancesUsualCustomers> createState() =>
      _GraphFinancesUsualCustomersState();
}

class _GraphFinancesUsualCustomersState
    extends ConsumerState<GraphFinancesUsualCustomers> {
  int _startMonth = 0;
  int yearSelected = 0;
  Future<List<List<UsualCustomerEntity>>>? _futureYearStatistics;
  List<List<List<UsualCustomerEntity>>>? allYearsStatiticPro;
  DateTime startDateTime = DateTime(1);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    startDateTime = await ref
        .read(usualUserPaymentStatiticsProvider.notifier)
        .getStartDateTime();
    allYearsStatiticPro = await ref
        .read(usualUserPaymentStatiticsProvider.notifier)
        .getAllYearsStatics();

    if (allYearsStatiticPro != null) {
      yearSelected = allYearsStatiticPro!.length - 1;
    } else {
      throw (' allYearsStatiticPro cannot be null');
    }

    setState(() {
      _startMonth = startDateTime.month;
      if (allYearsStatiticPro != null) {
        _futureYearStatistics = ref
            .read(usualUserPaymentStatiticsProvider.notifier)
            .getAYearStatitics(yearSelected: yearSelected);
      }
    });
  }

  Future<void> selectYear(int yearToSelect) async {
    setState(() {
      // _futureYearStatistics = ref
      //     .read(usualUserPaymentStatiticsProvider.notifier)
      //     .getAYearStatitics(yearSelected: yearToSelect);

      yearSelected = yearToSelect;
      _futureYearStatistics = ref
          .read(usualUserPaymentStatiticsProvider.notifier)
          .getAYearStatitics(yearSelected: yearSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double barWith = size.width * 0.06;

    ///if year selected is null the the year selected is the last year

    return FutureBuilder(
        future: _futureYearStatistics,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Text("error");
          }

          final usualUserPaymentStatitic = snapshot.data!;
          double intervalY = _calculateIntervalY(usualUserPaymentStatitic,
              firstInterval: 2, secontInterval: 10, thirdInvertal: 25);

          return BarChart(BarChartData(
              barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(rod.toY.toInt().toString(),
                      TextStyle(color: Colors.green));
                },
              )),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: intervalY,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                      color: Colors.white10, strokeWidth: 2, dashArray: [5, 2]);
                },
              ),
              borderData: FlBorderData(
                  border: Border.all(
                      color: Colors.white, width: size.width * 0.001)),
              // maxY: _roundIntervalY(usualUserPaymentStatitic, intervalY),
              barGroups: [
                ...List.generate(usualUserPaymentStatitic.length, (index) {
                  return BarChartGroupData(x: index, barRods: [
                    BarChartRodData(
                        color: Colors.green,
                        toY: usualUserPaymentStatitic[index].length.toDouble(),
                        width: barWith,
                        borderRadius: BorderRadius.zero),
                  ]);
                }),
              ],
              titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          interval: intervalY,
                          showTitles: true,
                          reservedSize: size.width * 0.1)),
                  rightTitles: const AxisTitles(),
                  topTitles: AxisTitles(
                    axisNameSize: size.height * 0.035,
                    axisNameWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Clientes Suscritos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (allYearsStatiticPro != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: (allYearsStatiticPro ?? []).length <= 1
                                ? Text(startDateTime.year.toString())
                                : DropdownButton(
                                    value: yearSelected,
                                    items: List.generate(
                                        allYearsStatiticPro!.length, (index) {
                                      int currentYear =
                                          startDateTime.year + index;

                                      return DropdownMenuItem(
                                          value: index,
                                          child: Text(currentYear.toString()));
                                    }),
                                    onChanged: (value) {
                                      selectYear(value!);
                                    },
                                  ),
                          )
                      ],
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: size.height * 0.08,
                      getTitlesWidget: (value, meta) {
                        bool isStartMonth = false;

                        if (yearSelected == 0 &&
                            _startMonth.toDouble() == value + 1) {
                          isStartMonth = true;
                        }

                        switch (value) {
                          case 0:
                            return _MonthTitle(
                              'E',
                              isStartMonth: isStartMonth,
                            );
                          case 1:
                            return _MonthTitle(
                              'F',
                              isStartMonth: isStartMonth,
                            );
                          case 2:
                            return _MonthTitle(
                              'M',
                              isStartMonth: isStartMonth,
                            );
                          case 3:
                            return _MonthTitle(
                              'A',
                              isStartMonth: isStartMonth,
                            );
                          case 4:
                            return _MonthTitle(
                              'M',
                              isStartMonth: isStartMonth,
                            );
                          case 5:
                            return _MonthTitle(
                              'J',
                              isStartMonth: isStartMonth,
                            );
                          case 6:
                            return _MonthTitle(
                              'J',
                              isStartMonth: isStartMonth,
                            );
                          case 7:
                            return _MonthTitle(
                              'A',
                              isStartMonth: isStartMonth,
                            );
                          case 8:
                            return _MonthTitle(
                              'S',
                              isStartMonth: isStartMonth,
                            );
                          case 9:
                            return _MonthTitle(
                              'O',
                              isStartMonth: isStartMonth,
                            );
                          case 10:
                            return _MonthTitle(
                              'N',
                              isStartMonth: isStartMonth,
                            );
                          case 11:
                            return _MonthTitle(
                              'D',
                              isStartMonth: isStartMonth,
                            );

                          default:
                            return const Text("no data");
                        }
                      },
                    ),
                  ))));
        });
  }
}

class _MonthTitle extends StatelessWidget {
  final String text;
  bool isStartMonth;
  _MonthTitle(this.text, {super.key, this.isStartMonth = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (isStartMonth)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: const Icon(Icons.flag_circle),
          )
      ],
    );
  }
}

double _calculateIntervalY(List<List<UsualCustomerEntity>> year,
    {required int firstInterval,
    required int secontInterval,
    required int thirdInvertal}) {
  final largestValueY = year
      .reduce(
        (a, b) => a.length > b.length ? a : b,
      )
      .length;

  return (largestValueY <= 20
          ? firstInterval
          : largestValueY > 20 && largestValueY < 100
              ? secontInterval
              : thirdInvertal)
      .toDouble();
}

double _roundIntervalY(List<List<UsualCustomerEntity>> year, double intervalY) {
  return ((year
                      .reduce(
                        (a, b) => a.length > b.length ? a : b,
                      )
                      .length
                      .toDouble() /
                  intervalY)
              .toInt() +
          1) *
      intervalY;
}
