import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitAuthFormFn});
  final Function({
    required String email,
    required String username,
    required String password,
    required bool isLogin,
  }) submitAuthFormFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  String _email = '';
  String _username = '';
  String _password = '';

  void submitForm() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        widget.submitAuthFormFn(
          email: _email,
          username: _username,
          password: _password,
          isLogin: _isLogin,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('email'),
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains("@")) {
                return 'Format email tidak valid';
              }
              return null;
            },
            onSaved: (newValue) {
              _email = newValue ?? '';
            },
          ),
          const SizedBox(
            height: 15,
          ),
          if (!_isLogin)
            TextFormField(
              key: const Key('username'),
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 4) {
                  return 'Username minimal memiliki 4 karakter';
                }
                return null;
              },
              onSaved: (newValue) {
                _username = newValue ?? '';
              },
            ),
          if (!_isLogin)
            const SizedBox(
              height: 15,
            ),
          TextFormField(
            key: const Key('password'),
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password minimal memiliki 6 karakter';
              }
              return null;
            },
            onSaved: (newValue) {
              _password = newValue ?? '';
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: submitForm,
            child: Text(_isLogin ? 'Masuk' : 'Daftar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
            child: Text(_isLogin ? 'Buat Akun Baru' : 'Sudah punya akun'),
          ),
        ],
      ),
    );
  }
}
