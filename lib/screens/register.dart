import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    final result = await AuthService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil')),
      );
      Navigator.pop(context); // kembali ke login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
          TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _register, child: Text("Register"))
        ]),
      ),
    );
  }
}
