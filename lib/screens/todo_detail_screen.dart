import 'package:flutter/material.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({super.key});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
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
            const TextField(
              decoration: InputDecoration(hintText: 'Saya akan...'),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Batas waktu menyelesaikan'),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                dueDateButton('Hari ini'),
                const SizedBox(
                  width: 10,
                ),
                dueDateButton('Besok'),
              ],
            ),
            Row(
              children: [
                dueDateButton('Minggu depan'),
                const SizedBox(
                  width: 10,
                ),
                dueDateButton('Custom'),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Catatan'),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('Tap untuk menambahkan catatan'),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Lokasi'),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('Tap untuk menambahkan lokasi'),
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
        onPressed: () {},
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
