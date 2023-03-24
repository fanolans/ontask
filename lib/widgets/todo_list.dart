import 'package:flutter/material.dart';
import 'package:ontask/function.dart';
import 'package:ontask/models/todo_model.dart';
import 'package:ontask/screens/todo_detail_screen.dart';

import '../services/database_service.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().todos,
      builder: (context, AsyncSnapshot<List<Todo>> todosSnapshot) {
        if (todosSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (todosSnapshot.hasError) {
          return Center(
            child: Text(
              todosSnapshot.error.toString(),
            ),
          );
        }
        if (todosSnapshot.data != null) {
          final todoList = todosSnapshot.data as List<Todo>;
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (ctx, index) {
              return Card(
                color: todoList[index].completed ? Colors.green : null,
                child: ListTile(
                  onTap: todoList[index].completed
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => TodoDetailScreen(
                                todo: todoList[index],
                              ),
                            ),
                          );
                        },
                  leading: IconButton(
                    onPressed: () {
                      DatabaseService().toogleCompleted(todoList[index]);
                    },
                    icon: todoList[index].completed
                        ? const Icon(Icons.check_outlined)
                        : const Icon(Icons.circle_outlined),
                  ),
                  title: Text(todoList[index].title),
                  subtitle: todoList[index].dueDate == null
                      ? null
                      : Text(
                          formatDateTime(todoList[index].dueDate),
                        ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text('Tidak ada data'),
          );
        }
      },
    );
  }
}
