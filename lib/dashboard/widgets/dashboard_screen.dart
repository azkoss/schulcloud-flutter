import 'package:flutter/material.dart';
import 'package:schulcloud/homework/homework.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var builders = [
      () => HomeworkDashboardCard(),
    ];

    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, i) {
          if (i < builders.length) {
            return builders[i]();
          } else {
            return null;
          }
        },
      ),
    );
  }
}
