import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ontask/widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ontask'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: const TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('todos')
              .snapshots()
              .listen((data) {
            data.docs.forEach((element) {
              print(element['title']);
            });
          });
          FirebaseFirestore.instance
              .collection('todos')
              .doc('HHALYo307wAuUHMge7ft')
              .get()
              .then(
                (value) => print(value['title']),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
