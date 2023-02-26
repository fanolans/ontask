import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo_model.dart';

class DatabaseService {
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
    return FirebaseFirestore.instance
        .collection('todos')
        .snapshots()
        .map(_todoListFromSnapshot);
  }
}
