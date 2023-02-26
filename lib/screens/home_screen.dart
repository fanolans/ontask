import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ontask/services/database_service.dart';
import 'package:ontask/widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _todoTitle = '';
  final _todoTitleController = TextEditingController();

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
      body: Container(
        child: Column(
          children: [
            const Expanded(
              child: TodoList(),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoTitleController,
                      decoration: InputDecoration(
                        hintText: 'Saya akan...',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
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
                            DatabaseService().addNewTitle(_todoTitle);
                            _todoTitleController.clear();
                          },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
