import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/Providers/Statitics/casual_user_payment_statitics_provider.dart';
import 'package:gym_scanner/UI/Providers/year_selected_provider.dart';
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
  // int yearSelectedIndex = 0;
  DateTime startDateTime = DateTime(1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadInitialData(),
    );
  }

  Future<void> loadInitialData() async {
    if (ref.read(casualUserPaymentStatiticsProvider).length > 1) {
      ref.read(yearSelectedIndexProvider.notifier).state =
          ref.read(casualUserPaymentStatiticsProvider).length - 1;
    }

    await ref.read(casualUserPaymentStatiticsProvider.notifier).loadData();

    // yearSelectedIndex = ref.read(casualUserPaymentStatiticsProvider).length - 1;

    startDateTime =
        await ref.read(casualUserPaymentStatiticsProvider.notifier).startDate;

    setState(() {});
  }

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
              ref.read(casualUserPaymentStatiticsProvider).length <= 1
                  ? Text(startDateTime.year.toString())
                  : DropdownButton(
                      value: ref.watch(yearSelectedIndexProvider),
                      items: List.generate(
                        ref.read(casualUserPaymentStatiticsProvider).length,
                        (index) {
                          int currentYear = startDateTime.year + index;

                          return DropdownMenuItem(
                              value: index,
                              child: Text(currentYear.toString()));
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          ref.read(yearSelectedIndexProvider.notifier).state =
                              value!;
                        });
                      },
                    ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: ref
                  .read(casualUserPaymentStatiticsProvider.notifier)
                  .getRegistersCoordenates(ref.watch(yearSelectedIndexProvider))
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
                      return LineChart(snapshot.data ??
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
