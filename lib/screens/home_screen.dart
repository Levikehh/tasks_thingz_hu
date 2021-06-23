import 'package:flutter/material.dart';
import 'package:tasks_thingz_hu/components/task_container.dart';
import 'package:tasks_thingz_hu/constants.dart';

import 'task_edit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskEditor(
                taskID: "",
                title: "",
                date: DateTime.now(),
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 3 * defaultPadding,
        ),
        child: TaskContainer(),
      ),
    );
  }
}
