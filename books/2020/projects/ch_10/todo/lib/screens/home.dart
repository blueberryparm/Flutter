import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/todo_db.dart';
import '../bloc/todo_bloc.dart';
import 'todo_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TodoBloc todoBloc;
  List<Todo> todos;

  @override
  void initState() {
    // 1 create an instance of the BLoC
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_testData();
    Todo todo = Todo('', '', '', 0);
    // contains the objects retrieved from the database
    todos = todoBloc.todoList;
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Container(
        child: StreamBuilder<List<Todo>>(
          initialData: todos,
          stream: todoBloc.todos,
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            return ListView.builder(
              itemCount: snapshot.hasData ? snapshot.data.length : 0,
              itemBuilder: (context, index) {
                // 2  include the UI in the StreamBuilder, which is the object
                // you use when showing a stream.
                return Dismissible(
                  key: Key(snapshot.data[index].id.toString()),
                  onDismissed: (_) =>
                      todoBloc.todoDeleteSink.add(snapshot.data[index]),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).highlightColor,
                      child: Text('${snapshot.data[index].priority}'),
                    ),
                    title: Text('${snapshot.data[index].name}'),
                    subtitle: Text('${snapshot.data[index].description}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TodoScreen(snapshot.data[index], false),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoScreen(todo, true),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 4 Call the dispose() method of the BLoC in order to prevent memory leaks, which are
    // very difficult to debug; that's also why a Stateful widget is recommended
    todoBloc.dispose();
    super.dispose();
  }

  Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();
    todos = await db.getTodos();
    await db.insertTodo(
        Todo('Call Donald', 'And tell him about Daisy', '02/26/2021', 1));
    await db.insertTodo(Todo('Buy Sugar', '1 kg, brown', '02/27/2021', 2));
    await db.insertTodo(
        Todo('Go Running', '@12:00 with neighbours', '02/28/2021', 3));
    todos = await db.getTodos();
    debugPrint('first insert');
    todos.forEach((todo) => debugPrint(todo.name));

    Todo todoToUpdate = todos[0];
    todoToUpdate.name = 'Call Tim';
    await db.updateTodo(todoToUpdate);

    Todo todoToDelete = todos[1];
    await db.deleteTodo(todoToDelete);

    debugPrint('After Updates');
    todos.forEach((todo) => debugPrint(todo.name));
  }
}
