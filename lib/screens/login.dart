import 'package:flutter/material.dart';
import 'package:tokoku_frontend/models/user_model.dart';
import 'package:tokoku_frontend/screens/register.dart';
import '../services/auth_service.dart';
import 'home_page.dart'; // Ganti sesuai tujuan setelah login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserModel? loggedInUser;

  void _login() async {
  try {
    final result = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    print('Result: $result'); // DEBUG: print isi response

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login berhasil')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal login')));
    }
  } catch (e) {
    print('Login error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan saat login: $e')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _login, child: Text("Login")),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
            },
            child: Text("Belum punya akun? Register"),
          )
        ]),
      ),
    );
  }
}
