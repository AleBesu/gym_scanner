import 'package:flutter/material.dart';
import 'package:gym_scanner/UI/subscreens/register_subscreen/screens/registred_customer_screen.dart';

import 'package:gym_scanner/domain/customer_entity.dart';

class SeachUsualCustomerDelegate extends SearchDelegate {
  final List<UsualCustomerEntity> listToSeach;
  SeachUsualCustomerDelegate(this.listToSeach);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [const Icon(Icons.clear)];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return InkWell(
      onTap: () {
        close(context, '');
      },
      child: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = listToSeach
        .where(
          (usualCustomer) =>
              usualCustomer.name.trim().toLowerCase().contains(query),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return RegisterCustomerWidget(results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = listToSeach
        .where(
          (usualCustomer) =>
              usualCustomer.name.trim().toLowerCase().contains(query),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return RegisterCustomerWidget(results[index]);
      },
    );
  }
}
