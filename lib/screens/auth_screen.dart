import 'package:flutter/material.dart';
import 'package:ontask/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              children: const [
                Text('Ontask'),
                SizedBox(
                  height: 25,
                ),
                AuthForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
