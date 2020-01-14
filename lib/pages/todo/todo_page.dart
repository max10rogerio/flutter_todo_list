import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_list/models/todo.dart';
import 'package:todo_list/pages/todo/todo_form.dart';

class TodoPage extends StatelessWidget {
  void _deleteTodo(Todo todo) async {
    await todo.delete();
  }

  void _handleCheckTodo(Todo todo, bool checked) async {
    todo.done = checked;
    todo.finishedAt = checked == true ? DateTime.now() : null;

    await todo.save();
  }

  Widget _renderItem(Todo todo) {
    return CheckboxListTile(
      subtitle: todo.finishedAt != null ? Text(todo.formatedDate()) : null,
      title: Text.rich(
        TextSpan(
          style: todo.done
              ? TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                )
              : null,
          children: <InlineSpan>[
            TextSpan(
              text: '# ${todo.key} - ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: todo.title,
            ),
          ],
        ),
      ),
      value: todo.done,
      onChanged: (value) => _handleCheckTodo(todo, value),
    );
  }

  Widget _renderList(Box<Todo> box) {
    if (box.values.isEmpty) {
      return Center(
        child: Text('No tasks'),
      );
    }

    return ListView.builder(
      itemCount: box.values.length,
      itemBuilder: (context, index) {
        Todo todo = box.getAt(index);

        return Dismissible(
          key: Key(todo.title + index.toString()),
          direction: DismissDirection.startToEnd,
          child: _renderItem(todo),
          onDismissed: (direction) => _deleteTodo(todo),
          background: Container(
            padding: EdgeInsets.only(left: 20.0),
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'DELETE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Todo>(Todo.boxName).listenable(),
          builder: (context, Box<Todo> todoBox, _) {
            return _renderList(todoBox);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoForm()));
        },
      ),
    );
  }
}
