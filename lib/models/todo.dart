import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  static final String boxName = 'TODOS';

  @HiveField(0)
  String title;

  @HiveField(1)
  bool done = false;

  @HiveField(2)
  DateTime finishedAt;

  Todo({this.title, this.done = false, this.finishedAt});

  String formatedDate() {
    final dateFormat = new DateFormat('dd-MM-yyyy hh:mm:ss', 'pt-BR');
    return dateFormat.format(this.finishedAt);
  }
}
