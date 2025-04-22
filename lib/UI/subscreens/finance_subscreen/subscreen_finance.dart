import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/widgets/casual_customers/graph_finances_casual_customers.dart';
import 'package:gym_scanner/UI/subscreens/finance_subscreen/widgets/usual_customers/graph_finances_usual_customers.dart';

class SubScreenFinance extends StatelessWidget {
  const SubScreenFinance({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.04),
            child: SizedBox(
              width: size.width * 0.9,
              height: size.height * 0.35,
              child: const GraphFinancesCasualCustomers(),
            ),
          ),
          SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.38,
            child: const GraphFinancesUsualCustomers(),
          )
        ],
      ),
    );
  }
}

class financesSubscreenAppbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const financesSubscreenAppbar({super.key});

  @override
  ConsumerState<financesSubscreenAppbar> createState() =>
      _financesSubscreenAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _financesSubscreenAppbarState
    extends ConsumerState<financesSubscreenAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Estadísticas'),
    );
  }
}
