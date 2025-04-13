import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/casual_user_payment_statitics_provider.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/widgets/casual_customers/configs_graphs.dart';
import 'package:gym_scanner/core/Date/time_inverval.dart';

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

class GraphFinancesCasualCustomers extends ConsumerStatefulWidget {
  const GraphFinancesCasualCustomers({super.key});

  @override
  ConsumerState<GraphFinancesCasualCustomers> createState() =>
      _GraphFinancesState();
}

class _GraphFinancesState extends ConsumerState<GraphFinancesCasualCustomers> {
  List<TimeInverval> timeTypeSelectedList = [
    TimeInverval.week,
    TimeInverval.month,
    TimeInverval.year,
  ];

  int currectTimeInverval = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: size.width * 0.1),
                child: SizedBox(
                  height: size.height * 0.03,
                  child: ToggleButtons(
                      borderColor: Colors.black,
                      selectedColor: Colors.red,
                      isSelected:
                          List.generate(timeTypeSelectedList.length, (index) {
                        return index == currectTimeInverval;
                      }),
                      onPressed: (index) {
                        setState(() {
                          currectTimeInverval = index;
                        });
                      },
                      children: const [Text("S"), Text("M"), Text("A")]),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: ref
                  .read(casualUserPaymentStatiticsProvider.notifier)
                  .getRegistersCoordenates()
                  .then(
                    (value) => value
                        .map(
                          (e) => FlSpot(e.x, e.y),
                        )
                        .toList(),
                  ),
              builder: (context, statitics) {
                if (statitics.hasError) {
                  return const Text("Error al cargar datos");
                }
                if (statitics.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return FutureBuilder(
                    future: ConfigsGraphs.getConfig(context, ref,
                        timeInterval: timeTypeSelectedList[currectTimeInverval],
                        coordenatesValuesList: statitics.data!),
                    builder: (context, snapshot) {
                      return LineChart(
                          curve: Curves.linear,
                          snapshot.data ??
                              LineChartData(
                                  titlesData: const FlTitlesData(
                                      topTitles: AxisTitles(
                                          axisNameWidget: Text('erroorrrr')))));
                    });
              }),
        ),
      ],
    );
  }
}
