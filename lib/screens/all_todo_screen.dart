import 'package:flutter/material.dart';

import '../widgets/new_todo.dart';
import '../widgets/todo_list.dart';

class AllTodoScreen extends StatelessWidget {
  const AllTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ontask'),
        centerTitle: true,
      ),
      body: Column(
        children: const [
          Expanded(
            child: TodoList(),
          ),
          NewTodo(),
        ],
      ),
    );
  }
}
