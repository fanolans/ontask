import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontask/services/database_service.dart';

import '../models/data_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: DatabaseService().dataUser,
        builder: (context, AsyncSnapshot<DataUser> dataUserSnapshot) {
          if (dataUserSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataUserSnapshot.hasError) {
            return Center(
              child: Text(
                dataUserSnapshot.error!.toString(),
              ),
            );
          }

          final dataUser = dataUserSnapshot.data as DataUser;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 150,
                color: Colors.blueAccent,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        XFile? xFile = await _imagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 30,
                        );
                        if (xFile != null) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Memproses Foto'),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            },
                          );
                          await DatabaseService().uploadUserImage(
                            File(xFile.path),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage: dataUser.userImageUrl != ''
                            ? NetworkImage(dataUser.userImageUrl)
                            : null,
                        minRadius: 40,
                        child: dataUser.userImageUrl == ''
                            ? const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      dataUser.username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        String tempUsername = '';
                        bool? isEditUsername = await showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              title: const Text('Edit Username'),
                              content: TextFormField(
                                initialValue: dataUser.username,
                                onChanged: (value) {
                                  tempUsername = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Simpan'),
                                ),
                              ],
                            );
                          },
                        );
                        if (isEditUsername != null && isEditUsername) {
                          DatabaseService().updateUsername(tempUsername);
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  'Data User',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Email'),
                            ),
                            const Text(': '),
                            Text(dataUser.email)
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Phone Number'),
                            ),
                            const Text(': '),
                            Text(dataUser.phone)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.logout),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
