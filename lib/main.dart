import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/pages/todo/todo_page.dart';

void main() async {
  await initializeDateFormatting('pt-BR');
  await Hive.initFlutter();

  Hive.registerAdapter<Todo>(TodoAdapter());
  await Hive.openBox<Todo>(Todo.boxName);

  Box<Todo> todoBox = Hive.box(Todo.boxName);

  await todoBox.clear();

  Intl.defaultLocale = 'pt-BR';

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme:
            InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: TodoPage(),
    );
  }
}
