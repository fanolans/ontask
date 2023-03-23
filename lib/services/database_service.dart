import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/data_user.dart';
import '../models/todo_model.dart';

class DatabaseService {
  String _uid = '';
  DatabaseService() {
    if (FirebaseAuth.instance.currentUser != null) {
      _uid = FirebaseAuth.instance.currentUser!.uid;
    }
  }
  final _todoReferences = FirebaseFirestore.instance.collection('todos');
  final _dataUserReference = FirebaseFirestore.instance.collection('users');

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

  DataUser _dataUserFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DataUser(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      userImageUrl: data['user_image_url'] ?? '',
    );
  }

  Stream<DataUser> get dataUser {
    return _dataUserReference.doc(_uid).snapshots().map(_dataUserFromSnapshot);
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
      'completed': !todo.completed,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future deleteTodo(String docid) async {
    return _todoReferences.doc(docid).delete();
  }

  Future updateUsername(String username) {
    return _dataUserReference.doc(_uid).update({
      'username': username,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future uploadUserImage(File file) async {
    final ref =
        FirebaseStorage.instance.ref().child('user_data').child('$_uid.jpg');
    await ref.putFile(file);

    final url = ref.getDownloadURL();

    await _dataUserReference.doc(_uid).update({
      'user_image_url': url,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
