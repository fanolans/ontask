import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraHomeScreen extends StatefulWidget {
  const CameraHomeScreen({super.key});

  @override
  State<CameraHomeScreen> createState() => _CameraHomeScreenState();
}

class _CameraHomeScreenState extends State<CameraHomeScreen> {
  File? _imageFile;
  List<File> _listImageFile = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_imageFile != null) Image.file(_imageFile!),
            SizedBox(
              height: 250,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _listImageFile.length,
                  itemBuilder: (context, index) {
                    return Image.file(_listImageFile[index]);
                  }),
            ),
            ElevatedButton(
              onPressed: () async {
                final XFile = await ImagePicker().pickMultiImage();
                if (XFile != null) {
                  setState(() {
                    XFile.forEach((element) {
                      _listImageFile.add(File(element.path));
                    });
                  });
                }

                // if (XFile != null) {
                //   setState(() {
                //     _imageFile = File(XFile.path);
                //   });
                // }
              },
              child: const Text('Buka Video'),
            ),
            ElevatedButton(
              onPressed: () async {
                final XFile = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 10,
                  maxWidth: 1080,
                  maxHeight: 1920,
                );
                if (XFile != null) {
                  setState(() {
                    _imageFile = File(XFile.path);
                  });
                }
              },
              child: const Text('Buka kamera'),
            ),
          ],
        ),
      ),
    );
  }
}
