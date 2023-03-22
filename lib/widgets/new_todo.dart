import 'package:flutter/material.dart';

import '../services/database_service.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  String _todoTitle = '';
  final _todoTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                hintText: 'Rencana kegiatan...',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _todoTitle = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _todoTitle.isEmpty
                ? null
                : () {
                    DatabaseService().addNewTodo(_todoTitle);
                    _todoTitleController.clear();
                  },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
