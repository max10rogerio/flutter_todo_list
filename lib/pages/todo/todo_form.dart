import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/utils/notification.dart';

class TodoForm extends StatefulWidget {
  final formKey = new GlobalKey<FormState>();

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  String title;
  DateTime notifyAt;

  final dateFieldFormat = DateFormat('dd-MM-yyyy hh:mm');
  final initialDate = DateTime.now();

  void onSubmit() async {
    final todoBox = Hive.box<Todo>(Todo.boxName);
    final notification = new NotificationWrapper();

    if (!widget.formKey.currentState.validate()) {
      return;
    }

    var id = await todoBox.add(Todo(title: title));

    if (notifyAt != null) {
      print('Notify');
      await notification.scheduleNotification(
          id, title, DateTime.now().add(new Duration(seconds: 10)));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Form(
          key: widget.formKey,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  validator: (value) =>
                      value.isEmpty ? 'Title is required' : null,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: DateTimeField(
                    decoration: InputDecoration(
                      labelText: 'Notify at',
                    ),
                    format: dateFieldFormat,
                    onChanged: (value) {
                      setState(() {
                        notifyAt = value;
                      });
                    },
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: initialDate,
                          initialDate: currentValue ?? initialDate,
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? initialDate),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      child: OutlineButton(
                        onPressed: onSubmit,
                        borderSide: BorderSide(color: Colors.green),
                        textColor: Colors.green,
                        splashColor: Colors.green,
                        child: Text('Save'),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
