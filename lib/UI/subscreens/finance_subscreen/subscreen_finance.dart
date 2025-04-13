import 'package:flutter/material.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/widgets/casual_customers/graph_finances_casual_customers.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/widgets/usual_customers/graph_finances_usual_customers.dart';

class SubScreenFinance extends StatelessWidget {
  const SubScreenFinance({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: size.width * 0.9,
              height: size.height * 0.35,
              child: const GraphFinancesCasualCustomers(),
            ),
          ),
          SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.38,
            child: GraphFinancesUsualCustomers(),
          )
        ],
      ),
    );
  }
}
