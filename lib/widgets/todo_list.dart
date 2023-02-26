import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('todos').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> todosSnapshot) {
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
        final documents = todosSnapshot.data!.docs;
        return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) {
              return Text(documents[index]['title']);
            });
      },
    );
  }
}
