import 'package:flutter/material.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/widgets/graph_finances.dart';

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
              height: size.height * 0.32,
              child: GraphFinances(),
            ),
          )
        ],
      ),
    );
  }
}
