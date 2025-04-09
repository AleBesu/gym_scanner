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
  @override
  void initState() {
    super.initState();
    _loadInitialData(ref);
  }

  Future<void> _loadInitialData(WidgetRef ref) async {
    final startDateTime = await ref
        .read(usualUserPaymentStatiticsProvider.notifier)
        .getStartDateTime();
    final allYearsStatiticPro = await ref
        .read(usualUserPaymentStatiticsProvider.notifier)
        .getAllYearsStatics();

    setState(() {
      _startMonth = startDateTime.month;
      yearSelected = allYearsStatiticPro.length - 1;
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

          return BarChart(BarChartData(
              maxY: 200,
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
                          showTitles: true, reservedSize: size.width * 0.1)),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
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
