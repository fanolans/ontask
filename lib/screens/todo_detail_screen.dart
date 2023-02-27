import 'package:flutter/material.dart';
import 'package:ontask/models/place_location.dart';
import 'package:ontask/models/todo_model.dart';

import '../function.dart';
import '../widgets/map_widget.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({super.key, required this.todo});
  final Todo todo;

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  Todo _todo = Todo(id: '', title: '');
  final _todoTitleController = TextEditingController();
  final _today = DateTime.now();

  @override
  void initState() {
    _todo = widget.todo;
    _todoTitleController.text = _todo.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kegiatan apa yang akan anda kerjakan?'),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _todoTitleController,
              decoration: const InputDecoration(hintText: 'Saya akan...'),
              onChanged: (value) {
                _todo = _todo.copyWith(title: value);
              },
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Batas waktu menyelesaikan'),
            const SizedBox(
              height: 10,
            ),
            if (_todo.dueDate != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatDateTime(_todo.dueDate),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _todo = _todo.copyWith(dueDate: DateTime(0));
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_todo.dueDate == null)
              Row(
                children: [
                  dueDateButton('Hari ini', value: _today),
                  const SizedBox(
                    width: 10,
                  ),
                  dueDateButton(
                    'Besok',
                    value: _today.add(
                      const Duration(days: 1),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                dueDateButton(
                  'Minggu depan',
                  value: _today.add(
                    Duration(days: (_today.weekday - 7).abs() + 1),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                dueDateButton(
                  'Custom',
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _today,
                      firstDate: _today,
                      lastDate: DateTime(_today.year + 100),
                    );
                    if (pickedDate != null) {
                      setState(
                        () {
                          _todo = _todo.copyWith(dueDate: pickedDate);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Catatan'),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                String? note = await showDialog(
                  context: context,
                  builder: (builder) {
                    String tempNote = _todo.note;
                    return Dialog(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Catatan',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextFormField(
                              initialValue: tempNote,
                              maxLines: 6,
                              onChanged: (value) {
                                tempNote = value;
                              },
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(tempNote),
                              child: const Text('Selesai'),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (note != null) {
                  setState(() {
                    _todo = _todo.copyWith(note: note);
                  });
                }
              },
              child: _todo.note.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('Tap untuk menambahkan catatan'),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        _todo.note,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Lokasi'),
            const SizedBox(
              height: 10,
            ),
            MapWidget(
              placeLocation: PlaceLocation(
                latitude: _todo.latitude,
                longitude: _todo.longitude,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Simpan'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Selesai'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dueDateButton(
    String text, {
    DateTime? value,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed ??
            () {
              setState(() {
                _todo = _todo.copyWith(dueDate: value);
              });
            },
        icon: const Icon(Icons.add_alarm),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
