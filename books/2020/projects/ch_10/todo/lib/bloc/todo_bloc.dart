import 'dart:async';
import '../models/todo.dart';
import '../utils/todo_db.dart';

// 1 Create a class that will serve as the BLoC.
// Serves as an interface between the UI and the data of the app
class TodoBloc {
  TodoDb db;
  // 2 Declare the data that needs to be updated in the app
  List<Todo> todoList;

  /*
      There are 2 kinds of Streams: single-subscription Streams and broadcast Streams.
      Single-subscription Streams only allow a single listener during the whole lifetime
      of the Stream. Broadcast Streams allow multiple listeners that can be added at any
      time. Each listener will receive data from the moment it begins listening to the
      Stream.
   */

  // 3 Set the StreamControllers
  // Create 1 StreamController for todoList and 3 more for the insert, update and delete tasks
  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  // for updates
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  // 6 Add a constructor in which you'll set data
  TodoBloc() {
    db = TodoDb();
    getTodos();
    //listen to changes:
    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
  }

  // 4 Create the getters for streams and sinks
  // We'll use the sink property to add data and the stream property to get data
  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  // 5 Add the logic of the BLoC
  // Implement the stream of data

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todosSink.add(todos);
  }

  List<Todo> returnTodos(todos) {
    return todos;
  }

  void _addTodo(Todo todo) => db.insertTodo(todo).then((result) => getTodos());
  void _updateTodo(Todo todo) =>
      db.updateTodo(todo).then((result) => getTodos());
  void _deleteTodo(Todo todo) =>
      db.deleteTodo(todo).then((result) => getTodos());

  // 8 Set the dispose() method.
  // This may prevent memory leaks and errors that are difficult to debug
  void dispose() {
    _todosStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoDeleteController.close();
  }
}
