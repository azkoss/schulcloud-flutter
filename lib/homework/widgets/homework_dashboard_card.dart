import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schulcloud/app/app.dart';

import '../data.dart';
import '../bloc.dart';

class HomeworkDashboardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<NetworkService, UserService, Bloc>(
      builder: (_, network, user, __) => Bloc(network: network, user: user),
      child: Consumer<Bloc>(
        builder: (context, bloc, _) {
          return StreamBuilder<int>(
            stream: bloc.getHomework().asyncMap((listOfHomework) async {
              var now = DateTime.now();
              return [
                for (var homework in listOfHomework)
                  if (homework.availableDate.isAfter(now))
                    if (homework.dueDate.isBefore(now.add(Duration(days: 7))))
                      if (await bloc
                          .getSubmissionForHomework(homework.id)
                          .isEmpty)
                        homework
              ].length;
            }),
            builder: (context, snapshot) {
              var numHomeworkToDo = '${snapshot.data}' ?? '-';
              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(numHomeworkToDo, style: TextStyle(fontSize: 40)),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('open assignments',
                            style: TextStyle(fontSize: 20)),
                        Text('in the next week'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
