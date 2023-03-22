import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/todo_model.dart';

class DatabaseService {
  String _uid = '';
  DatabaseService() {
    if (FirebaseAuth.instance.currentUser != null) {
      _uid = FirebaseAuth.instance.currentUser!.uid;
    }
  }
  final _todoReferences = FirebaseFirestore.instance.collection('todos');

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapShot) {
    return snapShot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Todo(
        id: doc.id,
        title: data['title'] ?? '',
        completed: data['completed'] ?? false,
        dueDate:
            data['due_date'] == null ? null : DateTime.parse(data['due_date']),
        latitude: data['location'] == null ? 0.0 : data['location'].latitude,
        longitude: data['location'] == null ? 0.0 : data['location'].longitude,
      );
    }).toList();
  }

  Stream<List<Todo>> get todos {
    return _todoReferences
        .orderBy('completed')
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  Future addNewTodo(String title) {
    return _todoReferences.add(
      {
        'uid': _uid,
        'completed': false,
        'title': title,
      },
    );
  }

  Future updateTodo(Todo todo) {
    return _todoReferences.doc(todo.id).update({
      'title': todo.title,
      'note': todo.note,
      'location': GeoPoint(
        todo.latitude,
        todo.longitude,
      ),
      'due_date': todo.dueDate == null ? null : todo.dueDate!.toIso8601String(),
      'completed': todo.completed,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future toogleCompleted(Todo todo) {
    return _todoReferences.doc(todo.id).update({
      'completed': todo.completed,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future deleteTodo(String docid) async {
    return _todoReferences.doc(docid).delete();
  }
}
