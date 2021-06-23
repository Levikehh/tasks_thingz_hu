import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tasks_thingz_hu/screens/task_edit.dart';

class TaskContainer extends StatefulWidget {
  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  final Stream<QuerySnapshot> _tasksStream =
      FirebaseFirestore.instance.collection('tasks').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator(
            indicatorType: Indicator.pacman,
            color: Theme.of(context).primaryColor,
          );
        }

        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            Timestamp t = data['date'];
            DateTime d = t.toDate();
            String formatDate = DateFormat('yyyy. MMM dd. (hh:mm)').format(d);
            return TaskTile(
              title: data['title'],
              formatDate: formatDate,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TaskEditor(
                      taskID: document.id,
                      title: data['title'].toString(),
                      date: d,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    Key? key,
    required this.title,
    required this.formatDate,
    required this.onTap,
  }) : super(key: key);

  final String title, formatDate;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: onTap,
      leading: Icon(Icons.edit),
      title: new Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      subtitle: Text(
        formatDate,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
          fontSize: 18,
        ),
      ),
    );
  }
}
