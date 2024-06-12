import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/main.dart';
import 'SignupPage.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers untuk TextField email dan password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoggedIn = false; // Status login pengguna

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(),
              _forgotPassword(),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            prefixIcon: Icon(Icons.email),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _isLoggedIn ? null : () => _login(context),
          child: Text("Login"),
        ),
      ],
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        // Implementasi logika untuk reset password
      },
      child: Text("Forgot password?"),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: Text("Sign Up"),
        ),
      ],
    );
  }

  Future<void> _login(BuildContext context) async {
    try {
      // Mengambil email dan password dari TextField
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Autentikasi dengan Firebase menggunakan email dan password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set status login menjadi true
      setState(() {
        _isLoggedIn = true;
      });

      // Jika login berhasil, tampilkan dialog alert berhasil
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Login Successful"),
            content: Text("You have successfully logged in."),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Tangani kesalahan autentikasi
      print("Login error: $error");
      // Jika terjadi kesalahan autentikasi, tampilkan dialog alert kesalahan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Login Failed"),
            content: Text("Login failed: $error"),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void checkLoginStatus() async {
    if (_auth.currentUser != null) {
      setState(() {
        _isLoggedIn = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}
