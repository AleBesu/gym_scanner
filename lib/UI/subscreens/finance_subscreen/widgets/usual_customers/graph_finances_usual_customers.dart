// import 'dart:ffi';

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/usual_user_payment_provider.dart';

class GraphFinancesUsualCustomers extends ConsumerStatefulWidget {
  const GraphFinancesUsualCustomers({super.key});

  @override
  ConsumerState<GraphFinancesUsualCustomers> createState() =>
      _GraphFinancesUsualCustomersState();
}

class _GraphFinancesUsualCustomersState
    extends ConsumerState<GraphFinancesUsualCustomers> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double barWith = size.width * 0.06;
    return FutureBuilder(
        future:
            ref.read(usualUserPaymentStatiticsProvider.notifier).getStatitics(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Text("error");
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
                      getTitlesWidget: (value, meta) {
                        switch (value) {
                          case 0:
                            return const Text('E');
                          case 1:
                            return const Text('F');
                          case 2:
                            return const Text('M');
                          case 3:
                            return const Text('A');
                          case 4:
                            return const Text('M');
                          case 5:
                            return const Text('J');
                          case 6:
                            return const Text('J');
                          case 7:
                            return const Text('A');
                          case 8:
                            return const Text('S');
                          case 9:
                            return const Text('O');
                          case 10:
                            return const Text('N');
                          case 11:
                            return const Text('D');

                          default:
                            return const Text("no data");
                        }
                      },
                    ),
                  ))));
        });
  }
}
