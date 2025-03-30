import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/casual_user_payment_provider.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/widgets/configs_graphs.dart';
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

class GraphFinances extends ConsumerStatefulWidget {
  const GraphFinances({super.key});

  @override
  ConsumerState<GraphFinances> createState() => _GraphFinancesState();
}

class _GraphFinancesState extends ConsumerState<GraphFinances> {
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
          child: LineChart(
              curve: Curves.linear,
              ConfigsGraphs.getConfig(context,
                  timeInterval: timeTypeSelectedList[currectTimeInverval],
                  coordenatesValuesList: ref
                      .read(casualUserPaymentProvider.notifier)
                      .getRegistersCoordenates()
                      .map(
                        (e) => FlSpot(e.x, e.y),
                      )
                      .toList())),
        ),
      ],
    );
  }
}
