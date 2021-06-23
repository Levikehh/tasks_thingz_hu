import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks_thingz_hu/components/task_container.dart';
import 'package:tasks_thingz_hu/constants.dart';

class TaskEditor extends StatefulWidget {
  final String taskID, title;
  final DateTime date;

  const TaskEditor(
      {required this.taskID, required this.title, required this.date});

  @override
  _TaskEditorState createState() => new _TaskEditorState(taskID, title, date);
}

class _TaskEditorState extends State<TaskEditor> {
  final String id, oldTitle;
  final DateTime oldDate;
  _TaskEditorState(this.id, this.oldTitle, this.oldDate);

  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  TextEditingController titleInputController = new TextEditingController();
  TextEditingController dateInputController = new TextEditingController();

  String title = "";
  DateTime date = DateTime.now();

  Future<void> updateTask() {
    return tasks
        .doc(id)
        .update({'title': title, 'date': date})
        .then((value) => Navigator.of(context).pop())
        .then(
          (value) => showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
              title: Text('Adatok frissitve'),
            ),
          ),
        )
        .catchError((error) => print("Failed to update task: $error"));
  }

  Future<void> addTask() {
    return tasks
        .add({'title': title, 'date': date})
        .then((value) => Navigator.of(context).pop())
        .then(
          (value) => showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
              title: Text('Adatok feltoltve'),
            ),
          ),
        )
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    setState(() {
      title = oldTitle;
      date = oldDate;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: 3 * defaultPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: titleInputController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty &&
                          value != " ")
                        title = value;
                      else
                        title = oldTitle;
                    });
                    print(value);
                  },
                ),
                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null && picked != date)
                      setState(() {
                        date = picked;
                      });
                  },
                  child: Text(
                    "Datum modositasa",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: defaultPadding),
                Text(
                  "Elonezet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: defaultPadding),
                Container(
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(.05),
                  child: TaskTile(
                    title: title,
                    formatDate:
                        DateFormat('yyyy. MMM dd. (hh:mm)').format(date),
                    onTap: null,
                  ),
                ),
                SizedBox(height: defaultPadding),
                ElevatedButton(
                  onPressed: () async {
                    if(id.isNotEmpty) await updateTask();
                    else await addTask();
                  },
                  child: Text(
                    "Mentes",
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding * 2,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: BackButton(),
            ),
          ),
        ],
      ),
    );
  }
}
